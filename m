From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: nf_tables: complete net namespace support
Date: Wed, 20 Feb 2013 00:02:28 +0100
Message-ID: <20130219230228.GA2345@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44475 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179Ab3BSXCc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2013 18:02:32 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

just going through the commits to the nftables tree of the past two months,
this one caught my eye:

Commit a85bea2a (netfilter: nf_tables: complete net namespace support) adds
per-NS af_info lists and registers the IPv4/IPv6/Bridge AFs in every NS.
I don't get the point of this at all, when the module is loaded, the AFs
will be registered in every namespace anyways, there's no way to have it
registered in just a subset of the namespaces, so why do this at all?

>From what I can tell, this patch can simply be reverted again.
