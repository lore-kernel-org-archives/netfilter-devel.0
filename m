From: Patrick McHardy <kaber@trash.net>
Subject: 76_conntrack_bucket_sysctl.patch
Date: Thu, 27 Nov 2003 06:35:49 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0311270631070.1622@gw.localnet>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811840-865722848-1069911349=:1622"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
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

---1463811840-865722848-1069911349=:1622
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi Harald,

I just had a look at 76_conntrack_bucket_sysctl.patch, it adds an
unneccessary strategy routine. The file permission check is done before
the strategy is called so that alone should be fine. In fact, I didn't
even manage to get it called at all. The attached patch is tested and
works.

Best regards,
Patrick
---1463811840-865722848-1069911349=:1622
Content-Type: TEXT/plain; charset=US-ASCII; name="sysctl.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0311270635490.1622@gw.localnet>
Content-Description: 
Content-Disposition: attachment; filename="sysctl.diff"

PT09PT0gbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja19zdGFuZGFs
b25lLmMgMS4yMiB2cyBlZGl0ZWQgPT09PT0NCi0tLSAxLjIyL25ldC9pcHY0
L25ldGZpbHRlci9pcF9jb25udHJhY2tfc3RhbmRhbG9uZS5jCUZyaSBPY3Qg
IDMgMDg6MjE6MTkgMjAwMw0KKysrIGVkaXRlZC9uZXQvaXB2NC9uZXRmaWx0
ZXIvaXBfY29ubnRyYWNrX3N0YW5kYWxvbmUuYwlUaHUgTm92IDI3IDA2OjI4
OjU5IDIwMDMNCkBAIC0yNjYsNiArMjY2LDcgQEANCiANCiAvKiBGcm9tIGlw
X2Nvbm50cmFja19jb3JlLmMgKi8NCiBleHRlcm4gaW50IGlwX2Nvbm50cmFj
a19tYXg7DQorZXh0ZXJuIHVuc2lnbmVkIGludCBpcF9jb25udHJhY2tfaHRh
YmxlX3NpemU7DQogDQogLyogRnJvbSBpcF9jb25udHJhY2tfcHJvdG9fdGNw
LmMgKi8NCiBleHRlcm4gdW5zaWduZWQgbG9uZyBpcF9jdF90Y3BfdGltZW91
dF9zeW5fc2VudDsNCkBAIC0yOTIsNiArMjkzLDkgQEANCiBzdGF0aWMgY3Rs
X3RhYmxlIGlwX2N0X3N5c2N0bF90YWJsZVtdID0gew0KIAl7TkVUX0lQVjRf
TkZfQ09OTlRSQUNLX01BWCwgImlwX2Nvbm50cmFja19tYXgiLA0KIAkgJmlw
X2Nvbm50cmFja19tYXgsIHNpemVvZihpbnQpLCAwNjQ0LCBOVUxMLA0KKwkg
JnByb2NfZG9pbnR2ZWN9LA0KKwl7TkVUX0lQVjRfTkZfQ09OTlRSQUNLX0JV
Q0tFVFMsICJpcF9jb25udHJhY2tfYnVja2V0cyIsDQorCSAmaXBfY29ubnRy
YWNrX2h0YWJsZV9zaXplLCBzaXplb2YodW5zaWduZWQgaW50KSwgMDQ0NCwg
TlVMTCwNCiAJICZwcm9jX2RvaW50dmVjfSwNCiAJe05FVF9JUFY0X05GX0NP
Tk5UUkFDS19UQ1BfVElNRU9VVF9TWU5fU0VOVCwgImlwX2Nvbm50cmFja190
Y3BfdGltZW91dF9zeW5fc2VudCIsDQogCSAmaXBfY3RfdGNwX3RpbWVvdXRf
c3luX3NlbnQsIHNpemVvZih1bnNpZ25lZCBpbnQpLCAwNjQ0LCBOVUxMLA0K
PT09PT0gaW5jbHVkZS9saW51eC9zeXNjdGwuaCAxLjUzIHZzIGVkaXRlZCA9
PT09PQ0KLS0tIDEuNTMvaW5jbHVkZS9saW51eC9zeXNjdGwuaAlXZWQgT2N0
IDI5IDIxOjE5OjMwIDIwMDMNCisrKyBlZGl0ZWQvaW5jbHVkZS9saW51eC9z
eXNjdGwuaAlUaHUgTm92IDI3IDA2OjA4OjA0IDIwMDMNCkBAIC0zNzYsNiAr
Mzc2LDcgQEANCiAJTkVUX0lQVjRfTkZfQ09OTlRSQUNLX1VEUF9USU1FT1VU
X1NUUkVBTT0xMSwNCiAJTkVUX0lQVjRfTkZfQ09OTlRSQUNLX0lDTVBfVElN
RU9VVD0xMiwNCiAJTkVUX0lQVjRfTkZfQ09OTlRSQUNLX0dFTkVSSUNfVElN
RU9VVD0xMywNCisJTkVUX0lQVjRfTkZfQ09OTlRSQUNLX0JVQ0tFVFM9MTQs
DQogfTsNCiAgDQogLyogL3Byb2Mvc3lzL25ldC9pcHY2ICovDQo=

---1463811840-865722848-1069911349=:1622--
