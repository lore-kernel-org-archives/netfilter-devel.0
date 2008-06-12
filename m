From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd [ERROR] commit: Invalid argument
Date: Thu, 12 Jun 2008 17:01:04 +0200
Message-ID: <48513A30.1020908@netfilter.org>
References: <e1aa27e00806090621r3fa83ac0s7bb89d903de3be41@mail.gmail.com> <200806111545.18856.sabelka@iue.tuwien.ac.at> <484FFCA2.1090500@netfilter.org> <200806111915.32313.sabelka@iue.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010001070905090208030409"
Cc: Marco Barbero <marco.barbero@gmail.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52619 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751891AbYFLOwr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:52:47 -0400
In-Reply-To: <200806111915.32313.sabelka@iue.tuwien.ac.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010001070905090208030409
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Rainer Sabelka wrote:
> On Wednesday 11 June 2008 18:26, Pablo Neira Ayuso wrote:
>> Rainer Sabelka wrote:
>>> On Wednesday 11 June 2008 15:25, Pablo Neira Ayuso wrote:
>>>> Are your scripts committing the entries twice (ie. invoking conntrackd
>>>> -c several times)?
>>> In my case - yes I did.
>>>
>>>> The only way to reproduce this that I have found is
>>>> to double insert an existing conntrack with some NAT handling. In the
>>>> upcoming 2.6.26 you'll get a EBUSY instead of EINVAL which sounds more
>>>> reasonable.
>>>>
>>>> Anyhow, does the patch attached fix this behaviour? The idea behind it
>>>> is to check if there is a conntrack present in kernel, if so, just
>>>> update the attributes of the conntrack object that are changeable to
>>>> avoid the error. Would you mind testing it?
>>> Thanks for the patch!
>>> Now I see no more "commit: Invalid argument" in the logs. Instead I get
>>> something like this, which looks much fiendlier:
>>>
>>> Jun 11 15:36:48 fw1b conntrack-tools[13273]: committing external cache
>>> Jun 11 15:36:48 fw1b conntrack-tools[13273]: Committed 69 new entries
>>> Jun 11 15:36:48 fw1b conntrack-tools[13273]: 53 entries ignored, already
>>> exist
>>                                                              ^^^
>> I'll also fix the message (those entries are not ignored but updated).
>> Then I'll commit the patch asap.
>>
>>> But in rare cases I can see "commit-create: Cannot allocate memory".
>>> I also noticed this a few times before applying this patch. Is this
>>> something I should worry about?
>> Yes, very strange. ctnetlink is hitting ENOMEM, ie. it cannot create the
>> conntrack because there's no memory available. As for now ctnetlink is
>> allocating conntracks via nf_conntrack_alloc() which uses GFP_ATOMIC.
>> I'll send you a patch to relax this to check if that is the problem,
>> otherwise I think that the error is bogus.
>>
>>> Jun 11 15:40:07 fw1b conntrack-tools[13383]: committing external cache
>>> Jun 11 15:40:07 fw1b conntrack-tools[13383]: commit-create: Cannot
>>> allocate memory
>>> Jun 11 15:40:07 fw1b conntrack-tools[13383]: Committed 33 new entries
>>> Jun 11 15:40:07 fw1b conntrack-tools[13383]: 25 entries ignored, already
>>> exist Jun 11 15:40:07 fw1b conntrack-tools[13383]: 1 entries can't be
>>> committed
>> What it is really annoying is the fact that you hit error with that less
>> entries. I cannot reproduce that in my testbed with ~20000 entries. Are
>> you using some kind of embedded device? Architecture?
> 
> This is a vitual machine (i686) which 128 MByte of memory running under VMware 
> server 1.0.4.

Would you try this patch?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010001070905090208030409
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="x"

W1BBVENIXSBhZGQgYWxsb2NhdGlvbiBmbGFnIHRvIG5mX2Nvbm50cmFja19hbGxvYwoKY3Ru
ZXRsaW5rIGRvZXMgbm90IG5lZWQgdG8gYWxsb2NhdGUgdGhlIGNvbm50cmFjayBlbnRyaWVz
IHdpdGggR0ZQX0FUT01JQwphcyBpdHMgY29kZSBpcyBleGVjdXRlZCBpbiB1c2VyIGNvbnRl
eHQuCgpTaWduZWQtb2ZmLWJ5OiBQYWJsbyBOZWlyYSBBeXVzbyA8cGFibG9AbmV0ZmlsdGVy
Lm9yZz4KCkluZGV4OiBuZXQtMi42L2luY2x1ZGUvbmV0L25ldGZpbHRlci9uZl9jb25udHJh
Y2suaAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09Ci0tLSBuZXQtMi42Lm9yaWcvaW5jbHVkZS9uZXQvbmV0Zmls
dGVyL25mX2Nvbm50cmFjay5oCTIwMDgtMDYtMTIgMTQ6NDM6NDEuMDAwMDAwMDAwICswMjAw
CisrKyBuZXQtMi42L2luY2x1ZGUvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2suaAkyMDA4
LTA2LTEyIDE0OjQzOjU5LjAwMDAwMDAwMCArMDIwMApAQCAtMjM5LDcgKzIzOSw4IEBACiBl
eHRlcm4gdm9pZCBuZl9jb25udHJhY2tfZnJlZShzdHJ1Y3QgbmZfY29ubiAqY3QpOwogZXh0
ZXJuIHN0cnVjdCBuZl9jb25uICoKIG5mX2Nvbm50cmFja19hbGxvYyhjb25zdCBzdHJ1Y3Qg
bmZfY29ubnRyYWNrX3R1cGxlICpvcmlnLAotCQkgICBjb25zdCBzdHJ1Y3QgbmZfY29ubnRy
YWNrX3R1cGxlICpyZXBsKTsKKwkJICAgY29uc3Qgc3RydWN0IG5mX2Nvbm50cmFja190dXBs
ZSAqcmVwbCwKKwkJICAgZ2ZwX3QgYWxsb2NhdGlvbik7CiAKIC8qIEl0J3MgY29uZmlybWVk
IGlmIGl0IGlzLCBvciBoYXMgYmVlbiBpbiB0aGUgaGFzaCB0YWJsZS4gKi8KIHN0YXRpYyBp
bmxpbmUgaW50IG5mX2N0X2lzX2NvbmZpcm1lZChzdHJ1Y3QgbmZfY29ubiAqY3QpCkluZGV4
OiBuZXQtMi42L25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuYwo9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09Ci0tLSBuZXQtMi42Lm9yaWcvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfY29yZS5j
CTIwMDgtMDYtMTIgMTQ6NDI6MDUuMDAwMDAwMDAwICswMjAwCisrKyBuZXQtMi42L25ldC9u
ZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuYwkyMDA4LTA2LTEyIDE0OjQ1OjMxLjAwMDAw
MDAwMCArMDIwMApAQCAtNDY2LDcgKzQ2Niw4IEBACiB9CiAKIHN0cnVjdCBuZl9jb25uICpu
Zl9jb25udHJhY2tfYWxsb2MoY29uc3Qgc3RydWN0IG5mX2Nvbm50cmFja190dXBsZSAqb3Jp
ZywKLQkJCQkgICBjb25zdCBzdHJ1Y3QgbmZfY29ubnRyYWNrX3R1cGxlICpyZXBsKQorCQkJ
CSAgIGNvbnN0IHN0cnVjdCBuZl9jb25udHJhY2tfdHVwbGUgKnJlcGwsCisJCQkJICAgZ2Zw
X3QgYWxsb2NhdGlvbikKIHsKIAlzdHJ1Y3QgbmZfY29ubiAqY3QgPSBOVUxMOwogCkBAIC00
OTEsNyArNDkyLDcgQEAKIAkJfQogCX0KIAotCWN0ID0ga21lbV9jYWNoZV96YWxsb2MobmZf
Y29ubnRyYWNrX2NhY2hlcCwgR0ZQX0FUT01JQyk7CisJY3QgPSBrbWVtX2NhY2hlX3phbGxv
YyhuZl9jb25udHJhY2tfY2FjaGVwLCBhbGxvY2F0aW9uKTsKIAlpZiAoY3QgPT0gTlVMTCkg
ewogCQlwcl9kZWJ1ZygibmZfY29ubnRyYWNrX2FsbG9jOiBDYW4ndCBhbGxvYyBjb25udHJh
Y2suXG4iKTsKIAkJYXRvbWljX2RlYygmbmZfY29ubnRyYWNrX2NvdW50KTsKQEAgLTU0Myw3
ICs1NDQsNyBAQAogCQlyZXR1cm4gTlVMTDsKIAl9CiAKLQljdCA9IG5mX2Nvbm50cmFja19h
bGxvYyh0dXBsZSwgJnJlcGxfdHVwbGUpOworCWN0ID0gbmZfY29ubnRyYWNrX2FsbG9jKHR1
cGxlLCAmcmVwbF90dXBsZSwgR0ZQX0FUT01JQyk7CiAJaWYgKGN0ID09IE5VTEwgfHwgSVNf
RVJSKGN0KSkgewogCQlwcl9kZWJ1ZygiQ2FuJ3QgYWxsb2NhdGUgY29ubnRyYWNrLlxuIik7
CiAJCXJldHVybiAoc3RydWN0IG5mX2Nvbm50cmFja190dXBsZV9oYXNoICopY3Q7CkluZGV4
OiBuZXQtMi42L25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX25ldGxpbmsuYwo9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09Ci0tLSBuZXQtMi42Lm9yaWcvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfbmV0
bGluay5jCTIwMDgtMDYtMTIgMTQ6NDU6NDIuMDAwMDAwMDAwICswMjAwCisrKyBuZXQtMi42
L25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX25ldGxpbmsuYwkyMDA4LTA2LTEyIDE0OjQ1
OjUwLjAwMDAwMDAwMCArMDIwMApAQCAtMTEzMCw3ICsxMTMwLDcgQEAKIAlzdHJ1Y3QgbmZf
Y29ubl9oZWxwICpoZWxwOwogCXN0cnVjdCBuZl9jb25udHJhY2tfaGVscGVyICpoZWxwZXI7
CiAKLQljdCA9IG5mX2Nvbm50cmFja19hbGxvYyhvdHVwbGUsIHJ0dXBsZSk7CisJY3QgPSBu
Zl9jb25udHJhY2tfYWxsb2Mob3R1cGxlLCBydHVwbGUsIEdGUF9LRVJORUwpOwogCWlmIChj
dCA9PSBOVUxMIHx8IElTX0VSUihjdCkpCiAJCXJldHVybiAtRU5PTUVNOwogCg==
--------------010001070905090208030409--
