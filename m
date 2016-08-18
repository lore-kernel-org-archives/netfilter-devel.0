From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 1/2] netfilter: nfnetlink_acct: fix race between nfacct
 del and xt_nfacct destroy
Date: Thu, 18 Aug 2016 18:41:12 +0800
Message-ID: <CAML_gOd71QecZabEgSz+YcGGsv66hJPZezudpt4YMp+WErUcnw@mail.gmail.com>
References: <1471101182-15294-1-git-send-email-zlpnobody@163.com>
 <20160817222634.GA2798@salvia> <20160817223741.GA5476@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=94eb2c122a9a891a56053a5638c0
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:35580 "EHLO
	mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbcHRKlO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Aug 2016 06:41:14 -0400
Received: by mail-ua0-f193.google.com with SMTP id 109so2896530uat.2
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 03:41:14 -0700 (PDT)
In-Reply-To: <20160817223741.GA5476@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--94eb2c122a9a891a56053a5638c0
Content-Type: text/plain; charset=UTF-8

Hi Pablo,

2016-08-18 6:37 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
>
> Wait. I noticed we have the same problem in cttimeout, so it would be
> good to fix this in the same logical change.
>
> I'm attaching your original patch that I have mangled here, including
> the cttimeout chunk.
>
> Let me know if you have any concern, otherwise I'll apply this new
> version, thanks!

Not exactly right.

Currently ctnl_timeout_try_del will not cause race with ctnl_timeout_put.
In ctnl_timeout_put, it only decreases the timeout object's refcnt,
but will not try to free it. This is different with nfnetlink_acct.

But when we do "ip netns del xxx", this will cause a use after free error.
In general, when we delete a netns, cttimeout_net_exit will be called
before ipt_unregister_table, i.e. before ctnl_timeout_put.

So after call kfree_rcu in cttimeout_net_exit, we will still decrease
the timeout object's refcnt in ctnl_timeout_put. Kernel will complain
about this:

  =======================================================================
  BUG kmalloc-96 (Tainted: G    B       E  ): Poison overwritten
  -----------------------------------------------------------------------
  INFO: 0xffff88002b5161e8-0xffff88002b5161e8. First byte 0x6a instead of
  0x6b
  INFO: Allocated in cttimeout_new_timeout+0xd4/0x240 [nfnetlink_cttimeout]
  age=104 cpu=0 pid=3330
  ___slab_alloc+0x4da/0x540
  __slab_alloc+0x20/0x40
  __kmalloc+0x1c8/0x240
  cttimeout_new_timeout+0xd4/0x240 [nfnetlink_cttimeout]
  nfnetlink_rcv_msg+0x21a/0x230 [nfnetlink]

So I think it seems better that we take another patch to fix the
problem in cttimeout.

Attachment is my patch.

--94eb2c122a9a891a56053a5638c0
Content-Type: application/octet-stream;
	name="0001-netfilter-cttimeout-fix-use-after-free-error-when-de.patch"
Content-Disposition: attachment;
	filename="0001-netfilter-cttimeout-fix-use-after-free-error-when-de.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_is0723tf1

RnJvbSBkM2JiNDhmNzM5MTRkZjgzMTUxNmY5OWQ3NzViNDU0MjU5YTQwNThkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXBpbmcgWmhhbmcgPGxpcGluZy56aGFuZ0BzcHJlYWR0cnVt
LmNvbT4KRGF0ZTogVGh1LCAxOCBBdWcgMjAxNiAxNjo1ODo0NiArMDgwMApTdWJqZWN0OiBbUEFU
Q0ggbmZdIG5ldGZpbHRlcjogY3R0aW1lb3V0OiBmaXggdXNlIGFmdGVyIGZyZWUgZXJyb3Igd2hl
biBkZWxldGUKIG5ldG5zCgpJbiBnZW5lcmFsLCB3aGVuIHdlIHdhbnQgdG8gZGVsZXRlIGEgbmV0
bnMsIGN0dGltZW91dF9uZXRfZXhpdCB3aWxsCmJlIGNhbGxlZCBiZWZvcmUgaXB0X3VucmVnaXN0
ZXJfdGFibGUsIGkuZS4gYmVmb3JlIGN0bmxfdGltZW91dF9wdXQuCgpCdXQgYWZ0ZXIgY2FsbCBr
ZnJlZV9yY3UgaW4gY3R0aW1lb3V0X25ldF9leGl0LCB3ZSB3aWxsIHN0aWxsIGRlY3JlYXNlCnRo
ZSB0aW1lb3V0IG9iamVjdCdzIHJlZmNudCBpbiBjdG5sX3RpbWVvdXRfcHV0LCB0aGlzIGlzIGlu
Y29ycmVjdCwKYW5kIHdpbGwgY2F1c2UgYSB1c2UgYWZ0ZXIgZnJlZSBlcnJvci4KCkl0IGlzIGVh
c3kgdG8gcmVwcm9kdWNlIHRoaXMgcHJvYmxlbToKICAjIHdoaWxlIDogOyBkbwogIGlwIG5ldG5z
IGFkZCB4eHgKICBpcCBuZXRucyBleGVjIHh4eCBuZmN0IGFkZCB0aW1lb3V0IHRlc3R4IGluZXQg
aWNtcCB0aW1lb3V0IDIwMAogIGlwIG5ldG5zIGV4ZWMgeHh4IGlwdGFibGVzIC10IHJhdyAtcCBp
Y21wIC1JIE9VVFBVVCAtaiBDVCAtLXRpbWVvdXQgdGVzdHgKICBpcCBuZXRucyBkZWwgeHh4CiAg
ZG9uZQoKICA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQogIEJVRyBrbWFsbG9jLTk2IChUYWludGVkOiBHICAgIEIg
ICAgICAgRSAgKTogUG9pc29uIG92ZXJ3cml0dGVuCiAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KICBJTkZPOiAw
eGZmZmY4ODAwMmI1MTYxZTgtMHhmZmZmODgwMDJiNTE2MWU4LiBGaXJzdCBieXRlIDB4NmEgaW5z
dGVhZCBvZgogIDB4NmIKICBJTkZPOiBBbGxvY2F0ZWQgaW4gY3R0aW1lb3V0X25ld190aW1lb3V0
KzB4ZDQvMHgyNDAgW25mbmV0bGlua19jdHRpbWVvdXRdCiAgYWdlPTEwNCBjcHU9MCBwaWQ9MzMz
MAogIF9fX3NsYWJfYWxsb2MrMHg0ZGEvMHg1NDAKICBfX3NsYWJfYWxsb2MrMHgyMC8weDQwCiAg
X19rbWFsbG9jKzB4MWM4LzB4MjQwCiAgY3R0aW1lb3V0X25ld190aW1lb3V0KzB4ZDQvMHgyNDAg
W25mbmV0bGlua19jdHRpbWVvdXRdCiAgbmZuZXRsaW5rX3Jjdl9tc2crMHgyMWEvMHgyMzAgW25m
bmV0bGlua10KICBbIC4uLiBdCgpTbyBvbmx5IHdoZW4gdGhlIHJlZmNudCBkZWNyZWFzZWQgdG8g
MCwgd2UgY2FsbCBrZnJlZV9yY3UgdG8gZnJlZSB0aGUKdGltZW91dCBvYmplY3QuIEFuZCBsaWtl
IG5mbmV0bGlua19hY2N0IGRvLCB1c2UgYXRvbWljX2NtcHhjaGcgdG8KYXZvaWQgcmFjZSBiZXR3
ZWVuIGN0bmxfdGltZW91dF90cnlfZGVsIGFuZCBjdG5sX3RpbWVvdXRfcHV0LgoKU2lnbmVkLW9m
Zi1ieTogTGlwaW5nIFpoYW5nIDxsaXBpbmcuemhhbmdAc3ByZWFkdHJ1bS5jb20+Ci0tLQogbmV0
L25ldGZpbHRlci9uZm5ldGxpbmtfY3R0aW1lb3V0LmMgfCAxNiArKysrKysrKysrLS0tLS0tCiAx
IGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9uZXQvbmV0ZmlsdGVyL25mbmV0bGlua19jdHRpbWVvdXQuYyBiL25ldC9uZXRmaWx0ZXIv
bmZuZXRsaW5rX2N0dGltZW91dC5jCmluZGV4IDRjZGNkOTYuLjY4MjE2Y2QgMTAwNjQ0Ci0tLSBh
L25ldC9uZXRmaWx0ZXIvbmZuZXRsaW5rX2N0dGltZW91dC5jCisrKyBiL25ldC9uZXRmaWx0ZXIv
bmZuZXRsaW5rX2N0dGltZW91dC5jCkBAIC0zMzAsMTYgKzMzMCwxNiBAQCBzdGF0aWMgaW50IGN0
bmxfdGltZW91dF90cnlfZGVsKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IGN0bmxfdGltZW91dCAq
dGltZW91dCkKIHsKIAlpbnQgcmV0ID0gMDsKIAotCS8qIHdlIHdhbnQgdG8gYXZvaWQgcmFjZXMg
d2l0aCBuZl9jdF90aW1lb3V0X2ZpbmRfZ2V0LiAqLwotCWlmIChhdG9taWNfZGVjX2FuZF90ZXN0
KCZ0aW1lb3V0LT5yZWZjbnQpKSB7CisJLyogV2Ugd2FudCB0byBhdm9pZCByYWNlcyB3aXRoIGN0
bmxfdGltZW91dF9wdXQuIFNvIG9ubHkgd2hlbiB0aGUKKwkgKiBjdXJyZW50IHJlZmNudCBpcyAx
LCB3ZSBkZWNyZWFzZSBpdCB0byAwLgorCSAqLworCWlmIChhdG9taWNfY21weGNoZygmdGltZW91
dC0+cmVmY250LCAxLCAwKSA9PSAxKSB7CiAJCS8qIFdlIGFyZSBwcm90ZWN0ZWQgYnkgbmZubCBt
dXRleC4gKi8KIAkJbGlzdF9kZWxfcmN1KCZ0aW1lb3V0LT5oZWFkKTsKIAkJbmZfY3RfbDRwcm90
b19wdXQodGltZW91dC0+bDRwcm90byk7CiAJCWN0bmxfdW50aW1lb3V0KG5ldCwgdGltZW91dCk7
CiAJCWtmcmVlX3JjdSh0aW1lb3V0LCByY3VfaGVhZCk7CiAJfSBlbHNlIHsKLQkJLyogc3RpbGwg
aW4gdXNlLCByZXN0b3JlIHJlZmVyZW5jZSBjb3VudGVyLiAqLwotCQlhdG9taWNfaW5jKCZ0aW1l
b3V0LT5yZWZjbnQpOwogCQlyZXQgPSAtRUJVU1k7CiAJfQogCXJldHVybiByZXQ7CkBAIC01NDMs
NyArNTQzLDkgQEAgZXJyOgogCiBzdGF0aWMgdm9pZCBjdG5sX3RpbWVvdXRfcHV0KHN0cnVjdCBj
dG5sX3RpbWVvdXQgKnRpbWVvdXQpCiB7Ci0JYXRvbWljX2RlYygmdGltZW91dC0+cmVmY250KTsK
KwlpZiAoYXRvbWljX2RlY19hbmRfdGVzdCgmdGltZW91dC0+cmVmY250KSkKKwkJa2ZyZWVfcmN1
KHRpbWVvdXQsIHJjdV9oZWFkKTsKKwogCW1vZHVsZV9wdXQoVEhJU19NT0RVTEUpOwogfQogI2Vu
ZGlmIC8qIENPTkZJR19ORl9DT05OVFJBQ0tfVElNRU9VVCAqLwpAQCAtNTkxLDcgKzU5Myw5IEBA
IHN0YXRpYyB2b2lkIF9fbmV0X2V4aXQgY3R0aW1lb3V0X25ldF9leGl0KHN0cnVjdCBuZXQgKm5l
dCkKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoY3VyLCB0bXAsICZuZXQtPm5mY3RfdGltZW91
dF9saXN0LCBoZWFkKSB7CiAJCWxpc3RfZGVsX3JjdSgmY3VyLT5oZWFkKTsKIAkJbmZfY3RfbDRw
cm90b19wdXQoY3VyLT5sNHByb3RvKTsKLQkJa2ZyZWVfcmN1KGN1ciwgcmN1X2hlYWQpOworCisJ
CWlmIChhdG9taWNfZGVjX2FuZF90ZXN0KCZjdXItPnJlZmNudCkpCisJCQlrZnJlZV9yY3UoY3Vy
LCByY3VfaGVhZCk7CiAJfQogfQogCi0tIAoyLjUuNQoK
--94eb2c122a9a891a56053a5638c0--
