From: Patrick McHardy <kaber@trash.net>
Subject: Re: (resend) pull for iptables
Date: Fri, 05 Jun 2009 16:46:51 +0200
Message-ID: <4A292FDB.4020005@trash.net>
References: <alpine.LSU.2.00.0906051524250.7950@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, pablo@netfilter.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59598 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZFEOqy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:46:54 -0400
In-Reply-To: <alpine.LSU.2.00.0906051524250.7950@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Please pull or apply from
> 	git://dev.medozas.de/iptables master
> 
> to receive:
> 
> [PATCH 1/5] libip6t_policy: remove redundant functions
> [PATCH 2/5] policy: use direct xt_policy_info instead of ipt/ip6t
> [PATCH 3/5] policy: merge ipv6 and ipv4 variant
> [PATCH 4/5] build: fix manpage collection
> [PATCH 5/5] extensions: use NFPROTO_UNSPEC for .family field

Looks good, pulled and pushed out again, thanks Jan.

Could you please add a complete diffstat for the entire series
to the pull requests in the future? That makes it easier to
verify that I indeed pulled what I had hoped to pull :)
