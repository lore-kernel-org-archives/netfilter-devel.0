From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables-kernel PATCH] netfilter: nf_tables: Fixes how a table
 is checked to be in use
Date: Wed, 04 Sep 2013 14:51:17 +0300
Message-ID: <52271EB5.6050301@linux.intel.com>
References: <1377855812-15251-1-git-send-email-tomasz.bursztyka@linux.intel.com> <20130830223705.GA9864@localhost> <5225E354.4090000@linux.intel.com> <20130904104832.GA8799@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:59974 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab3IDLvU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 07:51:20 -0400
In-Reply-To: <20130904104832.GA8799@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> We need that use counter for iptables-nftables for chains. See xtables
> -L for non-base chains.

Oh you mean the references!
So semantically the 'use' attribute is not really proper (could it be 
changed? we need to update the documentation of the netlink API anyway: 
many attributes are not described),
moreover if you want to add the same attribute name in table which would 
have a different sense.

So on chain I see the point. Not on table though :)
(or a simpler one, knowing that "there are chains in it" instead of a 
counter)

Tomasz

