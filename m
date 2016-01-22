From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables] Add support for masquerade port selection
Date: Fri, 22 Jan 2016 22:06:12 +0100
Message-ID: <20160122210612.GA9707@salvia>
References: <20160122205554.GA12691@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45281 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbcAVVGV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jan 2016 16:06:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EA08A1324C0
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 22:06:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CF1E8DA804
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 22:06:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 08CB4DA803
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 22:06:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160122205554.GA12691@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 23, 2016 at 02:25:55AM +0530, Shivani Bhardwaj wrote:
> Provide full support for masquerading by allowing port range selection.

Almost there:

You have to update stmt_evaluate_masq() too, otherwise...

$ sudo nft add table nat
$ sudo nft add chain nat post { type nat hook postrouting priority 0\; }
$ sudo nft add rule nat post masquerade to :1024-65535
BUG: unknown expression type symbol
nft: netlink_linearize.c:656: netlink_gen_expr: Assertion `0' failed.
Abortado

Then, you can check the listing via:

$ sudo nft list ruleset

Once you get this working, you have to add a new test to
tests/py/inet/masq.t

# python tests/py/nft-tests.py
