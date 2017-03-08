From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: untracked object removal
Date: Wed,  8 Mar 2017 13:49:48 +0100
Message-ID: <20170308124950.9369-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36978 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752861AbdCHNtu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 08:49:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches remove the percpu untracked objects, they get replaced
with a new (kernel internal) ctinfo state.

This avoids reference counter operations for untracked packets and
removes the need to check a conntrack for the UNTRACKED status bit
before setting connmark, labels, etc.

I checked with following rule set and things appear to work as
expected (i.e., ssh connections don't show up in conntrack -L):

*raw
:PREROUTING ACCEPT [455:34825]
:OUTPUT ACCEPT [251:29555]
[775:63699] -A PREROUTING -p tcp -m tcp --dport 22 -j NOTRACK
[251:29555] -A OUTPUT -p tcp -m tcp --sport 22 -j NOTRACK
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
[0:0] -A INPUT -m conntrack --ctstate INVALID -j DROP
[337:26377] -A INPUT -p tcp -m conntrack --ctstate UNTRACKED -m tcp --dport 22 -j ACCEPT
[0:0] -A INPUT -m conntrack --ctstate UNTRACKED
[102:13883] -A OUTPUT -p tcp -m conntrack --ctstate UNTRACKED -m tcp --sport 22 -j ACCEPT
[0:0] -A OUTPUT -m conntrack --ctstate UNTRACKED
COMMIT
