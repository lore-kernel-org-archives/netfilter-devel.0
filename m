From: Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] netfilter: nat: cope with negative port range
Date: Tue, 13 Feb 2018 18:22:35 +0100
Message-ID: <1518542555.2376.6.camel@redhat.com>
References: <9f25396653751c2d8130d7a1cbb62ae90969f37f.1518533214.git.pabeni@redhat.com>
         <20180213170217.GA2810@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964849AbeBMRWh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Feb 2018 12:22:37 -0500
In-Reply-To: <20180213170217.GA2810@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2018-02-13 at 18:02 +0100, Florian Westphal wrote:
> Paolo Abeni <pabeni@redhat.com> wrote:
> > Fixes: c7232c9979cb ("netfilter: add protocol independent NAT core")
> 
> are you sure?
> When I looked this was a day 0 bug, the code was just moved from ipv4.

You are right, the named commit just move around the bugged code, the
bug is apparently there since:

commit 5b1158e909ecbe1a052203e0d8df15633f829930
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Dec 2 22:07:13 2006 -0800

    [NETFILTER]: Add NAT support for nf_conntrack

I'll send a v2 with an updated commit message, thanks!

Paolo
