From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: operation failure on delete
Date: Wed, 04 Mar 2009 19:12:56 +0100
Message-ID: <49AEC4A8.7020000@netfilter.org>
References: <49AEA966.2020007@astrocorp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090502030803050109040803"
Cc: netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@ecessa.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60914 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754983AbZCDSNJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:13:09 -0500
In-Reply-To: <49AEA966.2020007@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090502030803050109040803
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Bryan Duff wrote:
> //snip - conntrack search and attempted delete.
> root@localhost / # conntrack -L -p gre  unknown  47 27 src=60.60.60.151
> dst=192.168.2.2 packets=6 bytes=648 [UNREPLIED] src=10.10.10.100
> dst=60.60.60.151 packets=0 bytes=0 mark=2 use=1
> conntrack v0.9.11 (conntrack-tools): 1 flow entries has been shown.
> root@localhost / # conntrack -D -p gre
> conntrack v0.9.11 (conntrack-tools): Operation failed: invalid parameters
> //end snip
> 
> But I can delete tcp, udp, icmp conntrack entries.  I can only guess
> that there is a problem with "unknown" protocols like gre (haven't
> checked on esp, and so forth).  Using the protocol number (in this case
> 47) also fails.

No, it seems that the problem is that libnetfilter_conntrack-0.0.99 does
not include support for GRE yet.

> I'm using  libnfnetlink-0.0.40 and libnetfilter_conntrack-0.0.99
> 
> Kernel version 2.6.29-rc7.  The conntrack version is that released on
> the website (md5sum: ae97d335ad44e9611adde881490c8ec9).

The following patch should add it, it compiles, I didn't tested though.
I'd appreciate if you call tell me how it goes with it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------090502030803050109040803
Content-Type: text/x-diff;
 name="gre-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gre-support.patch"

src: add support for GRE transport protocol

This patch adds support for GRE transport protocol.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 src/conntrack/build.c            |    1 +
 src/conntrack/snprintf_default.c |    9 +++++++--
 src/conntrack/snprintf_xml.c     |   14 +++++++++++++-
 3 files changed, 21 insertions(+), 3 deletions(-)


diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index 9611508..a1569ab 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -50,6 +50,7 @@ void __build_tuple_proto(struct nfnlhdr *req,
 	case IPPROTO_UDP:
 	case IPPROTO_TCP:
 	case IPPROTO_SCTP:
+	case IPPROTO_GRE:
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_SRC_PORT,
 			       &t->l4src.tcp.port, sizeof(u_int16_t));
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_DST_PORT,
diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index 7cf28f8..a846af9 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -13,7 +13,8 @@ static char *proto2str[IPPROTO_MAX] = {
         [IPPROTO_UDPLITE] = "udplite",
         [IPPROTO_ICMP] = "icmp",
         [IPPROTO_ICMPV6] = "icmpv6",
-        [IPPROTO_SCTP] = "sctp"
+        [IPPROTO_SCTP] = "sctp",
+        [IPPROTO_GRE] = "gre"
 };
 
 static char *l3proto2str[AF_MAX] = {
@@ -162,7 +163,11 @@ int __snprintf_proto(char *buf,
 			        ntohs(tuple->l4src.tcp.port),
 			        ntohs(tuple->l4dst.tcp.port));
 		break;
-
+	case IPPROTO_GRE:
+		return snprintf(buf, len, "srckey=0x%x dstkey=0x%x ",
+			        ntohs(tuple->l4src.all),
+			        ntohs(tuple->l4dst.all));
+		break;
 	case IPPROTO_ICMP:
 	case IPPROTO_ICMPV6:
 		/* The ID only makes sense some ICMP messages but we want to
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index b14ff43..cb6fc03 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -59,7 +59,8 @@ static char *proto2str[IPPROTO_MAX] = {
         [IPPROTO_UDPLITE] = "udplite",
         [IPPROTO_ICMP] = "icmp",
         [IPPROTO_ICMPV6] = "icmp6",
-        [IPPROTO_SCTP] = "sctp"
+        [IPPROTO_SCTP] = "sctp",
+        [IPPROTO_GRE] = "gre"
 };
 static char *l3proto2str[AF_MAX] = {
 	[AF_INET] = "ipv4",
@@ -177,6 +178,17 @@ static int __snprintf_proto_xml(char *buf,
 			BUFFER_SIZE(ret, size, len, offset);
 		}
 		break;
+	case IPPROTO_GRE:
+		if (type == __ADDR_SRC) {
+			ret = snprintf(buf, len, "<srckey>0x%x</srckey>", 
+				       ntohs(tuple->l4src.all));
+			BUFFER_SIZE(ret, size, len, offset);
+		} else {
+			ret = snprintf(buf, len, "<dstkey>%u</dstkey>",
+				       ntohs(tuple->l4dst.all));
+			BUFFER_SIZE(ret, size, len, offset);
+		}
+		break;
 	}
 
 	return ret;

--------------090502030803050109040803--
