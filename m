From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] ftp helper typo (espv/epsv)
Date: Fri, 10 Jan 2003 16:56:53 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0301101654540.30861@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-92571484-1042214213=:6837"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
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

---23717851-92571484-1042214213=:6837
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

this is the espv/epsv typo fix in ip_conntrack_ftp.c

regards,
Maciej Soltysiak


--- linux/net/ipv4/netfilter/ip_conntrack_ftp.c	2002-11-29 00:53:15.000000000 +0100
+++ linux.new/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-01-10 16:53:57.000000000 +0100
@@ -32,7 +32,7 @@

 static int try_rfc959(const char *, size_t, u_int32_t [], char);
 static int try_eprt(const char *, size_t, u_int32_t [], char);
-static int try_espv_response(const char *, size_t, u_int32_t [], char);
+static int try_epsv_response(const char *, size_t, u_int32_t [], char);

 static struct ftp_search {
 	enum ip_conntrack_dir dir;
@@ -65,7 +65,7 @@
 		IP_CT_DIR_REPLY,
 		"229 ", sizeof("229 ") - 1, '(', ')',
 		IP_CT_FTP_EPSV,
-		try_espv_response,
+		try_epsv_response,
 	},
 };

@@ -157,7 +157,7 @@
 }

 /* Returns 0, or length of numbers: |||6446| */
-static int try_espv_response(const char *data, size_t dlen, u_int32_t array[6],
+static int try_epsv_response(const char *data, size_t dlen, u_int32_t array[6],
 			     char term)
 {
 	char delim;

---23717851-92571484-1042214213=:6837
Content-Type: TEXT/plain; name="ip_conntrack_ftp.c.typo.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0301101656530.6837@dns.toxicfilms.tv>
Content-Description: espv/epsv typo
Content-Disposition: attachment; filename="ip_conntrack_ftp.c.typo.diff"

LS0tIGxpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfZnRw
LmMJMjAwMi0xMS0yOSAwMDo1MzoxNS4wMDAwMDAwMDAgKzAxMDANCisrKyBs
aW51eC5uZXcvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja19mdHAu
YwkyMDAzLTAxLTEwIDE2OjUzOjU3LjAwMDAwMDAwMCArMDEwMA0KQEAgLTMy
LDcgKzMyLDcgQEANCiANCiBzdGF0aWMgaW50IHRyeV9yZmM5NTkoY29uc3Qg
Y2hhciAqLCBzaXplX3QsIHVfaW50MzJfdCBbXSwgY2hhcik7DQogc3RhdGlj
IGludCB0cnlfZXBydChjb25zdCBjaGFyICosIHNpemVfdCwgdV9pbnQzMl90
IFtdLCBjaGFyKTsNCi1zdGF0aWMgaW50IHRyeV9lc3B2X3Jlc3BvbnNlKGNv
bnN0IGNoYXIgKiwgc2l6ZV90LCB1X2ludDMyX3QgW10sIGNoYXIpOw0KK3N0
YXRpYyBpbnQgdHJ5X2Vwc3ZfcmVzcG9uc2UoY29uc3QgY2hhciAqLCBzaXpl
X3QsIHVfaW50MzJfdCBbXSwgY2hhcik7DQogDQogc3RhdGljIHN0cnVjdCBm
dHBfc2VhcmNoIHsNCiAJZW51bSBpcF9jb25udHJhY2tfZGlyIGRpcjsNCkBA
IC02NSw3ICs2NSw3IEBADQogCQlJUF9DVF9ESVJfUkVQTFksDQogCQkiMjI5
ICIsIHNpemVvZigiMjI5ICIpIC0gMSwgJygnLCAnKScsDQogCQlJUF9DVF9G
VFBfRVBTViwNCi0JCXRyeV9lc3B2X3Jlc3BvbnNlLA0KKwkJdHJ5X2Vwc3Zf
cmVzcG9uc2UsDQogCX0sDQogfTsNCiANCkBAIC0xNTcsNyArMTU3LDcgQEAN
CiB9DQogDQogLyogUmV0dXJucyAwLCBvciBsZW5ndGggb2YgbnVtYmVyczog
fHx8NjQ0NnwgKi8NCi1zdGF0aWMgaW50IHRyeV9lc3B2X3Jlc3BvbnNlKGNv
bnN0IGNoYXIgKmRhdGEsIHNpemVfdCBkbGVuLCB1X2ludDMyX3QgYXJyYXlb
Nl0sDQorc3RhdGljIGludCB0cnlfZXBzdl9yZXNwb25zZShjb25zdCBjaGFy
ICpkYXRhLCBzaXplX3QgZGxlbiwgdV9pbnQzMl90IGFycmF5WzZdLA0KIAkJ
CSAgICAgY2hhciB0ZXJtKQ0KIHsNCiAJY2hhciBkZWxpbTsNCg==

---23717851-92571484-1042214213=:6837--
