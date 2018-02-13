From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net] netfilter: nat: cope with negative port range
Date: Tue, 13 Feb 2018 18:02:17 +0100
Message-ID: <20180213170217.GA2810@breakpoint.cc>
References: <9f25396653751c2d8130d7a1cbb62ae90969f37f.1518533214.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38680 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965538AbeBMRFh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Feb 2018 12:05:37 -0500
Content-Disposition: inline
In-Reply-To: <9f25396653751c2d8130d7a1cbb62ae90969f37f.1518533214.git.pabeni@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Paolo Abeni <pabeni@redhat.com> wrote:
> Fixes: c7232c9979cb ("netfilter: add protocol independent NAT core")

are you sure?
When I looked this was a day 0 bug, the code was just moved from ipv4.
