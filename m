From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/13] NFNL_SUBSYS_IPSET id and NLA_PUT_NET* macros
Date: Tue, 01 Feb 2011 15:24:10 +0100
Message-ID: <4D48178A.6000507@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43183 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab1BAOYM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:24:12 -0500
In-Reply-To: <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 23:52, schrieb Jozsef Kadlecsik:
> The patch adds the NFNL_SUBSYS_IPSET id and NLA_PUT_NET* macros to the vanilla
> kernel.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/linux/netfilter/nfnetlink.h |    3 ++-
>  include/net/netlink.h               |    9 +++++++++
>  2 files changed, 11 insertions(+), 1 deletions(-)

Applied, thanks.
