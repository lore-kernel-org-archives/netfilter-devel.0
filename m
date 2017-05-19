From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3 0/7] switch l4 dependency to meta l4proto
Date: Fri, 19 May 2017 22:11:04 +0200
Message-ID: <20170519201111.7402-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34030 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751513AbdESUKx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 16:10:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently nft inserts different types of dependencies for l4 protocols,
depending on the family.

For inet, nft inserts 'meta l4proto' to e.g. check for tcp, for
ip, nft uses 'ip protocol'. Both are fine.  The ip6 family however
uses 'ip6 nexthdr', and thats a problem because e.g. tcp dport 22 will
not match packets that use ipv6 extension headers.

The series switches both ipv6 and ipv4 to use meta l4 instead
so ipv6 will always check the last transport header value.

We could ignore ip as only ipv6 uses extension headers.
However, switching ipv4 as well makes things a bit simpler because nft
then creates the same l4 dependency for all families.

