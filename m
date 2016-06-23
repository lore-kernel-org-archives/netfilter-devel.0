From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipset: Backports for the nla_put_net64() API changes
Date: Thu, 23 Jun 2016 12:37:44 +0200
Message-ID: <20160623103744.GA10764@salvia>
References: <20160623102211.GA31272@hydrogen>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47830 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbcFWKht convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 06:37:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B4C3AE7DAA
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:37:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A1ADB9EBCA
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:37:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F31109EBB2
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:37:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160623102211.GA31272@hydrogen>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 23, 2016 at 05:22:11PM +0700, Neutron Soutmun wrote:
> * Backports the patch "libnl: nla_put_net64():align on a 64-bit area" [1]
>   by Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> * Since the nla_put_net64() API has been changed, therefore, the
>   ip_set_compat.h.in should provides the macro IPSET_NLA_PUT_NET64 that
>   point to the nla_put_net64() with appropriate number of arguments.
> 
>   The build script should distinguish the API changes by detect for
>   the existence of nla_put_64bit() function in include/net/netlink.h.
>   This function was added in the same patches set and called by
>   the nla_put_be64() that called by nla_put_net64() respectively.

What are you specifically fixing with this?

The pad attribute just makes sure that, after accessing a 64-bit
payload attribute, the follow up attribute still gets aligned to
64-bits.
