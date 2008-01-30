From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/10] [NETFILTER]: annotate nf_{conntrack,nat}_proto_gre
 with const
Date: Wed, 30 Jan 2008 16:48:18 +0100
Message-ID: <47A09C42.9050408@trash.net>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de> <Pine.LNX.4.64.0801260237480.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54464 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbYA3Pse (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:48:34 -0500
In-Reply-To: <Pine.LNX.4.64.0801260237480.15243@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  net/ipv4/netfilter/nf_nat_proto_gre.c  |    2 +-
>  net/netfilter/nf_conntrack_proto_gre.c |    6 ++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)

Applied.
