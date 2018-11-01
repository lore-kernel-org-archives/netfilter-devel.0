From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 12/31] netfilter: cttimeout: remove superfluous check on
 layer 4 netlink functions
Date: Thu, 1 Nov 2018 07:57:26 -0700
Message-ID: <46a2d5fe-ca45-c07b-2e2d-2ec99412dcb9@gmail.com>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-13-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-13-pablo@netfilter.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 10/08/2018 04:01 PM, Pablo Neira Ayuso wrote:
> We assume they are always set accordingly since a874752a10da
> ("netfilter: conntrack: timeout interface depend on
> CONFIG_NF_CONNTRACK_TIMEOUT"), so we can get rid of this checks.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nfnetlink_cttimeout.c | 48 ++++++++++++++-----------------------
>  net/netfilter/nft_ct.c              |  3 ---
>  2 files changed, 18 insertions(+), 33 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
> index a30f8ba4b89a..6ca0df7f416f 100644
> --- a/net/netfilter/nfnetlink_cttimeout.c
> +++ b/net/netfilter/nfnetlink_cttimeout.c
> @@ -53,9 +53,6 @@ ctnl_timeout_parse_policy(void *timeout,
>  	struct nlattr **tb;
>  	int ret = 0;
>  
> -	if (!l4proto->ctnl_timeout.nlattr_to_obj)
> -		return 0;
> -
>  	tb = kcalloc(l4proto->ctnl_timeout.nlattr_max + 1, sizeof(*tb),
>  		     GFP_KERNEL);
>  
> @@ -167,6 +164,8 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>  	struct nfgenmsg *nfmsg;
>  	unsigned int flags = portid ? NLM_F_MULTI : 0;
>  	const struct nf_conntrack_l4proto *l4proto = timeout->timeout.l4proto;
> +	struct nlattr *nest_parms;
> +	int ret;
>  
>  	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK_TIMEOUT, event);
>  	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*nfmsg), flags);
> @@ -186,22 +185,15 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>  			 htonl(refcount_read(&timeout->refcnt))))
>  		goto nla_put_failure;
>  
> -	if (likely(l4proto->ctnl_timeout.obj_to_nlattr)) {
> -		struct nlattr *nest_parms;
> -		int ret;
> -
> -		nest_parms = nla_nest_start(skb,
> -					    CTA_TIMEOUT_DATA | NLA_F_NESTED);
> -		if (!nest_parms)
> -			goto nla_put_failure;
> +	nest_parms = nla_nest_start(skb, CTA_TIMEOUT_DATA | NLA_F_NESTED);
> +	if (!nest_parms)
> +		goto nla_put_failure;
>  
> -		ret = l4proto->ctnl_timeout.obj_to_nlattr(skb,
> -							&timeout->timeout.data);
> -		if (ret < 0)
> -			goto nla_put_failure;
> +	ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, &timeout->timeout.data);
> +	if (ret < 0)
> +		goto nla_put_failure;
>  
> -		nla_nest_end(skb, nest_parms);
> -	}
> +	nla_nest_end(skb, nest_parms);
>  
>  	nlmsg_end(skb, nlh);
>  	return skb->len;
> @@ -397,6 +389,8 @@ cttimeout_default_fill_info(struct net *net, struct sk_buff *skb, u32 portid,
>  	struct nlmsghdr *nlh;
>  	struct nfgenmsg *nfmsg;
>  	unsigned int flags = portid ? NLM_F_MULTI : 0;
> +	struct nlattr *nest_parms;
> +	int ret;
>  
>  	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK_TIMEOUT, event);
>  	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*nfmsg), flags);
> @@ -412,21 +406,15 @@ cttimeout_default_fill_info(struct net *net, struct sk_buff *skb, u32 portid,
>  	    nla_put_u8(skb, CTA_TIMEOUT_L4PROTO, l4proto->l4proto))
>  		goto nla_put_failure;
>  
> -	if (likely(l4proto->ctnl_timeout.obj_to_nlattr)) {
> -		struct nlattr *nest_parms;
> -		int ret;
> -
> -		nest_parms = nla_nest_start(skb,
> -					    CTA_TIMEOUT_DATA | NLA_F_NESTED);
> -		if (!nest_parms)
> -			goto nla_put_failure;
> +	nest_parms = nla_nest_start(skb, CTA_TIMEOUT_DATA | NLA_F_NESTED);
> +	if (!nest_parms)
> +		goto nla_put_failure;
>  
> -		ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, NULL);
> -		if (ret < 0)
> -			goto nla_put_failure;
> +	ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, NULL);

Hi Pablo

None of the obj_to_nlattr handlers can handle a NULL pointer.
What is the intent here ?

netlink: 24 bytes leftover after parsing attributes in process `syz-executor2'.
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9575 Comm: syz-executor1 Not tainted 4.19.0+ #312
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:icmp_timeout_obj_to_nlattr+0x77/0x170 net/netfilter/nf_conntrack_proto_icmp.c:297
kobject: 'loop5' (00000000d8ff612b): kobject_uevent_env
Code: b5 41 c7 00 f1 f1 f1 f1 c7 40 04 04 f2 f2 f2 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 e8 c0 06 26 fb 4c 89 e8 48 c1 e8 03 <42> 0f b6 14 38 4c 89 e8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85
kobject: 'loop5' (00000000d8ff612b): fill_kobj_path: path = '/devices/virtual/block/loop5'
RSP: 0018:ffff88017def7220 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff1002fbdee45 RCX: ffffc90004561000
RDX: 000000000000064f RSI: ffffffff865970c0 RDI: ffff8801ba602bc0
RBP: ffff88017def72b0 R08: ffff8801879e2400 R09: ffff880188d264a8
R10: ffffed00311a4c94 R11: ffff880188d264a0 R12: ffff8801ba602bc0
R13: 0000000000000000 R14: ffff88017def7288 R15: dffffc0000000000
FS:  00007fb495a6f700(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kobject: 'loop3' (00000000bc48af2d): kobject_uevent_env
CR2: 00007f4879a55000 CR3: 00000001b7b96000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
kobject: 'loop3' (00000000bc48af2d): fill_kobj_path: path = '/devices/virtual/block/loop3'
 cttimeout_default_fill_info net/netfilter/nfnetlink_cttimeout.c:411 [inline]
 cttimeout_default_get+0x644/0x9e0 net/netfilter/nfnetlink_cttimeout.c:457
 nfnetlink_rcv_msg+0xdd3/0x10c0 net/netfilter/nfnetlink.c:228
kobject: 'loop3' (00000000bc48af2d): kobject_uevent_env
kobject: 'loop3' (00000000bc48af2d): fill_kobj_path: path = '/devices/virtual/block/loop3'
 netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1c0/0x4d0 net/netfilter/nfnetlink.c:560
 netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
 netlink_unicast+0x5a5/0x760 net/netlink/af_netlink.c:1336
 netlink_sendmsg+0xa18/0xfc0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:621 [inline]
 sock_sendmsg+0xd5/0x120 net/socket.c:631
 ___sys_sendmsg+0x7fd/0x930 net/socket.c:2116
 __sys_sendmsg+0x11d/0x280 net/socket.c:2154
 __do_sys_sendmsg net/socket.c:2163 [inline]
 __se_sys_sendmsg net/socket.c:2161 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2161
 do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290

> +	if (ret < 0)
> +		goto nla_put_failure;
>  
> -		nla_nest_end(skb, nest_parms);
> -	}
> +	nla_nest_end(skb, nest_parms);
>  
>  	nlmsg_end(skb, nlh);
>  	return skb->len;
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 5dd87748afa8..17ae5059c312 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -776,9 +776,6 @@ nft_ct_timeout_parse_policy(void *timeouts,
>  	struct nlattr **tb;
>  	int ret = 0;
>  
> -	if (!l4proto->ctnl_timeout.nlattr_to_obj)
> -		return 0;
> -
>  	tb = kcalloc(l4proto->ctnl_timeout.nlattr_max + 1, sizeof(*tb),
>  		     GFP_KERNEL);
>  
> 
