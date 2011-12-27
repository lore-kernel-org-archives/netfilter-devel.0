From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_log: build updates
Date: Tue, 27 Dec 2011 19:58:59 +0100
Message-ID: <20111227185859.GD28992@1984>
References: <1324136172-28320-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46946 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab1L0S7G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:59:06 -0500
Content-Disposition: inline
In-Reply-To: <1324136172-28320-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 17, 2011 at 04:36:08PM +0100, Jan Engelhardt wrote:
> 
> The following changes since commit 253172652d9f91f47b3bef79499d7994a9997f7f:
> 
>   build: fix error with automake-1.9 (2011-08-01 20:00:02 +0200)
> 
> are available in the git repository at:
>   git://dev.medozas.de/libnetfilter_log master
> 
> Jan Engelhardt (3):
>       Update .gitignore
>       build: use AC_CONFIG_AUX_DIR and stash away tools
>       build: disable implicit .tar.gz archive generation and use POSIX mode
> 
>  .gitignore   |   12 ++++--------
>  configure.ac |    5 +++--
>  2 files changed, 7 insertions(+), 10 deletions(-)

Applied, thanks
