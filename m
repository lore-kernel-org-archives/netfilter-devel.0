From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 04/10] [NETFILTER]: annotate nf_{conntrack,nat}_pptp with
 const
Date: Wed, 30 Jan 2008 16:37:08 +0100
Message-ID: <47A099A4.3050604@trash.net>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de> <Pine.LNX.4.64.0801260237160.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54202 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbYA3PhY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:37:24 -0500
In-Reply-To: <Pine.LNX.4.64.0801260237160.15243@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/linux/netfilter/nf_conntrack_pptp.h |    2 +-
>  net/ipv4/netfilter/nf_nat_pptp.c            |   10 +++++-----
>  net/netfilter/nf_conntrack_pptp.c           |   14 ++++++++------
>  3 files changed, 14 insertions(+), 12 deletions(-)

Applied.
