From: Patrick McHardy <kaber@trash.net>
Subject: datatype: fix crash if wrong integer type is passed
Date: Fri, 10 Jan 2014 08:04:25 +0000
Message-ID: <20140110080425.GA3799@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: eric@regit.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56699 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaAJIEa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:04:30 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm going through older commits in nftables that I didn't review at the
time and I'm wondering about this one:

commit a320531e78f1bcb12b24da048f34592771392a9a
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Wed Jul 24 15:14:22 2013 +0200

    datatype: fix crash if wrong integer type is passed
    
    Eric Leblond reported that this command:
    
    nft add rule ip6 filter input position 4 meta protocol icmpv6 accept
    
    crashes nft. The problem is that 'icmpv6' is wrong there, as
    meta protocol is expecting an ethernet protocol, that can be
    expressed as an hexadecimal.
    
    Now this command displays the following error:
    
    <cmdline>:1:52-57: Error: This is not a valid Ethernet protocol
    add rule ip6 filter input position 4 meta protocol icmpv6 accept
                                                       ^^^^^^
We have generic type checks so I don't want to add special ones (with
different error messages) for special cases.

Additionally I don't see the error, reverting that patch and executing
the mentioned rule produces:

<cmdline>:1:52-57: Error: datatype mismatch, expected Ethernet protocol, expression has type Internet protocol
add rule ip6 filter input position 4 meta protocol icmpv6 accept
                                     ~~~~~~~~~~~~~ ^^^^^^

Looking at the bugzilla entry, the bug report states:

BUG: invalid input descriptor type 538976288
nft: src/erec.c:100: erec_print: Assertion `0' failed.
Abandon

So the problem wasn't related to data types at all but simply due to
some bug in error reporting. I'll queue up a revert in my tree.
