From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix ERROR target on CRIS
Date: Thu, 16 Oct 2008 14:06:09 +0200
Message-ID: <48F72E31.9050603@trash.net>
References: <A612847CFE53224C91B23E3A5B48BAC73889D09813@xmail3.se.axis.com> <A612847CFE53224C91B23E3A5B48BAC73889D09814@xmail3.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jesper Bengtsson <jesper.bengtsson@axis.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64708 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYJPMGO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:06:14 -0400
In-Reply-To: <A612847CFE53224C91B23E3A5B48BAC73889D09814@xmail3.se.axis.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Bengtsson wrote:
> This patch corrects a problem with adding ERROR targets on architectures that don't align data structues, e.g. CRIS.
> 
> --- linux-2.6/include/linux/netfilter_ipv4/ip_tables.h 21 Aug 2008 08:40:42 -0000 1.19
> +++ linux-2.6/include/linux/netfilter_ipv4/ip_tables.h 15 Oct 2008 12:55:31 -0000
> @@ -259,7 +259,7 @@ struct ipt_standard
>  struct ipt_error_target
>  {
>   struct ipt_entry_target target;
> - char errorname[IPT_FUNCTION_MAXNAMELEN];
> + char errorname[IPT_TABLE_MAXNAMELEN];

Your mailer whitespace-corrupted the patch, please send as attachment.
Please also fix up ip6_tables and arp_tables.
