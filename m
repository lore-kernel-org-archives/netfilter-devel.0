From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] fix nf_conntrack_netlink expectation dumping/event
	notification
Date: Fri, 13 Jan 2006 02:41:10 +0100
Message-ID: <43C70536.7000608@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060400070302030400020604"
Cc: Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------060400070302030400020604
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Yasuyuki,

Currently we get an oops with nf_conntrack_netlink + nf_conntrack_ftp
because l3num is set to 0xFFFF for the expectation mask. At first sight,
this is correct because l3num is u_int16_t, but the size of the layer-3
array of protocol handlers is AF_MAX (32).

I could add some checking to verify that l3num is less than 32 in
nf_conntrack_find_l3proto, but such checking is only required for
nf_conntrack_ftp and further application helpers. AFAICS, this is the
cleanest way to fix this problem. Any other suggestion?

Cheers,
Pablo

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------060400070302030400020604
Content-Type: text/plain;
 name="x1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x1"

Set l3num to 0x1F (32) in expectation masks since the size of the layer 3 
procotol handler array is AF_MAX. This fixes a panic at expectation dumping
and event notification.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/netfilter/nf_conntrack_ftp.c
===================================================================
--- netfilter-2.6.14.git.orig/net/netfilter/nf_conntrack_ftp.c	2006-01-08 21:24:44.000000000 +0100
+++ netfilter-2.6.14.git/net/netfilter/nf_conntrack_ftp.c	2006-01-08 21:33:52.000000000 +0100
@@ -574,7 +574,7 @@ static int help(struct sk_buff **pskb,
 	exp->tuple.dst.protonum = IPPROTO_TCP;
 
 	exp->mask = (struct nf_conntrack_tuple)
-		    { .src = { .l3num = 0xFFFF,
+		    { .src = { .l3num = 0x001F,
 			       .u = { .tcp = { 0 }},
 			     },
 		      .dst = { .protonum = 0xFF,

--------------060400070302030400020604--
