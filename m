From: "Dong Wei" <dwei.zh@gmail.com>
Subject: [PATCH] Fix connlimit bug when receive RST packet in ESTABLISHED state
Date: Mon, 2 Jun 2008 19:22:11 +0800
Message-ID: <3104bfb60806020422s73c60a29kde8c896e1db901d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2517_6528086.1212405731486"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:50053 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYFBLWN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:22:13 -0400
Received: by fk-out-0910.google.com with SMTP id 18so864623fkq.5
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2008 04:22:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

------=_Part_2517_6528086.1212405731486
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, all
  In xt_connlimit match module, the counter of an IP is decreased when
the TCP packet is go through the chain with ip_conntrack state TW.
Well, it's very natural that the server and client close the socket
with FIN packet. But when the client/server close the socket with RST
packet(using so_linger), the counter for this connection still exsit.
The following patch can fix it which is based on linux-2.6.25.4

diff -ruN a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
--- a/net/netfilter/xt_connlimit.c      2008-06-02 18:48:38.000000000 +0800
+++ b/net/netfilter/xt_connlimit.c      2008-06-02 18:50:40.000000000 +0800
@@ -75,7 +75,8 @@
        u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;

        if (proto == IPPROTO_TCP)
-               return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
+               return (conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT
+                       || conn->proto.tcp.state == TCP_CONNTRACK_CLOSE);
        else
                return 0;
 }

------=_Part_2517_6528086.1212405731486
Content-Type: text/plain; name=xt_connlimit.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgyz2d190
Content-Disposition: attachment; filename=xt_connlimit.txt

ZGlmZiAtcnVOIGEvbmV0L25ldGZpbHRlci94dF9jb25ubGltaXQuYyBiL25ldC9uZXRmaWx0ZXIv
eHRfY29ubmxpbWl0LmMKLS0tIGEvbmV0L25ldGZpbHRlci94dF9jb25ubGltaXQuYwkyMDA4LTA2
LTAyIDE4OjQ4OjM4LjAwMDAwMDAwMCArMDgwMAorKysgYi9uZXQvbmV0ZmlsdGVyL3h0X2Nvbm5s
aW1pdC5jCTIwMDgtMDYtMDIgMTg6NTA6NDAuMDAwMDAwMDAwICswODAwCkBAIC03NSw3ICs3NSw4
IEBACiAJdV9pbnQxNl90IHByb3RvID0gY29ubi0+dHVwbGVoYXNoWzBdLnR1cGxlLmRzdC5wcm90
b251bTsKIAogCWlmIChwcm90byA9PSBJUFBST1RPX1RDUCkKLQkJcmV0dXJuIGNvbm4tPnByb3Rv
LnRjcC5zdGF0ZSA9PSBUQ1BfQ09OTlRSQUNLX1RJTUVfV0FJVDsKKwkJcmV0dXJuIChjb25uLT5w
cm90by50Y3Auc3RhdGUgPT0gVENQX0NPTk5UUkFDS19USU1FX1dBSVQKKwkJICAgICAgICB8fCBj
b25uLT5wcm90by50Y3Auc3RhdGUgPT0gVENQX0NPTk5UUkFDS19DTE9TRSk7CiAJZWxzZQogCQly
ZXR1cm4gMDsKIH0K
------=_Part_2517_6528086.1212405731486--
