From: Eicke Friedrich <tady@gmx.net>
Subject: [PATCH] ipp2p 0.6.1-2
Date: Fri, 10 Sep 2004 13:10:58 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41418BC2.7030705@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010406060304040404090806"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010406060304040404090806
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi again,

another patch for ipp2p. It covers a case that occured after the first
patch was send to the list. Please apply on top of the first patch.
Sorry for that.

Regards,
Eicke.

--------------010406060304040404090806
Content-Type: text/plain;
 name="ipp2p-0.6.1-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipp2p-0.6.1-2.diff"

diff -Nru patch-o-matic-ng-new/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c patch-o-matic-ng-061/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c
--- patch-o-matic-ng-new/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c	2004-09-10 11:01:56.511534576 +0200
+++ patch-o-matic-ng-061/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c	2004-09-10 12:35:36.131222528 +0200
@@ -44,9 +44,10 @@
     t += head_len;
 
     if (((packet_len - head_len) == 4) && (memcmp(t, "SEND", 4) == 0))  return 1;
+    if (((packet_len - head_len) == 3) && (memcmp(t, "GET", 3) == 0))  return 1;
     if (packet_len < (head_len + 10)) return 0;
 
-    if (memcmp(t, "SEND", 4) == 0){
+    if ((memcmp(t, "SEND", 4) == 0) || (memcmp(t, "GET", 3) == 0)){
         c = head_len + 4;
         t += 4;
         while (c < packet_len - 5) {
diff -Nru patch-o-matic-ng-new/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c patch-o-matic-ng-061/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c
--- patch-o-matic-ng-new/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	2004-09-10 11:02:17.171393800 +0200
+++ patch-o-matic-ng-061/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	2004-09-10 12:35:55.591264152 +0200
@@ -41,9 +41,10 @@
     t += head_len;
 
     if (((packet_len - head_len) == 4) && (memcmp(t, "SEND", 4) == 0))  return 1;
+    if (((packet_len - head_len) == 3) && (memcmp(t, "GET", 3) == 0))  return 1;
     if (packet_len < (head_len + 10)) return 0;
 
-    if (memcmp(t, "SEND", 4) == 0){
+    if ((memcmp(t, "SEND", 4) == 0) || (memcmp(t, "GET", 3) == 0)){
         c = head_len + 4;
         t += 4;
         while (c < packet_len - 5) {

--------------010406060304040404090806--
