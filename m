From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 3/5] netfilter: nf_tables: Add meta expression key for
 bridge interface name
Date: Thu, 24 Apr 2014 09:08:58 +0300
Message-ID: <5358AA7A.7030104@linux.intel.com>
References: <1397479290-6967-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1397479290-6967-4-git-send-email-tomasz.bursztyka@linux.intel.com> <20140423120325.GA7799@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55969 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaDXGJB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:09:01 -0400
In-Reply-To: <20140423120325.GA7799@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I'm going to rename
> NFT_META_BRI_IIFNAME to NFT_META_IBRIPORT,

As you want. I took the name proposed by Patrick here, and since it's an API
there is less concerns about having a really short human-writable name as
for the nftables tool.

Tomasz
