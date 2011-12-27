From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2: build updates
Date: Tue, 27 Dec 2011 20:02:37 +0100
Message-ID: <20111227190237.GF28992@1984>
References: <1324136362-16840-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47315 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1L0TCk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 14:02:40 -0500
Content-Disposition: inline
In-Reply-To: <1324136362-16840-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 17, 2011 at 04:39:18PM +0100, Jan Engelhardt wrote:
> 
> The following changes since commit 1aa4c6135545ee8107584406f9d865d13c65a5ce:
> 
>   pcap: add file option to configuration file (2011-09-01 17:09:16 +0200)
> 
> are available in the git repository at:
>   git://dev.medozas.de/ulogd2 master
> 
> Jan Engelhardt (3):
>       Update .gitignore
>       build: use AC_CONFIG_AUX_DIR and stash away tools
>       build: disable implicit .tar.gz archive generation and use POSIX mode
> 
>  .gitignore   |   11 ++++-------
>  configure.ac |    4 ++--
>  2 files changed, 6 insertions(+), 9 deletions(-)

Applied, thanks.
