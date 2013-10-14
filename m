From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH] nft: arp: fix STRING_OVERFLOW
Date: Mon, 14 Oct 2013 09:14:27 +0300
Message-ID: <525B8BC3.6070804@linux.intel.com>
References: <1381569712-7835-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3JNGOa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 02:14:30 -0400
In-Reply-To: <1381569712-7835-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe Longo a =E9crit :


> This patch replace strcat with strncat and strcpy with strncpy
> fixing possible string overflow.

Can you remind in the commit message that this patch is a backport of=20
the patch http://patchwork.ozlabs.org/patch/279672/ ?
(I mean: name the original author)

Thanks,

Tomasz
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
