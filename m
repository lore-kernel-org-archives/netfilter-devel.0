From: "Changli Gao" <xiaosuo@gmail.com>
Subject: Re: Fwd: [PATCH] nf_nat_core: eliminate find_appropriate_src call if range is set IP_NAT_RANGE_PROTO_RANDOM bit on
Date: Tue, 8 Jul 2008 10:50:59 +0800
Message-ID: <412e6f7f0807071950r1d64ad4dn1fd1cc3065e27a5c@mail.gmail.com>
References: <412e6f7f0806292132l18c747d6h982c64ce7c9d9c85@mail.gmail.com>
	 <412e6f7f0806300100t6bc37635pc922405705f1784d@mail.gmail.com>
	 <4868D76D.6050008@trash.net>
	 <412e6f7f0806300634g1d82ffcewd3ba7ef0b951cd1a@mail.gmail.com>
	 <4871FCFE.1020202@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_6241_21872235.1215485459504"
Cc: netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:63518 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbYGHCvD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 22:51:03 -0400
Received: by ti-out-0910.google.com with SMTP id b6so656252tic.23
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Jul 2008 19:50:59 -0700 (PDT)
In-Reply-To: <4871FCFE.1020202@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

------=_Part_6241_21872235.1215485459504
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The attachment is the patch.

On Mon, Jul 7, 2008 at 7:24 PM, Patrick McHardy <kaber@trash.net> wrote:
> Changli Gao wrote:
>>
>> On Mon, Jun 30, 2008 at 8:54 PM, Patrick McHardy <kaber@trash.net> wrote:
>>>
>>> Changli Gao wrote:
>>>>
>>>> ---------- Forwarded message ----------
>>>> From: Changli Gao <xiaosuo@gmail.com>
>>>> Date: 2008/6/30
>>>> Subject: [PATCH] nf_nat_core: eliminate find_appropriate_src call if
>>>> range is set IP_NAT_RANGE_PROTO_RANDOM bit on
>>>> To: netfilter-devel@lists.netfilter.org
>>>> Cc: Changli Gao <xiaosuo@gmail.com>
>>>>
>>>>
>>>> Eliminate find_appropriate_src call if range is set
>>>> IP_NAT_RANGE_PROTO_RANDOM bit on.
>>>
>>> Please explain why the call isn't necessary.
>>>
>> In fact, my patch doesn't change the logic of the code, it just
>> eliminates the uesless call find_appropriate_src. Because the tuple
>> returned by find_appropriate is only useful when the
>> IP_NAT_RANGE_PROTO_RANDOM isn't set on.  instead of testing the bit
>> IP_NAT_RANGE_PROTO_RANDOM after calling find_appropriate_src, I do
>> that before it to eliminate the cost of calling find_appropriate_src.
>
> OK, but it does not apply cleanly because of whitespace mangling.
> Please resend as attachment.
>



-- 
Regards，
Changli Gao(xiaosuo@gmail.com)

------=_Part_6241_21872235.1215485459504
Content-Type: application/octet-stream; name=nf_nat_core_opt.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fidwm7uk0
Content-Disposition: attachment; filename=nf_nat_core_opt.diff

LS0tIGxpbnV4L25ldC9pcHY0L25ldGZpbHRlci9uZl9uYXRfY29yZS5jCTIwMDgtMDYtMzAgMTE6
MTI6MjYuMDAwMDAwMDAwICswODAwCisrKyBsaW51eC1uZXcvbmV0L2lwdjQvbmV0ZmlsdGVyL25m
X25hdF9jb3JlLmMJMjAwOC0wNi0zMCAxMjoyMjoyMy4wMDAwMDAwMDAgKzA4MDAKQEAgLTI0MCwx
MiArMjQwLDEyIEBACiAJICAgVGhpcyBpcyBvbmx5IHJlcXVpcmVkIGZvciBzb3VyY2UgKGllLiBO
QVQvbWFzcSkgbWFwcGluZ3MuCiAJICAgU28gZmFyLCB3ZSBkb24ndCBkbyBsb2NhbCBzb3VyY2Ug
bWFwcGluZ3MsIHNvIG11bHRpcGxlCiAJICAgbWFuaXBzIG5vdCBhbiBpc3N1ZS4gICovCi0JaWYg
KG1hbmlwdHlwZSA9PSBJUF9OQVRfTUFOSVBfU1JDKSB7CisJaWYgKG1hbmlwdHlwZSA9PSBJUF9O
QVRfTUFOSVBfU1JDICYmCisJICAgICEocmFuZ2UtPmZsYWdzICYgSVBfTkFUX1JBTkdFX1BST1RP
X1JBTkRPTSkpIHsKIAkJaWYgKGZpbmRfYXBwcm9wcmlhdGVfc3JjKG9yaWdfdHVwbGUsIHR1cGxl
LCByYW5nZSkpIHsKIAkJCXByX2RlYnVnKCJnZXRfdW5pcXVlX3R1cGxlOiBGb3VuZCBjdXJyZW50
IHNyYyBtYXBcbiIpOwotCQkJaWYgKCEocmFuZ2UtPmZsYWdzICYgSVBfTkFUX1JBTkdFX1BST1RP
X1JBTkRPTSkpCi0JCQkJaWYgKCFuZl9uYXRfdXNlZF90dXBsZSh0dXBsZSwgY3QpKQotCQkJCQly
ZXR1cm47CisJCQlpZiAoIW5mX25hdF91c2VkX3R1cGxlKHR1cGxlLCBjdCkpCisJCQkJcmV0dXJu
OwogCQl9CiAJfQogCg==
------=_Part_6241_21872235.1215485459504--
