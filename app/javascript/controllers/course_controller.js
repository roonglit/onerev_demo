import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from '@rails/activestorage'
import * as FilePond from "filepond"
import FilePondPluginImagePreview from 'filepond-plugin-image-preview';

export default class extends Controller {
  static targets = ["filepond"]

  connect() {
    this.filepondTarget && this.initializeFilePond(
      this.filepondTarget.dataset.directUploadUrl
    )
  }

  initializeFilePond(directUploadUrl) {
    console.log("upload url:", directUploadUrl)
    FilePond.registerPlugin(FilePondPluginImagePreview);

    const filepond = FilePond.create(this.filepondTarget, {
      server: {
        process: (fieldName, file, metadata, load, error, progress, abort, transfer, options) => {
          const upload = new DirectUpload(file, directUploadUrl, {
            directUploadWillStoreFileWithXHR(request) {
              console.log("directUploadWillStoreFileWithXHR", request)
              request.upload.addEventListener("progress",
                event => progress(event.lengthComputable, event.loaded, event.total)
              );
            }
          });

          upload.create((error, blob) => {
            if (error) {
              // Handle the error
            } else {
              // Add an appropriately-named hidden input to the form with a
              //  value of blob.signed_id so that the blob ids will be
              //  transmitted in the normal upload flow
              console.log("blob", blob);

              const hiddenField = document.createElement('input')
              hiddenField.setAttribute("type", "hidden");
              hiddenField.setAttribute("value", blob.signed_id);
              console.log("input:", this.filepondTarget);
              hiddenField.name = this.filepondTarget.name + '_signed_id'
              document.querySelector('form').appendChild(hiddenField)
            }
          })

          return {
            abort: () => abort()
          }
        }
      }
    })
  }
}
