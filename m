From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables 0/3] ebtables patchset
Date: Tue, 25 Mar 2014 09:40:07 +0200
Message-ID: <533132D7.3050306@linux.intel.com>
References: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com> <531D98DF.5070507@linux.intel.com> <20140324150956.GA32546@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30967 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaCYHkJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 03:40:09 -0400
In-Reply-To: <20140324150956.GA32546@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I think you have to extend nft_meta to support that. See
> ebt_basic_match(), the net_bridge_port information is obtained via
> br_port_get_rcu(dev) given that dev != NULL.
>
> Beware that you have to make sure that the new meta types IIFBRNAME
> and OIFBRNAME can only be used from the bridge family.  I think you
> have to do something similar to what Patrick did with nft_reject, by
> adding a specific flavour of nft_meta for the bridge family.

Indeed. Will prepare something quick

Thanks,

Tomasz
