Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793334869;
	b=tzgZF10BFX5hKZxSLppI7M90r2RwIcPYUyBanWeV0Ui7pqOWA6hk+bb9O+lKpkK/iGyC
	 Z0nikINimYO6g/TItkxzYWaEw4uoT+5k/mIs9pzmHA4BNqKVB3vm7NQlVvvEpdoqjlsmJ
	 KR6cCjqqSo2RU+9LZFrQvBo4ZpHKUBOidPxkZqG+zDGnEz2uXo/Z/cQSRUEhgqLsEnDqt
	 3kNQalBaGGgp7ovvXjvdBHpgST/qoTAuBmvyw2NBQjPTVgBMjpU4gfyAaTistJZF09+zY
	 JswDQjOEFrexYmC+9BSWaE3Jq9bbJWjRTWkyi9EyYo/OE7EgBeumYiOP39BtUfMp7cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793334869;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=EdNxZc4X6LJFiwbbPfzZhQvrmn346FFzNDGFNfDLac0=;
	b=jt3b9VH03X1d7NJRRMUC2Gvryzmz4SA+d7/+nOC6nEAB2hwhfwGOAFWP4OvsyqkPhTkS
	 2kM4zIcn4GHpCpvrM3/b24IfrlbGCDmVfLlgdttrUu9KpIzdjJf3i+XOtVaSM+zLCJCPM
	 0Aa2MbEohxh3eFc/WssPI980bKMq+Lm5x/9stjy1xtA68eFbLg0u6p32CkzUyKfkLOG/k
	 4WqJD5ZK7F8okpDg5/Ftq0af1SDuIsfbPqTfb/hFfkEgqMsyH+X6jA9biwhxHk5JY4lQ0
	 XujX5fnPwdX6rLsVdYLL1lx2D56HnynQAb1lmA2mWqryfjkACCq9UBtNOpOlOVF8KwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QXQWURvf;
	arc=none smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA51606A31A;
	Fri, 30 Oct 2026 04:34:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FA51606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QXQWURvf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793334866; x=1824870866;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aOvaYqDIxiTGgTbHsnThDlqt+KqsfhQW5CiHanjH9V4=;
  b=QXQWURvfExmYHIlePXiVJ4UUWvNS98lAe/RpubvV63ZI0nFv0F0QQP7n
   Gb9/66XbWsogpK7jK6HNCZPwbk8JPhyWnGpKMVf0XazBHo2/+P6uIPLPk
   tjFb1xvCZBsJU/M6KC44+Is0xjrJ68QwfkPxe+Vlvkd9jj3M7yf7CqW+i
   ZwHneoWeVs2A5dA01ttoE2R2eQZi9PKQFB37EDnJehVTXRqiF9rOB4X2v
   8vEUumIQf9oPpwg792CN41bGEDp5B+bqK3rlIQoXlwKqSLpLww9XFuWPH
   nlqLeY2FjXaQ2w0QddLBfSQQx1RadUqZX0kNBrf5wQo2fQ7J5H7vuXIUz
   w==;
X-CSE-ConnectionGUID: 82govd88Tpy7/dmBB2NsZA==
X-CSE-MsgGUID: TQbXeH7NS3irMiu/qcHJqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2106855"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="2106855"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 21:34:25 -0700
X-CSE-ConnectionGUID: Ib86rIOjQPKTYfDG86lDUQ==
X-CSE-MsgGUID: aImYJuVoSn+YdNVEjNHdPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5695023"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 29 Oct 2026 21:34:22 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMeJm-00000000bJg-43jp;
	Fri, 30 Oct 2026 04:34:18 +0000
Date: Fri, 30 Oct 2026 12:33:21 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Subject: Re: [PATCH nf-next 5/8] net: netfilter: add IPv4 over IPv6 tunnel
 flowtable acceleration
Message-ID: <202610301255.BRNUBmqH-lkp@intel.com>
References: <20261029-flowtable-sw-accel-ip6ip-sit-v1-5-6a17c54f9fb7@oss.qualcomm.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-flowtable-sw-accel-ip6ip-sit-v1-5-6a17c54f9fb7@oss.qualcomm.com>

Hi Lorenzo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 734bef548a96e8774d6eef5dfa2026c6edc4e80b]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Bianconi/net-netfilter-nf_flow_table-recognize-IPv4-IPv6-in-tunnel-proto-matching/20261029-143512
base:   734bef548a96e8774d6eef5dfa2026c6edc4e80b
patch link:    https://lore.kernel.org/r/20261029-flowtable-sw-accel-ip6ip-sit-v1-5-6a17c54f9fb7%40oss.qualcomm.com
patch subject: [PATCH nf-next 5/8] net: netfilter: add IPv4 over IPv6 tunnel flowtable acceleration
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20261030/202610301255.BRNUBmqH-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261030/202610301255.BRNUBmqH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610301255.BRNUBmqH-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/netfilter/nf_flow_table_ip.c: In function 'nf_flow_queue_xmit4':
>> net/netfilter/nf_flow_table_ip.c:891:35: warning: variable 'dst' set but not used [-Wunused-but-set-variable=]
     891 |                 struct dst_entry *dst;
         |                                   ^~~
   net/netfilter/nf_flow_table_ip.c: In function 'nf_flow_queue_xmit6':
   net/netfilter/nf_flow_table_ip.c:1237:35: warning: variable 'dst' set but not used [-Wunused-but-set-variable=]
    1237 |                 struct dst_entry *dst;
         |                                   ^~~


vim +/dst +891 net/netfilter/nf_flow_table_ip.c

   858	
   859	static int nf_flow_queue_xmit4(struct nf_flowtable_ctx *ctx,
   860				       struct sk_buff *skb,
   861				       struct flow_offload_tuple_rhash *tuplehash,
   862				       const struct nf_hook_state *state)
   863	{
   864		struct flow_offload_tuple *other_tuple;
   865		enum flow_offload_tuple_dir dir;
   866		struct nf_flow_xmit xmit = {};
   867		union nf_inet_addr *ip_addr;
   868		struct flow_offload *flow;
   869		struct neighbour *neigh;
   870		struct rtable *rt;
   871	
   872		if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
   873			rt = dst_rtable(tuplehash->tuple.dst_cache);
   874			memset(skb->cb, 0, sizeof(struct inet_skb_parm));
   875			IPCB(skb)->iif = skb->dev->ifindex;
   876			IPCB(skb)->flags = IPSKB_FORWARDED;
   877			return nf_flow_xmit_xfrm(skb, state, &rt->dst);
   878		}
   879	
   880		dir = tuplehash->tuple.dir;
   881		flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
   882		other_tuple = &flow->tuplehash[!dir].tuple;
   883		ip_addr = (union nf_inet_addr *)&other_tuple->src_v4;
   884	
   885		if (nf_flow_tunnel_push(state->net, skb, other_tuple,
   886					tuplehash->tuple.dst_cache, &ip_addr) < 0)
   887			return NF_DROP;
   888	
   889		switch (tuplehash->tuple.xmit_type) {
   890		case FLOW_OFFLOAD_XMIT_NEIGH: {
 > 891			struct dst_entry *dst;
   892	
   893			xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
   894			if (!xmit.outdev) {
   895				flow_offload_teardown(flow);
   896				return NF_DROP;
   897			}
   898			if (other_tuple->tun.encap_proto ?
   899			    other_tuple->tun.encap_proto == AF_INET6 :
   900			    ctx->tun.inner_proto == IPPROTO_IPV6) {
   901				struct rt6_info *rt6;
   902	
   903				rt6 = dst_rt6_info(tuplehash->tuple.dst_cache);
   904				neigh = ip_neigh_gw6(rt6->dst.dev,
   905						     rt6_nexthop(rt6, &ip_addr->in6));
   906				dst = &rt6->dst;
   907			} else {
   908				rt = dst_rtable(tuplehash->tuple.dst_cache);
   909				neigh = ip_neigh_gw4(rt->dst.dev,
   910						     rt_nexthop(rt, ip_addr->ip));
   911				dst = &rt->dst;
   912			}
   913			if (IS_ERR(neigh)) {
   914				flow_offload_teardown(flow);
   915				return NF_DROP;
   916			}
   917			xmit.dest = neigh->ha;
   918			skb_dst_drop(skb);
   919			skb_dst_set_noref(skb, &rt->dst);
   920			break;
   921		}
   922		case FLOW_OFFLOAD_XMIT_DIRECT:
   923			xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
   924			if (!xmit.outdev) {
   925				flow_offload_teardown(flow);
   926				return NF_DROP;
   927			}
   928			xmit.dest = tuplehash->tuple.out.h_dest;
   929			xmit.source = tuplehash->tuple.out.h_source;
   930			break;
   931		default:
   932			WARN_ON_ONCE(1);
   933			return NF_DROP;
   934		}
   935		xmit.tuple = other_tuple;
   936		xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
   937	
   938		return nf_flow_queue_xmit(state->net, skb, &xmit);
   939	}
   940	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
