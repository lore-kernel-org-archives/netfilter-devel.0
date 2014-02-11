From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables (nft-compat) PATCH 3/8] xtables: Handle family is not
 related to Netlink family
Date: Tue, 11 Feb 2014 13:13:17 +0200
Message-ID: <52FA05CD.2060008@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1392115608-6733-4-git-send-email-tomasz.bursztyka@linux.intel.com> <20140211110242.GB4299@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaBKLNU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:13:20 -0500
In-Reply-To: <20140211110242.GB4299@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> AF_INET vs NFPROTO_IPV4
>> AF_INET6 vs NFPROTO_IPV6
> I think we should stick to NFPROTO_*
>
> I can see many references to AF_ in the compat layer, you can send me
> a patch to rename all those instead.

Actually we have always used AF_*
I will do the change

Tomasz

