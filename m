From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: [RFC] cloned skbs - if i am right there is a bug in ipt_ECN.c
Date: Fri, 12 Dec 2003 21:02:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002701c3c0ea$e26efa70$0e25fe0a@southpark.ae.poznan.pl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

maybe it is just me, but how should I read this?
        /* raw socket (tcpdump) may have clone of incoming
         * skb: don't disturb it --RR */
        if (skb_cloned(*pskb) && !(*pskb)->sk) {
                struct sk_buff *nskb = skb_copy(*pskb, GFP_ATOMIC);
                if (!nskb)
                        return NF_DROP;
                kfree_skb(*pskb);
                *pskb = nskb;
                iph = (*pskb)->nh.iph;
        }

What does this part of code do? I see it this way:
It checks if the skb is cloned and if it does not have a socket.
If that is the case, it tries to make a copy, if it succeeds, we are using
the internals of the new skb.
Why is that? Does this code apply when I am or am I not using
raw sockets. Why are raw sockets to be left unchanged?

I know it may sound lame. All of this came out when I was hacking
on some netfilter module and noticed, that there might be a bug in
ipt_ECN.c:

in set_ect_tcp() we have:
                kfree_skb(*pskb);
                *pskb = nskb;
                iph = (*pskb)->nh.iph;
        }

But iph is not used, we are using tcph later on in the code, so we should:
                tcph = (*pskb)->nh.tcph;

If this is not a bug, that line could be at least removed, because iph is
not used.

If this my mail shows my ignorance with reading some docs, please show me
which should i read.

Regards,
Maciej
