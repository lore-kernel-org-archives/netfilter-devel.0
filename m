From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables (nft-compat) PATCH 3/8] xtables: Handle family is not
 related to Netlink family
Date: Tue, 11 Feb 2014 13:28:54 +0200
Message-ID: <52FA0976.3000306@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1392115608-6733-4-git-send-email-tomasz.bursztyka@linux.intel.com> <20140211110242.GB4299@localhost> <52FA05CD.2060008@linux.intel.com> <20140211112311.GA5011@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36177 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbaBKL26 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:28:58 -0500
In-Reply-To: <20140211112311.GA5011@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> >Actually we have always used AF_*
>> >I will do the change
> Beware that there is no AF_ARP, that's why we have NFPROTO_ARP and
> also the new NFPROTO_INET for mixed ipv4/ipv6 tables in nft.

Yup
