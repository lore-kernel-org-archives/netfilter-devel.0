From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/10] [NETFILTER]: annotate nf_conntrack_l3proto_* with
 const
Date: Wed, 30 Jan 2008 16:54:51 +0100
Message-ID: <47A09DCB.6050102@trash.net>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de> <Pine.LNX.4.64.0801260238010.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54626 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYA3PzI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:55:08 -0500
In-Reply-To: <Pine.LNX.4.64.0801260238010.15243@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/net/netfilter/nf_conntrack_core.h          |    4 +-
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   14 ++++++-----
>  .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    8 +++---
>  net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |    7 +++--
>  net/netfilter/nf_conntrack_standalone.c            |   10 ++++----
>  5 files changed, 23 insertions(+), 20 deletions(-)

Also applied, thanks Jan.
