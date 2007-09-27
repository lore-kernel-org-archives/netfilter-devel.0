From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: ipt_ACCOUNT 1.11 warning fix
Date: Thu, 27 Sep 2007 11:45:08 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709271144100.30621@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: opensource@intra2net.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52043 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbXI0JpJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:45:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


sizeof() produces a 'size_t', which is a little bit larger than %u on 
64-bit. Fix it, the right way using %zu.

---
 net/ipv4/netfilter/ipt_ACCOUNT.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.22/net/ipv4/netfilter/ipt_ACCOUNT.c
===================================================================
--- linux-2.6.22.orig/net/ipv4/netfilter/ipt_ACCOUNT.c
+++ linux-2.6.22/net/ipv4/netfilter/ipt_ACCOUNT.c
@@ -867,7 +867,7 @@ static int ipt_acc_set_ctl(struct sock *
     switch (cmd) {
     case IPT_SO_SET_ACCOUNT_HANDLE_FREE:
         if (len != sizeof(struct ipt_acc_handle_sockopt)) {
-            printk("ACCOUNT: ipt_acc_set_ctl: wrong data size (%u != %u) "
+            printk("ACCOUNT: ipt_acc_set_ctl: wrong data size (%u != %zu) "
                    "for IPT_SO_SET_HANDLE_FREE\n", 
                    len, sizeof(struct ipt_acc_handle_sockopt));
             break;
@@ -913,7 +913,7 @@ static int ipt_acc_get_ctl(struct sock *
             struct ipt_acc_handle dest;
 
             if (*len < sizeof(struct ipt_acc_handle_sockopt)) {
-                printk("ACCOUNT: ipt_acc_get_ctl: wrong data size (%u != %u) "
+                printk("ACCOUNT: ipt_acc_get_ctl: wrong data size (%u != %zu) "
                     "for IPT_SO_GET_ACCOUNT_PREPARE_READ/READ_FLUSH\n",
                     *len, sizeof(struct ipt_acc_handle_sockopt));
                 break;
@@ -958,7 +958,7 @@ static int ipt_acc_get_ctl(struct sock *
         }
     case IPT_SO_GET_ACCOUNT_GET_DATA:
         if (*len < sizeof(struct ipt_acc_handle_sockopt)) {
-            printk("ACCOUNT: ipt_acc_get_ctl: wrong data size (%u != %u)"
+            printk("ACCOUNT: ipt_acc_get_ctl: wrong data size (%u != %zu)"
                    " for IPT_SO_GET_ACCOUNT_PREPARE_READ/READ_FLUSH\n",
                    *len, sizeof(struct ipt_acc_handle_sockopt));
             break;
@@ -977,7 +977,7 @@ static int ipt_acc_get_ctl(struct sock *
 
         if (*len < ipt_acc_handles[handle.handle_nr].itemcount
                    * sizeof(struct ipt_acc_handle_ip)) {
-            printk("ACCOUNT: ipt_acc_get_ctl: not enough space (%u < %u)"
+            printk("ACCOUNT: ipt_acc_get_ctl: not enough space (%u < %zu)"
                    " to store data from IPT_SO_GET_ACCOUNT_GET_DATA\n",
                    *len, ipt_acc_handles[handle.handle_nr].itemcount
                    * sizeof(struct ipt_acc_handle_ip));
@@ -999,7 +999,7 @@ static int ipt_acc_get_ctl(struct sock *
     case IPT_SO_GET_ACCOUNT_GET_HANDLE_USAGE: {
             unsigned int i;
             if (*len < sizeof(struct ipt_acc_handle_sockopt)) {
-                printk("ACCOUNT: ipt_acc_get_ctl: wrong data size (%u != %u)"
+                printk("ACCOUNT: ipt_acc_get_ctl: wrong data size (%u != %zu)"
                        " for IPT_SO_GET_ACCOUNT_GET_HANDLE_USAGE\n",
                        *len, sizeof(struct ipt_acc_handle_sockopt));
                 break;
