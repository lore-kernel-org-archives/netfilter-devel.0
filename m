From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/8] [NETFILTER]: Use bool type in nf_nat_proto
Date: Tue, 08 Apr 2008 17:16:03 +0200
Message-ID: <47FB8C33.6000304@trash.net>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <2c53bdac5644e1bba8f663f011834b1fbf735d09.1207664141.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42095 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYDHPQP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:16:15 -0400
In-Reply-To: <2c53bdac5644e1bba8f663f011834b1fbf735d09.1207664141.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/net/netfilter/nf_nat_protocol.h   |   42 ++++++++++----------
>  net/ipv4/netfilter/nf_nat_core.c          |    8 ++--
>  net/ipv4/netfilter/nf_nat_proto_common.c  |   10 ++--
>  net/ipv4/netfilter/nf_nat_proto_dccp.c    |   10 ++--
>  net/ipv4/netfilter/nf_nat_proto_gre.c     |   18 ++++----
>  net/ipv4/netfilter/nf_nat_proto_icmp.c    |   14 +++---
>  net/ipv4/netfilter/nf_nat_proto_sctp.c    |    8 ++--
>  net/ipv4/netfilter/nf_nat_proto_tcp.c     |   10 ++--
>  net/ipv4/netfilter/nf_nat_proto_udp.c     |    8 ++--
>  net/ipv4/netfilter/nf_nat_proto_udplite.c |    8 ++--
>  net/ipv4/netfilter/nf_nat_proto_unknown.c |   24 ++++++------
>  11 files changed, 80 insertions(+), 80 deletions(-)

Applied.
