From: Henrik Nordstrom <hno@marasystems.com>
Subject: dstlimit patch broken if CONFIG_NETFILTER_DEBUG
Date: Sat, 10 Jan 2004 14:47:49 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401101419300.5897-200000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-71219980-1073742469=:5897"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

---1463811839-71219980-1073742469=:5897
Content-Type: TEXT/PLAIN; charset=US-ASCII

The dstlimit uses MUST_BE_LOCKED macro on a directly spinlock_t, while
this macro requires the lock to be defined by DECLARE_LOCK().

Not sure how to best correct this in a clean manner, but I guess one could
add netfilter macros for struct based locks and manual lock
initialization.

The attached patch makes ipt_dstlimit.c compile if CONFIG_NETFILTER_DEBUG 
by adding manual #ifdef to set up the lock in a way matching what it done 
in lockhelp.h, but i would be cleaner to move this to lockhelp.h.

Regards
Henrik

---1463811839-71219980-1073742469=:5897
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="ipt_dstlimit_lock.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0401101447490.5897@filer.marasystems.com>
Content-Description: 
Content-Disposition: attachment; filename="ipt_dstlimit_lock.patch"

LS0tIG5ldC9pcHY0L25ldGZpbHRlci9pcHRfZHN0bGltaXQuYy5ub3R3b3Jr
aW5nCTIwMDQtMDEtMDkgMTc6MDI6NDMuMDAwMDAwMDAwICswMTAwDQorKysg
bmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9kc3RsaW1pdC5jCTIwMDQtMDEtMTAg
MTQ6NDQ6MTMuMDAwMDAwMDAwICswMTAwDQpAQCAtNzgsNyArNzgsMTEgQEAN
CiAJc3RydWN0IGlwdF9kc3RsaW1pdF9pbmZvICptaW5mbzsgLyogcHVibGlj
IHN0cnVjdHVyZSAqLw0KIA0KIAkvKiB1c2VkIGludGVybmFsbHkgKi8NCisj
aWZkZWYgQ09ORklHX05FVEZJTFRFUl9ERUJVRw0KKwlzdHJ1Y3Qgc3Bpbmxv
Y2tfZGVidWcgbG9jazsJLyogbG9jayBmb3IgbGlzdF9oZWFkICovDQorI2Vs
c2UNCiAJc3BpbmxvY2tfdCBsb2NrOwkJLyogbG9jayBmb3IgbGlzdF9oZWFk
ICovDQorI2VuZGlmDQogCXVfaW50MzJfdCBybmQ7CQkJLyogcmFuZG9tIHNl
ZWQgZm9yIGhhc2ggKi8NCiAJc3RydWN0IHRpbWVyX2xpc3QgdGltZXI7CS8q
IHRpbWVyIGZvciBnYyAqLw0KIAlhdG9taWNfdCBjb3VudDsJCQkvKiBudW1i
ZXIgZW50cmllcyBpbiB0YWJsZSAqLw0KQEAgLTE5OSw3ICsyMDMsMTEgQEAN
CiAJYXRvbWljX3NldCgmaGluZm8tPmNvdW50LCAwKTsNCiAJaGluZm8tPnJu
ZCA9IDA7DQogDQorI2lmZGVmIENPTkZJR19ORVRGSUxURVJfREVCVUcNCisJ
aGluZm8tPmxvY2sgPSAoc3RydWN0IHNwaW5sb2NrX2RlYnVnKXsgU1BJTl9M
T0NLX1VOTE9DS0VELCBBVE9NSUNfSU5JVCgtMSkgfTsNCisjZWxzZQ0KIAlo
aW5mby0+bG9jayA9IFNQSU5fTE9DS19VTkxPQ0tFRDsNCisjZW5kaWYNCiAN
CiAJaGluZm8tPnBkZSA9IGNyZWF0ZV9wcm9jX2VudHJ5KG1pbmZvLT5uYW1l
LCAwLCBkc3RsaW1pdF9wcm9jZGlyKTsNCiAJaWYgKCFoaW5mby0+cGRlKSB7
DQpAQCAtNTEzLDEwICs1MjEsMTAgQEANCiAJVU5MT0NLX0JIKCZodGFibGUt
PmxvY2spOw0KIH0NCiANCi1zdGF0aWMgaW5saW5lIGludCBkbF9zZXFfcmVh
bF9zaG93KHN0cnVjdCBkc3RoYXNoX2VudCAqZW50LCBzdHJ1Y3Qgc2VxX2Zp
bGUgKnMpDQorc3RhdGljIGlubGluZSBpbnQgZGxfc2VxX3JlYWxfc2hvdyhj
b25zdCBzdHJ1Y3QgZHN0aGFzaF9lbnQgKmVudCwgc3RydWN0IHNlcV9maWxl
ICpzKQ0KIHsNCiAJLyogcmVjYWxjdWxhdGUgdG8gc2hvdyBhY2N1cmF0ZSBu
dW1iZXJzICovDQotCXJhdGVpbmZvX3JlY2FsYyhlbnQsIGppZmZpZXMpOw0K
KwlyYXRlaW5mb19yZWNhbGMoKHN0cnVjdCBkc3RoYXNoX2VudCAqKWVudCwg
amlmZmllcyk7DQogDQogCXJldHVybiBzZXFfcHJpbnRmKHMsICIlbGQgJXUu
JXUuJXUuJXUtPiV1LiV1LiV1LiV1OiV1ICV1ICV1ICV1XG4iLA0KIAkJCShl
bnQtPmV4cGlyZXMgLSBqaWZmaWVzKS9IWiwNCg==
---1463811839-71219980-1073742469=:5897--
