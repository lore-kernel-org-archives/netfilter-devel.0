From: Maik Hentsche <netfilter@mm-double.de>
Subject: [PATCH] libnfnetlink
Date: Fri, 29 Sep 2006 14:10:18 +0200
Message-ID: <1159531818.451d0d2a31b47@www.domainfactory-webmail.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="-MOQ1159531818107c0d0974313647ddbf002600a6e33c"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
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

This message is in MIME format.

---MOQ1159531818107c0d0974313647ddbf002600a6e33c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hello Pablo, hello readers of the list,
I found another bug in libnfnetlink. The comment of nfnl_recv states, in
case of success 0 is returned. In fact at success the returnvalue of
recvfrom is returned, which is the number of received bytes
(libnfnetlink_recv_comment.patch). The second issue is a little more
serious. The comment states, in case of an error, errno is set when in
fact it is not. I appended a patch for two occurences, but I since I
don't know, in which case addrlen might be != sizeof(peer) and what
peer.nl_pid means (and therefore why it is a problem, if it's not 0)
two error cases without appropriate errno value still exist.

so long
Maik

---MOQ1159531818107c0d0974313647ddbf002600a6e33c
Content-Type: text/x-patch; name="libnfnetlink_recv_errno.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="libnfnetlink_recv_errno.patch"

ZGlmZiAtVSAzIC1iIC1CIC1kIC1pIC1yIC1OIC14IC5zdm4gLS0gbGlibmZuZXRsaW5rLTAuMC4x
Ni1wYWJsby1yMS9zcmMvbGlibmZuZXRsaW5rLmMgbGlibmZuZXRsaW5rLTAuMC4xNi1wYWJsby1y
MS5uZXcvc3JjL2xpYm5mbmV0bGluay5jCi0tLSBsaWJuZm5ldGxpbmstMC4wLjE2LXBhYmxvLXIx
L3NyYy9saWJuZm5ldGxpbmsuYwkyMDA2LTA5LTI2IDEwOjAwOjEyLjAwMDAwMDAwMCArMDIwMAor
KysgbGlibmZuZXRsaW5rLTAuMC4xNi1wYWJsby1yMS5uZXcvc3JjL2xpYm5mbmV0bGluay5jCTIw
MDYtMDktMjkgMDk6NTA6NDQuMDAwMDAwMDAwICswMjAwCkBAIC00NjIsOCArNDYyLDEwIEBACiAJ
YXNzZXJ0KGxlbiA+IDApOwogCQogCWlmIChsZW4gPCBzaXplb2Yoc3RydWN0IG5sbXNnZXJyKQot
CSAgICB8fCBsZW4gPCBzaXplb2Yoc3RydWN0IG5sbXNnaGRyKSkKKwkgICAgfHwgbGVuIDwgc2l6
ZW9mKHN0cnVjdCBubG1zZ2hkcikpeworCQllcnJubyA9IEVOT0JVRlM7CiAJCXJldHVybiAtMTsg
CisJfQogCiAJYWRkcmxlbiA9IHNpemVvZihoLT5wZWVyKTsKIAlzdGF0dXMgPSByZWN2ZnJvbSho
LT5mZCwgYnVmLCBsZW4sIDAsIChzdHJ1Y3Qgc29ja2FkZHIgKikmcGVlciwJCkBAIC00NzgsOCAr
NDgwLDEwIEBACiAJCXJldHVybiAtMTsKIAogCW5saCA9IChzdHJ1Y3Qgbmxtc2doZHIgKilidWY7
Ci0JaWYgKG5saC0+bmxtc2dfZmxhZ3MgJiBNU0dfVFJVTkMgfHwgc3RhdHVzID4gbGVuKQorCWlm
IChubGgtPm5sbXNnX2ZsYWdzICYgTVNHX1RSVU5DIHx8IHN0YXR1cyA+IGxlbil7CisJCWVycm5v
ID0gRU5PQlVGUzsKIAkJcmV0dXJuIC0xOworCX0KIAogCXJldHVybiBzdGF0dXM7CiB9Cg==

---MOQ1159531818107c0d0974313647ddbf002600a6e33c
Content-Type: text/x-patch; name="libnfnetlink_recv_comment.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="libnfnetlink_recv_comment.patch"

ZGlmZiAtVSAzIC1iIC1CIC1kIC1pIC1yIC1OIC14IC5zdm4gLS0gbGlibmZuZXRsaW5rLTAuMC4x
Ni1wYWJsby1yMS9zcmMvbGlibmZuZXRsaW5rLmMgbGlibmZuZXRsaW5rLTAuMC4xNi1wYWJsby1y
MS5uZXcvc3JjL2xpYm5mbmV0bGluay5jCi0tLSBsaWJuZm5ldGxpbmstMC4wLjE2LXBhYmxvLXIx
L3NyYy9saWJuZm5ldGxpbmsuYwkyMDA2LTA5LTI5IDA5OjU0OjI3LjAwMDAwMDAwMCArMDIwMAor
KysgbGlibmZuZXRsaW5rLTAuMC4xNi1wYWJsby1yMS5uZXcvc3JjL2xpYm5mbmV0bGluay5jCTIw
MDYtMDktMjkgMTA6MTc6MTEuMDAwMDAwMDAwICswMjAwCkBAIC00NDMsOCArNDQzLDggQEAKICAq
IHRoYXQgdGhlIGRhdGEgaXMgd2VsbC1mb3JtZWQuIFN1Y2ggY2hlY2tpbmdzIGFyZSBkb25lIGJ5
IHRoZSBwYXJzaW5nCiAgKiBmdW5jdGlvbnMuCiAgKgotICogT24gc3VjY2VzcywgMCBpcyByZXR1
cm5lZC4gT24gZXJyb3IsIC0xIGlzIHJldHVybmVkIGFuZCBlcnJubyBpcyBzZXQKLSAqIGFwcHJv
cGlhdGVseS4KKyAqIE9uIHN1Y2Nlc3MsIHRoZSBudW1iZXIgb2YgYnl0ZXMgcmVjZWl2ZWQgaXMg
cmV0dXJuZWQuIE9uIGVycm9yLCAtMSBpcworICogcmV0dXJuZWQgYW5kIGVycm5vIGlzIHNldCBh
cHByb3BpYXRlbHkuCiAgKgogICogTm90ZSB0aGF0IEVOT0JVRlMgaXMgcmV0dXJuZWQgaW4gY2Fz
ZSB0aGF0IG5mbmV0bGluayBpcyBleGhhdXN0ZWQuIEluCiAgKiB0aGF0IGNhc2UgaXMgcG9zc2li
bGUgdGhhdCB0aGUgaW5mb3JtYXRpb24gcmVxdWVzdGVkIGlzIGluY29tcGxldGUuCg==

---MOQ1159531818107c0d0974313647ddbf002600a6e33c--
