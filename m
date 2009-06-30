From: Nishit Shah <nsshah.82@gmail.com>
Subject: Re: arptables ruleset not working when compiling on
	fedora6,7,8/centos 5/redhat 5
Date: Tue, 30 Jun 2009 13:38:40 +0530
Message-ID: <b2d58cb80906300108q2ee5a060gf8013a88560d8820@mail.gmail.com>
References: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>
	 <56378e320906290721i63f969edm90aed19619decf71@mail.gmail.com>
	 <b2d58cb80906290751j7fb3976bx9d04fed852c8b451@mail.gmail.com>
	 <4A48D6AD.4010005@trash.net>
	 <b2d58cb80906290818t66616f70k2fe7596b906a8a4e@mail.gmail.com>
	 <4A48E14A.3060708@trash.net>
	 <b2d58cb80906290918q2da5af1ap87772755b3363032@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0cd2296482d914046d8c50e0
Cc: jengelh@medozas.de, Richard Horton <arimus.uk@googlemail.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:4064 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZF3IIh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:08:37 -0400
In-Reply-To: <b2d58cb80906290918q2da5af1ap87772755b3363032@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--000e0cd2296482d914046d8c50e0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2009 at 9:48 PM, Nishit Shah<nsshah.82@gmail.com> wrote:
> On Mon, Jun 29, 2009 at 9:14 PM, Patrick McHardy<kaber@trash.net> wrote:
>> Nishit Shah wrote:
>>>
>>> On Mon, Jun 29, 2009 at 8:28 PM, Patrick McHardy<kaber@trash.net> wrote=
:
>>>>
>>>> Nishit Shah wrote:
>>>>>
>>>>> On Mon, Jun 29, 2009 at 7:51 PM, Richard
>>>>> Horton<arimus.uk@googlemail.com>
>>>>> wrote:
>>>>>>
>>>>>> 2009/6/29 Nishit Shah <nsshah.82@gmail.com>:
>>>>>>>
>>>>>>> Hi,
>>>>>>> =A0 =A0 =A0 I am compiling arptables-v0.0.3-3/arptables-v0.0.3-2 on
>>>>>>> fedora6,7,8/centos 5/redhat 5. Module is compiled successfully.
>>>>>>> Following are the simple steps.
>>>>
>>>> Which kernel versions (the lowest) are these running?
>>>>
>>>
>>> lowest is 2.6.18.
>>
>> Ah, I remember, we had some breakage with of the ARPT codes with the
>> introduction of x_tables in 2.6.16. Please try to figure out the
>> difference of those values between working and non-working state
>> (ARPT_CONTINUE, ARPT_RETURN etc.)
>>
>
> Bingo !!!
>
> It is due to the value of ARPT_RETURN. ARPT_RETURN defined in
> arptables-v0.0.3-3 is
>
> ./include/linux/netfilter_arp/arp_tables.h:#define ARPT_RETURN
> (-NF_MAX_VERDICT - 1)
>
> and value of NF_MAX_VERDICT is different on machine running with gcc
> 2.96/glibc 2.2.4 and above all machines.
>
> value of NF_MAX_VERDICT on machine running gcc 2.96 and glibc 2.2.4,
>
> =A0 =A0 =A0 =A0/usr/include/linux/netfilter.h:#define NF_MAX_VERDICT NF_R=
EPEAT
>
> and same file on all above machines,
>
> =A0 =A0 =A0 =A0/usr/include/linux/netfilter.h:#define NF_MAX_VERDICT NF_S=
TOP
>
> Thanks Patrick :)
>
> Rgds,
> Nishit Shah.
>

I am adding the patch for the same.

Rgds,
Nishit Shah.

--000e0cd2296482d914046d8c50e0
Content-Type: application/octet-stream; name="arpt-return-fix.patch"
Content-Disposition: attachment; filename="arpt-return-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwkcag8e0

ZGlmZiAtUGF1ciBhcnB0YWJsZXMtdjAuMC4zLTMvaW5jbHVkZS9hcnBfdGFibGVzLmggYXJwdGFi
bGVzLXYwLjAuMy0zLXRtcC9pbmNsdWRlL2FycF90YWJsZXMuaAotLS0gYXJwdGFibGVzLXYwLjAu
My0zL2luY2x1ZGUvYXJwX3RhYmxlcy5oCTIwMDctMDgtMTkgMTg6MzQ6NTEuMDAwMDAwMDAwICsw
NTMwCisrKyBhcnB0YWJsZXMtdjAuMC4zLTMtdG1wL2luY2x1ZGUvYXJwX3RhYmxlcy5oCTIwMDkt
MDYtMzAgMTI6Mzg6MjIuMDAwMDAwMDAwICswNTMwCkBAIC0xNTQsNyArMTU0LDcgQEAKICNkZWZp
bmUgQVJQVF9DT05USU5VRSAweEZGRkZGRkZGCiAKIC8qIEZvciBzdGFuZGFyZCB0YXJnZXQgKi8K
LSNkZWZpbmUgQVJQVF9SRVRVUk4gKC1ORl9NQVhfVkVSRElDVCAtIDEpCisjZGVmaW5lIEFSUFRf
UkVUVVJOICgtTkZfUkVQRUFUIC0gMSkKIAogLyogVGhlIGFyZ3VtZW50IHRvIEFSUFRfU09fR0VU
X0lORk8gKi8KIHN0cnVjdCBhcnB0X2dldGluZm8KZGlmZiAtUGF1ciBhcnB0YWJsZXMtdjAuMC4z
LTMvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfYXJwL2FycF90YWJsZXMuaCBhcnB0YWJsZXMtdjAu
MC4zLTMtdG1wL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2FycC9hcnBfdGFibGVzLmgKLS0tIGFy
cHRhYmxlcy12MC4wLjMtMy9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9hcnAvYXJwX3RhYmxlcy5o
CTIwMDctMDgtMTkgMTg6MzY6MDEuMDAwMDAwMDAwICswNTMwCisrKyBhcnB0YWJsZXMtdjAuMC4z
LTMtdG1wL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2FycC9hcnBfdGFibGVzLmgJMjAwOS0wNi0z
MCAxMjozODoxMS4wMDAwMDAwMDAgKzA1MzAKQEAgLTE1NCw3ICsxNTQsNyBAQAogI2RlZmluZSBB
UlBUX0NPTlRJTlVFIDB4RkZGRkZGRkYKIAogLyogRm9yIHN0YW5kYXJkIHRhcmdldCAqLwotI2Rl
ZmluZSBBUlBUX1JFVFVSTiAoLU5GX01BWF9WRVJESUNUIC0gMSkKKyNkZWZpbmUgQVJQVF9SRVRV
Uk4gKC1ORl9SRVBFQVQgLSAxKQogCiAvKiBUaGUgYXJndW1lbnQgdG8gQVJQVF9TT19HRVRfSU5G
TyAqLwogc3RydWN0IGFycHRfZ2V0aW5mbwo=
--000e0cd2296482d914046d8c50e0--
