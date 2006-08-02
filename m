From: Piotr Chytla <pch@packetconsulting.pl>
Subject: u32 patch
Date: Wed, 2 Aug 2006 23:22:32 +0200
Message-ID: <20060802212232.GA29168@packetconsulting.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

Hi

Here are some small patch for u32 match, to work on 2.6.17 kernels . 
Matchsize in ipt_match  struct was missing. 


/pch

-- 
Dyslexia bug unpatched since 1977 ...
exploit has been leaked to the underground.

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ipt_u32.patch"

--- ipt_u32.c	2006-08-02 22:34:29.000000000 +0200
+++ /usr/src/linux-2.6.17.6/net/ipv4/netfilter/ipt_u32.c	2006-08-02 22:45:43.000000000 +0200
@@ -217,6 +217,7 @@
 static struct ipt_match u32_match = { 
 	.name 		= "u32",
 	.match		= &match,
+	.matchsize	= sizeof(struct ipt_u32),
 	.checkentry	= &checkentry,
 	.me		= THIS_MODULE
 };

--HlL+5n6rz5pIUxbD--
