From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: nftables: masquerade sets wrong source address
Date: Mon, 19 Dec 2016 10:25:14 +0800
Message-ID: <CAML_gOc5tdwguuZ6VhPsgwCcsP3WeUpENAw5ncXoMbC-EgXGZQ@mail.gmail.com>
References: <CAEvi_o9_SJNGH-RWq6Kt+UiXVY4ozaMy3yJ2rPdV0Rbk1QrRZw@mail.gmail.com>
 <CAML_gOdZn8UmZzeDWd6q--U9+f+SzBLMppCEtdCFsZ4rrTZ24A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter@vger.kernel.org,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Tom Hacohen <tom@stosb.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CAML_gOdZn8UmZzeDWd6q--U9+f+SzBLMppCEtdCFsZ4rrTZ24A@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

2016-12-17 22:18 GMT+08:00 Liping Zhang <zlpnobody@gmail.com>:
>
> For loopback connection, the request packets will traverse:
> OUTPUT->POSTROUTING->PREROUTING->INPUT
> and the source ip will be modified in nat POSTROUTING hook.
>
> Meanwhile the reply packets will also traverse:
> OUTPUT->POSTROUTING->PREROUTING->INPUT
> and if nat OUTPUT hook exist, the destination ip will be modified
> in it, and re-route will happen. Otherwise, the destination ip will
> be modified at nat PREROUTING hook, and the dst entry will
> be dropped. In such situation(i.e. nat OUTPUT doesn't exist),
> we will try to do routing lookup and packets will be dropped
> at ip_route_input_slow->martian_destination.
>
> Furthermore, if ipt_rpfilter is configured, the reply packet maybe
> dropped at there.
>
> In iptables, nat output chain always exists, so there's no
> such problem.
>
> But I think that enforcing the user to add a nat output chain
> in nftables is not a good idea, so probably we need a following
> patch(I only list the ipv4 part):
>
> diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> index f8aad03..5bc9b22 100644
> --- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> @@ -344,8 +344,21 @@ nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
>
>         ret = nf_nat_ipv4_fn(priv, skb, state, do_chain);
>         if (ret != NF_DROP && ret != NF_STOLEN &&
> -           daddr != ip_hdr(skb)->daddr)
> -               skb_dst_drop(skb);
> +           daddr != ip_hdr(skb)->daddr) {
> +               const struct rtable *rt = skb_rtable(skb);
> +               int err;
> +
> +               if (rt) {
> +                       if (rt->rt_flags & RTCF_LOCAL) {
> +                               err = ip_route_me_harder(state->net, skb,
> +                                                        RTN_UNSPEC);
> +                               if (err < 0)
> +                                       ret = NF_DROP_ERR(err);
> +                       } else {
> +                               skb_dst_drop(skb);
> +                       }
> +               }
> +       }
>
>         return ret;
>  }
>

Please ignore the above patch, it's incorrect that we use ip_route_output_key
for the incoming packets.

Maybe the below one will be better, but I'm not sure whether this will break
some special use cases or not:

diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index f8aad03..d358670 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -344,8 +344,13 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,

        ret = nf_nat_ipv4_fn(priv, skb, state, do_chain);
        if (ret != NF_DROP && ret != NF_STOLEN &&
-           daddr != ip_hdr(skb)->daddr)
+           daddr != ip_hdr(skb)->daddr) {
+               if (state->in->flags & IFF_LOOPBACK ||
+                   skb->pkt_type == PACKET_LOOPBACK)
+                       return ret;
+
                skb_dst_drop(skb);
+       }
