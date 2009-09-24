From: Shai Tahar <shait@storwize.com>
Subject: new target - ebtables dynamic snat, kernel and userspace patch
Date: Thu, 24 Sep 2009 10:43:50 +0300
Message-ID: <4ABB2336.6040806@storwize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: bdschuym@pandora.be, shai.tahar@storwize.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bzq-179-166-116.static.bezeqint.net ([212.179.166.116]:17225
	"EHLO stmail.storwiz.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752083AbZIXH7E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 03:59:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---- README ---
ebt_dyn_snat - ebtable dynamic snat
     Authors:
       Shai Tahar <shai.tahar@storwize.com>

     Changes source mac address according to source ip address based on 
local arp table
     to be used when source ip address is snated

Copyright (C) 2009 Storwize

ebtables target for transparent bridge
[user]<--->[transparent bridge]<--->[server]

if the transparent bridge maskes user ip address towards the server,
the bridge normally would replace the source mac address with the bridge 
mac
till now, using arptables and ebtables snat and arpreply targets used 
for overcoming this scenario.

using the attached target will rewrite the packet source mac address 
based on local arp table
(no need for arptables and arpreplay)

1. new ebtables target: dynamic snat target support
       depends on BRIDGE_NF_EBTABLES
       This option adds the MAC DYN SNAT target, which allows altering 
dynamicly the MAC
       source address of frames based on local arp table.

2. ebtables userspace extension

use the following rules for a bridge (eth0,eth2)
ebtables -t nat -A POSTROUTING -p IPV4 -o eth0 -j dyn_snat 
--dyn-snat-target ACCEPT
ebtables -t nat -A POSTROUTING -p IPV4 -o eth2 -j dyn_snat 
--dyn-snat-target ACCEPT


---- kernel 2.6.26 -- 2.6.30 ----

diff --git a/include/linux/netfilter_bridge/ebt_dyn_snat.h 
b/include/linux/netfilter_bridge/ebt_dyn_snat.h
new file mode 100644
index 0000000..b38b73b
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_dyn_snat.h
@@ -0,0 +1,19 @@
+/*
+ *  ebtables dynamic snat
+ *
+ *      Authors:
+ *       Shai Tahar                <shai.tahar@storwize.com>
+ *
+ *  Copyright (C) 2009 Storwize
+ */
+#ifndef __LINUX_BRIDGE_EBT_DYN_SNAT_H
+#define __LINUX_BRIDGE_EBT_DYN_SNAT_H
+
+
+struct ebt_dyn_snat_info
+{
+       int           target;
+};
+#define EBT_DYN_SNAT_TARGET "dyn_snat"
+
+#endif
diff --git a/net/bridge/netfilter/ebt_dyn_snat.c 
b/net/bridge/netfilter/ebt_dyn_snat.c
new file mode 100644
index 0000000..9690c5e
--- /dev/null
+++ b/net/bridge/netfilter/ebt_dyn_snat.c
@@ -0,0 +1,111 @@
+/*
+ *  ebt_dyn_snat - ebtable dynamic snat
+ *
+ *     Authors:
+ *     Shai Tahar <shai.tahar@storwize.com>
+ *
+ *     changes source mac address according to source ip address based 
on local arp table
+ *     to be used when source ip address is snated
+ *
+ *  Copyright (C) 2009 Storwize
+ */
+
+
+#include <linux/netfilter.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_dyn_snat.h>
+#include <linux/module.h>
+#include <net/sock.h>
+#include <linux/if_arp.h>
+#include <net/arp.h>
+#include "../br_private.h"
+#include <linux/ip.h>
+#include <net/ip.h>
+
+
+
+static struct net_device *bridge_parent(const struct net_device *dev)
+{
+        struct net_bridge_port *port = rcu_dereference(dev->br_port);
+        return port ? port->br->dev : NULL;
+}
+
+
+static int ebt_target_dyn_snat(struct sk_buff *skb, unsigned int hooknr,
+   const struct net_device *in, const struct net_device *out,
+   const void *data, unsigned int datalen)
+{
+       const struct ebt_dyn_snat_info *info = data;
+        const struct iphdr *ih;
+        struct iphdr _iph;
+       unsigned char mac[ETH_ALEN];
+
+        struct net_device *parent ;
+        __be32 ip;
+        struct neighbour *neigh;
+
+        if (!skb_make_writable(skb, 0))
+                return EBT_DROP;
+
+
+        ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
+        if (ih == NULL) return EBT_DROP;
+
+        parent = bridge_parent(out);
+
+        if (parent) {
+          ip = ih->saddr;
+          neigh = neigh_lookup(&arp_tbl,&ip, parent);
+          if (neigh) {
+                read_lock_bh(&neigh->lock);
+                memcpy(mac, neigh->ha, out->addr_len);
+                read_unlock_bh(&neigh->lock);
+                neigh_release(neigh);
+                memcpy(eth_hdr(skb)->h_source,mac, ETH_ALEN);
+          }
+        }
+       return info->target | ~EBT_VERDICT_BITS;
+}
+
+static int ebt_target_dyn_snat_check(const char *tablename, unsigned 
int hookmask,
+   const struct ebt_entry *e, void *data, unsigned int datalen)
+{
+       const struct ebt_dyn_snat_info *info = data;
+       int tmp;
+
+       if (datalen != EBT_ALIGN(sizeof(struct ebt_dyn_snat_info)))
+               return -EINVAL;
+       tmp = info->target | ~EBT_VERDICT_BITS;
+       if (BASE_CHAIN && tmp == EBT_RETURN)
+               return -EINVAL;
+       CLEAR_BASE_CHAIN_BIT;
+       if (strcmp(tablename, "nat"))
+               return -EINVAL;
+       if (hookmask & ~(1 << NF_BR_POST_ROUTING))
+               return -EINVAL;
+       if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
+               return -EINVAL;
+       return 0;
+}
+
+static struct ebt_target dyn_snat __read_mostly = {
+       .name           = EBT_DYN_SNAT_TARGET,
+       .target         = ebt_target_dyn_snat,
+       .check          = ebt_target_dyn_snat_check,
+       .me             = THIS_MODULE,
+};
+
+static int __init ebt_dyn_snat_init(void)
+{
+       return ebt_register_target(&dyn_snat);
+}
+
+static void __exit ebt_dyn_snat_fini(void)
+{
+       ebt_unregister_target(&dyn_snat);
+}
+
+module_init(ebt_dyn_snat_init);
+module_exit(ebt_dyn_snat_fini);
+MODULE_DESCRIPTION("Ebtables: Dynamic Source MAC address translation");
+MODULE_LICENSE("GPL");

----- user space based on ebtables 2.0.6  -----
diff --git a/ebtables-2.0.6/extensions/Makefile 
b/ebtables-2.0.6/extensions/Makefile
index 2361a4c..9f14627 100644
--- a/ebtables-2.0.6/extensions/Makefile
+++ b/ebtables-2.0.6/extensions/Makefile
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-EXT_FUNC+=802_3 nat arp arpreply ip standard log redirect vlan mark_m 
mark \
+EXT_FUNC+=802_3 dyn_snat nat arp arpreply ip standard log redirect vlan 
mark_m mark \
           pkttype stp among limit
 EXT_TABLES+=filter nat broute
 EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/ebt_$(T).o)

diff --git a/ebtables-2.0.6/extensions/ebt_dyn_snat.c 
b/ebtables-2.0.6/extensions/ebt_dyn_snat.c
new file mode 100644
index 0000000..38af510
--- /dev/null
+++ b/ebtables-2.0.6/extensions/ebt_dyn_snat.c
@@ -0,0 +1,126 @@
+/*
+ *  ebt_dyn_snat - ebtable dynamic snat
+ *
+ *      Authors:
+ *      Shai Tahar <shai.tahar@storwize.com>
+ *
+ *      changes source mac address according to source ip address based 
on local arp table
+ *      to be used when source ip address is snated
+ *
+ *  Copyright (C) 2009 Storwize
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/ether.h>
+#include <getopt.h>
+#include "../include/ebtables_u.h"
+#include <linux/netfilter_bridge/ebt_dyn_snat.h>
+
+
+#define DYN_SNAT_TARGET '1'
+static struct option opts[] =
+{
+    { "dyn-snat-target" , required_argument, 0, DYN_SNAT_TARGET },
+    { 0 }
+};
+
+static void print_help()
+{
+    printf(
+    "dynamic snat target options:\n"
+    " --dyn-snat-target target       : ACCEPT, DROP, RETURN or CONTINUE\n"
+    "                                   (standard target is DROP)\n" );
+}
+
+static void init(struct ebt_entry_target *target)
+{
+    struct ebt_dyn_snat_info *info =
+       (struct ebt_dyn_snat_info *)target->data;
+    info->target = EBT_DROP;
+}
+
+#define OPT_DYN_SNAT_TARGET   0x01
+
+static int parse(int c, char **argv, int argc,
+   const struct ebt_u_entry *entry, unsigned int *flags,
+   struct ebt_entry_target **target)
+{
+    struct ebt_dyn_snat_info *info =
+       (struct ebt_dyn_snat_info *)(*target)->data;
+    char *end;
+   
+
+    switch (c) {
+    case DYN_SNAT_TARGET:
+        check_option(flags, OPT_DYN_SNAT_TARGET);
+        if (FILL_TARGET(optarg, info->target))
+            print_error("Illegal --dyn-snat-target target");
+        break;
+
+    default:
+        return 0;
+    }
+    return 1;
+}
+
+static void final_check(const struct ebt_u_entry *entry,
+   const struct ebt_entry_target *target, const char *name,
+   unsigned int hookmask, unsigned int time)
+{
+    struct ebt_dyn_snat_info *info =
+       (struct ebt_dyn_snat_info *)target->data;
+
+    if (entry->ethproto != ETH_P_IP || entry->invflags & EBT_IPROTO)
+        print_error("For dynamic snat the protocol must be "
+                    "specified as IPV4");
+
+    if (BASE_CHAIN && info->target == EBT_RETURN)
+        print_error("--dyn-snat-target RETURN not allowed on "
+                    "base chain");
+
+    CLEAR_BASE_CHAIN_BIT;
+    if (strcmp(name, "nat") || hookmask & ~(1 << NF_BR_POST_ROUTING))
+        print_error("dynamic snat only allowed in POSTROUTING");
+}
+
+static void print(const struct ebt_u_entry *entry,
+   const struct ebt_entry_target *target)
+{
+    struct ebt_dyn_snat_info *info =
+       (struct ebt_dyn_snat_info *)target->data;
+
+    printf(" --dyn-snat-target %s", TARGET_NAME(info->target));
+}
+
+static int compare(const struct ebt_entry_target *t1,
+   const struct ebt_entry_target *t2)
+{
+    struct ebt_dyn_snat_info *info1 =
+       (struct ebt_dyn_snat_info *)t1->data;
+
+    struct ebt_dyn_snat_info *info2 =
+       (struct ebt_dyn_snat_info *)t2->data;
+
+    return info1->target == info2->target;
+}
+
+static struct ebt_u_target dyn_snat_target =
+{
+    .name        = EBT_DYN_SNAT_TARGET,
+    .size        = sizeof(struct ebt_dyn_snat_info),
+    .help        = print_help,
+    .init        = init,
+    .parse        = parse,
+    .final_check    = final_check,
+    .print        = print,
+    .compare    = compare,
+    .extra_ops    = opts,
+};
+
+static void _init(void) __attribute__ ((constructor));
+static void _init(void)
+{
+    register_target(&dyn_snat_target);
+}
diff --git 
a/ebtables-2.0.6/include/linux/netfilter_bridge/ebt_dyn_snat.h 
b/ebtables-2.0.6/include/linux/netfilter_bridge/ebt_dyn_snat.h
new file mode 100644
index 0000000..8abb0cb
--- /dev/null
+++ b/ebtables-2.0.6/include/linux/netfilter_bridge/ebt_dyn_snat.h
@@ -0,0 +1,23 @@
+/*
+ *  ebt_dyn_snat - ebtable dynamic snat
+ *
+ *      Authors:
+ *      Shai Tahar <shai.tahar@storwize.com>
+ *
+ *      changes source mac address according to source ip address based 
on local arp table
+ *      to be used when source ip address is snated
+ *
+ *  Copyright (C) 2009 Storwize
+ */
+
+#ifndef __LINUX_BRIDGE_EBT_DYN_SNAT_H
+#define __LINUX_BRIDGE_EBT_DYN_SNAT_H
+
+
+struct ebt_dyn_snat_info
+{
+    int           target;
+};
+#define EBT_DYN_SNAT_TARGET "dyn_snat"
+
+#endif
