Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE124168A9
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714485551; cv=none; b=gWxuWrQXcbkqDNywkY/IjTjqE+INARNNlyBvgVLa7V6f+GH3MPVwto/h9FN30Wlt8IfEGNUyglcB1m4f4Q/I4KjaxYtiQiNJ/TCnjLwWCQxxLzwAd9De93mifaKNSVTK4vb7xgA4qUPey1moZom/khusmRTYiH72Yq7bKJRQwAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714485551; c=relaxed/simple;
	bh=6HSef5lD9Euk0L9yMrFrOGun734E4Nge7g3QBg7o3YU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SAIQ/OJWbP/LAMb7L4N+Gc3e0lwJeRYGeQ2C/3432WWnFL7qk3XyrEaPXpvGw1nU8pe1FMyzwUx4FW5ARHiRSiraU1N41hztdDdClK6cevSSIvMED/Ec/54uklxCgnI0L1SGYimrHisXcvrkiKdEo+OQBgt9DhqxMBcA/Sg/fZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hbeP8OgH; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbeP8OgH"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a4702457ccbso757916266b.3
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 06:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714485548; x=1715090348; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mBHSkmiiNOqylzKpZ7XadIzhBSvWGGJJWvxi7BNnva0=;
        b=hbeP8OgH94Z9M08Pd9mRB7iyBix2XeqT/66tnSa35Qd1StX+mPymlF2bb9apATR08J
         TPMixELFNmtiyTJssQQ0B3mIoylZdyvqqbX2icpKr3/YUg2/fbxPsFQ4wF50K6jkR11P
         PqhsEaPURmwqMmEYFFsmeaIUjzh9JQpDYnR5LC915zbYFz4FN1333WVM8+nYR7ZQBh13
         OiETFoos4xL/wDSVBxSPs3MyX2S0BDQOgPF2XEkEWdSvVXwsatUImcj3eLSSA216KV9r
         Sg3iAcXZ+zHVbyoET2lpp4UZsSjDmUBqUjJurCPUmXkwgBxDKG7+jDu9QfdRS0UWWVu6
         k96Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714485548; x=1715090348;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mBHSkmiiNOqylzKpZ7XadIzhBSvWGGJJWvxi7BNnva0=;
        b=byHxyGijzEBjGGUf+liyVQKm+KPjAol46bPe7hFFG/PoOSDIEJO5JSfq2rAxaLM6ty
         yK1l3R35OFDF+eBxqTtWbVF5MFzR5jx7z/sekJSqaJ6cxg7iPkqvd3xtqNNsuRuqT+sJ
         URUxvFYiek9ERmEYhGHRjlu59f7SC/7ne6/Qhz5LKHJSG4tsG/pa1kEW+bn2AC3GFAwR
         5XckOPJqrZCesPVpJOykFDdFeYi83RreqoXEl3bvI716t8pza+1utB7g1ATqiLOSv+pC
         sZdPDZXuca0EDAAbF0RmaVA3j88bkshSGJkeac0Z03/8eOKa+WrJ4yOzsZPrChiwZsCF
         AP2Q==
X-Gm-Message-State: AOJu0YwQLjXs9rnybxfqQJqdxIZ1g8d1YmonPgmQiA+Su4DENIwpewJL
	+HNxveMHA3LzQXZBaN99BNxrRS37XvKCsxToRegLJeUzbbWOTmP+wtfag8NOTv5AZS5TilXbFBb
	+0W7JULFDOlq2Ss51BWBh71ZTDGiOfRBB
X-Google-Smtp-Source: AGHT+IHWvtWENRBt40R9xtrLPnC9Sj0xJhlelBIoxwtVcOop9oi2PAdof764oBeMSXEJqYHQxBzClk/RiHRRHSNlcqc=
X-Received: by 2002:a17:906:4903:b0:a58:98a1:8417 with SMTP id
 b3-20020a170906490300b00a5898a18417mr10553960ejq.15.1714485547955; Tue, 30
 Apr 2024 06:59:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAM9G1EADHBYk9Y-Y9RBHbAhqOPOMab41DOEh+PZZa6XKGm8drA@mail.gmail.com>
 <ZjDN2DNJNmbEv68p@orbyte.nwl.cc>
In-Reply-To: <ZjDN2DNJNmbEv68p@orbyte.nwl.cc>
From: Evgen Bendyak <jman.box@gmail.com>
Date: Tue, 30 Apr 2024 16:58:41 +0300
Message-ID: <CAM9G1EBn0m6xD1NS+4Gs7Ew-JR1QfQZJrR7xqoA5sHbR542+Bw@mail.gmail.com>
Subject: Re: [libnetfilter_log] fix bug in race condition of calling
 nflog_open from different threads at same time
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000000f15d8061750c63b"

--0000000000000f15d8061750c63b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patch file in the required format has been attached to the email.

Thanks, Evgen

=D0=B2=D1=82, 30 =D0=BA=D0=B2=D1=96=D1=82. 2024=E2=80=AF=D1=80. =D0=BE 13:5=
4 Phil Sutter <phil@nwl.cc> =D0=BF=D0=B8=D1=88=D0=B5:
>
> Evgen,
>
> On Tue, Apr 30, 2024 at 01:18:29PM +0300, Evgen Bendyak wrote:
> > This patch addresses a bug that occurs when the nflog_open function is
> > called concurrently from different threads within an application. The
> > function nflog_open internally invokes nflog_open_nfnl. Within this
> > function, a static global variable pkt_cb (static struct nfnl_callback
> > pkt_cb) is used. This variable is assigned a pointer to a newly
> > created structure (pkt_cb.data =3D h;) and is passed to
> > nfnl_callback_register. The issue arises with concurrent execution of
> > pkt_cb.data =3D h;, as only one of the simultaneously created
> > nflog_handle structures is retained due to the callback function.
> > Subsequently, the callback function __nflog_rcv_pkt is invoked for all
> > the nflog_open structures, but only references one of them.
> > Consequently, the callbacks registered by the end-user of the library
> > through nflog_callback_register fail to trigger in sessions where the
> > incorrect reference was recorded.
> > This patch corrects this behavior by creating the structure locally on
> > the stack for each call to nflog_open_nfnl. Since the
> > nfnl_callback_register function simply copies the data into its
> > internal structures, there is no need to retain pkt_cb beyond this
> > point.
>
> Patch looks sane, but I fear formatting won't do. Are you able to turn
> this into a git commit and use git-format-patch/git-send-email to submit
> it?
>
> Thanks, Phil

--0000000000000f15d8061750c63b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-fix-bug-in-race-condition-of-calling-nflog_open-from.patch"
Content-Disposition: attachment; 
	filename="0001-fix-bug-in-race-condition-of-calling-nflog_open-from.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lvmgcbkf0>
X-Attachment-Id: f_lvmgcbkf0

RnJvbSBlNjIzNjk5NTRkY2I3MzE1YjczODM0NmNjNWViZmY4OWNiZTNiZjU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFdmdlbmlpIEJlbmR5YWsgPGptYW4uYm94QGdtYWlsLmNvbT4K
RGF0ZTogVHVlLCAzMCBBcHIgMjAyNCAxNjo1MTo1MyArMDMwMApTdWJqZWN0OiBbUEFUQ0hdIGZp
eCBidWcgaW4gcmFjZSBjb25kaXRpb24gb2YgY2FsbGluZyBuZmxvZ19vcGVuIGZyb20KIGRpZmZl
cmVudCB0aHJlYWRzIGF0IHNhbWUgdGltZQoKLS0tCiBzcmMvbGlibmV0ZmlsdGVyX2xvZy5jIHwg
OSArKysrLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvc3JjL2xpYm5ldGZpbHRlcl9sb2cuYyBiL3NyYy9saWJuZXRmaWx0
ZXJfbG9nLmMKaW5kZXggY2IwOTM4NC4uMzM5Yzk2MSAxMDA2NDQKLS0tIGEvc3JjL2xpYm5ldGZp
bHRlcl9sb2cuYworKysgYi9zcmMvbGlibmV0ZmlsdGVyX2xvZy5jCkBAIC0xNjEsMTEgKzE2MSw2
IEBAIHN0YXRpYyBpbnQgX19uZmxvZ19yY3ZfcGt0KHN0cnVjdCBubG1zZ2hkciAqbmxoLCBzdHJ1
Y3QgbmZhdHRyICpuZmFbXSwKIAlyZXR1cm4gZ2gtPmNiKGdoLCBuZm1zZywgJm5mbGRhdGEsIGdo
LT5kYXRhKTsKIH0KIAotc3RhdGljIHN0cnVjdCBuZm5sX2NhbGxiYWNrIHBrdF9jYiA9IHsKLQku
Y2FsbCAJCT0gJl9fbmZsb2dfcmN2X3BrdCwKLQkuYXR0cl9jb3VudCAJPSBORlVMQV9NQVgsCi19
OwotCiAvKiBwdWJsaWMgaW50ZXJmYWNlICovCiAKIHN0cnVjdCBuZm5sX2hhbmRsZSAqbmZsb2df
bmZubGgoc3RydWN0IG5mbG9nX2hhbmRsZSAqaCkKQEAgLTI1NSw2ICsyNTAsMTAgQEAgc3RydWN0
IG5mbG9nX2hhbmRsZSAqbmZsb2dfb3Blbl9uZm5sKHN0cnVjdCBuZm5sX2hhbmRsZSAqbmZubGgp
CiB7CiAJc3RydWN0IG5mbG9nX2hhbmRsZSAqaDsKIAlpbnQgZXJyOworCXN0cnVjdCBuZm5sX2Nh
bGxiYWNrIHBrdF9jYiA9IHsKKwkJLmNhbGwgCQk9ICZfX25mbG9nX3Jjdl9wa3QsCisJCS5hdHRy
X2NvdW50IAk9IE5GVUxBX01BWCwKKwl9OwogCiAJaCA9IGNhbGxvYygxLCBzaXplb2YoKmgpKTsK
IAlpZiAoIWgpCi0tIAoyLjI1LjEKCg==
--0000000000000f15d8061750c63b--
