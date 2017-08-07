From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: Re: [nft PATCH] mnl: Remove dead code
Date: Mon, 7 Aug 2017 18:54:48 +0200
Message-ID: <CAAaDf4umkgnqEr+mxXBCwhh+tpQ8xW8ENepMcv3aMoAdDnj7xQ@mail.gmail.com>
References: <20170726161630.12919-1-phil@nwl.cc> <20170727084646.GB5576@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="001a11445ee86c12db05562cb44e"
Cc: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37702 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751513AbdHGQyt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Aug 2017 12:54:49 -0400
Received: by mail-it0-f45.google.com with SMTP id 76so5217819ith.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Aug 2017 09:54:49 -0700 (PDT)
In-Reply-To: <20170727084646.GB5576@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--001a11445ee86c12db05562cb44e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2017-07-27 10:46 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> Cc'ing Pablo Bermudo.
>
> On Wed, Jul 26, 2017 at 06:16:30PM +0200, Phil Sutter wrote:
>> Remove the functions mnl_nft_rule_add() and *_delete() since they are
>> not used throughout the code. Commit a72315d2bad47 ("src: add rule
>> batching support") changed their only caller to use the batch variant
>> introduced at the same time.
>
> I think there are more useless functions. Pablo Bermudo mentioned this
> to me a while ago. At least I remember some of them in netlink.c?
>
> If not much asking, it would be good if we can kill them all in one go.

I am using a combination of compiler and linker options in order to obtain
a list of unused functions:

  $ make -j5 CFLAGS=3D"-ffunction-sections -fdata-sections
-Wl,--gc-sections,--print-gc-sections"

You can find more information about --gc-sections and its pitfalls here [1]=
.
The listing is printed on stderr by --print-gc-sections and it looks like t=
his:

/usr/bin/ld: Removing unused section '.text.xt_stmt_xlate' in file 'stateme=
nt.o'
/usr/bin/ld: Removing unused section '.text.xt_stmt_release' in file
'statement.o'
/usr/bin/ld: Removing unused section '.text.xt_stmt_print' in file 'stateme=
nt.o'
...

There is also a small utility called callcatcher [2], written by LibreOffic=
e
developer Caol=C3=A1n McNamara. But it seems not to be recursive, so unused
functions invoked from other unused functions are not shown until the calle=
rs
are deleted.

The complete list contains some functions that I think are not worth removi=
ng,
because are part of a "consolidated API" (e.g. those related to the
implementation of the red=E2=80=93black tree). A bunch of unused functions =
are
from the auto-generated file scanner.c.

The current list is attached.

--

[1] http://elinux.org/images/2/2d/ELC2010-gc-sections_Denys_Vlasenko.pdf
[2] http://www.skynet.ie/~caolan/Packages/callcatcher.html

--001a11445ee86c12db05562cb44e
Content-Type: application/octet-stream; name=nft-unused-code
Content-Disposition: attachment; filename=nft-unused-code
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j62e1cb00

IyBVbnVzZWQgc3RydWN0Cnh0X3N0bXRfb3BzICAgICAgICAgICAgIGluIGZpbGUgJ3N0YXRlbWVu
dC5jJwoKIyBVbnVzZWQgZnVuY3Rpb25zCmNoYWluX2dldF9jYiAgICAgICAgICAgIGluIGZpbGUg
J21ubC5jJwpjbGlfZGlzcGxheSAgICAgICAgICAgICBpbiBmaWxlICdjbGkuYycKbW5sX25mdF9j
aGFpbl9nZXQgICAgICAgaW4gZmlsZSAnbW5sLmMnCm1ubF9uZnRfcnVsZV9hZGQgICAgICAgIGlu
IGZpbGUgJ21ubC5jJwptbmxfbmZ0X3J1bGVfZGVsZXRlICAgICBpbiBmaWxlICdtbmwuYycKbW5s
X25mdF9zZXRfZ2V0ICAgICAgICAgaW4gZmlsZSAnbW5sLmMnCm1ubF9uZnRfdGFibGVfZ2V0ICAg
ICAgIGluIGZpbGUgJ21ubC5jJwptcHpfZ2V0X2JlNjQgICAgICAgICAgICBpbiBmaWxlICdnbXB1
dGlsLmMnCm5ldGxpbmtfYWRkX3J1bGVfbGlzdCAgIGluIGZpbGUgJ25ldGxpbmsuYycKbmV0bGlu
a19kdW1wX3RhYmxlICAgICAgaW4gZmlsZSAnbmV0bGluay5jJwpuZXRsaW5rX2dldF9jaGFpbiAg
ICAgICBpbiBmaWxlICduZXRsaW5rLmMnCm5ldGxpbmtfZ2V0X3NldCAgICAgICAgIGluIGZpbGUg
J25ldGxpbmsuYycKbmV0bGlua19nZXRfdGFibGUgICAgICAgaW4gZmlsZSAnbmV0bGluay5jJwpu
ZXRsaW5rX2xpc3RfY2hhaW4gICAgICBpbiBmaWxlICduZXRsaW5rLmMnCm5mdF9zZXRfbHZhbCAg
ICAgICAgICAgIGluIGZpbGUgJ3NjYW5uZXIuYycKcmJfbGFzdCAgICAgICAgICAgICAgICAgaW4g
ZmlsZSAncmJ0cmVlLmMnCnJiX3ByZXYgICAgICAgICAgICAgICAgIGluIGZpbGUgJ3JidHJlZS5j
JwpyYl9yZXBsYWNlX25vZGUgICAgICAgICBpbiBmaWxlICdyYnRyZWUuYycKc2V0X2dldF9jYiAg
ICAgICAgICAgICAgaW4gZmlsZSAnbW5sLmMnCnRhYmxlX2dldF9jYiAgICAgICAgICAgIGluIGZp
bGUgJ21ubC5jJwp4dF9zdG10X2FsbG9jICAgICAgICAgICBpbiBmaWxlICdzdGF0ZW1lbnQuYycK
eHRfc3RtdF9kZXN0cm95ICAgICAgICAgaW4gZmlsZSAnc3RhdGVtZW50LmMnCnh0X3N0bXRfcHJp
bnQgICAgICAgICAgIGluIGZpbGUgJ3N0YXRlbWVudC5jJwp4dF9zdG10X3JlbGVhc2UgICAgICAg
ICBpbiBmaWxlICdzdGF0ZW1lbnQuYycKeHRfc3RtdF94bGF0ZSAgICAgICAgICAgaW4gZmlsZSAn
c3RhdGVtZW50LmMnCgpuZnRfZ2V0X2NvbHVtbiAgICAgICAgICBpbiBmaWxlICdzY2FubmVyLmMn
Cm5mdF9nZXRfZGVidWcgICAgICAgICAgIGluIGZpbGUgJ3NjYW5uZXIuYycKbmZ0X2dldF9pbiAg
ICAgICAgICAgICAgaW4gZmlsZSAnc2Nhbm5lci5jJwpuZnRfZ2V0X2xlbmcgICAgICAgICAgICBp
biBmaWxlICdzY2FubmVyLmMnCm5mdF9nZXRfbGluZW5vICAgICAgICAgIGluIGZpbGUgJ3NjYW5u
ZXIuYycKbmZ0X2dldF9sbG9jICAgICAgICAgICAgaW4gZmlsZSAnc2Nhbm5lci5jJwpuZnRfZ2V0
X2x2YWwgICAgICAgICAgICBpbiBmaWxlICdzY2FubmVyLmMnCm5mdF9nZXRfb3V0ICAgICAgICAg
ICAgIGluIGZpbGUgJ3NjYW5uZXIuYycKbmZ0X2dldF90ZXh0ICAgICAgICAgICAgaW4gZmlsZSAn
c2Nhbm5lci5jJwpuZnRfbGV4X2luaXRfZXh0cmEgICAgICBpbiBmaWxlICdzY2FubmVyLmMnCm5m
dF9zZXRfY29sdW1uICAgICAgICAgIGluIGZpbGUgJ3NjYW5uZXIuYycKbmZ0X3NldF9pbiAgICAg
ICAgICAgICAgaW4gZmlsZSAnc2Nhbm5lci5jJwpuZnRfc2V0X2xpbmVubyAgICAgICAgICBpbiBm
aWxlICdzY2FubmVyLmMnCm5mdF9zZXRfbGxvYyAgICAgICAgICAgIGluIGZpbGUgJ3NjYW5uZXIu
YycK
--001a11445ee86c12db05562cb44e--
