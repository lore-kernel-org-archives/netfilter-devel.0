From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/7] nftables: add ct helper set support
Date: Mon, 27 Feb 2017 16:02:48 +0100
Message-ID: <20170227150255.12624-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55738 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751364AbdB0PCi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 10:02:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series adds initial support to set conntrack helpers via
the nft objref infrastructure.

As -next is closed I will not push this yet since kernel support
is still missing.

Currently only supported attributes are:

type (e.g. "ftp", "sip)
protocol (udp or tcp)
l3proto (ip, ip6).

l3proto is optional, the kernel will infer it from
the family, i.e. in "inet" case kernel will check for both ipv4 and ipv6.

Let me know in case you spot any isses, patches #3 and #5 could already
be pushed to nft master since they are just preparation patches.

