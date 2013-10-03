From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH 3/3] xtables: arp: Do not add a useless
 prefix for afinfo_arp
Date: Thu, 03 Oct 2013 13:42:41 +0300
Message-ID: <524D4A21.5030103@linux.intel.com>
References: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1380793977-9730-4-git-send-email-tomasz.bursztyka@linux.intel.com> <20131003103701.GA15843@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:25283 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab3JCKmn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:42:43 -0400
In-Reply-To: <20131003103701.GA15843@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I think that .libprefix is ignored, so we don't really need this
> change.
>
> Are you noticing any problem when adding xtables-arp commands?

No indeed. It tries the prefix, and fallback to libxt_ as the default.
As you want then, this clarifies that at least we really don't have 
anything like libarp_ prefix

Tomasz
