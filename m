From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] remove ipt_tos
Date: Sat, 20 Oct 2007 17:32:04 +0200
Message-ID: <471A1F74.306@trash.net>
References: <Pine.LNX.4.64.0710201345340.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33985 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbXJTPdE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:33:04 -0400
In-Reply-To: <Pine.LNX.4.64.0710201345340.1997@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Removes ipt_tos since there is now xt_tos.
>
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
> ---
>
>  remove include/linux/netfilter_ipv4/ipt_tos.h

Applied, but we usually keep the old headers around for old userspace,
so I've changed it to include the new file and #define ipt_tos_info
to xt_tos_info.

 include/linux/netfilter/xt_tos.h |   13 +++++++
 net/netfilter/Kconfig            |   10 ++++++
 net/netfilter/Makefile           |    1 
 net/netfilter/xt_tos.c           |   65 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+)

I've also added xt_tos.h to include/linux/netfilter/Kbuild.

