From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [patch] pom-ng batch mode, and minor convert script fixes
Date: Fri, 27 Feb 2004 09:32:18 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402270929180.21288-200000@filer.marasystems.com>
References: <Pine.LNX.4.44.0402270919050.21192-300000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-675350442-1077870738=:21288"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0402270919050.21192-300000@filer.marasystems.com>
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

---1463811839-675350442-1077870738=:21288
Content-Type: TEXT/PLAIN; charset=US-ASCII

Minor update to the batch mode etc.

Disable stdout buffering to allow runme to be usedin a pipe such as in

 ./runme  | tee logfile


Regards
Henrik

---1463811839-675350442-1077870738=:21288
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="pomng-batch.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0402270932181.21288@filer.marasystems.com>
Content-Description: 
Content-Disposition: attachment; filename="pomng-batch.patch"

LS0tIHBhdGNoLW8tbWF0aWMtbmctMjAwNDAyMjYvcnVubWUJU3VuIEZlYiAy
MiAyMjo1OTo0NCAyMDA0DQorKysgcGF0Y2gtby1tYXRpYy1uZy9ydW5tZQlG
cmkgRmViIDI3IDA5OjI2OjQ4IDIwMDQNCkBAIC0yMSw2ICsyMSw4IEBADQog
cHVzaChASU5DLCAkUE9NTkdfUk9PVF9ESVIpOw0KIHVzZSBOZXRmaWx0ZXJf
UE9NOw0KIA0KKyR8PTE7DQorDQogc3ViIHByaW50X2hlYWRlcigpDQogew0K
IAlwcmludCgiV2VsY29tZSB0byBQYXRjaC1vLW1hdGljICgkVkVSU0lPTikh
XG5cbiIpOw0KQEAgLTgzLDcgKzg1LDcgQEANCiBteSBAcGF0Y2hkaXJzOw0K
IG15IEByZXBvc2l0b3JpZXM7DQogbXkgQGFwcGxpZWQ7DQotbXkgJGNscnNj
cjsNCitteSAkY2xyc2NyID0gIlxuXG5cblxuXG5cblxuXG5cblxuIjsNCiAN
CiBteSAkb3B0X2JhdGNoOyANCiBteSAkb3B0X3Rlc3Q7DQpAQCAtMTgyLDEx
ICsxODQsNiBAQA0KIE9VVDoNCiB9DQogDQotaWYgKCRvcHRfYmF0Y2gpIHsN
Ci0JcHJpbnQgU1RERVJSICgiLS1iYXRjaCBub3QgaW1wbGVtZW50ZWQgeWV0
XG4iKTsNCi0JZXhpdCgxKTsNCi19DQotDQogbXkgJGtwYXRoID0gJy91c3Iv
c3JjL2xpbnV4JzsNCiANCiBpZiAoIWRlZmluZWQoJEVOVntLRVJORUxfRElS
fSkgJiYgISRvcHRfcGF0aCkgew0KQEAgLTIzNSw3ICsyMzIsNyBAQA0KIAll
eGl0KDEpOw0KIH0NCiANCi1pZiAoZGVmaW5lZCgkRU5We1RFUk19KSkgew0K
K2lmIChkZWZpbmVkKCRFTlZ7VEVSTX0pICYmICEkb3B0X2JhdGNoKSB7DQog
CW15ICR0ZXJtaW5hbCA9IFRnZXRlbnQgVGVybTo6Q2FwIHt9Ow0KIAkkY2xy
c2NyID0gJHRlcm1pbmFsLT5UcHV0cygnY2wnLCAxKTsNCiB9DQpAQCAtMjgw
LDkgKzI3NywxNiBAQA0KIAkJcHJpbnRmKCIgICBBdXRob3I6ICVzXG4iLCAk
JHBhdGNobGV0e2luZm99e2F1dGhvcn0pOw0KIAkJcHJpbnRmKCIgICBTdGF0
dXM6ICVzXG5cbiIsICQkcGF0Y2hsZXR7aW5mb317c3RhdHVzfSk7DQogCQlw
cmludF9oZWxwZmlsZSgkcGF0Y2hsZXQpOw0KKwkJbXkgJGZpcnN0X3RyeSA9
IDE7DQogCVBST01QVDoNCi0JCXByaW50X3Byb21wdCgkb3B0X3JldmVyc2Up
Ow0KLQkJbXkgJGtleSA9IDxTVERJTj47DQorCQlteSAka2V5Ow0KKwkJaWYg
KCRvcHRfYmF0Y2ggJiYgJGZpcnN0X3RyeSkgew0KKwkJICAgICRrZXkgPSAn
eSc7DQorCQkgICAgJGZpcnN0X3RyeSA9IDA7DQorCQl9IGVsc2Ugew0KKwkJ
ICAgIHByaW50X3Byb21wdCgkb3B0X3JldmVyc2UpOw0KKwkJICAgICRrZXkg
PSA8U1RESU4+Ow0KKwkJfQ0KIAkJY2hvbXAoJGtleSk7DQogCQlpZiAoJGtl
eSBlcSAneScpIHsNCiAJCQlteSAkcmV0ID0gTmV0ZmlsdGVyX1BPTTo6ZGVw
ZW5kZW5jaWVzX2Z1bGZpbGxlZCgkcGxldHMsDQo=
---1463811839-675350442-1077870738=:21288--
