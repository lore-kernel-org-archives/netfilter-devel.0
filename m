From: "Sumit Pandya" <sumit@elitecore.com>
Subject: Difference between match and target
Date: Fri, 20 Jun 2003 18:33:58 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <009301c3372c$69cc47f0$010f430a@elitecore7>
References: <20030618222710.9325.98884.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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

Hi All,

    What is difference between writing match and target extension for
netfilter? Is there something in match which I cannot achieve in target and
vice-versa?
    So far I's under impression that I cannot alter skb in match because of
prototype for "match_entry()". Today I did following test with ipt_tos.c

static int
-- match(const struct sk_buff *skb,
      const struct net_device *in,
static int
++ match( struct sk_buff *skb,
      const struct net_device *in,

       const struct ipt_tos_info *info = matchinfo;
--    const struct iphdr *iph = skb->nh.iph;
--
--     return (iph->tos == info->tos) ^ info->invert;
++    struct iphdr *iph = skb->nh.iph;
++    u_int16_t diffs[2];
++
++        diffs[0] = htons(iph->tos) ^ 0xFFFF;
++        iph->tos = (iph->tos & IPTOS_PREC_MASK) | 0xFF;
++        diffs[1] = htons(iph->tos);
++        iph->check = csum_fold(csum_partial((char *)diffs,
++                                            sizeof(diffs),
++                                             iph->check^0xFFFF));
++        skb->nfcache |= NFC_ALTERED;
++        return IPT_CONTINUE;

then appended a rule for tos match with this changed match module inserted
into kernel.
[root@manage netfilter]# iptables -I OUTPUT -p tcp --dport 25  -m tos \
--tos 0x04 -j RETURN

 And surprisingly(for me), On the other machine when I observed traffic for
port 25, I get packet with TOS set to 0xFF.

 Someone to throw some light on this design? Mr. Rusty, Mr. Harald?

-- Sumit
