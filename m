From: Patrick McHardy <kaber@trash.net>
Subject: Re: pending/69_amanda-helpers.patch does not apply to 2.4.22?
Date: Sun, 12 Oct 2003 05:25:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F88C9AB.5010306@trash.net>
References: <Pine.LNX.4.44.0310112315200.14720-100000@filer.marasystems.com> <1065913241.29186.4.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030406070808030802070909"
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1065913241.29186.4.camel@tux.rsn.bth.se>
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
--------------030406070808030802070909
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Martin Josefsson wrote:

>On Sat, 2003-10-11 at 23:22, Henrik Nordstrom wrote:
>  
>
>>After a recent CVS update of my pom tree the pending patch set no longer 
>>applies to 2.4.22, failing in pending/69_amanda-helpers.patch
>>    
>>
>
>I havn't had time to do my usual checking to see if everything applies.
>I usually catch these things fairly quickly.
>
>After a very quick look, I'd say it looks like a conflict between
>61-remove-memsets.patch and 69_amanda-helpers.patch
>Both by Patrick.
>
>Patrick, do you think you could fix it up?
>

This should do it.

Best regards,
Patrick

--------------030406070808030802070909
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: cvs/patch-o-matic/pending/61-remove-memsets.patch
===================================================================
RCS file: /cvspublic/netfilter/patch-o-matic/pending/61-remove-memsets.patch,v
retrieving revision 1.1
diff -u -r1.1 61-remove-memsets.patch
--- cvs/patch-o-matic/pending/61-remove-memsets.patch	23 Aug 2003 18:37:41 -0000	1.1
+++ cvs/patch-o-matic/pending/61-remove-memsets.patch	12 Oct 2003 03:22:02 -0000
@@ -1,14 +1,3 @@
-===== net/ipv4/netfilter/ip_conntrack_amanda.c 1.2 vs edited =====
---- 1.2/net/ipv4/netfilter/ip_conntrack_amanda.c	Mon Apr 28 03:52:54 2003
-+++ edited/net/ipv4/netfilter/ip_conntrack_amanda.c	Sun Jun 29 21:30:43 2003
-@@ -205,7 +205,6 @@
- {
- 	int ret;
- 
--	memset(&amanda_helper, 0, sizeof(struct ip_conntrack_helper));
- 	amanda_helper.tuple.src.u.udp.port = htons(10080);
- 	amanda_helper.tuple.dst.protonum = IPPROTO_UDP;
- 	amanda_helper.mask.src.u.udp.port = 0xFFFF;
 ===== net/ipv4/netfilter/ip_conntrack_tftp.c 1.1 vs edited =====
 --- 1.1/net/ipv4/netfilter/ip_conntrack_tftp.c	Mon Mar 31 17:08:21 2003
 +++ edited/net/ipv4/netfilter/ip_conntrack_tftp.c	Sun Jun 29 21:31:10 2003
@@ -21,18 +10,6 @@
  		tftp[i].tuple.dst.protonum = IPPROTO_UDP;
  		tftp[i].tuple.src.u.udp.port = htons(ports[i]);
  		tftp[i].mask.dst.protonum = 0xFFFF;
-===== net/ipv4/netfilter/ip_nat_amanda.c 1.2 vs edited =====
---- 1.2/net/ipv4/netfilter/ip_nat_amanda.c	Wed Jun 25 00:16:00 2003
-+++ edited/net/ipv4/netfilter/ip_nat_amanda.c	Sun Jun 29 21:31:40 2003
-@@ -195,8 +195,6 @@
- 	struct ip_nat_helper *hlpr;
- 
- 	hlpr = &ip_nat_amanda_helper;
--	memset(hlpr, 0, sizeof(struct ip_nat_helper));
--
- 	hlpr->tuple.dst.protonum = IPPROTO_UDP;
- 	hlpr->tuple.src.u.udp.port = htons(10080);
- 	hlpr->mask.src.u.udp.port = 0xFFFF;
 ===== net/ipv4/netfilter/ip_nat_tftp.c 1.1 vs edited =====
 --- 1.1/net/ipv4/netfilter/ip_nat_tftp.c	Mon Mar 31 17:08:21 2003
 +++ edited/net/ipv4/netfilter/ip_nat_tftp.c	Sun Jun 29 21:31:53 2003

--------------030406070808030802070909--
