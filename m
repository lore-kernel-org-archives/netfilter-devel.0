Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAFA3AA50A
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 06:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791269713; cv=pass; b=CWTtnxQ+Z2TJRVnYm7tgJZrQx2hukWYbAgGAXUdMZpwH0jOshUCaIjfFaKfkY3PrwCQL4x8k6rjnFQMxEddhLFrF0fmbu8Slv6v9lN/lV86XSfR3pmweC5hO4BzpNHJPiKMZqPXoEixoM3KM96ulzJJFkus+UzEa+uJls0Qbe9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791269713; c=relaxed/simple;
	bh=RqB2yGqdzKFEgXjhHIwd+aQbFWqhaTJjYOr226NpJ/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gx8ed2QOPKzWW6JwN2QXLcVD358Qq20yIyoTCTwIcEKWcOP4CIlV08B8j0J8bL71OCEWkA3o3b4SMwQHXR9z1L3hpc7i5nroUpXItnQyOr4GHdJfRoUuV9s8M9w8gU8gQlH2P23JWsTvlTbDHugWfjIHR3gEEB/Zg2VguG2uCaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SfIyg5Kw; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SfIyg5Kw"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6afa651700eso490281a12.2
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2026 23:55:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791269708; cv=none;
        d=google.com; s=arc-20260327;
        b=iVJdbak0opjGaL2VA/KKKG3RkXGhj4o8ZCTAc/DfhbqpGbjHKu7R2WIop4MaQ6rqv6
         HU1blc6CDgOlGrHrBoR2Y81wvdPKEv0WUiRhNBjVmjpcY0xW1wFGOUmb0XrareDFjJam
         R0CnYFw8j2+UujmD8lDYEXG34nO0CONukpIGmwdOlBl6hYHxhk7RsqBXe3QjOF0/XvMU
         OaSPh22XeSy18AvfJEWtMsx2x5JvNlVB+EnvsAzc7cCBHqWDMgOtb7nsmkU+hynKuDCV
         YQLQE17BjBdx6vycKQMgZuRhDI9VLlqz0fshjMUX2HwD3inYY0tjem0XUZiQetTzqj1n
         EUxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=n0KFHAoUlkbus3zAE1BEMvXKDx48kJxczsUI2dPHxAE=;
        fh=vt2H3quRWD2oup/jbDk+ceRr5j3XTo6++qnNOn4fxyg=;
        b=LRQJTp6oeHXgH24S1u2iBYihhu+niuAhcSEATJcg2z3Xx3ZOKbXKuxGzppAQ0m2SNj
         JA+1WRmC7kMrthqnbTpg2Z15qYOJj2n3Nhuq11Q9ILfUhgZrIZEvtPxuyM21AngeXBUb
         FxY9fvAgtYhxNvAEBmcW4TJPb/mg8OIk+al3MT1RwUHkZmV4YVY6HvqtDrWUJC85DlAS
         XnXbATO6rnjkBJQDJDzof96nv/kTnbovPWq1ol2ZqynkYHHOJKPJPwQ4IxcBoi1t5POY
         LXSddDzNNAUmQPGi9ej7ziad7t/AYVAFml2C+IUCMhuu2g/wWDZ7dcylwTzC9IPLzoth
         tYkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791269708; x=1791874508; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n0KFHAoUlkbus3zAE1BEMvXKDx48kJxczsUI2dPHxAE=;
        b=SfIyg5KwCAr6Ooc17Wc/8lKry7sB/vxp10f2DvWH1Z3YFVe4ohqBeDrpZfrs7A+o7q
         uTPAiljDMH3naAsSxczFs4UU/TVk5aMLBURTpVlNGM2/0AQEaCCB6tXWatEB2ssTHlQh
         u/r2lKcsty145tldGUVpKuZU8feXnaV1AViJFTdZd5yCRtdVn8zpyQbkpiRL0bmOUFIh
         MH0VNIUl/mYEmEVGoVv3sPZZol4u8XMltsCIQGaXV55RX1H7mF3yzYwLJ5XctlcmYDyf
         132i/GHBsSbnu1G7lDaBZU8TTdHzOOfEqGYS5YVVwNM6EP4jQKb+AMovEJfoFJm+OQYs
         NV1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791269708; x=1791874508;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n0KFHAoUlkbus3zAE1BEMvXKDx48kJxczsUI2dPHxAE=;
        b=pGIdAaNxHCXKXYF0MTLZInAzQL/gEMPMzTvhXPqPU7GLUUpZ/5X0w6gUjOjmhTb6D3
         KvKiIbEopP3/X1K84d2QqPfGfjhM6n+WasZTOC87Ph5ZCbW3WEHJQHUyBmJJttuOlBgJ
         ad/1HhotpzzQJ56EUYpK6kJo3tBzxiLZuO3jb1VNaZ9uRr2npzNYWBOHn5yjjELKHGFi
         Bt0TvjUrgJ2CKbQA1kXDgZII+mxUHMFDLQCNSx5FsbJTEhCH/K5oFBmA2IPPO/zxac97
         0qcvgQXrSVXckD6/yPrLDk+OlRFKOvPFPjmW0ktB8k4948zv7sgxDgrrZecqh8yK0k1g
         XCew==
X-Forwarded-Encrypted: i=1; AKwUvByZM/8B6w43Xpf4eXBVrheuNuKBnrbPSHwyfF8sK8tu0det8rOTbD4Y50Vl8TP+Ghy//1mBjd1DM3I8635B45o=@vger.kernel.org
X-Gm-Message-State: AFq9FYL/3zA1Rxje1j+3d17CBR4E0TNhmuKCka+YCGcLAQiWI9l0qdbW
	I2uko8ndq0gqgXGqOBXu87ydWmKz+I+ULGLkyqv241QvKyRS9wd3xBPnl9iyyB0Hvd+KqDn8B9R
	zmyLDZVWqw2KKdHpnENmCaKk9YHBjt8I=
X-Gm-Gg: AYBFou13Dx2KHKGk2f0Qnp6eboxdeJ0l7A1UOLcH4qhMzcqRa/wckZwCATa+63QYLrM
	cNDSg1/e9RbUwy9I6EfDUk8lpNwz671Yj5HC/BsuEVi4Ytf6upHGgzpi9OYwxwg51iPgPszBkC4
	gNB5+lC+mljibAlkmk0IkQNUkMlMHHkN0oGzspFx3bHOr3SuLIhSD9mrwysBeOKYX/waDMA2qM0
	XgsaK8KcLA8GuJRNUFe94y7vNk/ehx5vEjmL0xZdUjD750nslICSQFvn9TEESaUy1ZEvQj1a9sM
	mb8kZYX7ZI5DxJ8RMk8sMtm9LXMmPO5sRRB5bZivoj2N8kfQGYen7gIHD7WMhuNKxc8=
X-Received: by 2002:a05:6402:2811:b0:6ac:94cf:9f2e with SMTP id
 4fb4d7f45d1cf-6afe29a9f12mr459844a12.13.1791269708098; Mon, 05 Oct 2026
 23:55:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHeizqGJ6WpknaU=WE+PB2A09jWi==-sUUgmc36qgStVDRdSLQ@mail.gmail.com>
In-Reply-To: <CAHeizqGJ6WpknaU=WE+PB2A09jWi==-sUUgmc36qgStVDRdSLQ@mail.gmail.com>
From: Subham Pal <subhampal789@gmail.com>
Date: Tue, 6 Oct 2026 12:24:54 +0530
X-Gm-Features: AclHuK8TyziJLreAFopSk65jnfmukaSzcAmarsHWLzj4F7rZbbrlst_zv_uhOks
Message-ID: <CAHeizqHTKneQUtcSr6k5HmNk+-WQmzK1jDVLFmwTTndUPugPcQ@mail.gmail.com>
Subject: [PATCH nf-next v2 2/2] netfilter: nf_conntrack_h323: check extension
 bitmap before decoding components
To: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de
Cc: phil@nwl.cc, kaber@trash.net, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org, Subham Pal <subhampal789@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000a628fc065d267a0b"

--000000000000a628fc065d267a0b
Content-Type: text/plain; charset="UTF-8"

In decode_seq(), the extension components loop iterates through bmp2_len
bits. However, it evaluates whether the component index exceeds the known
upper bound (`i >= f->ub`) and whether it contains a STOP attribute before
checking if the field is actually present in `bmp2`:

    if (i >= f->ub) {
        ...
        len = get_len(bs);
        ...
    }
    if (son->attr & STOP)
        return H323_ERROR_STOP;

    if (!((0x80000000 >> opt) & bmp2))
        continue;

If an unknown extension is marked absent in the bitmap (`bit == 0`), the
parser erroneously attempts to read a non-existent open type length from
the bitstream and advances `bs->cur` by garbage bytes. Furthermore, if a
known field has the STOP attribute but is absent from the transmission,
decoding aborts prematurely.

Move the presence bitmap check to the beginning of the loop body so absent
extensions are skipped immediately before attempting to decode or inspect
attributes. Also append a 'U' suffix to 0x80000000 to prevent signed shift
overflow.

Fixes: f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
Cc: stable@vger.kernel.org
Signed-off-by: Subham Pal <subhampal789@gmail.com>
---
 [Note: Raw patch attached to avoid webmail tab/whitespace corruption]

--000000000000a628fc065d267a0b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-netfilter-nf_conntrack_h323-check-extension-bitmap-b.patch"
Content-Disposition: attachment; 
	filename="0002-netfilter-nf_conntrack_h323-check-extension-bitmap-b.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_muwbpkyk0>
X-Attachment-Id: f_muwbpkyk0

RnJvbSA0NjgzNTYzMWU2OTQ5ZWQ5MzZhNDRjZDhlNDY0OGIxYWRmNzMwNGVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdWJoYW0gUGFsIDxzdWJoYW1wYWw3ODlAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDIyIFNlcCAyMDI2IDE2OjM1OjA4ICswNTMwClN1YmplY3Q6IFtQQVRDSCBuZi1u
ZXh0IHYyIDIvMl0gbmV0ZmlsdGVyOiBuZl9jb25udHJhY2tfaDMyMzogY2hlY2sgZXh0ZW5zaW9u
CiBiaXRtYXAgYmVmb3JlIGRlY29kaW5nIGNvbXBvbmVudHMKCkluIGRlY29kZV9zZXEoKSwgdGhl
IGV4dGVuc2lvbiBjb21wb25lbnRzIGxvb3AgaXRlcmF0ZXMgdGhyb3VnaCBibXAyX2xlbgpiaXRz
LiBIb3dldmVyLCBpdCBldmFsdWF0ZXMgd2hldGhlciB0aGUgY29tcG9uZW50IGluZGV4IGV4Y2Vl
ZHMgdGhlIGtub3duCnVwcGVyIGJvdW5kIChgaSA+PSBmLT51YmApIGFuZCB3aGV0aGVyIGl0IGNv
bnRhaW5zIGEgU1RPUCBhdHRyaWJ1dGUgYmVmb3JlCmNoZWNraW5nIGlmIHRoZSBmaWVsZCBpcyBh
Y3R1YWxseSBwcmVzZW50IGluIGBibXAyYDoKCiAgICBpZiAoaSA+PSBmLT51YikgewogICAgICAg
IC4uLgogICAgICAgIGxlbiA9IGdldF9sZW4oYnMpOwogICAgICAgIC4uLgogICAgfQogICAgaWYg
KHNvbi0+YXR0ciAmIFNUT1ApCiAgICAgICAgcmV0dXJuIEgzMjNfRVJST1JfU1RPUDsKCiAgICBp
ZiAoISgoMHg4MDAwMDAwMCA+PiBvcHQpICYgYm1wMikpCiAgICAgICAgY29udGludWU7CgpJZiBh
biB1bmtub3duIGV4dGVuc2lvbiBpcyBtYXJrZWQgYWJzZW50IGluIHRoZSBiaXRtYXAgKGBiaXQg
PT0gMGApLCB0aGUKcGFyc2VyIGVycm9uZW91c2x5IGF0dGVtcHRzIHRvIHJlYWQgYSBub24tZXhp
c3RlbnQgb3BlbiB0eXBlIGxlbmd0aCBmcm9tCnRoZSBiaXRzdHJlYW0gYW5kIGFkdmFuY2VzIGBi
cy0+Y3VyYCBieSBnYXJiYWdlIGJ5dGVzLiBGdXJ0aGVybW9yZSwgaWYgYQprbm93biBmaWVsZCBo
YXMgdGhlIFNUT1AgYXR0cmlidXRlIGJ1dCBpcyBhYnNlbnQgZnJvbSB0aGUgdHJhbnNtaXNzaW9u
LApkZWNvZGluZyBhYm9ydHMgcHJlbWF0dXJlbHkuCgpNb3ZlIHRoZSBwcmVzZW5jZSBiaXRtYXAg
Y2hlY2sgdG8gdGhlIGJlZ2lubmluZyBvZiB0aGUgbG9vcCBib2R5IHNvIGFic2VudApleHRlbnNp
b25zIGFyZSBza2lwcGVkIGltbWVkaWF0ZWx5IGJlZm9yZSBhdHRlbXB0aW5nIHRvIGRlY29kZSBv
ciBpbnNwZWN0CmF0dHJpYnV0ZXMuIEFsc28gYXBwZW5kIGEgJ1UnIHN1ZmZpeCB0byAweDgwMDAw
MDAwIHRvIHByZXZlbnQgc2lnbmVkIHNoaWZ0Cm92ZXJmbG93LgoKRml4ZXM6IGY1ODdkZTBlMmZl
YiAoIltORVRGSUxURVJdOiBuZl9jb25udHJhY2svbmZfbmF0OiBhZGQgSC4zMjMgaGVscGVyIHBv
cnQiKQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBTdWJoYW0gUGFs
IDxzdWJoYW1wYWw3ODlAZ21haWwuY29tPgotLS0KdjEgLT4gdjI6CiAgLSBSZXRhcmdldGVkIHRv
IG5mLW5leHQgcGVyIG1haW50YWluZXIgcmVxdWVzdC4KICAtIE5vIGZ1bmN0aW9uYWwgY2hhbmdl
cy4KCiBuZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX2FzbjEuYyB8IDYgKysrLS0tCiAx
IGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2gzMjNfYXNuMS5jIGIvbmV0L25ldGZpbHRl
ci9uZl9jb25udHJhY2tfaDMyM19hc24xLmMKaW5kZXggNjgzMGM5ZGEzNTA3Li41NzMxN2EyODIx
MmIgMTAwNjQ0Ci0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2gzMjNfYXNuMS5jCisr
KyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2gzMjNfYXNuMS5jCkBAIC01OTYsNiArNTk2
LDkgQEAgc3RhdGljIGludCBkZWNvZGVfc2VxKHN0cnVjdCBiaXRzdHIgKmJzLCBjb25zdCBzdHJ1
Y3QgZmllbGRfdCAqZiwKIAogCS8qIERlY29kZSB0aGUgZXh0ZW5zaW9uIGNvbXBvbmVudHMgKi8K
IAlmb3IgKG9wdCA9IDA7IG9wdCA8IGJtcDJfbGVuOyBvcHQrKywgaSsrLCBzb24rKykgeworCQlp
ZiAoISgoMHg4MDAwMDAwMFUgPj4gb3B0KSAmIGJtcDIpKQkvKiBOb3QgcHJlc2VudCAqLworCQkJ
Y29udGludWU7CisKIAkJLyogQ2hlY2sgUmFuZ2UgKi8KIAkJaWYgKGkgPj0gZi0+dWIpIHsJLyog
TmV3ZXIgVmVyc2lvbj8gKi8KIAkJCWlmIChuZl9oMzIzX2Vycm9yX2JvdW5kYXJ5KGJzLCAyLCAw
KSkKQEAgLTYxMyw5ICs2MTYsNiBAQCBzdGF0aWMgaW50IGRlY29kZV9zZXEoc3RydWN0IGJpdHN0
ciAqYnMsIGNvbnN0IHN0cnVjdCBmaWVsZF90ICpmLAogCQkJcmV0dXJuIEgzMjNfRVJST1JfU1RP
UDsKIAkJfQogCi0JCWlmICghKCgweDgwMDAwMDAwID4+IG9wdCkgJiBibXAyKSkJLyogTm90IHBy
ZXNlbnQgKi8KLQkJCWNvbnRpbnVlOwotCiAJCWlmIChuZl9oMzIzX2Vycm9yX2JvdW5kYXJ5KGJz
LCAyLCAwKSkKIAkJCXJldHVybiBIMzIzX0VSUk9SX0JPVU5EOwogCQlsZW4gPSBnZXRfbGVuKGJz
KTsKLS0gCjIuNDMuMAoK
--000000000000a628fc065d267a0b--
