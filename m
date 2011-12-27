From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_queue: build updates
Date: Tue, 27 Dec 2011 20:03:34 +0100
Message-ID: <20111227190334.GA29066@1984>
References: <1324136195-7784-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47422 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1L0TDg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 14:03:36 -0500
Content-Disposition: inline
In-Reply-To: <1324136195-7784-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 17, 2011 at 04:36:31PM +0100, Jan Engelhardt wrote:
> 
> The following changes since commit 4b3d0a4763b440ef748d537d86f0869d09544ab2:
> 
>   src: add notes on NF_STOLEN and NF_REPEAT to documentation (2011-09-06 13:48:25 +0200)
> 
> are available in the git repository at:
>   git://dev.medozas.de/libnetfilter_queue master
> 
> Jan Engelhardt (3):
>       Update .gitignore
>       build: use AC_CONFIG_AUX_DIR and stash away tools
>       build: disable implicit .tar.gz archive generation and use POSIX mode
> 
>  .gitignore   |   12 ++++--------
>  configure.ac |    4 +++-
>  2 files changed, 7 insertions(+), 9 deletions(-)

Applued, thanks.
