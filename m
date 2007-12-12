From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5] Add support for NAT sequence adjustments
Date: Wed, 12 Dec 2007 09:29:46 +0100
Message-ID: <475F9BFA.1000705@trash.net>
References: <475C302C.1070402@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38142 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbXLLI3s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:29:48 -0500
In-Reply-To: <475C302C.1070402@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> The combination of NAT and helpers may produce TCP sequence adjustments.
> In failover setups, this information needs to be replicated in order to
> achieve a successful recovery of mangled, related connections. This
> patch is particularly useful for conntrackd, see:


Applied, thanks Pablo. I did some minor renaming though, the
attribute names were neither consistent with themselves nor
with the naming scheme used elsewhere, so we now have:

+enum ctattr_natseq {
+       CTA_NAT_SEQ_CORRECTION_POS,
+       CTA_NAT_SEQ_OFFSET_BEFORE,
+       CTA_NAT_SEQ_OFFSET_AFTER,
+       __CTA_NAT_SEQ_MAX
+};
+#define CTA_NAT_SEQ_MAX (__CTA_NAT_SEQ_MAX - 1)
