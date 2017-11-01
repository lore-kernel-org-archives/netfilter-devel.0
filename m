From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] connlimit for nftables and limiting ct count by zone
Date: Wed, 1 Nov 2017 02:26:00 +0100
Message-ID: <20171101012600.GE7663@breakpoint.cc>
References: <20171016144254.GA3728@breakpoint.cc>
 <CAG1aQhJR9OMtxKgW3CQePsGDahbrpUpNk0Srx=RdOnr0_tWmKg@mail.gmail.com>
 <20171030104018.GA6593@breakpoint.cc>
 <CAG1aQhJ06iWmXsxD8QsaR-tkJVnGRKhAP1ieBx5ENY1kAzzsBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        YiHung Wei <yihungw@vmware.com>,
        Justin Pettit <jpettit@vmware.com>, Joe Stringer <joe@ovn.org>
To: Yi-Hung Wei <yihung.wei@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50110 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752175AbdKAB00 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Oct 2017 21:26:26 -0400
Content-Disposition: inline
In-Reply-To: <CAG1aQhJ06iWmXsxD8QsaR-tkJVnGRKhAP1ieBx5ENY1kAzzsBg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yi-Hung Wei <yihung.wei@gmail.com> wrote:
> > Really?  So far my impression was that ovs does not wish
> > to interact with nft in any way.
> I was thinking about how to use nft to get and the ct limit and ct
> count not by ovs tho. Say a nft user may want to know how many active
> connections are there in a particular zone.

They can do that with the conntrack tool ("conntrack -L --zone 42"),
we can extend the filtering capabilties if needed.
