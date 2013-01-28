From: David Miller <davem@davemloft.net>
Subject: Re: [stable-3.7 00/14] netfilter stable fixes for 3.7
Date: Mon, 28 Jan 2013 15:52:26 -0500 (EST)
Message-ID: <20130128.155226.1839051149651139071.davem@davemloft.net>
References: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: pablo@netfilter.org
Date: Mon, 28 Jan 2013 20:31:19 +0100

> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patchset contain netfilter stable fixes for 3.7, original
> commits (in no particular order) are:
> 
> 0c36b48 netfilter: nfnetlink_log: fix mac address for 6in4 tunnels
> e035edd netfilter: nfnetlink_log: fix possible compilation issue due to missing include
> 665e205 netfilter: xt_recent: fix namespace destroy path
> 2727de7 netfilter: xt_recent: avoid high order page allocations
> 5b76c49 netfilter: x_tables: print correct hook names for ARP
> 4fe198e netfilter: ipset: Fix range bug in hash:ip,port,net
> c6f4089 netfilter: ip[6]t_REJECT: fix wrong transport header pointer in TCP reset
> 32263dd netfilter: xt_hashlimit: fix namespace destroy path
> 0918184 netfilter: xt_hashlimit: fix race that results in duplicated entries
> 1310b95 netfilter: ctnetlink: fix leak in error path of ctnetlink_create_expect
> 97cf00e netfilter: nf_ct_reasm: fix conntrack reassembly expire code
> 10db906 netfilter: xt_CT: recover NOTRACK target support
> 757ae31 netfilter: fix missing dependencies for the NOTRACK target
> 1e47ee8 netfilter: nf_conntrack: fix BUG_ON while removing nf_conntrack with netns
> 
> Please, apply. Thanks!

These all look fine to me for -stable.
