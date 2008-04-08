From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/8] [NETFILTER]: Replace NF_CT_DUMP_TUPLE macro indrection
 by function call
Date: Tue, 08 Apr 2008 17:21:34 +0200
Message-ID: <47FB8D7E.6030408@trash.net>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <f73c6fe026e06a5fa9645202a3443d8b75e9ba8d.1207664141.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42236 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYDHPVg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:21:36 -0400
In-Reply-To: <f73c6fe026e06a5fa9645202a3443d8b75e9ba8d.1207664141.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Directly call IPv4 and IPv6 variants where the address family is
> easily known.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/net/netfilter/nf_conntrack_tuple.h     |    2 -
>  net/ipv4/netfilter/ipt_CLUSTERIP.c             |    2 +-
>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
>  net/ipv4/netfilter/nf_nat_pptp.c               |    2 +-
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
>  net/netfilter/nf_conntrack_core.c              |    2 +-
>  net/netfilter/nf_conntrack_h323_main.c         |   26 ++++++++--------
>  net/netfilter/nf_conntrack_pptp.c              |    4 +-
>  net/netfilter/nf_conntrack_proto_gre.c         |    6 ++--
>  net/netfilter/nf_conntrack_proto_tcp.c         |    6 ++--
>  net/netfilter/nf_conntrack_sane.c              |    2 +-
>  net/netfilter/nf_conntrack_tftp.c              |    6 ++--
>  12 files changed, 30 insertions(+), 32 deletions(-)

Applied.
