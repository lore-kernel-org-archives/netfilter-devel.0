From: Vineet Mehta <extreme@zayanionline.com>
Subject: ip_conntrack_tftp: added explanatory DEBUGP statements
Date: Sat, 3 Apr 2004 11:56:40 +0300 (AST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404031142250.32495-200000@sillypoint.zayanionline.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1146563692-464064345-1080982600=:32495"
Cc: netfilter devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1146563692-464064345-1080982600=:32495
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi all,

This patch makes TFTP Conntrack module (ip_conntrack_tftp.c) to understand 
more Opcodes then the previous READ/WRITE. This is then used in DEBUGP 
statements, to make output more informative.

Thanks and Regards,
Extreme

---1146563692-464064345-1080982600=:32495
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="ip_conntrack_tftp-2.4.25.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0404031156400.32495@sillypoint.zayanionline.com>
Content-Description: 
Content-Disposition: attachment; filename="ip_conntrack_tftp-2.4.25.diff"

ZGlmZiAtTnVyIHBhdGNoZWQtMi40LjI1L2luY2x1ZGUvbGludXgvbmV0Zmls
dGVyX2lwdjQvaXBfY29ubnRyYWNrX3RmdHAuaCBsaW51eC0yLjQuMjUvaW5j
bHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2NC9pcF9jb25udHJhY2tfdGZ0cC5o
DQotLS0gcGF0Y2hlZC0yLjQuMjUvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJf
aXB2NC9pcF9jb25udHJhY2tfdGZ0cC5oCTIwMDMtMDYtMTMgMTc6NTE6Mzgu
MDAwMDAwMDAwICswMzAwDQorKysgbGludXgtMi40LjI1L2luY2x1ZGUvbGlu
dXgvbmV0ZmlsdGVyX2lwdjQvaXBfY29ubnRyYWNrX3RmdHAuaAkyMDA0LTA0
LTAzIDEwOjEwOjQ2LjAwMDAwMDAwMCArMDMwMA0KQEAgLTksNSArOSw4IEBA
DQogDQogI2RlZmluZSBURlRQX09QQ09ERV9SRUFECTENCiAjZGVmaW5lIFRG
VFBfT1BDT0RFX1dSSVRFCTINCisjZGVmaW5lIFRGVFBfT1BDT0RFX0RBVEEJ
Mw0KKyNkZWZpbmUgVEZUUF9PUENPREVfQUNLCQk0DQorI2RlZmluZSBURlRQ
X09QQ09ERV9FUlJPUgk1DQogDQogI2VuZGlmIC8qIF9JUF9DVF9URlRQICov
DQpkaWZmIC1OdXIgcGF0Y2hlZC0yLjQuMjUvbmV0L2lwdjQvbmV0ZmlsdGVy
L2lwX2Nvbm50cmFja190ZnRwLmMgbGludXgtMi40LjI1L25ldC9pcHY0L25l
dGZpbHRlci9pcF9jb25udHJhY2tfdGZ0cC5jDQotLS0gcGF0Y2hlZC0yLjQu
MjUvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja190ZnRwLmMJMjAw
NC0wMi0xOCAxNjozNjozMi4wMDAwMDAwMDAgKzAzMDANCisrKyBsaW51eC0y
LjQuMjUvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja190ZnRwLmMJ
MjAwNC0wNC0wMyAxMDoxMzowOC4wMDAwMDAwMDAgKzAzMDANCkBAIC02NCw2
ICs2NCwxMyBAQA0KIAkJRFVNUF9UVVBMRSgmZXhwLm1hc2spOw0KIAkJaXBf
Y29ubnRyYWNrX2V4cGVjdF9yZWxhdGVkKGN0LCAmZXhwKTsNCiAJCWJyZWFr
Ow0KKwljYXNlIFRGVFBfT1BDT0RFX0RBVEE6DQorCWNhc2UgVEZUUF9PUENP
REVfQUNLOg0KKwkJREVCVUdQKCJEYXRhL0FDSyBvcGNvZGVcbiIpOw0KKwkJ
YnJlYWs7DQorCWNhc2UgVEZUUF9PUENPREVfRVJST1I6DQorCQlERUJVR1Ao
IkVycm9yIG9wY29kZVxuIik7DQorCQlicmVhazsNCiAJZGVmYXVsdDoNCiAJ
CURFQlVHUCgiVW5rbm93biBvcGNvZGVcbiIpOw0KIAl9DQo=
---1146563692-464064345-1080982600=:32495--
