From: Matt Walters <mattw@parasun.com>
Subject: Re: libipq, kernel panics/oopses, and other undesirable traits
Date: Mon, 16 Aug 2004 14:45:07 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092692707.22731.1687.camel@marx.mindlink.net>
References: <E1BwO5M-000718-NF@giant.mindlink.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <E1BwO5M-000718-NF@giant.mindlink.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Greetings, friends-

	I've inlined a patch for ip_queue.c (diff -u is the standard
patch-o-matic format, right?) which will fix the issue I've been having
with large packets coming back from userspace causing kernel panics.  It
should probably be added to the nonlinear_skbs patch, since it's the
same type of fix (memcpy --> copy_skb_bits).  There's also a
storage-type modification for ipq_rcv_skb - skb_len is an unsigned int
and it was being stored in an int.

	I also noticed several storage-type issues in the netlink code, which
I've messed with ("corrected" - maybe) on my machine, but messed with
*prior* to finding the memcpy in ip_queue.c, so I'll have to revert
those changes and see if it stays fixed, otherwise I guess I'll have to
get ahold of the netlink guys and send them a patch too.  :)

	Do please ignore the fact that my development machine thinks it's
tomorrow.  I've just noticed.

	I'm interested in doing further development for netfilter.  Please feel
free to add my name to a list somewhere or something.

	(addendum: I'm currently testing the code with icmp on INPUT and OUTPUT
going through userspace and having TOS bits tickled, etc, copied back
into kernelspace, with a flood of 64kB pings across a pair of Intel
e1000s -- IN octets: 2159535768  packets: 33458 // OUT octets:
2159470740  packets: 33457 -- looking really good)

-Matt

--- ip_queue.c.orig     2004-08-16 14:32:43.000000000 -0700
+++ ip_queue.c  2004-08-17 15:02:11.583159408 -0700
@@ -333,7 +333,7 @@
 static int
 ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
 {
-       int diff;
+       int diff, status;
        struct iphdr *user_iph = (struct iphdr *)v->payload;

        if (v->data_len < sizeof(*user_iph))
@@ -346,7 +346,7 @@
                        return -EINVAL;
                if (diff > skb_tailroom(e->skb)) {
                        struct sk_buff *newskb;
-
+
                        newskb = skb_copy_expand(e->skb,
                                                 skb_headroom(e->skb),
                                                 diff,
@@ -363,7 +363,10 @@
                }
                skb_put(e->skb, diff);
        }
-       memcpy(e->skb->data, v->payload, v->data_len);
+
+       if ((status = skb_copy_bits(e->skb, 0, v->payload, v->data_len))) {
+               return status;
+       }
        e->skb->nfcache |= NFC_ALTERED;

        /*
@@ -477,7 +480,8 @@
 static inline void
 ipq_rcv_skb(struct sk_buff *skb)
 {
-       int status, type, pid, flags, nlmsglen, skblen;
+       int status, type, pid, flags;
+       size_t nlmsglen, skblen;
        struct nlmsghdr *nlh;

        skblen = skb->len;
