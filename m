Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794716276;
	b=sCcWbAHq53eDxe8YXCQNVF86zV5wSrsGqX0SogdUI7SIpBq8pwjrrRRGetUY0/IjOju2
	 usG+A6A5dJKlStYwFx/WWcUvn5cXxc0a4r24HyNP6FpE2C3ZDzoS4fvuqJ0oHrtvrmfMg
	 J39kZREgTt8cUpzycJLxD333rZb3Pg/3yu3YVfU31HMZDpFvS6QHTZECMUD4dzn5EfI/v
	 GOTtUK4fYykWrlLOP7/BbfQ4OSJBlIONFQ01E2WEonQSjehvVGlxYu1lBMzUDobvTMzCd
	 xz0pKWyDG0LGHF30GAhkB54IT6TItsXeHPrBgjuOEDO2UPsFi1pcaFgcgH8+bJkGoXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794716276;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:MIME-Version:From:
	 X-Google-Nh-Sender:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=OTGSDI/qurNNnWJ5DD9+nhsFrBdHNtZLnM8Snb9crt8=;
	b=tPLdjzgV8S/xg+WIKRogdfYKPlTeK7lt3sC1EZeC+MoNmoOl2c1O2+cK1GjO7Q1Slpwy
	 O6JY6E8cbrTFjFF1FybVXwvjOLfgxqs+A9k46IGVUO8LL/TfM0xVRlsvFve34ccjqrKWU
	 BMM7Lh/sbM91HzUWZOXcwqatQ+y6FVeKs5xpiF7e9h3v0i0kd2yceeXGV+m4O9JkNzQat
	 IUeMBoiV46GT+w2U8gTLyQyCxybzjBLWcfmuPfAJtNk5VCuefWvtpGjNWCAIkKhCFiFSi
	 KdYJBznOx1ICyywR7OiIzB9Bgh7tkoSftHQ+EtwhcDCV8E2E+wmYt0sF2teoSZyKF2g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aRE7IsF9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.50
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB8B606A327
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 04:17:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEB8B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aRE7IsF9
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5c07c7306e1so2671720e87.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2026 20:17:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794716274; cv=none;
        d=google.com; s=arc-20260327;
        b=huR2yE5piT89/DOizYTD3VF5S5FbKwpnhJ26soWrI0yJvm4nsmRKoL0iKL+cg7yFC/
         frvHMG3tzZyxNop+zuOxO00gN9VRHbZ0dJ+vajOftmEayd9/GW4Y8qrZz4G1dEgyhk9t
         5qFZZsiauwevvq9lZbW7dP6DITGGPMO9/lvQRl0hD5lgFRgfJB5YefbYwVrW2tvU/nvw
         piBt7xLC8Im+QB5e9BgQO2LsWqgs7iL7ePe40BO09z1I/2IeSsPS8WAbArGlqDnNUNOy
         sKfEHQvRbtX3nlO0tObFOIbTnGTqYd2sBG7L6aXUGVbusK/hzL3Pi/trOLjDFH0mPEO8
         47tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=OTGSDI/qurNNnWJ5DD9+nhsFrBdHNtZLnM8Snb9crt8=;
        fh=IpVcWSIOrDusFgXqUT7wMetSHhonRzBbtUv3cr73LzY=;
        b=saLNO0VJLGFUEYDrQ/QlCAjcN/69eAmRav4FJC4u7pQVZzay4yFOEhs4XMEnOcz6ML
         sTZNP5+7+z3gzdGf6iW9mNJnj8fxcfYBmFPBO6HJBYRUud7NUDGeDTzdAUYbQevPIt8S
         WuZr+FZrsEenqmDnN5T/6Pc5OqgCAsZ3Pp9bWrRd+ApkdsNrywQZy6hnerHXPw+8tqMU
         rezIwd6M1gPmObsqkKbc3koEIdoRCFzBOi9PkdBZU9bDxAO1OGVStgbnpKDbfVs6NdfA
         Wd/YwER9l5sv1eT/IsgdNGC9Ov3bBp8XsxVGPuDLfOSTN0BjtS8t6VIeA1Fh8DL/gzqK
         TkzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794716274; x=1795321074; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OTGSDI/qurNNnWJ5DD9+nhsFrBdHNtZLnM8Snb9crt8=;
        b=aRE7IsF92SI8t+TuK5d0zyOXz0O+iemvkZDOqEzd/ywsiIEfWGodBqcEja8EsMuLdh
         Z81kKgVC1X8LJBeVezb7J+tzp7ZBHVm/izO0afLM/Go8KZQloiGWJbJWnzAEno3lj+Wv
         8TGBzwmCzT+MHdxjJOr3Y6Ezu26pGaxZJaXhn8FAgdKfnY1DhygdIxs2Ewg3HIvYgocy
         k8vqMlG9xPQBmvryGDKywluxZ2IKk6JQ/4r9jFKaMQ85jBN4cVzEDg40BHpRIt6TunBr
         djL/9Oq7Ilq7oubBBMBF1lOC52O4TYUj7YxweITsyrTW/E2P9LvhT0fXyEiLzkE1ZGXC
         IEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794716274; x=1795321074;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OTGSDI/qurNNnWJ5DD9+nhsFrBdHNtZLnM8Snb9crt8=;
        b=D0yjkIgx4jw18wHpk2fInHmeInHrCvpkXXMesP5rJmovJWo0F1eTXmwB9kyTUR97bp
         aWW685qgR9/MitPjEV32AKfmhh0/pSWwuyHg2knE0YDNC66KvsW5PC5IJIaRu3uL2UhC
         lvF477W+9RsDiLxrj6UmTipwbaV0/8e9KV4J9nVUqMBrWjf6RBfLf9JfJ/gYzJ8Y22Ap
         7wUWiLng/uDX0896JJTcFrUXHjiSbiedXyKKS/n/JBKSlS/xqVFUiaeC0t3gwS4MaAoB
         9CX99YMQlvdeGGI4RFDXynHlg5yVXMzPMQIG4uqKSO8vencFiwvcQEdNVMOHZ+4ejdmQ
         v2Jg==
X-Gm-Message-State: APuU4Z91mv5udvZZhtI4Im49D4mn6O/s5yTIyCCSy312O0FVJsIFoVM/
	s1x0ub+9lKATPGNtlXV5iCyIBZfK1NIIktxgxXi0c6/JkCbdmpha9mOJ1GSC3JfL/m73ksW3/tf
	izNieCxpNp/FtP/w2+NIh4hhp/PmKLPRKuA==
X-Gm-Gg: AYBFou3GenCjmiChgBJgGR7Cj8NE4WG/e0a8ShX5Vn/V2pFUi7aBaYeXfXq6xLDbZi/
	wX0w3H3fGxIuhxUfqwM99vkAQq5FvYUOBpx1lrfkZlaAZSLa73jLzKMPlh+6WZktZpPg2YUmwdx
	QlISgi2E2tePmxW+HEX8QPfMzZvhWSQPO3tgMfV+8Iwc+0bVsNvM3OA/hkl/W8DprV3A4oQt9s9
	i4mbcejw3OMwDPQBt9Jh2m4jymc7EDq6suUuLzZYI1fL8IpPmTv+jGGiX9i3eyl5S6/c3rRycZ4
	FBqJOMdtkrSxIu2y+ryWssAa8QsHMvX3tqBzi+DbYcparm2fi4eZTgJ2dkoF5FtqDEaOA60tNIv
	BsbzJsTp9Syr9QimfLFR2nlct1GKiA5tGRmP4vOLqmf+OcfyPue3R5HpVmnIzBTF6VFT06AYZOd
	56WHh366B3KQU1qA==
X-Received: by 2002:a05:6512:1114:b0:5c1:598c:bacb with SMTP id
 2adb3069b0e04-5c170a14af9mr2444775e87.64.1794716273492; Sat, 14 Nov 2026
 20:17:53 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 14 Nov 2026 22:17:53 -0600
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Oxunjon Ubaydullayev <oxunjonub@gmail.com>
X-Google-Nh-Sender: AW_J_UpxuDYtlwE80IAW0D3i6-CrljUXbm9QE8ySP31-YCaqfwdAOrjXNsEejnoZYU4JZ5oi1mj-pA5J0LQxg_WiRnD0AFiEcLxsVbCNnJ1-Vkfu90xQX59LaQFtGSou5OoB1GTT5wLO6rU2f6S4MeC_urDkg_XeEUkQNI-x6C_dCDfEJfcsNGqn8JFpVISKZb3CGTnNXWM2skuVflzVkTRWtNvbRwWO6qj8QRVVw04IABiRtonoCSCrVXkEnCSB4O_YvJmzwn2xfIZCGu6o8xCP3P7-0y6i
Date: Sat, 14 Nov 2026 22:17:53 -0600
X-Gm-Features: AclHuK8fUvRWwTTwaTkXhXC6Aagn6c63IAyfWb_CXjeoL70hN2MnlhmHSkn_bhg
Message-ID: <nh-4b1325cc-21a6-492b-a331-3713f9d61db1@google.com>
Subject: nft_payload: a static transport-store check is enforced at runtime,
 and 14 nft spellings die silently (`tcp flags set` regressed in v7.3)
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

STATUS: NOT SENT. Draft held by the reporter; nothing below has been posted=
.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
1. Summary
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

Since 112e447d17f7 ("netfilter: validate L4 headers after userspace packet
writes", first release v7.3), nft_th_write_ok() refuses any transport-heade=
r
payload store whose [offset, offset+len) range covers TCP header byte 12 =
=E2=80=94 the
byte that holds the data offset in its high nibble. It refuses by returning
NFT_BREAK at runtime. Three consequences, all measured on 7.2.15, 7.3, 7.3.=
4:

  a) the documented `tcp flags set` operator silently stops working: nft
     installs it (rc 0, no message), the packet is forwarded unchanged. Thi=
s
     is a regression: on 7.2.15 the same rule sets the flag and fixes the
     checksum.

  b) the break swallows the rest of the rule. In a chain with `policy drop`=
,
     `tcp flags set syn counter accept` DROPS every packet: the counter sta=
ys
     0 and the accept is never evaluated. A rule that was a no-op becomes a
     drop rule.

  c) the condition is static. `offset` and `len` are netlink attributes and
     cannot change between packets, and this very init function already
     rejects another static combination with a visible error
     (NFT_PAYLOAD_CSUM_NONE with a non-zero csum_offset is -EINVAL,
     "nonsensical", nft_payload.c:1239). So the same check can be made wher=
e
     the user can see it, instead of failing at runtime where nobody can.

It is not one operator. It is every nft spelling whose compiled store cover=
s
byte 12: 14 of them, three TCP fields out of the ten nft knows, plus the ra=
w
`@th` escape hatch. Two of those spellings provably cannot change the data
offset at all =E2=80=94 and they die just the same.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
2. The class: 14 spellings, measured
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

Instrument: nft 1.1.7 (static build) installs the rule in a forward chain;
nft itself prints the netlink message with --debug=3Dnetlink; the frame is
captured on the far side of a veth pair; a `counter` (or `counter accept`
under policy drop) placed after the store reports whether the kernel ran pa=
st
it. One frame: IPv4, TCP, doff 5, PSH|ACK, 16 bytes of 0x77.

  spelling (rule text)                       nft's own message  counter

7.2.15/7.3/7.3.4
  tcp doff set 6                             2b @ +12           1 / 0 / 0
  tcp doff set 5                             2b @ +12           1 / 0 / 0
  tcp reserved set 1                         2b @ +12           1 / 0 / 0
  tcp flags set syn                          2b @ +12           1 / 0 / 0
  tcp flags set tcp flags & (fin|syn|rst|...) 2b @ +12          1 / 0 / 0
  tcp flags set tcp flags | ecn | cwr        2b @ +12           1 / 0 / 0
  @th,96,8 set 0x50                          1b @ +12           1 / 0 / 0
  @th,96,8 set 0x58                          1b @ +12           1 / 0 / 0
  @th,96,16 set 0x5018                       2b @ +12           1 / 0 / 0
  @th,96,32 set 0x50180000                   4b @ +12           1 / 0 / 0
  @th,88,16 set 0x4450                       2b @ +11           1 / 0 / 0
  @th,80,24 set 0x334450                     3b @ +10           1 / 0 / 0
  @th,64,64 set 0x1122334455665018           8b @ +8            1 / 0 / 0
  @th,0,128 set 0x112233445566778899aabb...  16b @ +0           1 / 0 / 0

On 7.3 and 7.3.4 every one of the 14 leaves the captured frame byte-identic=
al
to the control frame (nft returns 0 and prints nothing). On 7.2.15 every on=
e
of the 14 runs, and the bytes on the wire are the bytes the rule named.

The inventory is closed by construction, not by search: in nftables 1.1.7 t=
he
only production that writes the packet is `payload_stmt : payload_expr SET
stmt_expr` (parser_bison.y:5856), so the space of spellings is every field =
of
every protocol table plus `@base,offset,length`. The TCP table has exactly =
ten
fields (src/proto.c:602-617); only doff (bits 12*8, 4), reserved (12*8+4, 4=
)
and flags (13*8, 8) cover byte 12. The other seven start or end outside it.

Note for the raw form: `@th,<off>,<len>` counts its offset in BITS. Measure=
d:
`@th,12,8` lands on transport byte 1, `@th,96,8` on byte 12. Writing byte 1=
2
by hand is possible, and it is refused exactly like the keyword forms.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
3. The check is coarser than the sentence it implements
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

The commit message says: "For nft payload writes, reject transport-header
stores that overlap TCP doff. ... keeping doff stable prevents nft payload
writes from changing the TCP header length underneath conntrack and helper
users."

The guard is `priv->offset > 12 || priv->offset + priv->len <=3D 12` =E2=80=
=94 purely
geometric. It never looks at the value or the mask, and nft hands it masks
that make the overlap harmless:

  tcp flags set syn    ->  payload load 2b @12
                           bitwise reg =3D (reg & 0xff00) ^ 0x0002
                           payload write 2b @12
     The high byte of the written word is taken from the packet itself
     (mask 0xff00): this store CANNOT change doff. It is refused anyway.

  tcp reserved set 1   ->  bitwise (reg & 0xf0ff) ^ 0x0100
     Only the reserved nibble is written; the high nibble is preserved by
     the mask. Refused anyway.

  tcp doff set 5       ->  bitwise (reg & 0x0fff) ^ 0x5000
     Writes the value the packet already has. Refused anyway.

Measured: `tcp doff set 5` and `tcp reserved set 1` are dead on 7.3/7.3.4
exactly like `tcp doff set 6`.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
4. The predicate, measured by sweep
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

A second battery writes the store at the netlink level (no nft), in a chain
with `policy drop` followed by `accept`, so delivery of the packet is the
answer "the guard let it through". 33 arms, offsets 0..14, lengths 1..16:

  7.2.15 : 33 delivered,  0 refused
  7.3    : 17 delivered, 16 refused
  7.3.4  : 17 delivered, 16 refused

Refused exactly when off <=3D 12 < off+len. Arms that end exactly at byte 1=
2
(off 8 len 4, off 9 len 3, off 4 len 8, off 10 len 2, off 11 len 1) are
delivered; arms that start at 12 (any length) are refused. Two arms write
values that cannot change anything =E2=80=94 0x50 (the byte already there) =
and 0x51
(doff kept, one reserved bit set) =E2=80=94 and both are refused on 7.3/7.3=
.4.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
5. The regression, in one line each
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

7.2.15 : `tcp flags set syn`  ->  captured flags byte 0x18 -> 0x02, checksu=
m
                                  valid (word d849).
7.3    : same rule, nft rc 0, no kernel message  ->  capture byte-identical
         to the no-rule control (word d833).
7.3.4  : identical to 7.3.

Verdict consequence (chain with policy drop, one packet):
  `tcp flags set syn counter accept` : dropped on 7.3/7.3.4 (counter 0),
                                       delivered and counted on 7.2.15.
  `counter accept` (control)         : delivered on all.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
6. Proposal
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

(a) Move the check where its inputs live. `offset`, `len` and `base` are
    known at nft_payload_set_init(); refusing there with -EOPNOTSUPP (and t=
he
    existing extack channel) turns a silent runtime death into an error the
    user sees at `nft add rule` time. This does not change behaviour for an=
y
    packet that is served today; it only makes the refusal observable.

(b) If `tcp flags set` (and the reserved/doff-preserving stores) should kee=
p
    working, compare the nibble instead of the range: accept a store that
    covers byte 12 iff the byte it writes keeps the packet's doff nibble.
    15 lines, measured on 7.3.4 + P:

      7.3.4        : 12 of the 14 spellings dead
      7.3.4 + (b)  : 12 of the 14 alive again (including all three
                     `tcp flags set` forms, `tcp reserved set`, `tcp doff
                     set 5`, and the raw stores that keep doff)
                     `tcp doff set 6` and `@th,0,128` (byte 12 =3D 0xdd)
                     are still refused =E2=80=94 the property the guard was=
 written
                     for is preserved.
      The one-byte store at offset 13 (flags only) is also admitted by (b);
      on 7.2.15/7.3/7.3.4 that store exists but leaves an invalid checksum
      (see item 2 below), so it is not a workaround.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
7. Reproduction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

Kernels: 7.2.15 (last release without the guard), 7.3, 7.3.4, each built fr=
om
the release tarball with the same .config; guest =3D QEMU/TCG, nftables 1.1=
.7
static, one veth pair, one forward chain, one crafted frame (doff 5,
PSH|ACK, 16 bytes of 0x77, dport 9999).

  # 7.3.4
  nft add table ip p
  nft 'add chain ip p c { type filter hook forward priority 0; policy accep=
t; }'
  nft add rule ip p c 'tcp flags set syn counter'
  # send one frame; `nft list chain ip p c` -> counter packets 0
  # capture on the far side -> byte-identical to the frame sent without rul=
e

The full batteries (14 language spellings + 33 raw arms + verdict chains),
the logs of five boots, the reference verifier (1034 checks) and a selftest
that mutates each log line to prove the verifier notices are available on
request. Nothing here needs a patch to reproduce; everything runs on stock
releases.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
8. Five more defects found with the same instrument
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

Each of these is independent of the one above and is included because the
same method produced it: one number the kernel states about itself against =
a
second number measured on the wire.

1. `csum type inet` at an odd store offset writes a byte-swapped delta
   (F21/F26). nft_payload_set_eval() takes fsum/tsum from the start of the
   STORE range, while the checksum field covers 16-bit words aligned to the
   HEADER. Measured: a 1-byte store of 0xa0 at TCP offset 19 and the same
   store at offset 18 leave the identical word 0x3833 at TCP+16; the correc=
t
   word for 19 is 0xd793, and the captured segment does not verify. A
   10 000-rule fuzzer over `payload set` produces 41 packets with a wrong L=
4
   checksum on 7.3.4 =E2=80=94 all 37 random cases at odd offsets =E2=80=94=
 and 0 with a
   3-line fix, with every other counter identical (2024 accepted, 7976
   -EINVAL, 1935 forwarded). Still present in master (nft_payload.c is
   byte-identical to 7.3.4 there). Reachable only with a custom netlink
   client: stock nft does not emit a 1-byte transport store (dscp is widene=
d
   to 2 bytes at offset 0).

2. `nft_inner`'s tunnel-parse cache is keyed on the descriptor type alone
   (F22/F23). Two `inner` expressions of the same type in one chain share o=
ne
   parse, so the second one's hdrsize and flags are silently ignored.
   Measured in both directions: a second expression with its own hdrsize
   reads the first one's position; a second with its own flags does not fir=
e.
   Not expressible in nft 1.1.7's grammar (three forms rejected, and nft
   prints a rule it cannot itself print back), but any custom netlink clien=
t
   can send the pair =E2=80=94 the kernel accepts it (rc 0) and the dump re=
turns
   both.

3. The set element counter lags the contents by up to one GC period (F24).
   `delete @s` in the packet path only marks the element dead; set->nelems
   is decremented later, in the GC batch's RCU callback. Measured window on
   a `flags dynamic` set with a 1 s GC: 6-861 ms over 12 measurements, plus
   `size 4  # count 4` printed next to a single element. Four backends as
   controls (rbtree, pipapo, hash, concat) all show count =3D=3D live, so t=
his is
   a window, not a general counter defect.

4. The catchall element is not counted, by construction (F25). NFT_SET_ELEM=
_
   CATCHALL is excluded from set->nelems by two guards and returned by the
   dump. A set whose only element is `*` reports count 0, dumps one element=
,
   and matches every packet (3 of 3). `size 4` accepts 5 elements and refus=
es
   the 6th. `nft delete set` deletes such a set without complaint because
   1.1.7 never sets NLM_F_NONREC.

5. A guard that silently disables a field it was meant to protect (F27) is
   item (a)/(b) above; this is the same function, one level up.

None of these is a memory-safety bug, and all of them need CAP_NET_ADMIN in
the initial user namespace; nft_payload_set_init() returns -EPERM otherwise=
.
They are correctness defects with user-visible consequences, which is why
they are reported together.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
9. Provenance
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

Everything above was measured on release kernels built from kernel.org
tarballs (sha256 compared with the published sums) inside disposable QEMU
guests; no patches were applied to the measured kernels. The fix in (b) was
built as a separate tree so the measured releases stay untouched. Full logs=
,
per-arm captures, the verifier and its selftest are available.
