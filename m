From: Michael StJohns <mstjohns@mindspring.com>
Subject: Re: ip_queue.c inefficiencies?
Date: Fri, 04 Feb 2005 18:01:21 -0500
Message-ID: <6.2.0.14.2.20050204180024.0420de40@pop.mindspring.com>
References: <6.2.0.14.2.20050118185904.047393e0@pop.mindspring.com>
	<20050201131128.GF6878@sunbeam.de.gnumonks.org>
	<4200EF2C.1030808@trash.net>
	<6.2.0.14.2.20050202105005.05278940@pop.mindspring.com>
	<42026FF0.2060602@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=====================_153707930==_"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42026FF0.2060602@trash.net>
References: <6.2.0.14.2.20050118185904.047393e0@pop.mindspring.com>
	<20050201131128.GF6878@sunbeam.de.gnumonks.org>
	<4200EF2C.1030808@trash.net>
	<6.2.0.14.2.20050202105005.05278940@pop.mindspring.com>
	<42026FF0.2060602@trash.net>
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

--=====================_153707930==_
Content-Type: text/plain; charset="us-ascii"; format=flowed



At 01:39 PM 2/3/2005, Patrick McHardy wrote:


>>Do you want a version of this against net/ipv6/netfilter/ip6_queue.c as 
>>well?  It has the same inefficiency issue.
>
>Yes, please.


Attached. Includes the changes you made to the v4 patch.


>Regards
>Patrick
>
>BTW: Please add a Signed-off-by: line when you send a patch.

--=====================_153707930==_
Content-Type: application/octet-stream; name="ip6queue.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="ip6queue.patch"

IyBNYW51YWxseSBnZW5lcmF0ZWQgZGlmZiAtTnVyIHBhdGNoCiMgbmV0L2lwdjYvbmV0ZmlsdGVy
L2lwNl9xdWV1ZS5jCiMKIyBTaWduZWQtb2ZmLWJ5OiBNaWtlIFN0Sm9obnMgPHN0am9obnNAbm9t
aW51bS5jb20+CiMKLS0tIG9sZC9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2X3F1ZXVlLmMJMjAwNS0w
Mi0wNCAxNzoyODoxMy41NDQ2ODg4ODggLTA1MDAKKysrIG5ldy9uZXQvaXB2Ni9uZXRmaWx0ZXIv
aXA2X3F1ZXVlLmMJMjAwNS0wMi0wNCAxNzozODo0NS43ODA1NzQ0MjQgLTA1MDAKQEAgLTIwLDYg
KzIwLDkgQEAKICAqICAgICAgICAgICAgIEZldyBjaGFuZ2VzIG5lZWRlZCwgbWFpbmx5IHRoZSBo
YXJkX3JvdXRpbmcgY29kZSBhbmQKICAqICAgICAgICAgICAgIHRoZSBuZXRsaW5rIHNvY2tldCBw
cm90b2NvbCAod2UncmUgTkVUTElOS19JUDZfRlcpLgogICogMjAwMi0wNi0yNTogQ29kZSBjbGVh
bnVwLiBbSk06IHBvcnRlZCBjbGVhbnVwIG92ZXIgZnJvbSBpcF9xdWV1ZS5jXQorICogMjAwNS0w
Mi0wNDogQWRkZWQgL3Byb2MgY291bnRlciBmb3IgZHJvcHBlZCBwYWNrZXRzOyBmaXhlZCBzbwor
ICogICAgICAgICAgICAgcGFja2V0cyBhcmVuJ3QgZGVsaXZlcmVkIHRvIHVzZXIgc3BhY2UgaWYg
dGhleSdyZSBnb2luZworICogICAgICAgICAgICAgdG8gYmUgZHJvcHBlZC4KICAqLwogI2luY2x1
ZGUgPGxpbnV4L21vZHVsZS5oPgogI2luY2x1ZGUgPGxpbnV4L3NrYnVmZi5oPgpAQCAtNjQsNiAr
NjcsOCBAQAogc3RhdGljIGludCBwZWVyX3BpZDsKIHN0YXRpYyB1bnNpZ25lZCBpbnQgY29weV9y
YW5nZTsKIHN0YXRpYyB1bnNpZ25lZCBpbnQgcXVldWVfdG90YWw7CitzdGF0aWMgdW5zaWduZWQg
aW50IHF1ZXVlX2Ryb3BwZWQgPSAwOworc3RhdGljIHVuc2lnbmVkIGludCBxdWV1ZV91c2VyX2Ry
b3BwZWQgPSAwOwogc3RhdGljIHN0cnVjdCBzb2NrICppcHFubDsKIHN0YXRpYyBMSVNUX0hFQUQo
cXVldWVfbGlzdCk7CiBzdGF0aWMgREVDTEFSRV9NVVRFWChpcHFubF9zZW0pOwpAQCAtNzUsMTgg
KzgwLDExIEBACiAJa2ZyZWUoZW50cnkpOwogfQogCi1zdGF0aWMgaW5saW5lIGludAorc3RhdGlj
IGlubGluZSB2b2lkCiBfX2lwcV9lbnF1ZXVlX2VudHJ5KHN0cnVjdCBpcHFfcXVldWVfZW50cnkg
KmVudHJ5KQogewotICAgICAgIGlmIChxdWV1ZV90b3RhbCA+PSBxdWV1ZV9tYXhsZW4pIHsKLSAg
ICAgICAgICAgICAgIGlmIChuZXRfcmF0ZWxpbWl0KCkpIAotICAgICAgICAgICAgICAgICAgICAg
ICBwcmludGsoS0VSTl9XQVJOSU5HICJpcDZfcXVldWU6IGZ1bGwgYXQgJWQgZW50cmllcywgIgot
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImRyb3BwaW5nIHBhY2tldChzKS5cbiIsIHF1
ZXVlX3RvdGFsKTsKLSAgICAgICAgICAgICAgIHJldHVybiAtRU5PU1BDOwotICAgICAgIH0KICAg
ICAgICBsaXN0X2FkZCgmZW50cnktPmxpc3QsICZxdWV1ZV9saXN0KTsKICAgICAgICBxdWV1ZV90
b3RhbCsrOwotICAgICAgIHJldHVybiAwOwogfQogCiAvKgpAQCAtMzEyLDEwICszMTAsMjIgQEAK
IAlpZiAoIXBlZXJfcGlkKQogCQlnb3RvIGVycl9vdXRfZnJlZV9uc2tiOyAKIAorCWlmIChxdWV1
ZV90b3RhbCA+PSBxdWV1ZV9tYXhsZW4pIHsKKyAgICAgICAgICAgICAgICBxdWV1ZV9kcm9wcGVk
Kys7CisJCXN0YXR1cyA9IC1FTk9TUEM7CisJCWlmIChuZXRfcmF0ZWxpbWl0KCkpCisJCSAgICAg
ICAgcHJpbnRrIChLRVJOX1dBUk5JTkcgImlwNl9xdWV1ZTogZmlsbCBhdCAlZCBlbnRyaWVzLCAi
CisJCQkJImRyb3BwaW5nIHBhY2tldChzKS4gIERyb3BwZWQ6ICVkXG4iLCBxdWV1ZV90b3RhbCwK
KwkJCQlxdWV1ZV9kcm9wcGVkKTsKKwkJZ290byBlcnJfb3V0X2ZyZWVfbnNrYjsKKwl9CisKICAJ
LyogbmV0bGlua191bmljYXN0IHdpbGwgZWl0aGVyIGZyZWUgdGhlIG5za2Igb3IgYXR0YWNoIGl0
IHRvIGEgc29ja2V0ICovIAogCXN0YXR1cyA9IG5ldGxpbmtfdW5pY2FzdChpcHFubCwgbnNrYiwg
cGVlcl9waWQsIE1TR19ET05UV0FJVCk7Ci0JaWYgKHN0YXR1cyA8IDApCisJaWYgKHN0YXR1cyA8
IDApIHsKKyAJICAgICAgICBxdWV1ZV91c2VyX2Ryb3BwZWQrKzsKIAkJZ290byBlcnJfb3V0X3Vu
bG9jazsKKwl9CiAJCiAJc3RhdHVzID0gX19pcHFfZW5xdWV1ZV9lbnRyeShlbnRyeSk7CiAJaWYg
KHN0YXR1cyA8IDApCkBAIC02MzksMTIgKzY0OSwxNiBAQAogCSAgICAgICAgICAgICAgIkNvcHkg
bW9kZSAgICAgICAgIDogJWh1XG4iCiAJICAgICAgICAgICAgICAiQ29weSByYW5nZSAgICAgICAg
OiAldVxuIgogCSAgICAgICAgICAgICAgIlF1ZXVlIGxlbmd0aCAgICAgIDogJXVcbiIKLQkgICAg
ICAgICAgICAgICJRdWV1ZSBtYXguIGxlbmd0aCA6ICV1XG4iLAorCSAgICAgICAgICAgICAgIlF1
ZXVlIG1heC4gbGVuZ3RoIDogJXVcbiIKKwkJICAgICAgIlF1ZXVlIGRyb3BwZWQgICAgIDogJXVc
biIKKwkJICAgICAgIk5ldGZpbHRlciBkcm9wcGVkIDogJXVcbiIsCiAJICAgICAgICAgICAgICBw
ZWVyX3BpZCwKIAkgICAgICAgICAgICAgIGNvcHlfbW9kZSwKIAkgICAgICAgICAgICAgIGNvcHlf
cmFuZ2UsCiAJICAgICAgICAgICAgICBxdWV1ZV90b3RhbCwKLQkgICAgICAgICAgICAgIHF1ZXVl
X21heGxlbik7CisJICAgICAgICAgICAgICBxdWV1ZV9tYXhsZW4sCisJCSAgICAgIHF1ZXVlX2Ry
b3BwZWQsCisJCSAgICAgIHF1ZXVlX3VzZXJfZHJvcHBlZCk7CiAKIAlyZWFkX3VubG9ja19iaCgm
cXVldWVfbG9jayk7CiAJCg==
--=====================_153707930==_
Content-Type: text/plain; charset="us-ascii"; format=flowed


--=====================_153707930==_--
