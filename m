From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables-kernel PATCH] netfilter: nf_tables: Fixes how a table
 is checked to be in use
Date: Wed, 4 Sep 2013 12:48:32 +0200
Message-ID: <20130904104832.GA8799@localhost>
References: <1377855812-15251-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20130830223705.GA9864@localhost>
 <5225E354.4090000@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57094 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab3IDKsj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:48:39 -0400
Content-Disposition: inline
In-Reply-To: <5225E354.4090000@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 03, 2013 at 04:25:40PM +0300, Tomasz Bursztyka wrote:
[...]
> What's the use case for it? I mean: knowing that the table is in
> use, I can see some use case (and it could be done much simpler).
> The number of chains, not really. At least right now, nothing is
> using it so what could be the future need for that?
> Same for chains actually.

We need that use counter for iptables-nftables for chains. See xtables
-L for non-base chains.
