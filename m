From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] patch-o-matic-ng patch
Date: Wed, 18 Feb 2004 15:57:12 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402181553330.13121-200000@blackhole.kfki.hu>
References: <Pine.LNX.4.33.0402180005300.11937-200000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-975494621-1077116232=:13121"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <Pine.LNX.4.33.0402180005300.11937-200000@blackhole.kfki.hu>
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

--110391808-975494621-1077116232=:13121
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi Harald,

Just another patch :-) If a patch has got kernel tree and kernel patch
for one kernel version, but only kernel patch for another kernel version
(the to-be-released nf-log patch is such a beast), then it cannot be
applied correctly.

The attached patch fixes the problem.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary

--110391808-975494621-1077116232=:13121
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="pom-ng.patch3"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.33.0402181557120.13121@blackhole.kfki.hu>
Content-Description: pom-ng.patch3
Content-Disposition: attachment; filename="pom-ng.patch3"

LS0tIHAtby1tLWEvTmV0ZmlsdGVyX1BPTS5wbQkyMDA0LTAyLTE3IDA3OjI3
OjM0LjAwMDAwMDAwMCArMDEwMA0KKysrIHBhdGNoLW8tbWF0aWMtbmcyL05l
dGZpbHRlcl9QT00ucG0JMjAwNC0wMi0xOCAxNToxMjozOC4wMDAwMDAwMDAg
KzAxMDANCkBAIC0yMTMsOSArMjEzLDExIEBADQogCQkJcmV0dXJuIDA7DQog
CQl9DQogCX0NCi0JbXkoJGJpbmdvLCAkbWF0Y2gpOw0KKyNwcmludCBEdW1w
ZXIoJHBhdGNobGV0KTsNCisNCisJbXkoJHByb2osICRiaW5nbywgJG1hdGNo
KTsNCiAJZm9yZWFjaCBteSAkdHlwZSAocXcocGF0Y2ggZmlsZXMgbGFkZHMp
KSB7DQotCQlmb3JlYWNoIG15ICRwcm9qIChrZXlzICV7JCRwYXRjaGxldHsk
dHlwZX19KSB7DQorCQlmb3JlYWNoICRwcm9qIChrZXlzICV7JCRwYXRjaGxl
dHskdHlwZX19KSB7DQogCQkJJGJpbmdvID0gLTE7DQogCQkJZm9yZWFjaCBt
eSAkdmVyIChrZXlzICV7JCRwYXRjaGxldHskdHlwZX17JHByb2p9fSkgew0K
IAkJCQkkbWF0Y2ggPSAhJHZlciA/IDENCkBAIC0yMjgsMTMgKzIzMCwxNSBA
QA0KIAkJCQl9DQogCQkJfQ0KIAkJCWlmICgkYmluZ28gPCAwKSB7DQotCQkJ
CSRFUlJNU0cgPSAiQ2FuJ3QgZmluZCBhIHBhdGNoIHZlcnNpb24gb2YgJCRw
YXRjaGxldHtuYW1lfSBtYXRjaGluZyB5b3VyICIgDQotCQkJCQkgICAuICgk
cHJvaiBlcSAnbGludXgnID8gJ2tlcm5lbCcgOiAkcHJvaikgLiAiIHZlcnNp
b24iOw0KLQkJCXJldHVybiAwOw0KKwkJCQlkZWxldGUgJCRwYXRjaGxldHsk
dHlwZX17JHByb2p9Ow0KIAkJCX0NCiAJCX0NCiAJfQ0KLQkNCisJaWYgKCEo
JXskJHBhdGNobGV0e3BhdGNofX0gfHwgJXskJHBhdGNobGV0e2ZpbGVzfX0g
fHwgJXskJHBhdGNobGV0e2xhZGRzfX0pKSB7DQorCQkkRVJSTVNHID0gIkNh
bid0IGZpbmQgYSBwYXRjaCB2ZXJzaW9uIG9mICQkcGF0Y2hsZXR7bmFtZX0g
bWF0Y2hpbmcgeW91ciAiIA0KKwkJCSAgIC4gKCRwcm9qIGVxICdsaW51eCcg
PyAna2VybmVsJyA6ICRwcm9qKSAuICIgdmVyc2lvbiI7DQorCQlyZXR1cm4g
MDsNCisJfQ0KIAlpZiAoIWNoZWNrX2tjb25maWcoJHBhdGNobGV0KSkgew0K
IAkJIyBkb24ndCBvdmVycmlkZSAkRVJSTVNHDQogCQlyZXR1cm4gMDsNCg==
--110391808-975494621-1077116232=:13121--
