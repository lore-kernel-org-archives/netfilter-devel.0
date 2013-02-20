From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: nf_tables: complete net namespace support
Date: Wed, 20 Feb 2013 01:56:38 +0100
Message-ID: <20130220005638.GB4061@localhost>
References: <20130219230228.GA2345@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:35045 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759038Ab3BTA4m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:56:42 -0500
Content-Disposition: inline
In-Reply-To: <20130219230228.GA2345@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 20, 2013 at 12:02:28AM +0100, Patrick McHardy wrote:
> Hi Pablo,
> 
> just going through the commits to the nftables tree of the past two months,
> this one caught my eye:

Great, please let me know if you find more stuff to discuss.

> Commit a85bea2a (netfilter: nf_tables: complete net namespace support) adds
> per-NS af_info lists and registers the IPv4/IPv6/Bridge AFs in every NS.
> I don't get the point of this at all, when the module is loaded, the AFs
> will be registered in every namespace anyways, there's no way to have it
> registered in just a subset of the namespaces, so why do this at all?
> 
> From what I can tell, this patch can simply be reverted again.

We need an empty table list for each family in each namespace.
Otherwise registered tables will be globally visible in every existing
namespace.
