From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] OSF: pom-ng - linux-2.6.
Date: Sun, 12 Dec 2004 18:13:51 +0300
Message-ID: <20041212181351.22570bf6@zanzibar.2ka.mipt.ru>
References: <1102503533.3363.48.camel@uganda> <1102503753.3363.50.camel@uganda>
	<41B74C8C.20607@trash.net>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="Multipart=_Sun__12_Dec_2004_18_13_51_+0300_R+aUJtoKFCZD9ExY"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41B74C8C.20607@trash.net>
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

This is a multi-part message in MIME format.

--Multipart=_Sun__12_Dec_2004_18_13_51_+0300_R+aUJtoKFCZD9ExY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 08 Dec 2004 19:48:44 +0100
Patrick McHardy <kaber@trash.net> wrote:

> Evgeniy Polyakov wrote:
> 
> >On Wed, 2004-12-08 at 13:58 +0300, Evgeniy Polyakov wrote:
> >  
> >
> >>Since OSF originally was created in 2.5 environment 
> >>it is strange not to have 2.6 support for OSF.
> >>This(similar) patch was sent some time ago but was lost.
> >>Please apply.
> >>
> >>Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> >>    
> >>
> >
> >My dear hands, please contact my brain before doing anything.
> >Thanks.
> >  
> >
> And I need to read first before complaining :)
> 
> >Proper patch attached.
> >  
> >
> Still doesn't apply, it seems to be present already. The latest
> change was two month ago.

Yep, my fault, I saw into the latest pom-ng.

...
 
> Anyhow, it still needs to handle non-linear skbs. Have a look
> at the other matches and their use of skb_header_pointer.

Sure.
Patch attached, although I do not quite understand what should be 
done with a poor skb to move IP and TCP headers into the fragments...

P.S. patch was done against my own tree, but should be applied 
against CVS, probably with some fuzz. I can not test it with the 
latest CVS since pserver.netfilter.org:2401 is not accessible.

P.P.S. I do not have 2.4 sources but if 2.4 has skb_header_pointer
(as long as it has skb_copy_bits()) patch can be applied against it
as well, but path in diff should be changed. If needed it is attached
as well.

> Regards
> Patrick


	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt

--Multipart=_Sun__12_Dec_2004_18_13_51_+0300_R+aUJtoKFCZD9ExY
Content-Type: application/octet-stream;
 name="ipt_osf.patch"
Content-Disposition: attachment;
 filename="ipt_osf.patch"
Content-Transfer-Encoding: base64

LS0tIG9yaWcvb3NmL2xpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcHRfb3NmLmMKKysrIG1vZC9v
c2YvbGludXgvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9vc2YuYwpAQCAtMTU4LDIwICsxNTgsMzAg
QEAKICAgICAgIGludCAqaG90ZHJvcCkKIHsKIAlzdHJ1Y3QgaXB0X29zZl9pbmZvICppbmZvID0g
KHN0cnVjdCBpcHRfb3NmX2luZm8gKiltYXRjaGluZm87Ci0Jc3RydWN0IGlwaGRyICppcCA9IHNr
Yi0+bmguaXBoOwotCXN0cnVjdCB0Y3BoZHIgKnRjcDsKKwlzdHJ1Y3QgaXBoZHIgX2lwaCwgKmlw
OworCXN0cnVjdCB0Y3BoZHIgX3RjcGgsICp0Y3A7CiAJaW50IGZtYXRjaCA9IEZNQVRDSF9XUk9O
RywgZmNvdW50ID0gMDsKIAl1bnNpZ25lZCBsb25nIHRvdGxlbiwgb3B0c2l6ZSA9IDAsIHdpbmRv
dzsKIAl1bnNpZ25lZCBjaGFyIGRmLCAqb3B0cCA9IE5VTEwsICpfb3B0cCA9IE5VTEw7CisJdW5z
aWduZWQgY2hhciBvcHRzW01BWF9JUE9QVExFTl07CiAJY2hhciBjaGVja19XU1MgPSAwOwogCXN0
cnVjdCBsaXN0X2hlYWQgKmVudDsKIAlzdHJ1Y3Qgb3NmX2ZpbmdlciAqZjsKKwlpbnQgb2ZmOwog
Ci0JaWYgKCFpcCB8fCAhaW5mbykKKwlpZiAoIWluZm8pCisJCXJldHVybiAwOworCQorCW9mZiA9
IDA7CisJCisJaXAgPSBza2JfaGVhZGVyX3BvaW50ZXIoc2tiLCBvZmYsIHNpemVvZihfaXBoKSwg
Jl9pcGgpOworCWlmICghaXApCiAJCXJldHVybiAwOwogCQkJCQotCXRjcCA9IChzdHJ1Y3QgdGNw
aGRyICopKCh1X2ludDMyX3QgKilpcCArIGlwLT5paGwpOwotCisJdGNwID0gc2tiX2hlYWRlcl9w
b2ludGVyKHNrYiwgb2ZmICsgaXAtPmlobCAqIDQsIHNpemVvZihfdGNwaCksICZfdGNwaCk7CisJ
aWYgKCF0Y3ApCisJCXJldHVybiAwOworCQogCWlmICghdGNwLT5zeW4pCiAJCXJldHVybiAwOwog
CQpAQCAtMTgxLDggKzE5MSwxNiBAQAogCQogCWlmICh0Y3AtPmRvZmYqNCA+IHNpemVvZihzdHJ1
Y3QgdGNwaGRyKSkKIAl7Ci0JCV9vcHRwID0gb3B0cCA9IChjaGFyICopKHRjcCsxKTsKIAkJb3B0
c2l6ZSA9IHRjcC0+ZG9mZio0IC0gc2l6ZW9mKHN0cnVjdCB0Y3BoZHIpOworCisJCWlmIChvcHRz
aXplID4gc2l6ZW9mKG9wdHMpKQorCQl7CisJCQlsb2coIiVzOiBCVUc6IHRvbyBiaWcgb3B0aW9u
cyBzaXplOiBvcHRzaXplPSVsdSwgbWF4PSVkLlxuIiwKKwkJCQkJX19mdW5jX18sIG9wdHNpemUs
IHNpemVvZihvcHRzKSk7CisJCQlvcHRzaXplID0gc2l6ZW9mKG9wdHMpOworCQl9CisJCQorCQlf
b3B0cCA9IG9wdHAgPSBza2JfaGVhZGVyX3BvaW50ZXIoc2tiLCBvZmYgKyBpcC0+aWhsKjQgKyBz
aXplb2YoX3RjcGgpLCBvcHRzaXplLCBvcHRzKTsKIAl9CiAKIAkvKiBBY3R1YWxseSB3ZSBjYW4g
Y3JlYXRlIGhhc2gvdGFibGUgb2YgYWxsIGdlbnJlcyBhbmQgc2VhcmNoCkBAIC0zNzUsNyArMzkz
LDcgQEAKIAkJaWYgKG9wdHApCiAJCXsKIAkJCW9wdHNpemUgPSB0Y3AtPmRvZmYgKiA0IC0gc2l6
ZW9mKHN0cnVjdCB0Y3BoZHIpOwotCQkJaWYgKHNrYl9jb3B5X2JpdHMoc2tiLCBpcC0+aWhsKjQg
KyBzaXplb2Yoc3RydWN0IHRjcGhkciksCisJCQlpZiAoc2tiX2NvcHlfYml0cyhza2IsIG9mZiAr
IGlwLT5paGwqNCArIHNpemVvZihzdHJ1Y3QgdGNwaGRyKSwKIAkJCQkJICBvcHQsIG9wdHNpemUp
IDwgMCkKIAkJCXsKIAkJCQlpZiAoaW5mby0+ZmxhZ3MgJiBJUFRfT1NGX0xPRykKCgoK

--Multipart=_Sun__12_Dec_2004_18_13_51_+0300_R+aUJtoKFCZD9ExY
Content-Type: application/octet-stream;
 name="ipt_osf.patch-2.4"
Content-Disposition: attachment;
 filename="ipt_osf.patch-2.4"
Content-Transfer-Encoding: base64

LS0tIG9yaWcvb3NmL2xpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcHRfb3NmLmMKKysrIG1vZC9v
c2YvbGludXgvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9vc2YuYwpAQCAtMTU4LDIwICsxNTgsMzAg
QEAKICAgICAgIGludCAqaG90ZHJvcCkKIHsKIAlzdHJ1Y3QgaXB0X29zZl9pbmZvICppbmZvID0g
KHN0cnVjdCBpcHRfb3NmX2luZm8gKiltYXRjaGluZm87Ci0Jc3RydWN0IGlwaGRyICppcCA9IHNr
Yi0+bmguaXBoOwotCXN0cnVjdCB0Y3BoZHIgKnRjcDsKKwlzdHJ1Y3QgaXBoZHIgX2lwaCwgKmlw
OworCXN0cnVjdCB0Y3BoZHIgX3RjcGgsICp0Y3A7CiAJaW50IGZtYXRjaCA9IEZNQVRDSF9XUk9O
RywgZmNvdW50ID0gMDsKIAl1bnNpZ25lZCBsb25nIHRvdGxlbiwgb3B0c2l6ZSA9IDAsIHdpbmRv
dzsKIAl1bnNpZ25lZCBjaGFyIGRmLCAqb3B0cCA9IE5VTEwsICpfb3B0cCA9IE5VTEw7CisJdW5z
aWduZWQgY2hhciBvcHRzW01BWF9JUE9QVExFTl07CiAJY2hhciBjaGVja19XU1MgPSAwOwogCXN0
cnVjdCBsaXN0X2hlYWQgKmVudDsKIAlzdHJ1Y3Qgb3NmX2ZpbmdlciAqZjsKKwlpbnQgb2ZmOwog
Ci0JaWYgKCFpcCB8fCAhaW5mbykKKwlpZiAoIWluZm8pCisJCXJldHVybiAwOworCQorCW9mZiA9
IDA7CisJCisJaXAgPSBza2JfaGVhZGVyX3BvaW50ZXIoc2tiLCBvZmYsIHNpemVvZihfaXBoKSwg
Jl9pcGgpOworCWlmICghaXApCiAJCXJldHVybiAwOwogCQkJCQotCXRjcCA9IChzdHJ1Y3QgdGNw
aGRyICopKCh1X2ludDMyX3QgKilpcCArIGlwLT5paGwpOwotCisJdGNwID0gc2tiX2hlYWRlcl9w
b2ludGVyKHNrYiwgb2ZmICsgaXAtPmlobCAqIDQsIHNpemVvZihfdGNwaCksICZfdGNwaCk7CisJ
aWYgKCF0Y3ApCisJCXJldHVybiAwOworCQogCWlmICghdGNwLT5zeW4pCiAJCXJldHVybiAwOwog
CQpAQCAtMTgxLDggKzE5MSwxNiBAQAogCQogCWlmICh0Y3AtPmRvZmYqNCA+IHNpemVvZihzdHJ1
Y3QgdGNwaGRyKSkKIAl7Ci0JCV9vcHRwID0gb3B0cCA9IChjaGFyICopKHRjcCsxKTsKIAkJb3B0
c2l6ZSA9IHRjcC0+ZG9mZio0IC0gc2l6ZW9mKHN0cnVjdCB0Y3BoZHIpOworCisJCWlmIChvcHRz
aXplID4gc2l6ZW9mKG9wdHMpKQorCQl7CisJCQlsb2coIiVzOiBCVUc6IHRvbyBiaWcgb3B0aW9u
cyBzaXplOiBvcHRzaXplPSVsdSwgbWF4PSVkLlxuIiwKKwkJCQkJX19mdW5jX18sIG9wdHNpemUs
IHNpemVvZihvcHRzKSk7CisJCQlvcHRzaXplID0gc2l6ZW9mKG9wdHMpOworCQl9CisJCQorCQlf
b3B0cCA9IG9wdHAgPSBza2JfaGVhZGVyX3BvaW50ZXIoc2tiLCBvZmYgKyBpcC0+aWhsKjQgKyBz
aXplb2YoX3RjcGgpLCBvcHRzaXplLCBvcHRzKTsKIAl9CiAKIAkvKiBBY3R1YWxseSB3ZSBjYW4g
Y3JlYXRlIGhhc2gvdGFibGUgb2YgYWxsIGdlbnJlcyBhbmQgc2VhcmNoCkBAIC0zNzUsNyArMzkz
LDcgQEAKIAkJaWYgKG9wdHApCiAJCXsKIAkJCW9wdHNpemUgPSB0Y3AtPmRvZmYgKiA0IC0gc2l6
ZW9mKHN0cnVjdCB0Y3BoZHIpOwotCQkJaWYgKHNrYl9jb3B5X2JpdHMoc2tiLCBpcC0+aWhsKjQg
KyBzaXplb2Yoc3RydWN0IHRjcGhkciksCisJCQlpZiAoc2tiX2NvcHlfYml0cyhza2IsIG9mZiAr
IGlwLT5paGwqNCArIHNpemVvZihzdHJ1Y3QgdGNwaGRyKSwKIAkJCQkJICBvcHQsIG9wdHNpemUp
IDwgMCkKIAkJCXsKIAkJCQlpZiAoaW5mby0+ZmxhZ3MgJiBJUFRfT1NGX0xPRykKCgoK

--Multipart=_Sun__12_Dec_2004_18_13_51_+0300_R+aUJtoKFCZD9ExY--
