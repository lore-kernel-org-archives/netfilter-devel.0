From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH] tests/shell: unload modules between tests
Date: Fri, 18 Mar 2016 09:41:31 +0100
Message-ID: <CAOkSjBi7-XMcjZkc9N=RD9SsSZ4Xhc7TuNyA7vw5q0mbWRvfXw@mail.gmail.com>
References: <145820368731.17259.3174729391842967272.stgit@r2d2.cica.es> <56EAF119.3070009@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b6d9514ef1b84052e4eb738
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37597 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbcCRIlx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 04:41:53 -0400
Received: by mail-wm0-f41.google.com with SMTP id p65so26649304wmp.0
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 01:41:52 -0700 (PDT)
In-Reply-To: <56EAF119.3070009@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--047d7b6d9514ef1b84052e4eb738
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 17 March 2016 at 19:02, Piyush Pangtey <gokuvsvegita@gmail.com> wrote:
> I'm getting nonzero return code(1) by this last kernel_cleanup call, mayb=
e.
>

Hi Piyush,

find attached a patch, please test it and let me know.

best regards.

--=20
Arturo Borrero Gonz=C3=A1lez

--047d7b6d9514ef1b84052e4eb738
Content-Type: text/x-patch; charset=US-ASCII; name="tests-shell-run-tests-sh-force.patch"
Content-Disposition: attachment;
	filename="tests-shell-run-tests-sh-force.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ilxgheky0

dGVzdHMvc2hlbGwvcnVuLXRlc3RzLnNoOiB0dW5lIGtlcm5lbCBjbGVhbnVwCgpGcm9tOiBBcnR1
cm8gQm9ycmVybyBHb256YWxleiA8YXJ0dXJvLmJvcnJlcm8uZ2xlekBnbWFpbC5jb20+CgpUaGUg
bW9kcHJvYmUgY2FsbCBjYW4gcmV0dXJuICE9IDAgaWYsIGZvciBleGFtcGxlLCBhIG1vZHVsZSB3
YXMgYnVpbHRpbiBhbmQKd2UgYXJlIHRyaXlpbmcgdG8gcmVtb3ZlIGl0LCBzbyBmb3JjZSByZXR1
cm4gY29kZSBvZiAwIGF0IHRoZSBlbmQgb2YgdGhlCnNjcmlwdC4KClRoaXMgcGF0Y2ggYWxzbyBh
ZGRzIHRoZSAnLWEnIHN3aXRjaCB0byBtb2Rwcm9iZSBzbyBpdCBkb2Vzbid0IHN0b3AgdW5sb2Fk
aW5nCm1vZHVsZXMgaWYgb25lIG9mIHRoZW0gZmFpbHMgKGZvciBleGFtcGxlLCBpdCB3YXMgYnVp
bHRpbikuCgpXaGlsZSBhdCBpdCwgZml4IHNldmVyYWwgbW9kdWxlIG5hbWVzLCBmb3IgZXhhbXBs
ZTogJ25mdF9icmlkZ2VfcmVqZWN0JyB2cwonbmZ0X3JlamVjdF9icmlkZ2UnLCBkZWxldGUgYm9n
dXMgbW9kdWxlIG5hbWVzLgoKUmVwb3J0ZWQtYnk6IFBpeXVzaCBQYW5ndGV5IDxnb2t1dnN2ZWdp
dGFAZ21haWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBBcnR1cm8gQm9ycmVybyBHb256YWxleiA8YXJ0
dXJvLmJvcnJlcm8uZ2xlekBnbWFpbC5jb20+Ci0tLQogdGVzdHMvc2hlbGwvcnVuLXRlc3RzLnNo
IHwgICAxMSArKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS90ZXN0cy9zaGVsbC9ydW4tdGVzdHMuc2ggYi90ZXN0
cy9zaGVsbC9ydW4tdGVzdHMuc2gKaW5kZXggYzA4YTNlYi4uNjIwZmU1NyAxMDA3NTUKLS0tIGEv
dGVzdHMvc2hlbGwvcnVuLXRlc3RzLnNoCisrKyBiL3Rlc3RzL3NoZWxsL3J1bi10ZXN0cy5zaApA
QCAtNDgsMTUgKzQ4LDEzIEBAIGZpCiAKIGtlcm5lbF9jbGVhbnVwKCkgewogCSRORlQgZmx1c2gg
cnVsZXNldAotCSRNT0RQUk9CRSAtcnEgXAotCW5mdF9yZWplY3RfaXB2NCBuZnRfcmVqZWN0X2lw
djYgbmZ0X2JyaWRnZV9yZWplY3QgXAotCW5mdF9yZWplY3RfaXB2NiBuZnRfcmVqZWN0IFwKKwkk
TU9EUFJPQkUgLXJhcSBcCisJbmZ0X3JlamVjdF9pcHY0IG5mdF9yZWplY3RfYnJpZGdlIG5mdF9y
ZWplY3RfaXB2NiBuZnRfcmVqZWN0IFwKIAluZnRfcmVkaXJfaXB2NCBuZnRfcmVkaXJfaXB2NiBu
ZnRfcmVkaXIgXAotCW5mdF9kdXBfaXB2NCBuZnRfZHVwX2lwdjYgbmZ0X2R1cCBcCi0JbmZ0X25h
dF9pcHY0IG5mdF9uYXRfaXB2NiBuZnRfbmF0IFwKKwluZnRfZHVwX2lwdjQgbmZ0X2R1cF9pcHY2
IG5mdF9kdXAgbmZ0X25hdCBcCiAJbmZ0X21hc3FfaXB2NCBuZnRfbWFzcV9pcHY2IG5mdF9tYXNx
IFwKIAluZnRfZXh0aGRyIG5mdF9wYXlsb2FkIG5mdF9jbXAgXAotCW5mdF9tZXRhIG5mdF9icmlk
Z2VfbWV0YSBuZnRfY291bnRlciBuZnRfbG9nIG5mdF9saW1pdCBcCisJbmZ0X21ldGEgbmZ0X21l
dGFfYnJpZGdlIG5mdF9jb3VudGVyIG5mdF9sb2cgbmZ0X2xpbWl0IFwKIAluZnRfaGFzaCBuZnRf
cmJ0cmVlIG5mdF9jdCBuZnRfY29tcGF0IFwKIAluZl90YWJsZXNfaW5ldCBuZl90YWJsZXNfYnJp
ZGdlIG5mX3RhYmxlc19hcnAgXAogCW5mX3RhYmxlc19pcHY0IG5mX3RhYmxlc19pcHY2IG5mX3Rh
YmxlcwpAQCAtOTEsMyArODksNCBAQCBlY2hvICIiCiBtc2dfaW5mbyAicmVzdWx0czogW09LXSAk
b2sgW0ZBSUxFRF0gJGZhaWxlZCBbVE9UQUxdICQoKG9rK2ZhaWxlZCkpIgogCiBrZXJuZWxfY2xl
YW51cAorZXhpdCAwCg==
--047d7b6d9514ef1b84052e4eb738--
