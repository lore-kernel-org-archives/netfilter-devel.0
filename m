Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB67046AF
	for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 08:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716453464; cv=none; b=P5bTxT27UjuZP0cYwYnxRfk1JR+lrgynvNCQej6olGriYnjrg6e2Ut2M2eIOOWF+R+XySaX4z/qLaejP1LWosnVAKjrm54S9EjLwV8nh+OHkh5AC9RJ0c1XEOrZWOzYeTLIcuQloMtQBTHnPClK1oSngo65N6qXn/NGPyWLX4H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716453464; c=relaxed/simple;
	bh=88MhsEGVC7kvYQOJqO5nLZ4WbgjgQEMHgzccSF8VDlc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mS4zo/ULAUAO/HMhLgqQbwDjvT+QvED5JOpuahebp9MyLGqOu6tZIZwuLqg3XdncFOtuQkpJ1hKpxY1TyxrGE62phMzpCBfaQuj42tcPnJM5TlXvJwA1FcQ+sOMPG2LKA9MRbLKoKIA75StGeJ/UyYNOJ2ZKsIV0BoR+bKeoAj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jftEyOEC; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jftEyOEC"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-571ba432477so12832292a12.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 01:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716453460; x=1717058260; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UGOh/A51V14tXc2+JQMaqimlRjEbQOh88ES0RfZJAHU=;
        b=jftEyOECfLTfVtzDXDH8SPyJquZXwLD/5Svvbpw4NRKTgUAJpgEAnqwy9VIMsrMBBQ
         T+X0US7AglTH6LLxbbrPw0ldANBRmdJ6UI3MLzyV0JbODs3Px4yzHMVPjGvlr6pz1bf+
         Xg6iwXm3xLBlfjh9OB/mAmPPrX3X0FZn7SqWvlwzWpaB/tI4or7vYR8PvomqGvnfKJJW
         KTHzU/7173rumUg2VPb/cqxWzRr22v6OChtIUfAeGDcXdjUWYbEktOcBQrNlH7iZO6My
         k0kYHn5BlSCKbwMeF+2tj/jDKWKecwNDoEIarlRgg4AKdZB5hn4kC0jvVhvOrWqh4QUk
         +x6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716453460; x=1717058260;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UGOh/A51V14tXc2+JQMaqimlRjEbQOh88ES0RfZJAHU=;
        b=OFyDLNb1xn90cV139WkKqX4k3lG58hj0AGRtWMlsldi9opVR3Qx/dNkz8M/vZ5duBN
         m+Eyb1wncMfIIVjfU5JfaxxqftWdCAInpFdzWc8AvvnAa801tlw33+DBJ7GO1eKrYmqx
         BFhbFa4zNyyt140XcfWqJdjUb1T8kFPD3OTHnYnx3euy+8y1nD6OTuyIBUNx2qLWjpBT
         fFBlYiOZKNW+JGrHJxiUJvGazCpIYMwbKow+yus0uCrv6aEfu8Yufq7EWXJhZ4nbOKg0
         LxUEngIXOpWjXlQ1lWdcTgiDO4JolR/OAF2bbH4fMAtxbjG0fttjN12gkeQx+HUOUlN1
         crvw==
X-Gm-Message-State: AOJu0Yy7tuYZAdGKbqljmEt1OX8BEz33aNaczWb69ja//MQu11tPl4PL
	K6ysm3vP/AKP1Cde88657SXIPCLe3pILZdwucYxeLO9Ru3mAzv04rSbQOTZ7vP+9a0nZVk3ALb/
	VKd0iS4AUXQB6rTM5SGvuIOXlTcA=
X-Google-Smtp-Source: AGHT+IFKrtf3tfkLdm0xOUNLvnRkyyLJkNy3lBOMZnIpnFsjdqMHms/DO97v5ocL78Uw+dmKO9t0fc3WXnLtEKv5twI=
X-Received: by 2002:a50:9e2e:0:b0:572:7c99:a280 with SMTP id
 4fb4d7f45d1cf-578329e295cmr2869289a12.15.1716453459926; Thu, 23 May 2024
 01:37:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALMA0xYY-QzN+gbPTxNw3TJt3Rvm-vkN1yb4MgHs1Ey4TuEURw@mail.gmail.com>
 <02acedac-3ec3-8b2c-0f27-30cf135be5de@netfilter.org>
In-Reply-To: <02acedac-3ec3-8b2c-0f27-30cf135be5de@netfilter.org>
From: Zhixu Liu <zhixu.liu@gmail.com>
Date: Thu, 23 May 2024 16:37:03 +0800
Message-ID: <CALMA0xZ9y-oU1tNXK8BNHtN_FyqKuerkAGFvuRB1pfraMG=cdA@mail.gmail.com>
Subject: Re: [PATCH] fix json output format for IPSET_OPT_IP
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000c0d11206191af65f"

--000000000000c0d11206191af65f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, please see attachment for the updated patch.

Jozsef Kadlecsik <kadlec@netfilter.org> =E4=BA=8E2024=E5=B9=B45=E6=9C=8823=
=E6=97=A5=E5=91=A8=E5=9B=9B 15:09=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello,
>
> On Mon, 20 May 2024, Zhixu Liu wrote:
>
> > It should be quoted to be a well formed json file, otherwise see follow=
ing
> > bad example (range is not quoted):
> >
> >   # ipset create foo bitmap:ip range 192.168.0.0/16
> >   # ipset list -o json foo
> >   [
> >     {
> >       "name" : "foo",
> >       "type" : "bitmap:ip",
> >       "revision" : 3,
> >       "header" : {
> >         "range" : 192.168.0.0-192.168.255.255,
> >         "memsize" : 8280,
> >         "references" : 0,
> >         "numentries" : 0
> >       },
> >       "members" : [
> >       ]
> >     }
> >   ]
>
> Thank you your patch. Please rework it and use a quoted buffer similarly
> to ipset_print_hexnumber() in order to avoid the many "if (env &
> IPSET_ENV_QUOTED)" constructs.
>
> Best regards,
> Jozsef
> --
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary



--=20
Z. Liu

--000000000000c0d11206191af65f
Content-Type: application/octet-stream; 
	name="0001-ipset-fix-json-output-format-for-IPSET_OPT_IP.patch"
Content-Disposition: attachment; 
	filename="0001-ipset-fix-json-output-format-for-IPSET_OPT_IP.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lwizz8e80>
X-Attachment-Id: f_lwizz8e80

RnJvbSBmOGRiNTUzNDVlYTkyZjRmNzdlYmI3ZTIyZjJhN2RiODM4OTU2NWUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiWi4gTGl1IiA8bGl1enhAa25vd25zZWMuY29tPgpEYXRlOiBN
b24sIDIwIE1heSAyMDI0IDIyOjIzOjQwICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzFdIGlwc2V0
OiBmaXgganNvbiBvdXRwdXQgZm9ybWF0IGZvciBJUFNFVF9PUFRfSVAKCklQU0VUX09QVF9JUCBz
aG91bGQgYmUgcXVvdGVkIHRvIGJlIGEgd2VsbCBmb3JtZWQganNvbiBmaWxlLCBvdGhlcndpc2Ug
c2VlCmZvbGxvd2luZyBiYWQgZXhhbXBsZSAocmFuZ2UgaXMgbm90IHF1b3RlZCk6CgogICMgaXBz
ZXQgY3JlYXRlIGZvbyBiaXRtYXA6aXAgcmFuZ2UgMTkyLjE2OC4wLjAvMTYKICAjIGlwc2V0IGxp
c3QgLW8ganNvbiBmb28KICBbCiAgICB7CiAgICAgICJuYW1lIiA6ICJmb28iLAogICAgICAidHlw
ZSIgOiAiYml0bWFwOmlwIiwKICAgICAgInJldmlzaW9uIiA6IDMsCiAgICAgICJoZWFkZXIiIDog
ewogICAgICAgICJyYW5nZSIgOiAxOTIuMTY4LjAuMC0xOTIuMTY4LjI1NS4yNTUsCiAgICAgICAg
Im1lbXNpemUiIDogODI4MCwKICAgICAgICAicmVmZXJlbmNlcyIgOiAwLAogICAgICAgICJudW1l
bnRyaWVzIiA6IDAKICAgICAgfSwKICAgICAgIm1lbWJlcnMiIDogWwogICAgICBdCiAgICB9CiAg
XQoKU2lnbmVkLW9mZi1ieTogWi4gTGl1IDxsaXV6eEBrbm93bnNlYy5jb20+Ci0tLQogbGliL3By
aW50LmMgfCAxNyArKysrKysrKysrKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlv
bnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbGliL3ByaW50LmMgYi9saWIvcHJp
bnQuYwppbmRleCA2ZWE3OWNiLi4zODA2ZTFjIDEwMDY0NAotLS0gYS9saWIvcHJpbnQuYworKysg
Yi9saWIvcHJpbnQuYwpAQCAtMjYxLDYgKzI2MSw3IEBAIGlwc2V0X3ByaW50X2lwKGNoYXIgKmJ1
ZiwgdW5zaWduZWQgaW50IGxlbiwKIAl1aW50OF90IGZhbWlseSwgY2lkcjsKIAlpbnQgZmxhZ3Ms
IHNpemUsIG9mZnNldCA9IDA7CiAJZW51bSBpcHNldF9vcHQgY2lkcm9wdDsKKwljb25zdCBjaGFy
ICpxdW90ZWQgPSBlbnYgJiBJUFNFVF9FTlZfUVVPVEVEID8gIlwiIiA6ICIiOwogCiAJYXNzZXJ0
KGJ1Zik7CiAJYXNzZXJ0KGxlbiA+IDApOwpAQCAtMjc3LDIwICsyNzgsMjYgQEAgaXBzZXRfcHJp
bnRfaXAoY2hhciAqYnVmLCB1bnNpZ25lZCBpbnQgbGVuLAogCQljaWRyID0gZmFtaWx5ID09IE5G
UFJPVE9fSVBWNiA/IDEyOCA6IDMyOwogCWZsYWdzID0gKGVudiAmIElQU0VUX0VOVl9SRVNPTFZF
KSA/IDAgOiBOSV9OVU1FUklDSE9TVDsKIAorCXNpemUgPSBzbnByaW50ZihidWYsIGxlbiwgIiVz
IiwgcXVvdGVkKTsKKwlTTlBSSU5URl9GQUlMVVJFKHNpemUsIGxlbiwgb2Zmc2V0KTsKKwogCWlw
ID0gaXBzZXRfZGF0YV9nZXQoZGF0YSwgb3B0KTsKIAlhc3NlcnQoaXApOwogCWlmIChmYW1pbHkg
PT0gTkZQUk9UT19JUFY0KQotCQlzaXplID0gc25wcmludGZfaXB2NChidWYsIGxlbiwgZmxhZ3Ms
IGlwLCBjaWRyKTsKKwkJc2l6ZSA9IHNucHJpbnRmX2lwdjQoYnVmICsgb2Zmc2V0LCBsZW4sIGZs
YWdzLCBpcCwgY2lkcik7CiAJZWxzZSBpZiAoZmFtaWx5ID09IE5GUFJPVE9fSVBWNikKLQkJc2l6
ZSA9IHNucHJpbnRmX2lwdjYoYnVmLCBsZW4sIGZsYWdzLCBpcCwgY2lkcik7CisJCXNpemUgPSBz
bnByaW50Zl9pcHY2KGJ1ZiArIG9mZnNldCwgbGVuLCBmbGFncywgaXAsIGNpZHIpOwogCWVsc2UK
IAkJcmV0dXJuIC0xOwogCUQoInNpemUgJWksIGxlbiAldSIsIHNpemUsIGxlbik7CiAJU05QUklO
VEZfRkFJTFVSRShzaXplLCBsZW4sIG9mZnNldCk7CiAKIAlEKCJsZW46ICV1LCBvZmZzZXQgJXUi
LCBsZW4sIG9mZnNldCk7Ci0JaWYgKCFpcHNldF9kYXRhX3Rlc3QoZGF0YSwgSVBTRVRfT1BUX0lQ
X1RPKSkKKwlpZiAoIWlwc2V0X2RhdGFfdGVzdChkYXRhLCBJUFNFVF9PUFRfSVBfVE8pKSB7CisJ
CXNpemUgPSBzbnByaW50ZihidWYgKyBvZmZzZXQsIGxlbiwgIiVzIiwgcXVvdGVkKTsKKwkJU05Q
UklOVEZfRkFJTFVSRShzaXplLCBsZW4sIG9mZnNldCk7CiAJCXJldHVybiBvZmZzZXQ7CisJfQog
CiAJc2l6ZSA9IHNucHJpbnRmKGJ1ZiArIG9mZnNldCwgbGVuLCAiJXMiLCBJUFNFVF9SQU5HRV9T
RVBBUkFUT1IpOwogCVNOUFJJTlRGX0ZBSUxVUkUoc2l6ZSwgbGVuLCBvZmZzZXQpOwpAQCAtMzA0
LDYgKzMxMSwxMCBAQCBpcHNldF9wcmludF9pcChjaGFyICpidWYsIHVuc2lnbmVkIGludCBsZW4s
CiAJCXJldHVybiAtMTsKIAogCVNOUFJJTlRGX0ZBSUxVUkUoc2l6ZSwgbGVuLCBvZmZzZXQpOwor
CisJc2l6ZSA9IHNucHJpbnRmKGJ1ZiArIG9mZnNldCwgbGVuLCAiJXMiLCBxdW90ZWQpOworCVNO
UFJJTlRGX0ZBSUxVUkUoc2l6ZSwgbGVuLCBvZmZzZXQpOworCiAJcmV0dXJuIG9mZnNldDsKIH0K
IAotLSAKMi40My4yCgo=
--000000000000c0d11206191af65f--
