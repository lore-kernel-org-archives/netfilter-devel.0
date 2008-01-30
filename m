From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/10] [NETFILTER]: annotate nf_{conntrack,nat}_sip with
 const
Date: Wed, 30 Jan 2008 16:34:33 +0100
Message-ID: <47A09909.10903@trash.net>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de> <Pine.LNX.4.64.0801260236560.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54133 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbYA3Pet (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:34:49 -0500
In-Reply-To: <Pine.LNX.4.64.0801260236560.15243@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/linux/netfilter/nf_conntrack_sip.h |    6 ++--
>  net/ipv4/netfilter/nf_nat_sip.c            |    4 +-
>  net/netfilter/nf_conntrack_sip.c           |   25 ++++++++++---------
>  3 files changed, 18 insertions(+), 17 deletions(-)

Applied.
