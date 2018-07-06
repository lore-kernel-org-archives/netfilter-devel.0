From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] netfilter: conntrack: add weak IPV6 dependency
Date: Fri, 6 Jul 2018 16:50:45 +0200
Message-ID: <CAK8P3a1o6+dcZuW_iMGzwBBw_dcW41QAQ2Mu4A5Ru9ScnwaYDA@mail.gmail.com>
References: <20180706130005.3640993-1-arnd@arndb.de> <20180706135516.viz6pjtkdmcoqq2l@breakpoint.cc>
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
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180706135516.viz6pjtkdmcoqq2l@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 6, 2018 at 3:55 PM, Florian Westphal <fw@strlen.de> wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
>> Now that the conntrack module contains code for ipv6, we can no longer
>> have it built-in while IPv6 itself is a loadable module:
>>
>> net/netfilter/nf_conntrack_proto.o: In function `nf_ct_netns_do_get':
>> nf_conntrack_proto.c:(.text+0x88c): undefined reference to `nf_defrag_ipv6_enable'
>
> AFAICS this is caused by
>
> CONFIG_NF_CONNTRACK=y
> CONFIG_IPV6=m
> CONFIG_NF_DEFRAG_IPV6=m
>
> This is exported via nf_defrag_ipv6.ko.
>
> nf_defrag_ipv6 has an ipv6 dependency, but i think it might be avoidable
> so this would work:
>
> CONFIG_NF_CONNTRACK=y
> CONFIG_NF_DEFRAG_IPV6=y
> CONFIG_IPV6=m

I've tried it like this now:

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 07516d5c2f80..18b9f8f37c97 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -5,10 +5,6 @@
 menu "IPv6: Netfilter Configuration"
        depends on INET && IPV6 && NETFILTER

-config NF_DEFRAG_IPV6
-       tristate
-       default n
-
 config NF_SOCKET_IPV6
        tristate "IPv6 socket lookup support"
        help
@@ -352,3 +348,6 @@ endif # IP6_NF_IPTABLES

 endmenu

+config NF_DEFRAG_IPV6
+       tristate
+       default n
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e42c38c99741..51be519a3802 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -49,9 +49,8 @@ config NETFILTER_NETLINK_LOG
 config NF_CONNTRACK
        tristate "Netfilter connection tracking support"
        default m if NETFILTER_ADVANCED=n
-       depends on IPV6 || !IPV6
        select NF_DEFRAG_IPV4
-       select NF_DEFRAG_IPV6 if IPV6
+       select NF_DEFRAG_IPV6 if IPV6 != n
        help
          Connection tracking keeps a record of what packets have passed
          through your machine, in order to figure out how they are related

and that resulted in a new build failure:

net/netfilter/nf_conntrack_proto.o:(.rodata+0x788): undefined
reference to `nf_conntrack_l4proto_icmpv6'
net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_expire':
nf_conntrack_reasm.c:(.text+0x2320): undefined reference to
`ip6_expire_frag_queue'
net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_init':
nf_conntrack_reasm.c:(.text+0x2384): undefined reference to `ip6_frag_init'
nf_conntrack_reasm.c:(.text+0x2394): undefined reference to `ip6_frag_init'
nf_conntrack_reasm.c:(.text+0x2398): undefined reference to `ip6_rhash_params'
net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_expire':
nf_conntrack_reasm.c:(.text+0x10bc): undefined reference to
`ip6_expire_frag_queue'

I don't think we can get CONFIG_NF_DEFRAG_IPV6=y to work with IPV6=m.

      Arnd
