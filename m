From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [Resend] OSF update: netlink logging
Date: Sat, 31 Jan 2004 15:47:25 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040131154725.5a6a82be.johnpol@2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sat__31_Jan_2004_15_47_25_+0300_Jd+Y7UrznRz5G6fq"
Cc: netfilter-devel@lists.netfilter.org
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

This is a multi-part message in MIME format.

--Multipart=_Sat__31_Jan_2004_15_47_25_+0300_Jd+Y7UrznRz5G6fq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello, Harald.
Hello, all.

This patches add possibility to log OSF events through netlink.
I've stolen NETLINK_NFLOG and mcast group 1 in OSF module from ULOG,
so you can't use ipt_ULOG and ipt_osf at the same time(or you will catch
some unusal events in ulogd/osfd).
Patchset also adds missing diffs for

Some "smart" hardware/software changes MSS while doing NAT/DSL, so
make additional compare with "good" MSS value(predefined 1460).
Kudos to Michal Zalewski and Mike Frantzen.

Whitespace cleanup.

Packets from outside(loopback is outside too) may have equal to
fingerprint ttl, not necessarily lesser.
 
If we have timestamp option, do not compare it with one from
fingerprint.
(For now it is always 0).

ip->ttl must be less than finger's ttl if fingerprint is valid.

and probably others.

Patchset is against latest pom-ng and userspace.
Please test and apply.

For testing i also attach trivial osfd.c.


	Evgeniy Polyakov ( s0mbre )

Only failure makes us experts. -- Theo de Raadt

--Multipart=_Sat__31_Jan_2004_15_47_25_+0300_Jd+Y7UrznRz5G6fq
Content-Type: text/plain;
 name="pom-ng-help.diff"
Content-Disposition: attachment;
 filename="pom-ng-help.diff"
Content-Transfer-Encoding: 7bit

--- patch-o-matic-ng/osf/help	20 Dec 2003 16:19:18 -0000	1.2
+++ patch-o-matic-ng/osf/help	31 Jan 2004 12:32:53 -0000
@@ -3,25 +3,15 @@
 Original idea was lurked in some OpenBSD mailing list (thanks
 grange@open...) and than adopted for Linux netfilter in form of this code.
 
-Original table was created by Michal Zalewski <lcamtuf@coredump.cx> for
-his excellent p0f and than changed a bit for more convenience.
+Original fingerprint table was created by Michal Zalewski <lcamtuf@coredump.cx>.
 
 This module compares some data(WS, MSS, options and it's order, ttl,
 df and others) from first SYN packet (actually from packets with SYN
-bit set) with hardcoded in fingers[] table ones.
+bit set) with dinamically loaded OS fingerprints.
 
-Example: (Of course this only an example, do not get inspired by this)
-
-# iptables -N LINUX
-# iptables -A LINUX -j LOG --log-prefix "Linux"
-
-# iptables -A INPUT -p tcp -m osf --genre Linux -j LINUX
-# iptables -A INPUT -p tcp -m osf --genre FreeBSD -j REJECT
-
-NOTE: -p tcp is obviously required as it is a TCP match.
 
 OSF also has:
---log 1/0. 
+  --log 1/0. 
 	If present, OSF will log determined genres even if they don't match
 	desired one.	
 	0 - log all determined entries, 
@@ -29,16 +19,23 @@
 	
 	Example:
 	#iptables -I INPUT -j ACCEPT -p tcp -m osf --genre Linux --log 1 --smart
+	NOTE: -p tcp is obviously required as it is a TCP match.
 
 	In syslog you find something like this:
-	ipt_osf: Windows [Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 -> 11.22.33.44:139
+	ipt_osf: Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 -> 11.22.33.44:139
 	ipt_osf: Unknown: 16384:106:1:48:020405B401010402 44.33.22.11:1239 -> 11.22.33.44:80
 
   --smart
   	if present, OSF will use some smartness to determine remote OS.
-	Now only not use TTL( with it far remote machines can be determined).
+	OSF will use initial TTL only if source of connection is in our local network.
+  
+  --netlink
+	If present, OSF will log all events also through netlink NETLINK_NFLOG groupt 1.
+
+Fingerprints can be loaded and read through /proc/sys/net/ipv4/osf file.
+One can flush all fingerprints with following command:
+echo -en FLUSH > /proc/sys/net/ipv4/osf
 
-Fingerprints can be loaded through /proc/sys/net/ipv4/osf file.
-Only one fingerprint per open/close.
+Only one fingerprint per open/write/close.
 
 Fingerprints can be downloaded from http://www.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os

--Multipart=_Sat__31_Jan_2004_15_47_25_+0300_Jd+Y7UrznRz5G6fq
Content-Type: application/octet-stream;
 name="pom-ng-ipt_osf.diff.1"
Content-Disposition: attachment;
 filename="pom-ng-ipt_osf.diff.1"
Content-Transfer-Encoding: base64

LS0tIHBhdGNoLW8tbWF0aWMtbmcvb3NmL2xpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcHRfb3Nm
LmMJVGh1IERlYyAxOCAyMTo1NjowMyAyMDAzCisrKyBwYXRjaC1vLW1hdGljLW5nL29zZi9saW51
eC9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X29zZi5jCUZyaSBKYW4gMTYgMTc6NTY6NDMgMjAwNApA
QCAtMzAsNiArMzAsOCBAQAogCiAjaW5jbHVkZSA8bGludXgvY29uZmlnLmg+CiAjaW5jbHVkZSA8
bGludXgva2VybmVsLmg+CisjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlIDxsaW51
eC9zdHJpbmcuaD4KICNpbmNsdWRlIDxsaW51eC9zbXAuaD4KICNpbmNsdWRlIDxsaW51eC9tb2R1
bGUuaD4KICNpbmNsdWRlIDxsaW51eC9za2J1ZmYuaD4KQEAgLTQxLDEzICs0MywxNCBAQAogI2lu
Y2x1ZGUgPGxpbnV4L3NwaW5sb2NrLmg+CiAjaW5jbHVkZSA8bGludXgvY3R5cGUuaD4KICNpbmNs
dWRlIDxsaW51eC9saXN0Lmg+CisjaW5jbHVkZSA8bGludXgvaWYuaD4KIAogI2luY2x1ZGUgPG5l
dC9zb2NrLmg+CiAjaW5jbHVkZSA8bmV0L2lwLmg+CiAKICNpbmNsdWRlIDxsaW51eC9uZXRmaWx0
ZXJfaXB2NC9pcF90YWJsZXMuaD4KIAotI2luY2x1ZGUgPGxpbnV4L25ldGZpbHRlcl9pcHY0L2lw
dF9vc2YuaD4KKyNpbmNsdWRlIDxsaW51eC9uZXRmaWx0ZXJfaXB2NC9pcHRfb3NmLmg+CiAKICNk
ZWZpbmUgT1NGX0RFQlVHCiAKQEAgLTcwLDEyICs3MywxNiBAQAogCiBzdGF0aWMgcndsb2NrX3Qg
b3NmX2xvY2sgPSBSV19MT0NLX1VOTE9DS0VEOwogc3RhdGljIHN0cnVjdCBsaXN0X2hlYWQJZmlu
Z2VyX2xpc3Q7CQotCiBzdGF0aWMgaW50IG1hdGNoKGNvbnN0IHN0cnVjdCBza19idWZmICosIGNv
bnN0IHN0cnVjdCBuZXRfZGV2aWNlICosIGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlICosCi0JCSAg
ICAgIGNvbnN0IHZvaWQgKiwgaW50LCBjb25zdCB2b2lkICosIHVfaW50MTZfdCwgaW50ICopOwor
CQkgICAgICBjb25zdCB2b2lkICosIGludCwgCisJCSAgICAgIGNvbnN0IHZvaWQgKiwgdV9pbnQx
Nl90LCAKKwkJICAgICAgaW50ICopOwogc3RhdGljIGludCBjaGVja2VudHJ5KGNvbnN0IGNoYXIg
KiwgY29uc3Qgc3RydWN0IGlwdF9pcCAqLCB2b2lkICosCiAJCSAgICAgICAgICAgdW5zaWduZWQg
aW50LCB1bnNpZ25lZCBpbnQpOwogCitzdGF0aWMgdW5zaWduZWQgbG9uZyBzZXEsIGlwdF9vc2Zf
Z3JvdXBzID0gMTsKK3N0YXRpYyBzdHJ1Y3Qgc29jayAqbnRzOworCiBzdGF0aWMgc3RydWN0IGlw
dF9tYXRjaCBvc2ZfbWF0Y2ggPSAKIHsgCiAJeyBOVUxMLCBOVUxMIH0sIApAQCAtODYsMTIgKzkz
LDYwIEBACiAJVEhJU19NT0RVTEUgCiB9OwogCi1zdGF0aWMgaW5saW5lIGludCBzbWFydF9kZWMo
dW5zaWduZWQgbG9uZyBmbGFncywgdW5zaWduZWQgY2hhciBpcF90dGwsIHVuc2lnbmVkIGNoYXIg
Zl90dGwpCitzdGF0aWMgdm9pZCBpcHRfb3NmX25sc2VuZChzdHJ1Y3Qgb3NmX2ZpbmdlciAqZiwg
Y29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrKQoreworCXVuc2lnbmVkIGludCBzaXplOworCXN0cnVj
dCBza19idWZmICpza2I7CisJc3RydWN0IGlwdF9vc2Zfbmxtc2cgKmRhdGE7CisJc3RydWN0IG5s
bXNnaGRyICpubGg7CisKKwlzaXplID0gTkxNU0dfU1BBQ0Uoc2l6ZW9mKHN0cnVjdCBpcHRfb3Nm
X25sbXNnKSk7CisKKwlza2IgPSBhbGxvY19za2Ioc2l6ZSwgR0ZQX0FUT01JQyk7CisJaWYgKCFz
a2IpCisJeworCQlsb2coInNrYl9hbGxvYygpIGZhaWxlZC5cbiIpOworCQlyZXR1cm47CisJfQor
CQorCW5saCA9IE5MTVNHX1BVVChza2IsIDAsIHNlcSsrLCBOTE1TR19ET05FLCBzaXplIC0gc2l6
ZW9mKCpubGgpKTsKKwkKKwlkYXRhID0gKHN0cnVjdCBpcHRfb3NmX25sbXNnICopTkxNU0dfREFU
QShubGgpOworCisJbWVtY3B5KCZkYXRhLT5mLCBmLCBzaXplb2Yoc3RydWN0IG9zZl9maW5nZXIp
KTsKKwltZW1jcHkoJmRhdGEtPmlwLCBza2ItPm5oLmlwaCwgc2l6ZW9mKHN0cnVjdCBpcGhkcikp
OworCW1lbWNweSgmZGF0YS0+dGNwLCAoc3RydWN0IHRjcGhkciAqKSgodV9pbnQzMl90ICopc2ti
LT5uaC5pcGggKyBza2ItPm5oLmlwaC0+aWhsKSwgc2l6ZW9mKHN0cnVjdCB0Y3BoZHIpKTsKKwkK
KwlORVRMSU5LX0NCKHNrYikuZHN0X2dyb3VwcyA9IGlwdF9vc2ZfZ3JvdXBzOworCW5ldGxpbmtf
YnJvYWRjYXN0KG50cywgc2tiLCAwLCBpcHRfb3NmX2dyb3VwcywgR0ZQX0FUT01JQyk7CisKK25s
bXNnX2ZhaWx1cmU6CisJcmV0dXJuOworfQorCitzdGF0aWMgaW5saW5lIGludCBzbWFydF9kZWMo
Y29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwgdW5zaWduZWQgbG9uZyBmbGFncywgdW5zaWduZWQg
Y2hhciBmX3R0bCkKIHsKKwlzdHJ1Y3QgaXBoZHIgKmlwID0gc2tiLT5uaC5pcGg7CisKIAlpZiAo
ZmxhZ3MgJiBJUFRfT1NGX1NNQVJUKQotCQlyZXR1cm4gMTsKKwl7CisJCXN0cnVjdCBpbl9kZXZp
Y2UgKmluX2RldiA9IGluX2Rldl9nZXQoc2tiLT5kZXYpOworCisJCWZvcl9pZmEoaW5fZGV2KQor
CQl7CisJCQlpZiAoaW5ldF9pZmFfbWF0Y2goaXAtPnNhZGRyLCBpZmEpKQorCQkJeworCQkJCWlu
X2Rldl9wdXQoaW5fZGV2KTsKKwkJCQlyZXR1cm4gKGlwLT50dGwgPT0gZl90dGwpOworCQkJfQor
CQl9CisJCWVuZGZvcl9pZmEoaW5fZGV2KTsKKwkJCisJCWluX2Rldl9wdXQoaW5fZGV2KTsKKwkJ
cmV0dXJuIChpcC0+dHRsIDw9IGZfdHRsKTsKKwl9CiAJZWxzZQotCQlyZXR1cm4gKGlwX3R0bCA9
PSBmX3R0bCk7CisJCXJldHVybiAoaXAtPnR0bCA9PSBmX3R0bCk7CiB9CiAKIHN0YXRpYyBpbnQK
QEAgLTE1MSw3ICsyMDYsNyBAQAogCQlmbWF0Y2ggPSBGTUFUQ0hfV1JPTkc7CiAKIAkJaWYgKHRv
dGxlbiA9PSBmLT5zcyAmJiBkZiA9PSBmLT5kZiAmJiAKLQkJCXNtYXJ0X2RlYyhpbmZvLT5mbGFn
cywgaXAtPnR0bCwgZi0+dHRsKSkKKwkJCXNtYXJ0X2RlYyhza2IsIGluZm8tPmZsYWdzLCBmLT50
dGwpKQogCQl7CiAJCQl1bnNpZ25lZCBsb25nIGZvcHRzaXplOwogCQkJaW50IG9wdG51bTsKQEAg
LTE5NywzMiArMjUyLDU3IEBACiAKIAkJCWZvciAob3B0bnVtPTA7IG9wdG51bTxmLT5vcHRfbnVt
OyArK29wdG51bSkKIAkJCXsKLQkJCQlpZiAoZi0+b3B0W29wdG51bV0ua2luZCA9PSAoKm9wdHAp
KQorCQkJCWlmIChmLT5vcHRbb3B0bnVtXS5raW5kID09ICgqb3B0cCkpIAogCQkJCXsKIAkJCQkJ
dW5zaWduZWQgY2hhciBsZW4gPSBmLT5vcHRbb3B0bnVtXS5sZW5ndGg7CiAJCQkJCXVuc2lnbmVk
IGNoYXIgKm9wdGVuZCA9IG9wdHAgKyBsZW47CisJCQkJCWludCBsb29wX2NvbnQgPSAwOwogCiAJ
CQkJCWZtYXRjaCA9IEZNQVRDSF9PSzsKIAotCQkJCQlpZiAoKm9wdHAgPT0gT1NGT1BUX01TUykg
LyogTVNTICovCi0JCQkJCQltc3MgPSBudG9ocygqKHVuc2lnbmVkIHNob3J0ICopKG9wdHArMikp
OworCisJCQkJCXN3aXRjaCAoKm9wdHApCisJCQkJCXsKKwkJCQkJCWNhc2UgT1NGT1BUX01TUzoK
KwkJCQkJCQltc3MgPSBudG9ocygqKHVuc2lnbmVkIHNob3J0ICopKG9wdHArMikpOworCQkJCQkJ
CWJyZWFrOworCQkJCQkJY2FzZSBPU0ZPUFRfVFM6CisJCQkJCQkJbG9vcF9jb250ID0gMTsKKwkJ
CQkJCQlicmVhazsKKwkJCQkJfQorCQkJCQkKKwkJCQkJaWYgKGxvb3BfY29udCkKKwkJCQkJewor
CQkJCQkJb3B0cCA9IG9wdGVuZDsKKwkJCQkJCWNvbnRpbnVlOworCQkJCQl9CiAJCQkJCQogCQkJ
CQlpZiAobGVuICE9IDEpCiAJCQkJCXsKIAkJCQkJCS8qIFNraXAga2luZCBhbmQgbGVuZ3RoIGZp
ZWxkcyovCiAJCQkJCQlvcHRwICs9IDI7IAogCi0JCQkJCQlpZiAoZi0+b3B0W29wdG51bV0ud2Mu
d2MgIT0gMCkKKwkJCQkJCWlmIChmLT5vcHRbb3B0bnVtXS53Yy52YWwgIT0gMCkKIAkJCQkJCXsK
IAkJCQkJCQl1bnNpZ25lZCBsb25nIHRtcCA9IDA7CiAJCQkJCQkJCiAJCQkJCQkJLyogSG1tbS4u
LiBJdCBsb29rcyBhIGJpdCB1Z2x5LiA6KSAqLwotCQkJCQkJCW1lbWNweSgmdG1wLCAmZi0+b3B0
W29wdG51bV0ud2MudmFsLCAKKwkJCQkJCQltZW1jcHkoJnRtcCwgb3B0cCwgCiAJCQkJCQkJCShs
ZW4gPiBzaXplb2YodW5zaWduZWQgbG9uZyk/CiAJCQkJCQkJCSAJc2l6ZW9mKHVuc2lnbmVkIGxv
bmcpOmxlbikpOwotCi0JCQkJCQkJdG1wID0gbnRvaGwodG1wKTsKLQkJCQkJCQlpZiAodG1wICE9
IGYtPm9wdFtvcHRudW1dLndjLnZhbCkKKwkJCQkJCQkvKiAyICsgMjogb3B0bGVuKDIgYnl0ZXMp
ICsgCisJCQkJCQkJICogCWtpbmQoMSBieXRlKSArIGxlbmd0aCgxIGJ5dGUpICovCisJCQkJCQkJ
aWYgKGxlbiA9PSA0KSAKKwkJCQkJCQkJdG1wID0gbnRvaHModG1wKTsKKwkJCQkJCQllbHNlCisJ
CQkJCQkJCXRtcCA9IG50b2hsKHRtcCk7CisKKwkJCQkJCQlpZiAoZi0+b3B0W29wdG51bV0ud2Mu
d2MgPT0gJyUnKQorCQkJCQkJCXsKKwkJCQkJCQkJaWYgKCh0bXAgJSBmLT5vcHRbb3B0bnVtXS53
Yy52YWwpICE9IDApCisJCQkJCQkJCQlmbWF0Y2ggPSBGTUFUQ0hfT1BUX1dST05HOworCQkJCQkJ
CX0KKwkJCQkJCQllbHNlIGlmICh0bXAgIT0gZi0+b3B0W29wdG51bV0ud2MudmFsKQogCQkJCQkJ
CQlmbWF0Y2ggPSBGTUFUQ0hfT1BUX1dST05HOwogCQkJCQkJfQogCQkJCQl9CkBAIC0yNDMsMTkg
KzMyMywyMyBAQAogCQkJCXN3aXRjaCAoY2hlY2tfV1NTKQogCQkJCXsKIAkJCQkJY2FzZSAwOgot
CQkJCQkJaWYgKHdpbmRvdyA9PSBmLT53c3MudmFsKQorCQkJCQkJaWYgKGYtPndzcy52YWwgPT0g
MCB8fCB3aW5kb3cgPT0gZi0+d3NzLnZhbCkKIAkJCQkJCQlmbWF0Y2ggPSBGTUFUQ0hfT0s7CiAJ
CQkJCQlicmVhazsKIAkJCQkJY2FzZSAxOiAvKiBNU1MgKi8KLQkJCQkJCWlmICh3aW5kb3cgPT0g
Zi0+d3NzLnZhbCptc3MpCisvKiBMdXJrZWQgaW4gT3BlbkJTRCAqLworI2RlZmluZSBTTUFSVF9N
U1MJMTQ2MAorCQkJCQkJaWYgKHdpbmRvdyA9PSBmLT53c3MudmFsKm1zcyB8fCAKKwkJCQkJCQl3
aW5kb3cgPT0gZi0+d3NzLnZhbCpTTUFSVF9NU1MpCiAJCQkJCQkJZm1hdGNoID0gRk1BVENIX09L
OwogCQkJCQkJYnJlYWs7CiAJCQkJCWNhc2UgMjogLyogTVRVICovCi0JCQkJCQlpZiAod2luZG93
ID09IGYtPndzcy52YWwqKG1zcys0MCkpCisJCQkJCQlpZiAod2luZG93ID09IGYtPndzcy52YWwq
KG1zcys0MCkgfHwKKwkJCQkJCQl3aW5kb3cgPT0gZi0+d3NzLnZhbCooU01BUlRfTVNTKzQwKSkK
IAkJCQkJCQlmbWF0Y2ggPSBGTUFUQ0hfT0s7CiAJCQkJCQlicmVhazsKIAkJCQkJY2FzZSAzOiAv
KiBNT0QgKi8KLQkJCQkJCWlmICh3aW5kb3cgJSBmLT53c3MudmFsID09IDApCisJCQkJCQlpZiAo
KHdpbmRvdyAlIGYtPndzcy52YWwpID09IDApCiAJCQkJCQkJZm1hdGNoID0gRk1BVENIX09LOwog
CQkJCQkJYnJlYWs7CiAJCQkJfQpAQCAtMjY1LDEwICszNDksMTQgQEAKIAkJCWlmIChmbWF0Y2gg
PT0gRk1BVENIX09LKQogCQkJewogCQkJCWZjb3VudCsrOwotCQkJCWxvZygiJXMgWyVzXTogJXUu
JXUuJXUuJXU6JXUgLT4gJXUuJXUuJXUuJXU6JXVcbiIsIAotCQkJCQlmLT5nZW5yZSwgZi0+ZGV0
YWlscywKKwkJCQlsb2coIiVzIFslczolczolc10gOiAldS4ldS4ldS4ldToldSAtPiAldS4ldS4l
dS4ldToldSBob3BzPSVkXG4iLCAKKwkJCQkJZi0+Z2VucmUsIGYtPnZlcnNpb24sCisJCQkJCWYt
PnN1YnR5cGUsIGYtPmRldGFpbHMsCiAJCQkJCU5JUFFVQUQoaXAtPnNhZGRyKSwgbnRvaHModGNw
LT5zb3VyY2UpLAotCQkJCQlOSVBRVUFEKGlwLT5kYWRkciksIG50b2hzKHRjcC0+ZGVzdCkpOwor
CQkJCQlOSVBRVUFEKGlwLT5kYWRkciksIG50b2hzKHRjcC0+ZGVzdCksCisJCQkJCWYtPnR0bCAt
IGlwLT50dGwpOworCQkJCWlmIChpbmZvLT5mbGFncyAmIElQVF9PU0ZfTkVUTElOSykKKwkJCQkJ
aXB0X29zZl9ubHNlbmQoZiwgc2tiKTsKIAkJCQlpZiAoKGluZm8tPmZsYWdzICYgSVBUX09TRl9M
T0cpICYmIAogCQkJCQlpbmZvLT5sb2dsZXZlbCA9PSBJUFRfT1NGX0xPR0xFVkVMX0ZJUlNUKQog
CQkJCQlicmVhazsKQEAgLTU5NCw3ICs2ODIsMTIgQEAKIAkJCWVsc2UgCiAJCQkJZmluZ2VyLT53
c3MudmFsID0gc2ltcGxlX3N0cnRvdWwocGJlZysxLCBOVUxMLCAxMCk7CiAJCX0KLQkJaWYgKGlz
ZGlnaXQocGJlZ1swXSkpCisJCWVsc2UgaWYgKHBiZWdbMF0gPT0gJyUnKQorCQl7CisJCQlmaW5n
ZXItPndzcy53YyA9ICclJzsKKwkJCWZpbmdlci0+d3NzLnZhbCA9IHNpbXBsZV9zdHJ0b3VsKHBi
ZWcrMSwgTlVMTCwgMTApOworCQl9CisJCWVsc2UgaWYgKGlzZGlnaXQocGJlZ1swXSkpCiAJCXsK
IAkJCWZpbmdlci0+d3NzLndjID0gMDsKIAkJCWZpbmdlci0+d3NzLnZhbCA9IHNpbXBsZV9zdHJ0
b3VsKHBiZWcsIE5VTEwsIDEwKTsKQEAgLTcwMiw2ICs3OTUsMTUgQEAKIAogCXAtPndyaXRlX3By
b2MgPSBvc2ZfcHJvY193cml0ZTsKIAlwLT5yZWFkX3Byb2MgID0gb3NmX3Byb2NfcmVhZDsKKwkK
KwludHMgPSBuZXRsaW5rX2tlcm5lbF9jcmVhdGUoTkVUTElOS19ORkxPRywgTlVMTCk7CisJaWYg
KCFudHMpCisJeworCQlsb2coIm5ldGxpbmtfa2VybmVsX2NyZWF0ZSgpIGZhaWxlZFxuIik7CisJ
CXJlbW92ZV9wcm9jX2VudHJ5KCJzeXMvbmV0L2lwdjQvb3NmIiwgTlVMTCk7CisJCWlwdF91bnJl
Z2lzdGVyX21hdGNoKCZvc2ZfbWF0Y2gpOworCQlyZXR1cm4gLUVOT01FTTsKKwl9CiAKIAlyZXR1
cm4gMDsKIH0KQEAgLTcxMyw2ICs4MTUsOCBAQAogCQogCXJlbW92ZV9wcm9jX2VudHJ5KCJzeXMv
bmV0L2lwdjQvb3NmIiwgTlVMTCk7CiAJaXB0X3VucmVnaXN0ZXJfbWF0Y2goJm9zZl9tYXRjaCk7
CisJaWYgKG50cyAmJiBudHMtPnNvY2tldCkKKwkJc29ja19yZWxlYXNlKG50cy0+c29ja2V0KTsK
IAogCWxpc3RfZm9yX2VhY2hfc2FmZShlbnQsIG4sICZmaW5nZXJfbGlzdCkKIAl7CkBAIC03MzAs
NCArODM0LDMgQEAKIE1PRFVMRV9MSUNFTlNFKCJHUEwiKTsKIE1PRFVMRV9BVVRIT1IoIkV2Z2Vu
aXkgUG9seWFrb3YgPGpvaG5wb2xAMmthLm1pcHQucnU+Iik7CiBNT0RVTEVfREVTQ1JJUFRJT04o
IlBhc3NpdmUgT1MgZmluZ2VycHJpbnQgbWF0Y2hpbmcuIik7Ci0KLS0tIHBhdGNoLW8tbWF0aWMt
bmcvb3NmL2xpbnV4L2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjQvaXB0X29zZi5oCVRodSBE
ZWMgMTggMjE6Mjg6NDMgMjAwMworKysgcGF0Y2gtby1tYXRpYy1uZy9vc2YvbGludXgvaW5jbHVk
ZS9saW51eC9uZXRmaWx0ZXJfaXB2NC9pcHRfb3NmLmgJRnJpIEphbiAxNiAxNzo1Njo0MyAyMDA0
CkBAIC0yNiwxNCArMjYsMjUgQEAKICNkZWZpbmUgTUFYREVUTEVOCQk2NAogCiAjZGVmaW5lIElQ
VF9PU0ZfR0VOUkUJCTEKLSNkZWZpbmUgSVBUX09TRl9TTUFSVAkJMgorI2RlZmluZQlJUFRfT1NG
X1NNQVJUCQkyCiAjZGVmaW5lIElQVF9PU0ZfTE9HCQk0CisjZGVmaW5lIElQVF9PU0ZfTkVUTElO
SwkJOAogCi0jZGVmaW5lIElQVF9PU0ZfTE9HTEVWRUxfQUxMCQkwCisjZGVmaW5lIElQVF9PU0Zf
TE9HTEVWRUxfQUxMCTAKICNkZWZpbmUgSVBUX09TRl9MT0dMRVZFTF9GSVJTVAkxCiAKICNpbmNs
dWRlIDxsaW51eC9saXN0Lmg+CiAKKyNpZm5kZWYgX19LRVJORUxfXworI2luY2x1ZGUgPG5ldGlu
ZXQvaXAuaD4KKyNpbmNsdWRlIDxuZXRpbmV0L3RjcC5oPgorCitzdHJ1Y3QgbGlzdF9oZWFkCit7
CisJc3RydWN0IGxpc3RfaGVhZCAqcHJldiwgKm5leHQ7Cit9OworI2VuZGlmCisKIHN0cnVjdCBp
cHRfb3NmX2luZm8KIHsKIAljaGFyIAkJCWdlbnJlW01BWEdFTlJFTEVOXTsKQEAgLTU5LDggKzcw
LDYgQEAKIAlzdHJ1Y3Qgb3NmX3djCQl3YzsKIH07CiAKLSNpZmRlZiBfX0tFUk5FTF9fCi0KIHN0
cnVjdCBvc2ZfZmluZ2VyCiB7CiAJc3RydWN0IGxpc3RfaGVhZAlmbGlzdDsKQEAgLTc4LDYgKzg3
LDE1IEBACiAJc3RydWN0IG9zZl9vcHQJCW9wdFtNQVhfSVBPUFRMRU5dOyAvKiBJbiBjYXNlIGl0
IGlzIGFsbCBOT1Agb3IgRU9MICovCiAKIH07CisKK3N0cnVjdCBpcHRfb3NmX25sbXNnCit7CisJ
c3RydWN0IG9zZl9maW5nZXIJZjsKKwlzdHJ1Y3QgaXBoZHIgCQlpcDsKKwlzdHJ1Y3QgdGNwaGRy
IAkJdGNwOworfTsKKworI2lmZGVmIF9fS0VSTkVMX18KIAogLyogRGVmaW5lcyBmb3IgSUFOQSBv
cHRpb24ga2luZHMgKi8KIAo=

--Multipart=_Sat__31_Jan_2004_15_47_25_+0300_Jd+Y7UrznRz5G6fq
Content-Type: text/x-csrc;
 name="osfd.c"
Content-Disposition: attachment;
 filename="osfd.c"
Content-Transfer-Encoding: 7bit

#include <asm/types.h>

#include <sys/types.h>
#include <sys/socket.h>

#include <linux/netlink.h>
#include <linux/rtnetlink.h>

#include <arpa/inet.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "osf/ipt_osf.h"

#ifndef NIPQUAD
#define NIPQUAD(addr) \
	((unsigned char *)&addr)[0], \
	((unsigned char *)&addr)[1], \
	((unsigned char *)&addr)[2], \
	((unsigned char *)&addr)[3]
#endif

int main()
{
	int s;
	char buf[1024];
	int len;
	struct nlmsghdr *reply;
	struct sockaddr_nl l_local;
	struct ipt_osf_nlmsg *data;
	
	memset(buf, 0, sizeof(buf));
	
	s = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_NFLOG);
	if (s == -1)
	{
		perror("socket");
		return -1;
	}
	
	l_local.nl_family = AF_NETLINK;
	l_local.nl_groups = 1;
	l_local.nl_pid    = getpid();
	
	if (bind(s, (struct sockaddr *)&l_local, sizeof(struct sockaddr_nl)) == -1)
	{
		perror("bind");
		close(s);
		return -1;
	}

	while (1)
	{
		len = recv(s, buf, sizeof(buf), 0);
		if (len == -1)
		{
			perror("recv buf");
			close(s);
			return -1;
		}
		reply = (struct nlmsghdr *)buf;
		
		printf("first nlmsghdr received: len=%d\n", len);
		printf("nlsmsghdr: len=%d, type=%d, flags=%d, seq=%d, pid=%d, sender_pid=%d\n", 
				reply->nlmsg_len, reply->nlmsg_type, 
				reply->nlmsg_flags, reply->nlmsg_seq, reply->nlmsg_pid,
				getpid());

		switch (reply->nlmsg_type)
		{
			case NLMSG_ERROR:
				printf("Error message received.\n");
				break;
			case NLMSG_DONE:
				data = (struct ipt_osf_nlmsg *)NLMSG_DATA(reply);
				printf("%s [%s:%s:%s] : %u.%u.%u.%u:%u -> %u.%u.%u.%u:%u hops=%d\n", 
					data->f.genre, data->f.version,
					data->f.subtype, data->f.details,
					NIPQUAD(data->ip.saddr), ntohs(data->tcp.source),
					NIPQUAD(data->ip.daddr), ntohs(data->tcp.dest),
					data->f.ttl - data->ip.ttl);
				break;
		}
	}

	close(s);
	return 0;
}


--Multipart=_Sat__31_Jan_2004_15_47_25_+0300_Jd+Y7UrznRz5G6fq
Content-Type: text/plain;
 name="libipt_osf.diff"
Content-Disposition: attachment;
 filename="libipt_osf.diff"
Content-Transfer-Encoding: 7bit

--- iptables/extensions/libipt_osf.c	Fri Jan  2 15:58:30 2004
+++ iptables/extensions/libipt_osf.c	Fri Jan 16 17:56:43 2004
@@ -31,9 +31,9 @@
 #include <ctype.h>
 
 #include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_osf.h>
+#include <linux/netfilter_ipv4/ipt_osf.h>
 
-#define IPTABLES_VERSION	"1.2.6a" /* It looks like FIXME */
+#define IPTABLES_VERSION	"1.2.7a" /* Permanent FIXME */
 
 static void help(void)
 {
@@ -42,7 +42,8 @@
 		"--smart		Use some smart extensions to determine OS (do not use TTL).\n"
 		"--log level		Log all(or only first) determined genres even if "
 					"they do not match desired one. "
-					"Level may be 0(all) or 1(only first entry).\n",
+					"Level may be 0(all) or 1(only first entry).\n"
+		"--netlink		Log through netlink(NETLINK_NFLOG).\n",
 		IPTABLES_VERSION);
 }
 
@@ -51,6 +52,7 @@
 	{ .name = "genre",	.has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = "smart",	.has_arg = 0, .flag = 0, .val = '2' },
 	{ .name = "log",	.has_arg = 1, .flag = 0, .val = '3' },
+	{ .name = "netlink",	.has_arg = 0, .flag = 0, .val = '4' },
 	{ .name = 0 }
 };
 
@@ -101,6 +103,12 @@
 			*flags |= IPT_OSF_LOG;
 			info->loglevel = atoi(argv[optind-1]);
 			info->flags |= IPT_OSF_LOG;
+			break;
+		case '4': /* --netlink */
+			if (*flags & IPT_OSF_NETLINK)
+				exit_error(PARAMETER_PROBLEM, "Can't specify multiple smart parameter");
+			*flags |= IPT_OSF_NETLINK;
+			info->flags |= IPT_OSF_NETLINK;
 			break;
 		default:
 			return 0;

--Multipart=_Sat__31_Jan_2004_15_47_25_+0300_Jd+Y7UrznRz5G6fq--
