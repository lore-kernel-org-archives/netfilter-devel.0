From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: resolve automake-1.12 warnings
Date: Mon, 8 Oct 2012 17:17:33 +0200
Message-ID: <20121008151733.GB1647@1984>
References: <1349702239-25213-1-git-send-email-jengelh@inai.de>
 <1349702239-25213-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49908 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab2JHPRk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:17:40 -0400
Content-Disposition: inline
In-Reply-To: <1349702239-25213-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 08, 2012 at 03:17:19PM +0200, Jan Engelhardt wrote:
> am/ltlibrary.am: warning: 'libnetfilter_queue.la': linking libtool
> libraries using a non-POSIX archiver requires 'AM_PROG_AR' in
> 'configure.ac'
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  bl           |    2 ++
>  configure.ac |    1 +
>  2 files changed, 3 insertions(+)
>  create mode 100644 bl
> 
> diff --git a/bl b/bl
> new file mode 100644
> index 0000000..57eb8dd
> --- /dev/null
> +++ b/bl
> @@ -0,0 +1,2 @@
> +Error: '/home/jengelh/code/libnetfilter_queue' is not an osc project dir or working copy
> +Current directory looks like git.

This slipped through accidentally, please fix it and will pull.

Thanks.
