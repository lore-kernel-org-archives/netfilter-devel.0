From: Simon Lodal <simonl@parknet.dk>
Subject: [PATCH] realm: fix inversion
Date: Wed, 22 Sep 2004 03:48:40 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4150D9F8.7060600@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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


Make '--realm ! id' work as advertised.
Make save() output inversion correctly so it can be parsed back in, and 
work with iptables-restore and iptables-save.


Simon Lodal



diff -ruN iptables-1.2.11.orig/extensions/libipt_realm.c 
iptables-1.2.11.realm_inversion/extensions/libipt_realm.c
--- iptables-1.2.11.orig/extensions/libipt_realm.c	Wed Sep 22 03:14:48 2004
+++ iptables-1.2.11.realm_inversion/extensions/libipt_realm.c	Wed Sep 22 
01:37:06 2004
@@ -49,7 +49,8 @@
  	switch (c) {
  		char *end;
  	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
+		if (check_inverse(optarg, &invert, &optind, 0))
+			optarg = argv[optind-1];
  		realminfo->id = strtoul(optarg, &end, 0);
  		if (*end == '/') {
  			realminfo->mask = strtoul(end+1, &end, 0);
@@ -72,7 +73,7 @@
  print_realm(unsigned long id, unsigned long mask, int invert, int numeric)
  {
  	if (invert)
-		fputc('!', stdout);
+		printf("! ");

  	if(mask != 0xffffffff)
  		printf("0x%lx/0x%lx ", id, mask);
