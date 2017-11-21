From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables: lockout with 0008split_tables_0 test
Date: Tue, 21 Nov 2017 18:09:46 +0100
Message-ID: <20171121170946.GB24866@breakpoint.cc>
References: <20171121111556.GX32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51810 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751191AbdKURKp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2017 12:10:45 -0500
Content-Disposition: inline
In-Reply-To: <20171121111556.GX32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> Hi,
> 
> This is about tests/shell/testcases/nft-f/0008split_tables_0, which adds
> the following simple ruleset:
> 
> | table inet filter {
> |         chain ssh {
> |                 type filter hook input priority 0; policy accept;
> |                 tcp dport ssh accept;
> |         }
> | }
> | 
> | table inet filter {
> |         chain input {
> |                 type filter hook input priority 1; policy drop;
> |         }
> | }
> 
> If applied, it kills my SSH connection. :(

Yes, thats expected.
First ssh base chain gets invoked, which accepts any packet
either by verdict or policy.

Then next base chain gets consulted which drops the packet.

I would suggest to either swap the policies or duplicate the ssh
rule into the input chain too.
