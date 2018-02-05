From: David McCullough <david.mccullough@accelerated.com>
Subject: IPv6 Parameter problem with no ICMPv6 response ?
Date: Mon, 5 Feb 2018 13:58:26 +1000
Message-ID: <20180205035826.GA2558@spottygum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-by2nam03on0041.outbound.protection.outlook.com ([104.47.42.41]:13216
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751979AbeBED6o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Feb 2018 22:58:44 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi devel,

I am looking for some feedback on IPv6 behaviour with/without netfilter in
the path.  We are in process of some IPv6 certification at a lab.

RFC2460 has a bunch of conditions under which certain ICMPv6 responses
should be sent.  This is even commented in the code.

linux/net/ipv6/reassembly.c:255
                /* Check if the fragment is rounded to 8 bytes.
                 * Required by the RFC.
                 */
                if (end & 0x7) {
                        /* RFC2460 says always send parameter problem in
                         * this case. -DaveM
                         */
                        __IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
                                        IPSTATS_MIB_INHDRERRORS);
                        icmpv6_param_prob(skb, ICMPV6_HDR_FIELD,
                                          offsetof(struct ipv6hdr, payload_len));                       
                        return -1;
                }

linux/net/ipv6/netfilter/nf_conntrack_reasm.c:259
                /* Check if the fragment is rounded to 8 bytes.
                 * Required by the RFC.
                 */
                if (end & 0x7) {
                        /* RFC2460 says always send parameter problem in
                         * this case. -DaveM
                         */
                        pr_debug("end of fragment not rounded to 8 bytes.\n");
                        return -1;      
                }

The behaviour of the non-netfilter code is what the certification is expecting.
We are using conntracking though and I can see no way to avoid the above
netfilter code from silently dropping the packet and not responding correctly.

We experiemented with the patch below and it provided the appropriate
responses but we were not sure this is the best approach.  Happy to send in
a proper patch if this looks ok.

Any comments appreciated,

Thanks,
Davidm

--- a/linux/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/linux/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -263,6 +263,8 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
     * this case. -DaveM
     */
    pr_debug("end of fragment not rounded to 8 bytes.\n");
+   icmpv6_send(skb, ICMPV6_PARAMPROB, ICMPV6_HDR_FIELD,
+        offsetof(struct ipv6hdr, saddr));
    return -1;
   }
   if (end > fq->q.len) {


-- 
David McCullough,  david.mccullough@accelerated.com,   Ph: 0410 560 763
