From: Dirk Morris <dmorris@metavize.com>
Subject: [PATCH] ipt_do_table accesss pskb after it has been freed
Date: Thu, 06 Nov 2003 18:18:15 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FAB00E7.1030507@metavize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dmorris@metavize.com,  netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I had a target in the mangle/PREROUTING that was freeing the skb and 
returning NF_STOLEN.
ipt_do_table would then cause a kernel panic as it accesses the skb 
after its freed.

Is this a bug? If so, here's the patch.

-dirk

-->

diff -urN --ignore-all-space 
linux-2.6.0-test8-orig/net/ipv4/netfilter/ip_tables.c 
linux-2.6.0-test8-netcap2/net/ipv4/netfilter/ip_tables.c
--- linux-2.6.0-test8-orig/net/ipv4/netfilter/ip_tables.c       
2003-10-17 14:42:57.000000000 -0700
+++ linux-2.6.0-test8-netcap2/net/ipv4/netfilter/ip_tables.c    
2003-11-06 18:03:26.000000000 -0800
@@ -375,8 +375,10 @@
                                       = 0x57acc001;
#endif
                               /* Target might have changed stuff. */
+              if (verdict != NF_STOLEN) {
                               ip = (*pskb)->nh.iph;
                               datalen = (*pskb)->len - ip->ihl * 4;
+              }

                               if (verdict == IPT_CONTINUE)
                                       e = (void *)e + e->next_offset;
