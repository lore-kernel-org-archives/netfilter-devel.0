From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] [NETFILTER]: Use bool type in struct nf_conntrack_l4proto
Date: Tue, 08 Apr 2008 17:05:47 +0200
Message-ID: <47FB89CB.5080409@trash.net>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <37930da3de9690be8eeed1e201ed0ef62288af44.1207664141.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41837 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbYDHPGE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:06:04 -0400
In-Reply-To: <37930da3de9690be8eeed1e201ed0ef62288af44.1207664141.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/net/netfilter/nf_conntrack_l4proto.h   |   13 ++--
>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   25 ++++----
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   27 ++++----
>  net/netfilter/nf_conntrack_proto_dccp.c        |   22 +++---
>  net/netfilter/nf_conntrack_proto_generic.c     |   20 +++---
>  net/netfilter/nf_conntrack_proto_gre.c         |   25 ++++----
>  net/netfilter/nf_conntrack_proto_sctp.c        |   33 +++++-----
>  net/netfilter/nf_conntrack_proto_tcp.c         |   52 ++++++++--------
>  net/netfilter/nf_conntrack_proto_udp.c         |   18 +++---
>  net/netfilter/nf_conntrack_proto_udplite.c     |   22 +++---
>  10 files changed, 125 insertions(+), 132 deletions(-)

Applied.
