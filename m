From: Maciek Zobniow <maciek@zobniow.priv.pl>
Subject: [NEW TARGET] MARKCB connection marking balancing
Date: Mon, 03 Mar 2003 02:25:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E62AF18.8010000@zobniow.priv.pl>
Reply-To: maciek@zobniow.priv.pl
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020801010301050006020007"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020801010301050006020007
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi all!
  This is my first message to this list and I want to annouce a first 
version of my new netfilter module for connection tracking balancing.
First maybe I will try to describe what this target should do:
I made this as a solution for balancing connections from one LAN, 
betewen a few providers links, but I think that is possible to find 
another good usages for this target.
Idea is quite simply: each connection (yes, connection not packet) which 
arrived to this target is marked. It recive one mark which is use for 
marking all packets  from this connection. Marks are sharing by choosen 
algorithm (for now I implemented RR, WRR and special one- basing on 
amout of data for each mark for last 1000 packets).
So this is a example how to use this target for balancing http 
connections betewen 3 internet links (let's suppose that internet links 
are ppp0, ppp1 and ppp2 and LAN link is eth0):
First we need to use my target:
iptables -t mangle -A PREROUTING -i eth0 -p tcp --dport 80 -j MARKCB   
--set-mark-rr 1-3
for simply RR balancing.
For now each connection from LAN will marked by 1,2 or by 3.
Now let's make special routing table for each of this marks and define 
rules for marked packets:
ip route add default via ip_for_first_link dev ppp0 table 1
ip route add ip_for_first_network dev ppp0 table 1 (I mean for example 
192.168.1.0/24)
ip route add ip_for_lan_network dev eth0 table 1
same etries you have to make for ppp1 and ppp2, names of tables should 
be diffrent of course.
thaen we need to make rules for pakets:
ip rule add fwmark 1 table 1
and so on...
now we only need to do a couple of proper SNAT rules:
iptables -t nat -A PREROUTING -o ppp0 -p tcp --dport 80 -j SNAT --to 
external_ip_of_ppp0
and so on for rest.
As you see after this all connection to outside to port 80 will balanced 
betewen this 3 internet links by RR algorithm. To use weights you need 
only to change this mangle rule. Instead of --set-mark-rr 1-3 put: 
--set-mark-wrr 1-3xw1:w2:w3 where w1, w2 and w3 are your weights for 
internet links. To use balancing based on amout of data write: 
--set-mark-lcb 1-3.
I attached two patchs. One for iptables-1.2.7a and second for kernel 
2.4.20 (or 2.4.19). You need to patch iptables sources and kernel, then 
recompile and install. I tested this module and it was working for me.
Please don't be angry for my programming style or possibly mistakes. It 
is my first kernel module and I am not so good C programmer...

--
Maciej Zobniow
Open Source - Free software for free people.


--------------020801010301050006020007
Content-Type: text/plain;
 name="iptables-1.2.7a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-1.2.7a.patch"

diff -r -uN iptab-1.2.7a/extensions/libipt_MARKCB.c iptables-1.2.7a/extensions/libipt_MARKCB.c
--- iptab-1.2.7a/extensions/libipt_MARKCB.c	2002-12-09 14:49:26.000000000 +0100
+++ iptables-1.2.7a/extensions/libipt_MARKCB.c	1970-01-01 01:00:00.000000000 +0100
@@ -1,238 +0,0 @@
-
-/* Shared library add-on to iptables to add MARKCB target support. */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_MARKCB.h>
-
-#if 0
-struct markinfo {
-	struct ipt_entry_target t;
-	struct ipt_markcb_target_info mark;
-};
-#endif
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"MARKCB target v%s options:\n"
-"  --set-mark-xxx value              Set  markcb value\n"
-"\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "set-mark-rr", 1, 0, '1' },
-  { "set-mark-wrr",1 ,0 , '2'},
-  { "set-mark-lcb",1 ,0, '3'},
-	{ 0 }
-};
-
-/* Initialize the target. */
-static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
-{
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
-{
-	char *test = calloc(sizeof(optarg),1);
-	char *ws1;
-	char *ws2;
-  char *w1;
-  char *w2;
-  char *weight;
-  long wsi1, wsi2,wei;
-  int i;
-  
-	struct ipt_markcb_target_info *markinfo
-		= (struct ipt_markcb_target_info *)(*target)->data;
-
-	switch (c) {
-		char *end;
-	case '1':
-		strcpy(test,optarg);
-		ws1 = strtok(test,"-");
-		ws2 = strtok(0,"-");
-		markinfo->mark1 = strtoul(ws1, &end, 0);
-		if (*end != '\0' || end == ws1)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-		markinfo->mark2 = strtoul(ws2, &end, 0);
-		if (*end != '\0' || end == ws2)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "MARKCB target: Can't specify --set-mark-rr twice");
-		*flags = 1;
-    markinfo->mode = '1';
-    //markinfo->tab_of_weights = NULL;
-		free((void*)test);
-		break;
-  case '2':
-    strcpy(test,optarg);
-    w1 = strtok(test,"x");
-    w2 = strtok(0,"x");
-    ws1 = strtok(w1,"-");
-		ws2 = strtok(0,"-");
-    wsi1 = strtoul(ws1, &end, 0);
-    if (*end != '\0' || end == ws1)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-    wsi2 = strtoul(ws2, &end, 0);
-    if (*end != '\0' || end == ws2)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-    //printf("Mark1: %lu Mark2: %lu\n",wsi1,wsi2);
-    markinfo->mark1 = wsi1;
-    markinfo->mark2 = wsi2;
-    wei=wsi2-wsi1;
-    //markinfo->tab_of_weights = calloc(sizeof(unsigned long),wei);
-    weight = strtok(w2,":");
- //   printf("weight1: %s\n",weight);
-    for(i=0;i<=wei;i++){
-      markinfo->tab_of_weights[i] = strtoul(weight, &end, 0);
-      if (*end != '\0' || end == weight)
-			  exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-      weight = strtok(0,":");
-   //   printf("weight: %s\n",weight);
-      }
-    *flags = 1;
-    markinfo->mode = '2';
-    free((void*)test);
-    break;
-  case '3':
-    strcpy(test,optarg);
-		ws1 = strtok(test,"-");
-		ws2 = strtok(0,"-");
-		markinfo->mark1 = strtoul(ws1, &end, 0);
-		if (*end != '\0' || end == ws1)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-		markinfo->mark2 = strtoul(ws2, &end, 0);
-		if (*end != '\0' || end == ws2)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "MARKCB target: Can't specify --set-mark-lcb twice");
-		*flags = 1;
-    markinfo->mode = '3';
-    //markinfo->tab_of_weights = NULL;
-		free((void*)test);
-		break;
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-		           "MARKCB target: Parameter --set-mark-xxx is required");
-}
-
-static void
-print_mark(unsigned long mark, int numeric)
-{
-	printf("0x%lx ", mark);
-}
-
-/* Prints out the targinfo. */
-static void
-print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
-      int numeric)
-{
-	const struct ipt_markcb_target_info *markinfo =
-		(const struct ipt_markcb_target_info *)target->data;
-  unsigned long w=0;
-  long wei;
-    
-    switch(markinfo->mode){
-      case '1':
-	      printf("MARKCB first ");
-	      print_mark(markinfo->mark1, numeric);
-	      printf("MARKCB second ");
-	      print_mark(markinfo->mark2, numeric);
-        break;
-      case '2':
-        printf("MARKCB first ");
-	      print_mark(markinfo->mark1, numeric);
-	      printf("MARKCB second ");
-	      print_mark(markinfo->mark2, numeric);
-        printf(" Weight table ");
-        wei = markinfo->mark2 - markinfo->mark1;
-        while(w<=wei){
-          printf("%u ",markinfo->tab_of_weights[w]);
-          w++;
-          }
-        break;
-      case '3':
-        printf("MARKCB first ");
-	      print_mark(markinfo->mark1, numeric);
-	      printf("MARKCB second ");
-	      print_mark(markinfo->mark2, numeric);
-        break;  
-  }
-
-}
-
-/* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
-{
-	const struct ipt_markcb_target_info *markinfo =
-		(const struct ipt_markcb_target_info *)target->data;
-  unsigned long w=0;
-  long wei;
-  
-    switch(markinfo->mode){
-      case '1':
-	      printf("--set-mark-rr 0x%lx-0x%lx", markinfo->mark1, markinfo->mark2);
-        break;
-      case '2':
-         printf("--set-mark-wrr 0x%lx-0x%lxx");
-         wei = markinfo->mark2 - markinfo->mark1;
-         while(w<=wei){
-          printf("%u:",markinfo->tab_of_weights[w]);
-          w++;
-          }
-        break;
-      case '3':
-         printf("--set-mark-lcb 0x%lx-0x%lx", markinfo->mark1, markinfo->mark2);
-         break;
-  }
-	
-}
-
-static
-struct iptables_target mark
-= { NULL,
-    "MARKCB",
-    IPTABLES_VERSION,
-    IPT_ALIGN(sizeof(struct ipt_markcb_target_info)),
-    IPT_ALIGN(sizeof(struct ipt_markcb_target_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
-};
-
-void _init(void)
-{
-	register_target(&mark);
-}
diff -r -uN iptab-1.2.7a/extensions/Makefile iptables-1.2.7a/extensions/Makefile
--- iptab-1.2.7a/extensions/Makefile	2002-12-06 00:09:31.000000000 +0100
+++ iptables-1.2.7a/extensions/Makefile	2002-08-09 09:44:10.000000000 +0200
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp length limit mac mark multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TCPMSS TOS ULOG MARKCB
+PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp length limit mac mark multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TCPMSS TOS ULOG
 PF6_EXT_SLIB:=eui64 icmpv6 length limit mac mark multiport owner standard tcp udp LOG MARK
 
 # The following may not be present, but compile them anyway.
diff -r -uN iptab-1.2.7a/extensions/.MARKCB-test iptables-1.2.7a/extensions/.MARKCB-test
--- iptab-1.2.7a/extensions/.MARKCB-test	2002-12-06 00:12:33.000000000 +0100
+++ iptables-1.2.7a/extensions/.MARKCB-test	1970-01-01 01:00:00.000000000 +0100
@@ -1,2 +0,0 @@
-#! /bin/sh
-[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_MARKCB.c ] && echo MARKCB

--------------020801010301050006020007
Content-Type: text/plain;
 name="markcb_patch-0.01"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="markcb_patch-0.01"

diff -urN lin/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.4.19/include/linux/netfilter_ipv4/ip_conntrack.h
--- lin/include/linux/netfilter_ipv4/ip_conntrack.h	2002-12-05 01:58:19.000000000 +0100
+++ linux-2.4.19/include/linux/netfilter_ipv4/ip_conntrack.h	2002-12-11 13:12:00.000000000 +0100
@@ -197,10 +197,7 @@
 #endif
 	} nat;
 #endif /* CONFIG_IP_NF_NAT_NEEDED */
-#if defined(CONFIG_IP_NF_MARKCB)
-	       unsigned long mark;
-	       unsigned long ind;
-#endif
+
 };
 
 /* get master conntrack via master expectation */
diff -urN lin/include/linux/netfilter_ipv4/ipt_MARKCB.h linux-2.4.19/include/linux/netfilter_ipv4/ipt_MARKCB.h
--- lin/include/linux/netfilter_ipv4/ipt_MARKCB.h	2002-12-11 12:37:03.000000000 +0100
+++ linux-2.4.19/include/linux/netfilter_ipv4/ipt_MARKCB.h	1970-01-01 01:00:00.000000000 +0100
@@ -1,32 +0,0 @@
-/***************************************************************************
-                          ipt_markcb.h  -  description
-                             -------------------
-    begin                : |31-08-02|
-    copyright            : (C) |2002| by |Maciej Zobniow|
-    email                : |maciek@zobniow.priv.pl|
- ***************************************************************************/
-
-/***************************************************************************
- *                                                                         *
- *   This program is free software; you can redistribute it and/or modify  *
- *   it under the terms of the GNU General Public License as published by  *
- *   the Free Software Foundation; either version 2 of the License, or     *
- *   (at your option) any later version.                                   *
- *                                                                         *
- ***************************************************************************/
-
-#ifndef _IPT_MARKCB_H_target
-#define _IPT_MARKCB_H_target
-
-#define IPT_MARKCB_NCON 10   // max of balanced links
-#define IPT_MARKCB_PKT 500   // number of counting packets for lcb
-
-struct ipt_markcb_target_info {
-       unsigned long mark1;
-       unsigned long mark2;
-       unsigned long tab_of_weights[IPT_MARKCB_NCON];    //for wrr
-       char mode; /* ? */
-       unsigned long options[3];
-       unsigned long *data_len;
-};
-#endif /*_IPT_MARKCB_H*/
diff -urN lin/net/ipv4/netfilter/Config.in linux-2.4.19/net/ipv4/netfilter/Config.in
--- lin/net/ipv4/netfilter/Config.in	2002-12-11 13:28:26.000000000 +0100
+++ linux-2.4.19/net/ipv4/netfilter/Config.in	2002-12-11 13:12:01.000000000 +0100
@@ -7,7 +7,6 @@
 tristate 'Connection tracking (required for masq/NAT)' CONFIG_IP_NF_CONNTRACK
 if [ "$CONFIG_IP_NF_CONNTRACK" != "n" ]; then
   dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP $CONFIG_IP_NF_CONNTRACK
-  bool '  Packet marking balancing  support' CONFIG_IP_NF_MARKCB
   dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CONNTRACK
 fi
 
@@ -92,9 +91,6 @@
   dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP_NF_IPTABLES
   dep_tristate '  ULOG target support' CONFIG_IP_NF_TARGET_ULOG $CONFIG_IP_NF_IPTABLES
   dep_tristate '  TCPMSS target support' CONFIG_IP_NF_TARGET_TCPMSS $CONFIG_IP_NF_IPTABLES
-if [ "$CONFIG_IP_NF_MARKCB" != "n" ]; then
-      dep_tristate '  MARKCB target support' CONFIG_IP_NF_TARGET_MARKCB $CONFIG_IP_NF_IPTABLES
-      fi
 fi
 
 tristate 'ARP tables support' CONFIG_IP_NF_ARPTABLES
diff -urN lin/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.4.19/net/ipv4/netfilter/ip_conntrack_standalone.c
--- lin/net/ipv4/netfilter/ip_conntrack_standalone.c	2002-12-05 15:04:59.000000000 +0100
+++ linux-2.4.19/net/ipv4/netfilter/ip_conntrack_standalone.c	2002-12-11 13:12:01.000000000 +0100
@@ -104,9 +104,6 @@
 		len += sprintf(buffer + len, "[ASSURED] ");
 	len += sprintf(buffer + len, "use=%u ",
 		       atomic_read(&conntrack->ct_general.use));
-		#if defined(CONFIG_IP_NF_MARKCB)
-		len += sprintf(buffer + len, "mark=%lu ", conntrack->mark);
-		#endif
 	len += sprintf(buffer + len, "\n");
 
 	return len;
diff -urN lin/net/ipv4/netfilter/ipt_MARKCB.c linux-2.4.19/net/ipv4/netfilter/ipt_MARKCB.c
--- lin/net/ipv4/netfilter/ipt_MARKCB.c	2002-12-11 12:23:35.000000000 +0100
+++ linux-2.4.19/net/ipv4/netfilter/ipt_MARKCB.c	1970-01-01 01:00:00.000000000 +0100
@@ -1,172 +0,0 @@
-/***************************************************************************
-                          ipt_MARKCB.c  -  description
-                             -------------------
-    begin                : nie wrz 1 2002
-    copyright            : (C) 2002 by Maciek Zobniow
-    email                : maciek@zobniow.priv.pl
- ***************************************************************************/
-
-/***************************************************************************
- *                                                                         *
- *   This program is free software; you can redistribute it and/or modify  *
- *   it under the terms of the GNU General Public License as published by  *
- *   the Free Software Foundation; either version 2 of the License, or     *
- *   (at your option) any later version.                                   *
- *                                                                         *
- ***************************************************************************/
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/checksum.h>
-#include <linux/slab.h>
-
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_MARKCB.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
-
-
-static unsigned long minimtabl(unsigned long *tabl,unsigned long len);
-
-static unsigned int target(struct sk_buff **pskb,
-       unsigned int hooknum,
-       const struct net_device *in,
-       const struct net_device *out,
-       const void *targinfo,
-       void *userinfo)
-{
-       struct ipt_markcb_target_info *markinfo = targinfo;    
-       enum ip_conntrack_info ctinfo;
-       struct ip_conntrack *ct = ip_conntrack_get((*pskb), &ctinfo);
-       int i;
-       unsigned long numb;
-       unsigned long len = markinfo->mark2 - markinfo->mark1+1;
-
-       if(markinfo->options[0] == 0){
-            markinfo->options[0] = markinfo->mark1;
-            if(markinfo->mode == '3'){
-              markinfo->data_len = kmalloc(sizeof(unsigned long), len);
-              // data_len_temp = kmalloc(sizeof(unsigned long), len);
-              for(i=0;i<=(markinfo->mark2 - markinfo->mark1);i++){
-                  markinfo->data_len[i]=0;
-                  }
-            }
-         }
-           
-			 if(ct->ind == 1){
-					(*pskb)->nfmark = ct->mark;
-					(*pskb)->nfcache |= NFC_ALTERED;
-          if(markinfo->mode == '3'){ //counting data for lcb
-            if(markinfo->options[2] <= IPT_MARKCB_PKT){
-               markinfo->options[2]++;
-               markinfo->data_len[ct->mark - markinfo->mark1] += (*pskb)->len;
-              }else{   // initialize tab after IPT_MARKCB_PKT packets           
-                markinfo->options[2]=0;
-                for(i=0;i<=(markinfo->mark2 - markinfo->mark1);i++){
-                  markinfo->data_len[i] = 0;
-                  // data_len_temp[i]=0;
-                  }
-                }
-            }
-			 } else {
-         switch(markinfo->mode){
-           case '1':  // RR
-			 		  ct->mark = markinfo->options[0];
-			      ct->ind = 1;
-			      (*pskb)->nfmark = ct->mark;
-			      (*pskb)->nfcache |= NFC_ALTERED;
-			      if(markinfo->mark2 > markinfo->options[0]){
-						  markinfo->options[0] = markinfo->options[0]+1;
-			      } else {
-			    	  markinfo->options[0] = markinfo->mark1;
-			      }
-            break;
-            case '2': //WRR
-               if(markinfo->options[1] >= markinfo->tab_of_weights[markinfo->options[0] - markinfo->mark1]){
-                  if(markinfo->mark2 > markinfo->options[0]){
-						         markinfo->options[0] = markinfo->options[0]+1;
-			            } else {
-			    	         markinfo->options[0] = markinfo->mark1;
-			            }
-                  markinfo->options[1] = 1;
-                  ct->mark = markinfo->options[0];
-			            ct->ind = 1;
-			            (*pskb)->nfmark = ct->mark;
-			            (*pskb)->nfcache |= NFC_ALTERED;
-                 } else {
-                     ct->mark = markinfo->options[0];
-			               ct->ind = 1;
-			               (*pskb)->nfmark = ct->mark;
-			               (*pskb)->nfcache |= NFC_ALTERED;
-                     markinfo->options[1]++;
-                   }
-                   break;
-            case '3':   //LCB
-               numb = minimtabl(markinfo->data_len,len);
-               ct->mark = markinfo->mark1+numb;
-               ct->ind = 1;
-               (*pskb)->nfmark = ct->mark;
-			         (*pskb)->nfcache |= NFC_ALTERED;
-               break;
-                   }
-			  }
-			 return NF_ACCEPT;
-}
-
-static unsigned long minimtabl(unsigned long *tabl,unsigned long len)
-{
-  int i,ind;
-  unsigned long min;
-
- min = tabl[0];
- ind = 0;  
- for(i=1;i<len;i++){
-    if(min<=tabl[i]){
-      continue;
-      }else {
-        min = tabl[i];
-        ind = i;
-        }
-   }
-   return ind; 
-}
-  
-static int checkentry(const char *tablename,
-          const struct ipt_entry *e,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
-{
-       struct ipt_markcb_target_info *matchinfo = targinfo;
-       if (targinfosize != IPT_ALIGN(sizeof(struct ipt_markcb_target_info))) {
-               printk(KERN_WARNING "MARKCB: targinfosize %u != %Zu\n",
-                      targinfosize,
-                      IPT_ALIGN(sizeof(struct ipt_markcb_target_info)));
-               return 0;
-       }
-
-       if (strcmp(tablename, "mangle") != 0) {
-       		     printk(KERN_WARNING "MARKCB: restore can only be called from \"mangle\" table, not \"%s\"\n", tablename);
-               return 0;
-           }
-
-       return 1;
-}
-
-static struct ipt_target ipt_markcb_reg = { { NULL, NULL }, "MARKCB", target, checkentry, NULL, THIS_MODULE };
-
-static int __init init(void)
-{
-       if (ipt_register_target(&ipt_markcb_reg))
-               return -EINVAL;
-
-       return 0;
-}
-
-static void __exit fini(void)
-{
-       ipt_unregister_target(&ipt_markcb_reg);
-}
-
-module_init(init);
-module_exit(fini);
-
diff -urN lin/net/ipv4/netfilter/Makefile linux-2.4.19/net/ipv4/netfilter/Makefile
--- lin/net/ipv4/netfilter/Makefile	2002-12-05 01:46:47.000000000 +0100
+++ linux-2.4.19/net/ipv4/netfilter/Makefile	2002-12-11 13:12:01.000000000 +0100
@@ -89,7 +89,6 @@
 obj-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 obj-$(CONFIG_IP_NF_TARGET_TCPMSS) += ipt_TCPMSS.o
-obj-$(CONFIG_IP_NF_TARGET_MARKCB) += ipt_MARKCB.o
 
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) += arp_tables.o

--------------020801010301050006020007--
