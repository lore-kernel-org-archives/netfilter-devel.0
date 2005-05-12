From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH pom-ng 1/3] h323-conntrack-nat updates: check bb->error
	in every iteration
Date: Thu, 12 May 2005 22:51:06 +0200
Message-ID: <20050512205106.GB2175@roonstrasse.net>
References: <20050512204956.GA2086@roonstrasse.net>
	<20050512205047.GA2175@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050512205047.GA2175@roonstrasse.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2005/05/12 22:50, Max Kellermann <max@duempel.org> wrote:
> h323-01-another_bb_error_check.patch
> - critical bug fix, check bb->error in every for iteration
> 

damn, patch was missing :(

here it is


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="h323-01-another_bb_error_check.patch"

Thu May 12 21:58:49 CEST 2005  max@duempel.org
  * check bb->error in loop
diff -rN -u old-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/asn1_per.c new-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/asn1_per.c
--- old-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/asn1_per.c	2005-05-12 22:40:24.000000000 +0200
+++ new-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/asn1_per.c	2005-05-12 21:58:41.000000000 +0200
@@ -278,7 +278,7 @@
 	if (bb->error)
 		return;
 
-	for (i = 0; i < ext.count; i++) {
+	for (i = 0; i < ext.count && !bb->error; i++) {
 		if (asn1_per_bitmap_get(&ext.present, i))
 			asn1_per_skip_octet_string(bb);
 	}


--6c2NcOVqGQ03X4Wi--
