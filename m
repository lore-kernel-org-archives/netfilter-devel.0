From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: nftables: masquerade sets wrong source address
Date: Sat, 17 Dec 2016 22:18:08 +0800
Message-ID: <CAML_gOdZn8UmZzeDWd6q--U9+f+SzBLMppCEtdCFsZ4rrTZ24A@mail.gmail.com>
References: <CAEvi_o9_SJNGH-RWq6Kt+UiXVY4ozaMy3yJ2rPdV0Rbk1QrRZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter@vger.kernel.org,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Tom Hacohen <tom@stosb.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:36474 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbcLQOSJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Dec 2016 09:18:09 -0500
In-Reply-To: <CAEvi_o9_SJNGH-RWq6Kt+UiXVY4ozaMy3yJ2rPdV0Rbk1QrRZw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tom,

2016-12-13 21:28 GMT+08:00 Tom Hacohen <tom@stosb.com>:
> Hi,
>
> I've recently migrated from iptables (no modules loaded anymore) to
> nftables and came across a weird situation that looks like a bug to
> me.
>
> When using "masquerade" it always sets the ip address to that of one
> of my interfaces, and not per interface as one would expect.
>
> My config:
>
> flush ruleset
>
> table inet filter {
>     chain input {
>         type filter hook input priority 0; policy accept;
>
>         iifname lo log accept
>     }
>     chain output {
>         type filter hook output priority 0; policy accept;
>     }
> }
>
> table ip nat {
>     chain postrouting {
>         type nat hook postrouting priority 100;
>         masquerade
>     }
> }
>

According to the explanations in nftables wifi:
https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT)

You should add the following nft rules(I agree this is tricky and
unfriendly for the end user):
# nft add chain nat prerouting { type nat hook prerouting priority 0 \; }

But unfortunately,  even if you add the above rule, you will still fail to
connect to a local server.

Now add another nft rules listed below, you can probably make everything
work fine:
# nft add chain nat output { type nat hook output priority 0 \; }

[ cc netfilter-dev group ]

For loopback connection, the request packets will traverse:
OUTPUT->POSTROUTING->PREROUTING->INPUT
and the source ip will be modified in nat POSTROUTING hook.

Meanwhile the reply packets will also traverse:
OUTPUT->POSTROUTING->PREROUTING->INPUT
and if nat OUTPUT hook exist, the destination ip will be modified
in it, and re-route will happen. Otherwise, the destination ip will
be modified at nat PREROUTING hook, and the dst entry will
be dropped. In such situation(i.e. nat OUTPUT doesn't exist),
we will try to do routing lookup and packets will be dropped
at ip_route_input_slow->martian_destination.

Furthermore, if ipt_rpfilter is configured, the reply packet maybe
dropped at there.

In iptables, nat output chain always exists, so there's no
such problem.

But I think that enforcing the user to add a nat output chain
in nftables is not a good idea, so probably we need a following
patch(I only list the ipv4 part):

diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index f8aad03..5bc9b22 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -344,8 +344,21 @@ nf_nat_ipv4_in(void *priv, struct sk_buff *skb,

        ret = nf_nat_ipv4_fn(priv, skb, state, do_chain);
        if (ret != NF_DROP && ret != NF_STOLEN &&
-           daddr != ip_hdr(skb)->daddr)
-               skb_dst_drop(skb);
+           daddr != ip_hdr(skb)->daddr) {
+               const struct rtable *rt = skb_rtable(skb);
+               int err;
+
+               if (rt) {
+                       if (rt->rt_flags & RTCF_LOCAL) {
+                               err = ip_route_me_harder(state->net, skb,
+                                                        RTN_UNSPEC);
+                               if (err < 0)
+                                       ret = NF_DROP_ERR(err);
+                       } else {
+                               skb_dst_drop(skb);
+                       }
+               }
+       }

        return ret;
 }

>
> With this, connections to localhost fail because the masquerade line
> sets the source IP to that of the wlp1s0 interface, and not of the lo
> interface.
>
> Here is output from the log:
> IN=lo OUT= MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00
> SRC=192.168.86.18 DST=127.0.0.1 LEN=60 TOS=0x00 PREC=0x00 TTL=64
> ID=64500 DF PROTO=TCP SPT=36844 DPT=8000 WINDOW=43690 RES=0x00 SYN
> URGP=0
>
> You can see how the source ip is wrong. This is from running "curl"
> trying to connect to a local http server on port 8000.
>
> Removing the masquerade line, or changing it to: "oifname wlp1s0
> masquerade" fixes it, but this is just a workaround that will fail in
> more complex situations.
>
> I would have loved to provide you with tracing information, but
> unfortunately I never got that to work for me.
>
> Tried with kernels: 4.8.12 and 4.4.35 on arch linux. Nft version is 0.6.
>
> Please let me know if there's any other info you'd like me to provide you with.
>
> Thanks,
> Tom.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
