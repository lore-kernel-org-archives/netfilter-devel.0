From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: conntrack: add weak IPV6 dependency
Date: Fri, 6 Jul 2018 15:55:16 +0200
Message-ID: <20180706135516.viz6pjtkdmcoqq2l@breakpoint.cc>
References: <20180706130005.3640993-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-15?Q?M=E1t=E9?= Eckl <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180706130005.3640993-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:
> Now that the conntrack module contains code for ipv6, we can no longer
> have it built-in while IPv6 itself is a loadable module:
> 
> net/netfilter/nf_conntrack_proto.o: In function `nf_ct_netns_do_get':
> nf_conntrack_proto.c:(.text+0x88c): undefined reference to `nf_defrag_ipv6_enable'

AFAICS this is caused by

CONFIG_NF_CONNTRACK=y
CONFIG_IPV6=m
CONFIG_NF_DEFRAG_IPV6=m

This is exported via nf_defrag_ipv6.ko.

nf_defrag_ipv6 has an ipv6 dependency, but i think it might be avoidable
so this would work:

CONFIG_NF_CONNTRACK=y
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_IPV6=m
