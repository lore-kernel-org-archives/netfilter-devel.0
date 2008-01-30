From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/10] [NETFILTER]: constify and annotate nf_{conntrack,nat}_proto_tcp
Date: Wed, 30 Jan 2008 16:40:12 +0100
Message-ID: <47A09A5C.4000707@trash.net>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de> <Pine.LNX.4.64.0801260237360.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54287 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbYA3Pk3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:40:29 -0500
In-Reply-To: <Pine.LNX.4.64.0801260237360.15243@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Constify a few data tables use const qualifiers on variables where
> possible in the nf_*_proto_tcp sources.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/net/netfilter/nf_conntrack.h   |    2 +-
>  net/ipv4/netfilter/nf_nat_proto_tcp.c  |    2 +-
>  net/netfilter/nf_conntrack_proto_tcp.c |   44 +++++++++++++-----------
>  3 files changed, 26 insertions(+), 22 deletions(-)

Applied with some minor editing to remove conflicts with my
naming unification patch.
