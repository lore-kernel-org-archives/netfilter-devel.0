From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: [PATCH] let submitted/61_nulldev_alignment match official kernel
 2.4.25 in pom-20040409
Date: Sun, 11 Apr 2004 14:01:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4079337D.4010207@fl.priv.at>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070501060408050308010503"
Cc: Tommi Virtanen <tv@debian.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------070501060408050308010503
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

Tommi I have you CC'd as you are the author of this patch.

Here is a patch for the submitted/61_nulldev_alignment patch in
pom-20040409 (not pom-ng!) that matches the latest official changes
in kernel 2.4.25.

-- 
MfG / Regards
Friedrich Lobenstock

--------------070501060408050308010503
Content-Type: text/plain;
 name="patch-submitted-61_nulldev_alignment-patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-submitted-61_nulldev_alignment-patch"

--- patch-o-matic-20040409/submitted/61_nulldev_alignment.patch.pre-2.4.25	2004-04-11 14:45:23.000000000 +0200
+++ patch-o-matic-20040409/submitted/61_nulldev_alignment.patch	2004-04-11 14:45:38.000000000 +0200
@@ -1,16 +1,11 @@
---- linux-2.4.orig/net/ipv4/netfilter/ip_tables.c	2003-12-26 19:24:46.000000000
-+0200
-+++ linux-2.4/net/ipv4/netfilter/ip_tables.c	2003-12-26 18:58:30.000000000 +0200
-@@ -260,7 +278,11 @@ ipt_do_table(struct sk_buff **pskb,
+--- linux-2.4.24/net/ipv4/netfilter/ip_tables.c	2003-08-25 04:44:44.000000000 -0700
++++ linux-2.4.25/net/ipv4/netfilter/ip_tables.c	2004-02-18 05:36:32.000000000 -0800
+@@ -259,7 +259,7 @@
  	     struct ipt_table *table,
  	     void *userdata)
  {
 -	static const char nulldevname[IFNAMSIZ] = { 0 };
-+	/* Pointer to nulldevname may be dereferenced as unsigned
-+	   long* in ip_packet_match. We need to guarantee
-+	   sufficient alignment here. */
-+	static const char nulldevname[IFNAMSIZ]
-+		__attribute__((__aligned__(__alignof__ (unsigned long)))) = {0};
++	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long)))) = { 0 };
  	u_int16_t offset;
  	struct iphdr *ip;
  	void *protohdr;

--------------070501060408050308010503--
