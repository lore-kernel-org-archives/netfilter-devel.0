From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 2/2] netfilter: nft: add queue module
Date: Mon, 02 Dec 2013 08:39:47 +0200
Message-ID: <529C2B33.9020205@linux.intel.com>
References: <1385808722.4321.19.camel@ice-age2.regit.org> <1385808978-19833-1-git-send-email-eric@regit.org> <1385808978-19833-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46554 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3LBGjy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Dec 2013 01:39:54 -0500
In-Reply-To: <1385808978-19833-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

> +
> +#define NFT_QUEUE_FLAG_BYPASS		0x01 /* for compatibility with v2 */
> +#define NFT_QUEUE_FLAG_CPU_FANOUT	0x02 /* use current CPU (no hashing) */
> +#define NFT_QUEUE_FLAG_MASK		0x03

Why not declaring them in an enum, as for nft_rule_compat_flags, 
nft_set_flags or nft_set_elem_flags?

Tomasz
