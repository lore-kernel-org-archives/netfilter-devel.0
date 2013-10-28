From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables-kernel PATCH] netfilter: nftables: Fix sparse endianness
 issue on nft_nat.c
Date: Mon, 28 Oct 2013 09:18:15 +0200
Message-ID: <526E0FB7.8060206@linux.intel.com>
References: <1382086853-14251-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37377 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab3J1HSR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:18:17 -0400
In-Reply-To: <1382086853-14251-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Any thoughts on that one?
Is there another (and proper) way of fixing this?

Tomasz
