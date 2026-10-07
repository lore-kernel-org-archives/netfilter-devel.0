Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F37A4973A0
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 11:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.125.188.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372391; cv=pass; b=gaNfmCHF+u6uVQj2xi7bumiyzpy+p0EwT+T1ySlc6KAOmjePiLdV0iO3abSV5f39nR85ttdmpWJwjhvZd7BwcaVipDpSdcctBtclTbMLck2uVq/HPNv5Im1STtY0yPORgYDDn11l7q4L0V0jIEdxwjo5Kzz/TTvas28g8L/ktBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372391; c=relaxed/simple;
	bh=YOvJfCQYvtfwSqKEnivmM7ap+Su7cl5i1aPxXTTO3jQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Z/eZFz5jbUjX3A55V5dXxwzdU3OQlvINi+E8nlswS1LGSUVuNIayzVeaer12FwVsfa4n7YRONFRr7dnfF+X8Ax8qsYfK6XSuJtVPqqfiVgnINJeqRgOr0G7gIsLGk+M32I9hQNI2pyRyvGAc9nxOitSpj4G99fJuyWh6XhGVjDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=AOAbTkgc; arc=pass smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="AOAbTkgc"
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 04FE13F4C1
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 11:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791372372;
	bh=wW1/Mvzw6Ydm5ISejMgmTWSWEx3M30kINyLjFEgiO2w=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type;
	b=AOAbTkgcAKQR1wtAeH2qMwQePRp6w+0h7shnruoeZHeei2bvthNzDNI/pALrXtOJu
	 EQ+e8u8JZtdlxWnFnw92FxtDIqf0g9GbJpbskD7CtqXfPCc9CK9pEFdji6AJg5wnB4
	 X34tb9Nje0dU/x4usou9LdZR1ncfuNeihe3Cr36Gs5M2e9DUMdNV+nRX/mDccaa4QA
	 gnppAFuU0gyZpGSXP643+9qFg3oNwgYNdGJAnSzrdctSBSxgeYkxvem+KoCcVbQ0Ma
	 0xAiHHbTlXlenVrZUM4s+04fs/5Q6pVuU+4uUrly93tIH6nSBCp6mt3JLubJ0g+P5j
	 2VC3BSEUyqLsnzs9QRiWJHFJ8q5TnK5fX4be+o+bbIKoEPNc5z4mVsU2QFq0s/EkJE
	 4xLERKjtrAMsEESzZz6FajvN+xjGmCt1DzUPjeFAB1mqEjMfR+heEtVKiFFxDQL2Wa
	 IR4tRvl6JK/vfLPlF/8eHdugQoTXU8EqbXdc/0m0kQsXnGhSdRJLPYYD50AL526osj
	 4PsOXS4zQLMUhViibYKb8rzYrbO+Mg3VMll60UI23YmsqvNYl5kJrr3fCQXg/SPp/w
	 zwhZViZIwbSyjHQr7ut7g50hLQK14xj66BCNipUzcuow49V4AlNFbTDXdB7ox/Nj9X
	 r8z/G1OJZYL01tux5XeofHkA=
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3a998bcf6afso8462981fa.0
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Oct 2026 04:26:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791372371; cv=none;
        d=google.com; s=arc-20260327;
        b=inuGqUgII/AJTFQoA99VUnAk8O/E8BZ53zID4VASaNrDrTAKuhvFBJGsXmXr6+50kW
         HQeuFzpKifTX+ye7uGVqTzH9qqWodgPl50zsVV2WopkMlSUrtzGEfRLBJReGAAG5jXCi
         vztoirxtwQNkn3EzQnHEItnrYMrebP0yeOYYRujy+uQD8Na+0YWwCCKOBuXAiuy1YRyL
         wYKP3Esi4maVl6/j+YGV9sUOjm7s2bIWCS54bgtZw/Pv3LJfLdhFS9WDU63k+DCFFJes
         Jd/1NgmzJjGbffPqUsTKqHdUxDbAl0jgH2qBMnJOL6JQpGUj30lepbgg2qkbU8b6U/RD
         AtRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version;
        bh=wW1/Mvzw6Ydm5ISejMgmTWSWEx3M30kINyLjFEgiO2w=;
        fh=94XZ0kbhVmGEa7CVQQn7x19t/0l9HgwgaJK+mk7Jllo=;
        b=PytzWhqSg+x516IlGVRiRv7oOqrrKSfjz3j7b5Q2FXzIsKVGwHP/n+I6dpJpoVMpWH
         z5bzL55hhm8ToyvVGpZA+F9b5cYlbT02sd8573bYPUBCbYhCfhs1yy3Y0cEIzzN5THiO
         2zUm28Apxv8FqTy8vFozblSlTJ/In5yPAdE5ORM58Pi9hjrBCv/EoHxxYogFQZoJ5QBK
         DK/GwsbYcIpfua2Pxois80Nh7ccrIjF25xMwVcjA2D4IhvjOg1XXu88jaASZAileYGbu
         l1f6OmYi2JK4bbmEKM6i2xi2pQvkuoAWMqheOGcd64aR5FzhMiSqrLHaXyH84+zDQoBL
         hDmw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791372371; x=1791977171;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wW1/Mvzw6Ydm5ISejMgmTWSWEx3M30kINyLjFEgiO2w=;
        b=zTnjAt71BJcVrRths0FAZkeF4XtA56W6ksDQGAlk9eCnFy96ibhAmNfuIQp/wip9UL
         eNCAP2BIGqv84fdEhICBc/GbpGCZvizTlu74ejbsaGZH5ghfK1Xa/rYLN35kWAn1EcUq
         XtiybHS3zRfYmpaxf65+Wx+VobyrynmwSe10TtSv3g5+/hj3urkrI75QsJ+GwsGEN92s
         mSTI3UUng/SwhuQvm/YdPf/Xb1TfdTeb8BM08QMqxEh4KYyTHXrKEtoGk6ti4XA+pFpk
         AotIUQztJXtfOH15XL3VksJeR/AgJLzZH8yO+HgpQFIlk6OPa4NubpzMZV70HpKtnhYX
         H8QQ==
X-Gm-Message-State: AFq9FYInQs4d+lIGsG+Klw5hdPW46nXVEIqZ9yt7nB3/nKBihS1cfwF4
	I4/8NyZ0OOqY7qLBhu2s6SoTPg2eSHilVBW8NRIDMzUW60TTNu33RRKWaJ2QqYEqEX/EvzeOwY4
	luvdk8qnkyEk12yDu2GOdPttYYMWpByOn30hWdw8vxsWP0959FaQOjRh2qZIxeBs4ZNAbKYZIdk
	sWGq9KOm3hMRYqWO+3uf+aZHIcKuO82w/b0DO7QUeGueyrikiGJlYmOilIHGArsupwIwgaOxAe0
	g==
X-Gm-Gg: AYBFou2ReMPlV2/qAcEZ4nGWVMbnOqLsWnO0dpdJK/tsXTAnCZLqZgEpJflf/mvct/C
	NYwnGN9K8yTRfnQ2FG+bZkay7DMFUxyOGAkpsQ49BlIQZIEpYXGoroBKYk6UonmIqQg55ZCrczA
	I7UeF+HYCpRhfXhiqDaFJQ7i1gjO/sS6YLoAHA9sqOvyD4+wZVt+OZHfc5m3F2wfsq2Lk8/vBpu
	hct
X-Received: by 2002:a05:651c:41d4:b0:3a9:8969:3dd2 with SMTP id 38308e7fff4ca-3a9a2d0f257mr4031111fa.13.1791372371279;
        Wed, 07 Oct 2026 04:26:11 -0700 (PDT)
X-Received: by 2002:a05:651c:41d4:b0:3a9:8969:3dd2 with SMTP id
 38308e7fff4ca-3a9a2d0f257mr4030991fa.13.1791372370836; Wed, 07 Oct 2026
 04:26:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sebastien Bacher <sebastien.bacher@canonical.com>
Date: Wed, 7 Oct 2026 13:25:58 +0200
X-Gm-Features: AclHuK8-LnHygiBfhTrIEyiGDUQg58W3wT4Raew-7cC2_nDa8snFFqGiMb49yAQ
Message-ID: <CAD04=wrZafKknWixGGRZWtYD_ydfdL4Uk39s_RkwZ6WUEVATKg@mail.gmail.com>
Subject: [ebtables PATCH] include: drop bundled copy of linux/types.h
To: netfilter-devel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000d32430065d3e61cc"

--000000000000d32430065d3e61cc
Content-Type: multipart/alternative; boundary="000000000000d32430065d3e61ca"

--000000000000d32430065d3e61ca
Content-Type: text/plain; charset="UTF-8"

The bundled include/linux/types.h is a copy of the kernel UAPI header
from v3.16. Since the build uses -I./include, it shadows the system
<linux/types.h>.

Recent kernel UAPI headers (v7.3) changed arm64's asm/sigcontext.h,
included via <signal.h>, to use the __u128 type from linux/types.h:

  - __uint128_t vregs[32];
  + __u128 vregs[32];

The stale copy lacks __u128, so the build fails on arm64:

  /usr/include/aarch64-linux-gnu/asm/sigcontext.h:81:9: error: unknown
  type name '__u128'; did you mean '__u32'?

The system header provides everything the bundled copy did, so drop it.

Link: https://bugs.launchpad.net/ubuntu/+source/ebtables/+bug/2169809

--000000000000d32430065d3e61ca
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The bundled include/linux/types.h is a copy of the kernel =
UAPI header<br>from v3.16. Since the build uses -I./include, it shadows the=
 system<br>&lt;linux/types.h&gt;.<br><br>Recent kernel UAPI headers (v7.3) =
changed arm64&#39;s asm/sigcontext.h,<br>included via &lt;signal.h&gt;, to =
use the __u128 type from linux/types.h:<br><br>=C2=A0 -	__uint128_t vregs[3=
2];<br>=C2=A0 +	__u128 vregs[32];<br><br>The stale copy lacks __u128, so th=
e build fails on arm64:<br><br>=C2=A0 /usr/include/aarch64-linux-gnu/asm/si=
gcontext.h:81:9: error: unknown<br>=C2=A0 type name &#39;__u128&#39;; did y=
ou mean &#39;__u32&#39;?<br><br>The system header provides everything the b=
undled copy did, so drop it.<br><br>Link: <a href=3D"https://bugs.launchpad=
.net/ubuntu/+source/ebtables/+bug/2169809">https://bugs.launchpad.net/ubunt=
u/+source/ebtables/+bug/2169809</a><br><br><br></div>

--000000000000d32430065d3e61ca--
--000000000000d32430065d3e61cc
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-include-drop-bundled-copy-of-linux-types.h.patch"
Content-Disposition: attachment; 
	filename="0001-include-drop-bundled-copy-of-linux-types.h.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_muy0u88h0>
X-Attachment-Id: f_muy0u88h0

RnJvbSBiNTM1Y2FmMDc2ZTIxZjI2NjdiODRhYWQ5MzA4ZGQ0NDMzZjE4MDE3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWJhc3RpZW4gQmFjaGVyIDxzZWIxMjhAdWJ1bnR1LmNvbT4K
RGF0ZTogV2VkLCA3IE9jdCAyMDI2IDEyOjM5OjEzICswMjAwClN1YmplY3Q6IFtlYnRhYmxlcyBQ
QVRDSF0gaW5jbHVkZTogZHJvcCBidW5kbGVkIGNvcHkgb2YgbGludXgvdHlwZXMuaAoKVGhlIGJ1
bmRsZWQgaW5jbHVkZS9saW51eC90eXBlcy5oIGlzIGEgY29weSBvZiB0aGUga2VybmVsIFVBUEkg
aGVhZGVyCmZyb20gdjMuMTYuIFNpbmNlIHRoZSBidWlsZCB1c2VzIC1JLi9pbmNsdWRlLCBpdCBz
aGFkb3dzIHRoZSBzeXN0ZW0KPGxpbnV4L3R5cGVzLmg+LgoKUmVjZW50IGtlcm5lbCBVQVBJIGhl
YWRlcnMgKHY3LjMpIGNoYW5nZWQgYXJtNjQncyBhc20vc2lnY29udGV4dC5oLAppbmNsdWRlZCB2
aWEgPHNpZ25hbC5oPiwgdG8gdXNlIHRoZSBfX3UxMjggdHlwZSBmcm9tIGxpbnV4L3R5cGVzLmg6
CgogIC0JX191aW50MTI4X3QgdnJlZ3NbMzJdOwogICsJX191MTI4IHZyZWdzWzMyXTsKClRoZSBz
dGFsZSBjb3B5IGxhY2tzIF9fdTEyOCwgc28gdGhlIGJ1aWxkIGZhaWxzIG9uIGFybTY0OgoKICAv
dXNyL2luY2x1ZGUvYWFyY2g2NC1saW51eC1nbnUvYXNtL3NpZ2NvbnRleHQuaDo4MTo5OiBlcnJv
cjogdW5rbm93bgogIHR5cGUgbmFtZSAnX191MTI4JzsgZGlkIHlvdSBtZWFuICdfX3UzMic/CgpU
aGUgc3lzdGVtIGhlYWRlciBwcm92aWRlcyBldmVyeXRoaW5nIHRoZSBidW5kbGVkIGNvcHkgZGlk
LCBzbyBkcm9wIGl0LgoKTGluazogaHR0cHM6Ly9idWdzLmxhdW5jaHBhZC5uZXQvdWJ1bnR1Lytz
b3VyY2UvZWJ0YWJsZXMvK2J1Zy8yMTY5ODA5ClNpZ25lZC1vZmYtYnk6IFNlYmFzdGllbiBCYWNo
ZXIgPHNlYjEyOEB1YnVudHUuY29tPgotLS0KIGluY2x1ZGUvbGludXgvdHlwZXMuaCB8IDUxIC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCA1MSBkZWxldGlvbnMoLSkKIGRlbGV0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2xpbnV4L3R5cGVz
LmgKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3R5cGVzLmggYi9pbmNsdWRlL2xpbnV4L3R5
cGVzLmgKZGVsZXRlZCBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDIzZWE3OGYuLjAwMDAwMDAKLS0t
IGEvaW5jbHVkZS9saW51eC90eXBlcy5oCisrKyAvZGV2L251bGwKQEAgLTEsNTEgKzAsMCBAQAot
I2lmbmRlZiBfTElOVVhfVFlQRVNfSAotI2RlZmluZSBfTElOVVhfVFlQRVNfSAotCi0jaW5jbHVk
ZSA8YXNtL3R5cGVzLmg+Ci0KLSNpZm5kZWYgX19BU1NFTUJMWV9fCi0KLSNpbmNsdWRlIDxsaW51
eC9wb3NpeF90eXBlcy5oPgotCi0KLS8qCi0gKiBCZWxvdyBhcmUgdHJ1bHkgTGludXgtc3BlY2lm
aWMgdHlwZXMgdGhhdCBzaG91bGQgbmV2ZXIgY29sbGlkZSB3aXRoCi0gKiBhbnkgYXBwbGljYXRp
b24vbGlicmFyeSB0aGF0IHdhbnRzIGxpbnV4L3R5cGVzLmguCi0gKi8KLQotI2lmZGVmIF9fQ0hF
Q0tFUl9fCi0jZGVmaW5lIF9fYml0d2lzZV9fIF9fYXR0cmlidXRlX18oKGJpdHdpc2UpKQotI2Vs
c2UKLSNkZWZpbmUgX19iaXR3aXNlX18KLSNlbmRpZgotI2lmZGVmIF9fQ0hFQ0tfRU5ESUFOX18K
LSNkZWZpbmUgX19iaXR3aXNlIF9fYml0d2lzZV9fCi0jZWxzZQotI2RlZmluZSBfX2JpdHdpc2UK
LSNlbmRpZgotCi10eXBlZGVmIF9fdTE2IF9fYml0d2lzZSBfX2xlMTY7Ci10eXBlZGVmIF9fdTE2
IF9fYml0d2lzZSBfX2JlMTY7Ci10eXBlZGVmIF9fdTMyIF9fYml0d2lzZSBfX2xlMzI7Ci10eXBl
ZGVmIF9fdTMyIF9fYml0d2lzZSBfX2JlMzI7Ci10eXBlZGVmIF9fdTY0IF9fYml0d2lzZSBfX2xl
NjQ7Ci10eXBlZGVmIF9fdTY0IF9fYml0d2lzZSBfX2JlNjQ7Ci0KLXR5cGVkZWYgX191MTYgX19i
aXR3aXNlIF9fc3VtMTY7Ci10eXBlZGVmIF9fdTMyIF9fYml0d2lzZSBfX3dzdW07Ci0KLS8qCi0g
KiBhbGlnbmVkX3U2NCBzaG91bGQgYmUgdXNlZCBpbiBkZWZpbmluZyBrZXJuZWw8LT51c2Vyc3Bh
Y2UgQUJJcyB0byBhdm9pZAotICogY29tbW9uIDMyLzY0LWJpdCBjb21wYXQgcHJvYmxlbXMuCi0g
KiA2NC1iaXQgdmFsdWVzIGFsaWduIHRvIDQtYnl0ZSBib3VuZGFyaWVzIG9uIHg4Nl8zMiAoYW5k
IHBvc3NpYmx5IG90aGVyCi0gKiBhcmNoaXRlY3R1cmVzKSBhbmQgdG8gOC1ieXRlIGJvdW5kYXJp
ZXMgb24gNjQtYml0IGFyY2hpdGVjdHVyZXMuICBUaGUgbmV3Ci0gKiBhbGlnbmVkXzY0IHR5cGUg
ZW5mb3JjZXMgOC1ieXRlIGFsaWdubWVudCBzbyB0aGF0IHN0cnVjdHMgY29udGFpbmluZwotICog
YWxpZ25lZF82NCB2YWx1ZXMgaGF2ZSB0aGUgc2FtZSBhbGlnbm1lbnQgb24gMzItYml0IGFuZCA2
NC1iaXQgYXJjaGl0ZWN0dXJlcy4KLSAqIE5vIGNvbnZlcnNpb25zIGFyZSBuZWNlc3NhcnkgYmV0
d2VlbiAzMi1iaXQgdXNlci1zcGFjZSBhbmQgYSA2NC1iaXQga2VybmVsLgotICovCi0jZGVmaW5l
IF9fYWxpZ25lZF91NjQgX191NjQgX19hdHRyaWJ1dGVfXygoYWxpZ25lZCg4KSkpCi0jZGVmaW5l
IF9fYWxpZ25lZF9iZTY0IF9fYmU2NCBfX2F0dHJpYnV0ZV9fKChhbGlnbmVkKDgpKSkKLSNkZWZp
bmUgX19hbGlnbmVkX2xlNjQgX19sZTY0IF9fYXR0cmlidXRlX18oKGFsaWduZWQoOCkpKQotCi0j
ZW5kaWYgLyogIF9fQVNTRU1CTFlfXyAqLwotI2VuZGlmIC8qIF9MSU5VWF9UWVBFU19IICovCi0t
IAoyLjQzLjAKCg==
--000000000000d32430065d3e61cc--
