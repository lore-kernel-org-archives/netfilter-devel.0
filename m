From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack: build updates
Date: Tue, 27 Dec 2011 19:57:10 +0100
Message-ID: <20111227185710.GC28992@1984>
References: <1324136144-12845-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46832 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1L0S5N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:57:13 -0500
Content-Disposition: inline
In-Reply-To: <1324136144-12845-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 17, 2011 at 04:35:40PM +0100, Jan Engelhardt wrote:
> 
> The following changes since commit 7843632196fd959f3f8f16f3d533c72d315a7e08:
> 
>   expect: add nfexp_send() (2011-12-08 02:06:53 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/libnetfilter_conntrack master
> 
> Jan Engelhardt (3):
>       Update .gitignore
>       build: use AC_CONFIG_AUX_DIR and stash away tools
>       build: disable implicit .tar.gz archive generation and use POSIX mode
> 
>  .gitignore   |   11 ++++-------
>  configure.ac |    4 +++-
>  2 files changed, 7 insertions(+), 8 deletions(-)

Applied, thanks!
