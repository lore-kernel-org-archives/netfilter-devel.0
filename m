From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables: masquerade sets wrong source address
Date: Thu, 22 Dec 2016 11:34:48 +0100
Message-ID: <20161222103448.GA31504@breakpoint.cc>
References: <CAEvi_o9_SJNGH-RWq6Kt+UiXVY4ozaMy3yJ2rPdV0Rbk1QrRZw@mail.gmail.com>
 <CAML_gOdZn8UmZzeDWd6q--U9+f+SzBLMppCEtdCFsZ4rrTZ24A@mail.gmail.com>
 <CAEvi_o-7soTh5vPqniCo76Szbf7J1y6nwwD-YqJ5uJvOYSeVHw@mail.gmail.com>
 <CAML_gOfxzY9iWefK8Vw8kxYXNmOrZBmouO=PfMxtyz4jfp=13g@mail.gmail.com>
 <CAEvi_o96hh=ZfkofcjswUEDeH1Pi6wGD99qV+k87B=Z+QM-78w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter@vger.kernel.org,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Tom Hacohen <tom@stosb.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEvi_o96hh=ZfkofcjswUEDeH1Pi6wGD99qV+k87B=Z+QM-78w@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Tom Hacohen <tom@stosb.com> wrote:
> I'm sorry for repeating myself, however I'd like to stress out again,
> that while your workaround fixes an inconsistency between iptables and
> nftables, the scenario itself is caused by the buggy behaviour of
> masquerade with "lo", and that needs to be fixed too. The workaround
> above, and any fixes to that issue will only fix the dropping of the
> packets, but the wrong rewrite will still be there.

The 'wrong rewrite' also occurs with iptables.

It doesn't cause connectivity issues because in iptables the nat table
always registers the output hook.

(I agree that nft masquerade should not cause these connectivity issues,
 but I think proper ruleset fix is to use meta iif to restrict masq to
 the correct interface(s)).
