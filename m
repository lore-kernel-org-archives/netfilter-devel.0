Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399F4136E0E
	for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2024 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716218711; cv=none; b=NEb2v2VWUlBPD64cVhckGD5T17CVTJ+oqgH5z8Kar5t33zIOzhu1FZnr3OTkKe967kFHFTTcmJGeeJ53W5S8iPSqLAb4tRywtkE8p+JMtLcEApPwKfVEOwkyWnbyDQXCJIkcdiFjWliyIZtFE/xoyVVYvHl61dfwSg7XtTGdNAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716218711; c=relaxed/simple;
	bh=8FiLYevFNCJt+F0mWKuXDvHEPQuRFUwgq0hJLvBFgds=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=KZAeBqt86xARaz0geQmXt1+FmH5fgufbZDeVECgRORJUXUQuR/wuECYNjIEAKt22sL7rlT6GAvLnSp5Qq70zxZzPM7ZYQWLm8vLsfFwnodUKUZdAmJuZ8dIVC4tt+/yj7gvg89CUJJL2hg53BiOTVAEH9VNrdoNHUIjEPudPjw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NQU90zEL; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQU90zEL"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-572b37afd73so8489778a12.2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2024 08:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716218708; x=1716823508; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9WeiJE2s3UV9rcB4uIyDtiXlxlY+/YBWobAofw7rh64=;
        b=NQU90zELGc5APB0Sj2vpH2zAzd2Rbfa95N4nefq2NSsG0F/b1ZT0nstuwm76fMXcbK
         SIYKKWSz4zbJWMZ8czMinI6IH8zpN6Ts9nwZZO3SynEpmjeGkbX1DC8FaRmRfscArl1S
         HIhf8znx0e0H9cVU/3GEImu/r3TzKY5uqrzs7Te4iwwik32aK69/IpT9ipLE1oxikfka
         c7rtRV7MLwCnfBfP7orpw4xePLWiSYHntXh7eaA1eBKIypFLYMww4UE8Ie4F0jfIsbCv
         J7U1XfJ9+mOYpzegUh0fMNIj7CUm2Ukf3p2txlDmWM2sgi4m6P7l/9uFlpQZmHDsizMb
         Warw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716218708; x=1716823508;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9WeiJE2s3UV9rcB4uIyDtiXlxlY+/YBWobAofw7rh64=;
        b=OYDVq4RnADR6Pe+cXhRVKSS73bjsQpn/9x2DRFBHWge+QB97sFdhOJmxfcay7qIHni
         u3GB6HyrcfV082vUDTu8xsg0heaB/5hiVTFLGyBRvU/4JcPeL/CkUSfNNz3yunFh+7ft
         p2FBLWj7behVNiS1rug+8Ii/cA3asMunrvofU1TvVXYirVErcZevRpVvxZIMMHuzSsi9
         irPSNbwWKzjEGsPclAW/UTJAE03tVHzObKqvHKoYot7W0W034eAhpUPOKcXSqHOrmd3b
         l7F1AKzc61FfrCAsrn+dYixBJaTmhrskDYo1SfDvpxqQr6owPOCYNFxaMab8h8ZLMei8
         Cisw==
X-Gm-Message-State: AOJu0YyuO8pq6ZNvMuF57OLWm+8fXEj3whsUuUFIP7Mb3K84whNy1qRb
	ycZXjNJ7sdQatCJOI5qF+oAm7xpOhUFZoC7O7k2wpYRpzjux5ft7GKT7IeM3Wf0ddN/dxENZF0/
	/Qaz/yhPVCUcoNAP8ybAUN/m1Epsdk7/JXuI=
X-Google-Smtp-Source: AGHT+IFJ/NOesmBojj2JbJb1HXNWoDE6YNmiM9homlcH7QuHBFo4XN6SS3ylrbrQ+RFuqveO3WNEpeu1HqtxQH1/Xyk=
X-Received: by 2002:a50:cd44:0:b0:572:df77:c1bf with SMTP id
 4fb4d7f45d1cf-575750f4033mr4146403a12.3.1716218708367; Mon, 20 May 2024
 08:25:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zhixu Liu <zhixu.liu@gmail.com>
Date: Mon, 20 May 2024 23:24:32 +0800
Message-ID: <CALMA0xYY-QzN+gbPTxNw3TJt3Rvm-vkN1yb4MgHs1Ey4TuEURw@mail.gmail.com>
Subject: [PATCH] fix json output format for IPSET_OPT_IP
To: netfilter-devel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000078374c0618e44e82"

--00000000000078374c0618e44e82
Content-Type: text/plain; charset="UTF-8"

It should be quoted to be a well formed json file, otherwise see following
bad example (range is not quoted):

  # ipset create foo bitmap:ip range 192.168.0.0/16
  # ipset list -o json foo
  [
    {
      "name" : "foo",
      "type" : "bitmap:ip",
      "revision" : 3,
      "header" : {
        "range" : 192.168.0.0-192.168.255.255,
        "memsize" : 8280,
        "references" : 0,
        "numentries" : 0
      },
      "members" : [
      ]
    }
  ]

-- 
Z. Liu

--00000000000078374c0618e44e82
Content-Type: application/octet-stream; 
	name="0001-fix-json-output-format-for-IPSET_OPT_IP.patch"
Content-Disposition: attachment; 
	filename="0001-fix-json-output-format-for-IPSET_OPT_IP.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lwf46kvq0>
X-Attachment-Id: f_lwf46kvq0

RnJvbSBiZTgyNzk2MzViZTZhNWE4YmY1NTMwOWFlNjA0NDlmZjdjN2IyNDgxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiWi4gTGl1IiA8bGl1enhAa25vd25zZWMuY29tPgpEYXRlOiBN
b24sIDIwIE1heSAyMDI0IDIyOjIzOjQwICswODAwClN1YmplY3Q6IFtQQVRDSF0gZml4IGpzb24g
b3V0cHV0IGZvcm1hdCBmb3IgSVBTRVRfT1BUX0lQCgpJdCBzaG91bGQgYmUgcXVvdGVkIHRvIGJl
IGEgd2VsbCBmb3JtZWQganNvbiBmaWxlLCBvdGhlcndpc2Ugc2VlIGZvbGxvd2luZwpiYWQgZXhh
bXBsZSAocmFuZ2UgaXMgbm90IHF1b3RlZCk6CgogICMgaXBzZXQgY3JlYXRlIGZvbyBiaXRtYXA6
aXAgcmFuZ2UgMTkyLjE2OC4wLjAvMTYKICAjIGlwc2V0IGxpc3QgLW8ganNvbiBmb28KICBbCiAg
ICB7CiAgICAgICJuYW1lIiA6ICJmb28iLAogICAgICAidHlwZSIgOiAiYml0bWFwOmlwIiwKICAg
ICAgInJldmlzaW9uIiA6IDMsCiAgICAgICJoZWFkZXIiIDogewogICAgICAgICJyYW5nZSIgOiAx
OTIuMTY4LjAuMC0xOTIuMTY4LjI1NS4yNTUsCiAgICAgICAgIm1lbXNpemUiIDogODI4MCwKICAg
ICAgICAicmVmZXJlbmNlcyIgOiAwLAogICAgICAgICJudW1lbnRyaWVzIiA6IDAKICAgICAgfSwK
ICAgICAgIm1lbWJlcnMiIDogWwogICAgICBdCiAgICB9CiAgXQoKU2lnbmVkLW9mZi1ieTogWi4g
TGl1IDxsaXV6eEBrbm93bnNlYy5jb20+Ci0tLQogbGliL3ByaW50LmMgfCAyMSArKysrKysrKysr
KysrKysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2xpYi9wcmludC5jIGIvbGliL3ByaW50LmMKaW5kZXggNmVhNzlj
Yi4uNjM2ZjA4NSAxMDA2NDQKLS0tIGEvbGliL3ByaW50LmMKKysrIGIvbGliL3ByaW50LmMKQEAg
LTI3NywyMCArMjc3LDI5IEBAIGlwc2V0X3ByaW50X2lwKGNoYXIgKmJ1ZiwgdW5zaWduZWQgaW50
IGxlbiwKIAkJY2lkciA9IGZhbWlseSA9PSBORlBST1RPX0lQVjYgPyAxMjggOiAzMjsKIAlmbGFn
cyA9IChlbnYgJiBJUFNFVF9FTlZfUkVTT0xWRSkgPyAwIDogTklfTlVNRVJJQ0hPU1Q7CiAKKwlp
ZiAoZW52ICYgSVBTRVRfRU5WX1FVT1RFRCkgeworCQlzaXplID0gc25wcmludGYoYnVmLCBsZW4s
ICIlcyIsICJcIiIpOworCQlTTlBSSU5URl9GQUlMVVJFKHNpemUsIGxlbiwgb2Zmc2V0KTsKKwl9
CiAJaXAgPSBpcHNldF9kYXRhX2dldChkYXRhLCBvcHQpOwogCWFzc2VydChpcCk7CiAJaWYgKGZh
bWlseSA9PSBORlBST1RPX0lQVjQpCi0JCXNpemUgPSBzbnByaW50Zl9pcHY0KGJ1ZiwgbGVuLCBm
bGFncywgaXAsIGNpZHIpOworCQlzaXplID0gc25wcmludGZfaXB2NChidWYgKyBvZmZzZXQsIGxl
biwgZmxhZ3MsIGlwLCBjaWRyKTsKIAllbHNlIGlmIChmYW1pbHkgPT0gTkZQUk9UT19JUFY2KQot
CQlzaXplID0gc25wcmludGZfaXB2NihidWYsIGxlbiwgZmxhZ3MsIGlwLCBjaWRyKTsKKwkJc2l6
ZSA9IHNucHJpbnRmX2lwdjYoYnVmICsgb2Zmc2V0LCBsZW4sIGZsYWdzLCBpcCwgY2lkcik7CiAJ
ZWxzZQogCQlyZXR1cm4gLTE7CiAJRCgic2l6ZSAlaSwgbGVuICV1Iiwgc2l6ZSwgbGVuKTsKIAlT
TlBSSU5URl9GQUlMVVJFKHNpemUsIGxlbiwgb2Zmc2V0KTsKIAogCUQoImxlbjogJXUsIG9mZnNl
dCAldSIsIGxlbiwgb2Zmc2V0KTsKLQlpZiAoIWlwc2V0X2RhdGFfdGVzdChkYXRhLCBJUFNFVF9P
UFRfSVBfVE8pKQorCWlmICghaXBzZXRfZGF0YV90ZXN0KGRhdGEsIElQU0VUX09QVF9JUF9UTykp
IHsKKwkJaWYgKGVudiAmIElQU0VUX0VOVl9RVU9URUQpIHsKKwkJCXNpemUgPSBzbnByaW50Zihi
dWYgKyBvZmZzZXQsIGxlbiwgIiVzIiwgIlwiIik7CisJCQlTTlBSSU5URl9GQUlMVVJFKHNpemUs
IGxlbiwgb2Zmc2V0KTsKKwkJfQogCQlyZXR1cm4gb2Zmc2V0OworCX0KIAogCXNpemUgPSBzbnBy
aW50ZihidWYgKyBvZmZzZXQsIGxlbiwgIiVzIiwgSVBTRVRfUkFOR0VfU0VQQVJBVE9SKTsKIAlT
TlBSSU5URl9GQUlMVVJFKHNpemUsIGxlbiwgb2Zmc2V0KTsKQEAgLTMwNCw2ICszMTMsMTIgQEAg
aXBzZXRfcHJpbnRfaXAoY2hhciAqYnVmLCB1bnNpZ25lZCBpbnQgbGVuLAogCQlyZXR1cm4gLTE7
CiAKIAlTTlBSSU5URl9GQUlMVVJFKHNpemUsIGxlbiwgb2Zmc2V0KTsKKworCWlmIChlbnYgJiBJ
UFNFVF9FTlZfUVVPVEVEKSB7CisJCXNpemUgPSBzbnByaW50ZihidWYgKyBvZmZzZXQsIGxlbiwg
IiVzIiwgIlwiIik7CisJCVNOUFJJTlRGX0ZBSUxVUkUoc2l6ZSwgbGVuLCBvZmZzZXQpOworCX0K
KwogCXJldHVybiBvZmZzZXQ7CiB9CiAKLS0gCjIuNDMuMgoK
--00000000000078374c0618e44e82--
