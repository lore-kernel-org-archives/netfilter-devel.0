From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/8] [NETFILTER]: Use bool type in struct nf_conntrack_l3proto
Date: Tue, 08 Apr 2008 17:03:23 +0200
Message-ID: <47FB893B.7010808@trash.net>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <67629b27a77644a6643e252580a9f77663191831.1207664141.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41776 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYDHPDk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:03:40 -0400
In-Reply-To: <67629b27a77644a6643e252580a9f77663191831.1207664141.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/net/netfilter/nf_conntrack_l3proto.h   |    8 ++++----
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   14 +++++++-------
>  net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   14 +++++++-------
>  net/netfilter/nf_conntrack_l3proto_generic.c   |   12 ++++++------
>  4 files changed, 24 insertions(+), 24 deletions(-)

Applied.
