From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH V2] net: Allow xt_owner in any user namespace
Date: Wed, 15 Jun 2016 06:52:01 -0500
Message-ID: <87inxaoeji.fsf@x220.int.ebiederm.org>
References: <1465850579-23431-1-git-send-email-cernekee@chromium.org>
	<20160614000223.GC16798@breakpoint.cc>
	<87wplszfpc.fsf@x220.int.ebiederm.org> <20160614132318.GA13565@salvia>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Florian Westphal <fw@strlen.de>,
	Kevin Cernekee <cernekee@chromium.org>, kaber@trash.net,
	kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:45828 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbcFOMEJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 08:04:09 -0400
In-Reply-To: <20160614132318.GA13565@salvia> (Pablo Neira Ayuso's message of
	"Tue, 14 Jun 2016 15:23:18 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Mon, Jun 13, 2016 at 09:06:55PM -0500, Eric W. Biederman wrote:
>> Florian Westphal <fw@strlen.de> writes:
>> 
>> > Kevin Cernekee <cernekee@chromium.org> wrote:
>> >> @@ -35,6 +63,7 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
>> >>  	const struct xt_owner_match_info *info = par->matchinfo;
>> >>  	const struct file *filp;
>> >>  	struct sock *sk = skb_to_full_sk(skb);
>> >> +	const struct net *net;
>> >>  
>> >>  	if (sk == NULL || sk->sk_socket == NULL)
>> >>  		return (info->match ^ info->invert) == 0;
>> >> @@ -50,9 +79,10 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
>> >>  		return ((info->match ^ info->invert) &
>> >>  		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
>> >>  
>> >> +	net = sock_net(skb->sk);
>> >
>> > I think you need to use sock_net(sk) as skb_to_full_sk(skb) can return something
>> > other than skb->sk.
>> 
>> Actually this should be "par->net".  That did not exist a few years ago
>> when the patch was written but it does now, and that should simplify
>> things a little bit, and remove any guess work or uncertainty.
>
> Right.
>
> BTW, could you also send a follow up patch to update
> net/netfilter/nft_meta.c? We have similar support for socket owner in
> nf_tables as well (actually it will be a more simple patch that this,
> I would expect).

That sounds worth doing.

At the very least we need a test that whoever sets the filter is
in the initial user namespace or else the filter is just nonsense.

I took a glance at the code and I completely don't remember the
context in which .init and .eval methods run in so I am temporarily at a
loss.

That said I suspect we want something like the patch below.  I am a
little uncertain if we want from_kuid or from_kuid_munged.  The
difference is how we handle unmapped uids and gids (in the rare case
they come up).  There are some nuances but in practice from_xxx_munged
returns (u16)-1 when things don't map, and from_xxx returns (u32)-1
when things don't map.

Eric

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 16c50b0dd426..b0b832eddb0d 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -104,7 +104,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		}
 
-		*dest =	from_kuid_munged(&init_user_ns,
+		*dest =	from_kuid_munged(pkt->net->user_ns,
 				sk->sk_socket->file->f_cred->fsuid);
 		read_unlock_bh(&sk->sk_callback_lock);
 		break;
@@ -119,7 +119,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			read_unlock_bh(&sk->sk_callback_lock);
 			goto err;
 		}
-		*dest =	from_kgid_munged(&init_user_ns,
+		*dest =	from_kgid_munged(pkt->net->user_ns,
 				 sk->sk_socket->file->f_cred->fsgid);
 		read_unlock_bh(&sk->sk_callback_lock);
 		break;
@@ -263,8 +263,6 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 	case NFT_META_MARK:
 	case NFT_META_IIF:
 	case NFT_META_OIF:
-	case NFT_META_SKUID:
-	case NFT_META_SKGID:
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_META_RTCLASSID:
 #endif
@@ -288,6 +286,12 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		prandom_init_once(&nft_prandom_state);
 		len = sizeof(u32);
 		break;
+	case NFT_META_SKUID:
+	case NFT_META_SKGID:
+		if (current_user_ns() != net->user_ns)
+			return -EINVAL;
+		len = sizeof(u32);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}



Eric

