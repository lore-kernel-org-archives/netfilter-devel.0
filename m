From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH 00/47] Netfilter/IPVS updates for net-next
Date: Tue, 3 Apr 2018 08:13:49 +0200
Message-ID: <fbd3cd82-cece-74cb-2305-bbb6980b52cc@gmail.com>
References: <20180330113729.18335-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113729.18335-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

 > The following patchset contains Netfilter/IPVS updates for your net-next
 > tree. This batch comes with more input sanitization for xtables to
 > address bug reports from fuzzers, preparation works to the flowtable
 > infrastructure and assorted updates. In no particular order, they are:
 >
 > 1) Make sure userspace provides a valid standard target verdict, from
 >    Florian Westphal.
 >
 > 2) Sanitize error target size, also from Florian.
 >
 > 3) Validate that last rule in basechain matches underflow/policy since
 >    userspace assumes this when decoding the ruleset blob that comes
 >    from the kernel, from Florian.
 >
 > 4) Consolidate hook entry checks through xt_check_table_hooks(),
 >    patch from Florian.
 >
 > 5) Cap ruleset allocations at 512 mbytes, 134217728 rules and reject
 >    very large compat offset arrays, so we have a reasonable upper limit
 >    and fuzzers don't exercise the oom-killer. Patches from Florian.
 >
 > 6) Several WARN_ON checks on xtables mutex helper, from Florian.
 >
 > 7) xt_rateest now has a hashtable per net, from Cong Wang.
 >
 > 8) Consolidate counter allocation in xt_counters_alloc(), from Florian.
 >
 > 9) Earlier xt_table_unlock() call in {ip,ip6,arp,eb}tables, patch
 >    from Xin Long.
 >
 > 10) Set FLOW_OFFLOAD_DIR_* to IP_CT_DIR_* definitions, patch from
 >     Felix Fietkau.
 >
 > 11) Consolidate code through flow_offload_fill_dir(), also from Felix.
 >
 > 12) Inline ip6_dst_mtu_forward() just like ip_dst_mtu_maybe_forward()
 >     to remove a dependency with flowtable and ipv6.ko, from Felix.
 >
 > 13) Cache mtu size in flow_offload_tuple object, this is safe for
 >     forwarding as f87c10a8aa1e describes, from Felix.
 >
 > 14) Rename nf_flow_table.c to nf_flow_table_core.o, to simplify too
 >     modular infrastructure, from Felix.

I see you mentioned changes from Felix in the pull request but:
1) I don't see any commits from Felix listed below
2) I don't think you sent any of these patches

Can you take a look at what has happened to them, please?
