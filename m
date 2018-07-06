From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] netfilter: conntrack: add weak IPV6 dependency
Date: Fri, 6 Jul 2018 17:14:06 +0200
Message-ID: <CAK8P3a2H44gVZWkC+4vYbg68rr90Fhr12DktEAFMFFOB6fbE9Q@mail.gmail.com>
References: <20180706130005.3640993-1-arnd@arndb.de> <20180706135516.viz6pjtkdmcoqq2l@breakpoint.cc>
 <CAK8P3a1o6+dcZuW_iMGzwBBw_dcW41QAQ2Mu4A5Ru9ScnwaYDA@mail.gmail.com> <20180706150037.knqt736uq6uyh3bs@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?TcOhdMOpIEVja2w=?= <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180706150037.knqt736uq6uyh3bs@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 6, 2018 at 5:00 PM, Florian Westphal <fw@strlen.de> wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
>> and that resulted in a new build failure:
>>
>> net/netfilter/nf_conntrack_proto.o:(.rodata+0x788): undefined
>> reference to `nf_conntrack_l4proto_icmpv6'
>> net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_expire':
>> nf_conntrack_reasm.c:(.text+0x2320): undefined reference to
>> `ip6_expire_frag_queue'
>> net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_init':
>> nf_conntrack_reasm.c:(.text+0x2384): undefined reference to `ip6_frag_init'
>> nf_conntrack_reasm.c:(.text+0x2394): undefined reference to `ip6_frag_init'
>> nf_conntrack_reasm.c:(.text+0x2398): undefined reference to `ip6_rhash_params'
>> net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_expire':
>> nf_conntrack_reasm.c:(.text+0x10bc): undefined reference to
>> `ip6_expire_frag_queue'
>>
>> I don't think we can get CONFIG_NF_DEFRAG_IPV6=y to work with IPV6=m.
>
> Yes, not with current implementation, but I still don't think this
> is unavoidable.
>
> In case this is urgent I'm fine with the patch that adds the dependency,
> otherwise I'd like to try and disentangle nf_conntrack_reasm and ipv6.

I don't think any real users depend on it, but I hit the problem quite
frequently in randconfig testing on linux-next.

       Arnd
