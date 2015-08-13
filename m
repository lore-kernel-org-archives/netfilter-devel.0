From: Feng Gao <gfree.wind@gmail.com>
Subject: [PATCH] netfilter: Remove the duplicated word "see" in the comment
 when set the IPS_ASSURED_BIT in tcp_packet
Date: Thu, 13 Aug 2015 16:22:28 +0800
Message-ID: <CA+6hz4o4TbcAhgnC8sbN6utxAR=wWOMkd_=k+hGVqW+tZZxuZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113cdf403403cf051d2d098d
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33804 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbHMIW3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2015 04:22:29 -0400
Received: by oip136 with SMTP id 136so22719625oip.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2015 01:22:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--001a113cdf403403cf051d2d098d
Content-Type: text/plain; charset=UTF-8

Hi Pablo,

There is one duplicated word "see" in the comment when set the
IPS_ASSURED_BIT in tcp_packet.

The attachment is the patch file.

The following is the change.

>From d092aaa3dc847ed08b27081a467e39727d6627cb Mon Sep 17 00:00:00 2001
From: Feng Gao <gfree.wind@gmail.com>
Date: Thu, 13 Aug 2015 16:14:36 +0800
Subject: [PATCH 1/1] netfilter: Remove the duplicated word "see" in the
 comment when set the IPS_ASSURED_BIT in tcp_packet

Signed-off-by: Feng Gao <gfree.wind@gmail.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
b/net/netfilter/nf_conntrack_proto_tcp.c
index 70383de..697210f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1088,7 +1088,7 @@ static int tcp_packet(struct nf_conn *ct,
           && (old_state == TCP_CONNTRACK_SYN_RECV
               || old_state == TCP_CONNTRACK_ESTABLISHED)
           && new_state == TCP_CONNTRACK_ESTABLISHED) {
-       /* Set ASSURED if we see see valid ack in ESTABLISHED
+       /* Set ASSURED if we see valid ack in ESTABLISHED
           after SYN_RECV or a valid answer for a picked up
           connection. */
        set_bit(IPS_ASSURED_BIT, &ct->status);



Best Regards
Feng

--001a113cdf403403cf051d2d098d
Content-Type: application/octet-stream;
	name="0001-netfilter-Remove-the-duplicated-word-see-in-the-comm.patch"
Content-Disposition: attachment;
	filename="0001-netfilter-Remove-the-duplicated-word-see-in-the-comm.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_id9xrx1e0

RnJvbSBkMDkyYWFhM2RjODQ3ZWQwOGIyNzA4MWE0NjdlMzk3MjdkNjYyN2NiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGZW5nIEdhbyA8Z2ZyZWUud2luZEBnbWFpbC5jb20+CkRhdGU6
IFRodSwgMTMgQXVnIDIwMTUgMTY6MTQ6MzYgKzA4MDAKU3ViamVjdDogW1BBVENIIDEvMV0gbmV0
ZmlsdGVyOiBSZW1vdmUgdGhlIGR1cGxpY2F0ZWQgd29yZCAic2VlIiBpbiB0aGUKIGNvbW1lbnQg
d2hlbiBzZXQgdGhlIElQU19BU1NVUkVEX0JJVCBpbiB0Y3BfcGFja2V0CgpTaWduZWQtb2ZmLWJ5
OiBGZW5nIEdhbyA8Z2ZyZWUud2luZEBnbWFpbC5jb20+Ci0tLQogbmV0L25ldGZpbHRlci9uZl9j
b25udHJhY2tfcHJvdG9fdGNwLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFj
a19wcm90b190Y3AuYyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvX3RjcC5jCmlu
ZGV4IDcwMzgzZGUuLjY5NzIxMGYgMTAwNjQ0Ci0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRy
YWNrX3Byb3RvX3RjcC5jCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvX3Rj
cC5jCkBAIC0xMDg4LDcgKzEwODgsNyBAQCBzdGF0aWMgaW50IHRjcF9wYWNrZXQoc3RydWN0IG5m
X2Nvbm4gKmN0LAogCQkgICAmJiAob2xkX3N0YXRlID09IFRDUF9DT05OVFJBQ0tfU1lOX1JFQ1YK
IAkJICAgICAgIHx8IG9sZF9zdGF0ZSA9PSBUQ1BfQ09OTlRSQUNLX0VTVEFCTElTSEVEKQogCQkg
ICAmJiBuZXdfc3RhdGUgPT0gVENQX0NPTk5UUkFDS19FU1RBQkxJU0hFRCkgewotCQkvKiBTZXQg
QVNTVVJFRCBpZiB3ZSBzZWUgc2VlIHZhbGlkIGFjayBpbiBFU1RBQkxJU0hFRAorCQkvKiBTZXQg
QVNTVVJFRCBpZiB3ZSBzZWUgdmFsaWQgYWNrIGluIEVTVEFCTElTSEVECiAJCSAgIGFmdGVyIFNZ
Tl9SRUNWIG9yIGEgdmFsaWQgYW5zd2VyIGZvciBhIHBpY2tlZCB1cAogCQkgICBjb25uZWN0aW9u
LiAqLwogCQlzZXRfYml0KElQU19BU1NVUkVEX0JJVCwgJmN0LT5zdGF0dXMpOwotLSAKMS44LjMu
MQoK
--001a113cdf403403cf051d2d098d--
