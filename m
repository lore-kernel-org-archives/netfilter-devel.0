From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/10] [NETFILTER]: annotate nf_{conntrack,nat}_proto_udp{,lite}
 with const
Date: Wed, 30 Jan 2008 16:47:12 +0100
Message-ID: <47A09C00.3010309@trash.net>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de> <Pine.LNX.4.64.0801260237420.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54434 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbYA3Pra (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:47:30 -0500
In-Reply-To: <Pine.LNX.4.64.0801260237420.15243@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  net/ipv4/netfilter/nf_nat_proto_udp.c      |    2 +-
>  net/netfilter/nf_conntrack_proto_udp.c     |    6 ++++--
>  net/netfilter/nf_conntrack_proto_udplite.c |    6 ++++--
>  3 files changed, 9 insertions(+), 5 deletions(-)

Applied.
