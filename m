From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [PATCH] make happy cracking message more verbose
Date: Fri, 7 Nov 2003 15:36:42 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0311071530270.4534@dns.toxicfilms.tv>
References: <Pine.LNX.4.44.0311070119110.2662-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0311070119110.2662-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> But I do have a question.. shouln't the ipv6 code use nh.ipv6h and struct
> ipv6hdr? The ipv6 code deals with IPv6 headers doesn't it? I notice both
> the original code and your changes uses nh.iph which looks plain wrong in
> any code dealing with IPv6 packets. Until this is corrected you probably
> should leave those "#if 0" shields there to prevent the code from being
> active..
I checked and rechecked before sending.
Now I double checked the rechecks, and ... the patch is fine :-)
Look closely, the lines with nh.iph are '-' and I am not doing
a check on nh.ipv6h in IPv6 version because the IPv6 header does not
have any type of length field. I am only comparing the sk_buff len.


Exerpt from the patch:
-#if 0
+       /* More verbosity to happy cracking by Maciej Soltysiak
+        * <solt@dns.toxicfilms.tv> */
+       int hdrlen = sizeof(struct ipv6hdr);
+                                  ^^^^^^^^ <-- this is ok
        /* root is playing with raw sockets. */
-       if ((*pskb)->len < sizeof(struct iphdr)
-           || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
+       if ((*pskb)->len < hdrlen) {
                if (net_ratelimit())
-                       printk("ip6t_hook: happy cracking.\n");
+                       printk("ip6t_hook: happy cracking at %s in %s."
+                               " sk_buff too short: %u. Expected: %u\n",
+                               __FUNCTION__, __FILE__,
+                               (*pskb)->len, hdrlen);
                return NF_ACCEPT;
        }
-#endif

> Henrik
Maciek
