From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfnetlink: build updates
Date: Tue, 27 Dec 2011 19:53:34 +0100
Message-ID: <20111227185334.GB28992@1984>
References: <1324091086-6074-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46574 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab1L0Sxk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:53:40 -0500
Content-Disposition: inline
In-Reply-To: <1324091086-6074-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 17, 2011 at 04:04:42AM +0100, Jan Engelhardt wrote:
> 
> The following changes since commit 98a8de97de020cedb0240cd0554dc6246bf0237a:
> 
>   build: fix error with automake-1.9 (2011-08-01 19:55:55 +0200)
> 
> are available in the git repository at:
>   git://dev.medozas.de/libnfnetlink master
> 
> Jan Engelhardt (3):
>       Update .gitignore
>       build: use AC_CONFIG_AUX_DIR and stash away tools
>       build: disable implicit .tar.gz archive generation and use POSIX mode
> 
>  .gitignore   |   12 ++++--------
>  configure.ac |    4 +++-
>  2 files changed, 7 insertions(+), 9 deletions(-)

Applied, thanks a lot.
