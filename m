From: Henrik Nordstrom <hno@marasystems.com>
Subject: raw table breaks iptables binary compatibility
Date: Sun, 9 Nov 2003 02:12:43 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311090204280.25676-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a followup to the message I sent on 30 Oct after noticing binary 
compatibility with older iptables releases was broken after applying 
p-o-m/base.

Other unrelated events has identified this being due to the raw table
patch. This patch modifies ipt_entry by adding two more fields and this
totally breaks binary compatibility with iptables binaries compiled for
kernels with/without the raw table.

linux-2.4.22-log/include/linux/netfilter_ipv4/ip_tables.h 
linux-2.4.22-raw/include/linux/netfilter_ipv4/ip_tables.h
--- linux-2.4.22-log/include/linux/netfilter_ipv4/ip_tables.h   2003-09-17 
17:15:00.000000000 +0200
+++ linux-2.4.22-raw/include/linux/netfilter_ipv4/ip_tables.h   2003-09-28 
14:19:16.000000000 +0200
@@ -134,6 +134,12 @@
        /* Back pointer */
        unsigned int comefrom;

+       /* Name of the chain */
+       char *chainname;
+       
+       /* Rule number in the chain. */
+       u_int32_t rulenum;
+
        /* Packet and byte counters. */
        struct ipt_counters counters;



I don't quite see why these are required for the 'raw' table. Seems to be 
related to debugging or error management on rulesets incompatible with 
'raw'. In any case the effect is probably not that desireable from a 
p-o-m/base patch..

Regards
Henrik
