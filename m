From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 09/10] [NETFILTER]: constify and annotate nf_{conntrack,nat}_icmp
Date: Wed, 30 Jan 2008 16:49:23 +0100
Message-ID: <47A09C83.5000202@trash.net>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de> <Pine.LNX.4.64.0801260237550.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54526 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbYA3Ptj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:49:39 -0500
In-Reply-To: <Pine.LNX.4.64.0801260237550.15243@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Constify a few data tables use const qualifiers on variables where
> possible in the nf_conntrack_icmp* sources.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   10 ++++++----
>  net/ipv4/netfilter/nf_nat_proto_icmp.c         |    2 +-
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   14 ++++++++------
>  3 files changed, 15 insertions(+), 11 deletions(-)


Applied.
