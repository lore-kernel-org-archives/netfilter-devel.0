Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94250328636
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760611690; cv=none; b=naz91ItdEyR+3SNUQxyogiHgX8pwRXGC16479khtvteHoTqr5j3+d04pc3OSMfcxanGhUJWxDg1FaVu0EETImpBZeHm01km90+cslELpyN5h0XaqHViyWv5PiTDH60Iwu14sjNf58NtCv0SR8Vt+DLoEWQV+foxdkqVaQBnFWJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760611690; c=relaxed/simple;
	bh=yFEsYiCogN+aow2kZWzorI6R4zVGJwnbnGGcQnCPf6E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iGsDY0hljQAv/FkpOwmVBqu2HJWCZ/nakmkbazNNACqa2DJZSj/jMB4NIts9Ngbb7hGh0BaOK6HIydgVI296Jjon0Obwg8y1cXBPq/xwyOziVBXQ0MDp468dBW2ms9Os5XcCfyE9jPgncR47D02lJeEoOjCZES1SifM6mycknf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=uQ91b1ik; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="uQ91b1ik"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3ee64bc6b90so398430f8f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 03:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1760611686; x=1761216486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vj2yUb8R3eX7RD7UoPcqhNO1Z4bWlgfrzVLfpWFTIbM=;
        b=uQ91b1ikE4WTd2xbGpJQzsJWHaqMQx/MPJyNmslQytKypjAaG2BB7yVofq2WSZn2pu
         +BF3UzskR5vefXIST+NOZo+V8tfVet3kmKUmPA5L8CLcOoqOlDBg/DzrNh/+paq7MFAA
         mZUki3SCJMDVYMGbc0PShz2TXTi1mkmqOzMJyKbsBnvfEj92tIPqYqqVl2IUiVtvczWs
         beA+z+AXorg9FLGz1Fawu6/zOLlpENI+zhrxmvmQjFbP69e0EWZgq5xU0Ma65pJK70go
         pxRnDWk7EuBbLbmuxFKCSlMlgm4smN7lAq3fQW9SGwJC477K/a/+OKYYEZl8Lw0l5GkD
         YHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760611686; x=1761216486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vj2yUb8R3eX7RD7UoPcqhNO1Z4bWlgfrzVLfpWFTIbM=;
        b=P7vziKcL3q1WvwFFdMq8n1k/lMJnNGJWvuZVo8Oy0BP3S/8Kwuw42gK0Qa2GrG/xKj
         x9SwxM+Rv2SgglyPeHNeHSxwZyMbnvsIiLYXGDk/bnjnmmz8ZPt8v8UhKh+sf91ITdMV
         iVv21dtTF8mSCkGFdb96bBM2uQpC0Ekanf0Jz529w52UgV3P22FPViQ1XX7VBeScsh2Q
         pzk9rntizlZB+C6oDVjZ5JVjFrTbamJ9+mAn2mgRir2qYdCbN1HNkJ0K/6xnPls81Z4F
         2+If2rXwgY+zDKuHCQAC2ujFPY2a4iI73oITwOKTUWBM9soKBeipMmqsppRWgk7hAORL
         0l/g==
X-Forwarded-Encrypted: i=1; AJvYcCXAMsPcdJ1C8nb5Nyo5kgpoikP+0U2iUJv6h4Zlk7ZlDwkfHKcAWDFLPKRJXANBFhEVGSbmAXjfE880IoNn+oE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlv3L7MymRT1wsbq518ksf0pqwnpRHBMesLu7TNogpIdJ278Lc
	yDeDBofDuBunsRDXN3KVgameiJ2DrpoUkFf8yxae4FjtIMw0Pilrrcqh8UTl2UwB5FQ=
X-Gm-Gg: ASbGnctFaP0c9VDCp9XD7F4Oyt8Kt8vks5bciiqfxpiCzeF83EuAYu7E8zG1EuvKm94
	gj8DJQTxTcJQoowwzb9/UQSjLmxe9mk8Nu9sUr3l2O3UOjHlhYun4EamjPduITxtH+G453/2t+e
	3hkEpGrUWKTGP5Nkshqpud6oRELTAuzoog1tVdio8M3UT79/x2LfC4cdryJaL6g50gM/GCcz01D
	0ZQ1Mk1jDEQLpidz9WBOGBwJbsDEwCwN/+GrJbmEF8w8TXelI7mGZ+B6ki6u6fi0bUJZTPTaA6h
	NXr4AheSitLKIUnqAJMy4PZa81Yucmg9NZ5ILPA0jPjEP810225YWX+q+NV6Ve5ETnbXN1+OP5T
	umy1b6jhFAieEKlHJv2qphKLuyA5qk3XmR4OfANKmaKsN8iDxmzzFODDByLgsbv3Bvdcc0nRZET
	Uh4d+znJ4hjwC5PSXfbwgG0YqXhgY/BqpqUBtAmwB9xHwQ/yfQ
X-Google-Smtp-Source: AGHT+IGgaLPcwdWJH9Gy8ifJz8LWBEVC3gErvq1D1L4gZqOK9ngjbpyI1DEFb6w04ucdJmWpEr+g5w==
X-Received: by 2002:a5d:5d11:0:b0:425:8502:f8c3 with SMTP id ffacd0b85a97d-42666ab95a3mr18043363f8f.1.1760611685676;
        Thu, 16 Oct 2025 03:48:05 -0700 (PDT)
Received: from VyOS.. (089144196114.atnat0005.highway.a1.net. [89.144.196.114])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ff84cbb7sm2729374f8f.23.2025.10.16.03.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 03:48:05 -0700 (PDT)
From: Andrii Melnychenko <a.melnychenko@vyos.io>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] nf_conntrack_ftp: Added nfct_seqadj_ext_add().
Date: Thu, 16 Oct 2025 12:48:00 +0200
Message-ID: <20251016104802.567812-1-a.melnychenko@vyos.io>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

There is an issue with FTP SNAT/DNAT. When the PASV/EPSV message is altered
The sequence adjustment is required, and there is an issue that seqadj is
not set up at that moment.

The easiest way to reproduce this issue is with PASV mode.
Topoloy:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20
```=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20
 +-------------------+     +----------------------------------+=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
 | FTP: 192.168.13.2 | <-> | NAT: 192.168.13.3, 192.168.100.1 |=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
 +-------------------+     +----------------------------------+=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
                                      |=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20
                         +-----------------------+
                         | Client: 192.168.100.2 |
                         +-----------------------+
```

nft ruleset:
```
nft flush ruleset
sudo nft add table inet ftp_nat
sudo nft add ct helper inet ftp_nat ftp_helper { type \"ftp\" protocol tcp\=
; }
sudo nft add chain inet ftp_nat prerouting { type filter hook prerouting pr=
iority 0 \; policy accept \; }
sudo nft add rule inet ftp_nat prerouting tcp dport 21 ct state new ct help=
er set "ftp_helper"
nft add table ip nat
nft add chain ip nat prerouting { type nat hook prerouting priority dstnat =
\; policy accept \; }
nft add chain ip nat postrouting { type nat hook postrouting priority srcna=
t \; policy accept \; }
nft add rule ip nat prerouting tcp dport 21 dnat ip prefix to ip daddr map =
{ 192.168.100.1 : 192.168.13.2/32 }
nft add rule ip nat postrouting tcp sport 21 snat ip prefix to ip saddr map=
 { 192.168.13.2 : 192.168.100.1/32 }

# nft -s list ruleset
table inet ftp_nat {
        ct helper ftp_helper {
                type "ftp" protocol tcp
                l3proto inet
        }

        chain prerouting {
                type filter hook prerouting priority filter; policy accept;
                tcp dport 21 ct state new ct helper set "ftp_helper"
        }
}
table ip nat {
        chain prerouting {
                type nat hook prerouting priority dstnat; policy accept;
                tcp dport 21 dnat ip prefix to ip daddr map { 192.168.100.1=
 : 192.168.13.2/32 }
        }

        chain postrouting {
                type nat hook postrouting priority srcnat; policy accept;
                tcp sport 21 snat ip prefix to ip saddr map { 192.168.13.2 =
: 192.168.100.1/32 }
        }
}

```

Connecting the client:
```
# ftp 192.168.100.1
Connected to 192.168.100.1.
220 Welcome to my FTP server.
Name (192.168.100.1:dev): user
331 Username ok, send password.
Password:=20
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> epsv
EPSV/EPRT on IPv4 off.
EPSV/EPRT on IPv6 off.
ftp> ls
227 Entering passive mode (192,168,100,1,209,129).
421 Service not available, remote server has closed connection.
```

Kernel logs:
```
Oct 16 10:24:37 vyos kernel: nf_conntrack_ftp: ftp: Conntrackinfo =3D 2
Oct 16 10:24:37 vyos kernel: nf_conntrack_ftp: ftp: dataoff(60) >=3D skblen=
(60)
Oct 16 10:24:37 vyos kernel: nf_conntrack_ftp: ftp: dataoff(52) >=3D skblen=
(52)
Oct 16 10:24:37 vyos kernel: nf_conntrack_ftp: nf_conntrack_ftp: wrong seq =
pos (UNSET)(0) or (UNSET)(0)
Oct 16 10:24:37 vyos kernel: nf_conntrack_ftp: ftp: dataoff(52) >=3D skblen=
(52)
Oct 16 10:24:38 vyos kernel: nf_conntrack_ftp: nf_conntrack_ftp: wrong seq =
pos (UNSET)(0) or (UNSET)(0)
Oct 16 10:24:38 vyos kernel: nf_conntrack_ftp: ftp: dataoff(52) >=3D skblen=
(52)
Oct 16 10:24:38 vyos kernel: nf_conntrack_ftp: find_pattern `227 ': dlen =
=3D 33
Oct 16 10:24:38 vyos kernel: nf_conntrack_ftp: find_pattern `229 ': dlen =
=3D 33
Oct 16 10:24:38 vyos kernel: nf_conntrack_ftp: ftp: dataoff(52) >=3D skblen=
(52)
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `PORT': dlen =
=3D 8
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `EPRT': dlen =
=3D 8
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `227 ': dlen =
=3D 23
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `229 ': dlen =
=3D 23
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: ftp: dataoff(52) >=3D skblen=
(52)
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `PORT': dlen =
=3D 6
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `EPRT': dlen =
=3D 6
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `227 ': dlen =
=3D 19
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `229 ': dlen =
=3D 19
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `PORT': dlen =
=3D 6
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `EPRT': dlen =
=3D 6
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `227 ': dlen =
=3D 25
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `229 ': dlen =
=3D 25
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `227 ': dlen =
=3D 133
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `229 ': dlen =
=3D 133
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `227 ': dlen =
=3D 15
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: find_pattern `229 ': dlen =
=3D 15
Oct 16 10:24:40 vyos kernel: nf_conntrack_ftp: ftp: dataoff(52) >=3D skblen=
(52)
Oct 16 10:24:44 vyos kernel: nf_conntrack_ftp: find_pattern `PORT': dlen =
=3D 6
Oct 16 10:24:44 vyos kernel: nf_conntrack_ftp: find_pattern `EPRT': dlen =
=3D 6
Oct 16 10:24:44 vyos kernel: nf_conntrack_ftp: find_pattern `227 ': dlen =
=3D 51
Oct 16 10:24:44 vyos kernel: nf_conntrack_ftp: Pattern matches!
Oct 16 10:24:44 vyos kernel: nf_conntrack_ftp: Skipped up to 0x0 delimiter!
Oct 16 10:24:44 vyos kernel: nf_conntrack_ftp: Match succeeded!
Oct 16 10:24:44 vyos kernel: nf_conntrack_ftp: conntrack_ftp: match `192,16=
8,13,2,209,129' (20 bytes at 2149072380)=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20
Oct 16 10:24:44 vyos kernel: ------------[ cut here ]------------
Oct 16 10:24:44 vyos kernel: Missing nfct_seqadj_ext_add() setup call
Oct 16 10:24:44 vyos kernel: WARNING: CPU: 1 PID: 0 at net/netfilter/nf_con=
ntrack_seqadj.c:41 nf_ct_seqadj_set+0xbf/0xe0 [nf_conntrack]=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
Oct 16 10:24:44 vyos kernel: Modules linked in: nf_nat_ftp(E) nft_nat(E) nf=
_conntrack_ftp(E) af_packet(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_tabl=
es(E) nfnetlink_cthelper(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv=
4(E) nfnetlink(E) binfmt_misc(E) intel_rapl_common(E) crct10dif_pclmul(E) c=
rc32_pclmul(E) ghash_clmulni_intel(E) sha512_ssse3(E) sha256_ssse3(E) sha1_=
ssse3(E) aesni_intel(E) crypto_simd(E) cryptd(E) rapl(E) iTCO_wdt(E) iTCO_v=
endor_support(E) button(E) virtio_console(E) virtio_balloon(E) pcspkr(E) ev=
dev(E) tcp_bbr(E) sch_fq_codel(E) mpls_iptunnel(E) mpls_router(E) ip_tunnel=
(E) br_netfilter(E) bridge(E) stp(E) llc(E) fuse(E) efi_pstore(E) configfs(=
E) virtio_rng(E) rng_core(E) ip_tables(E) x_tables(E) autofs4(E) usb_storag=
e(E) ohci_hcd(E) uhci_hcd(E) ehci_hcd(E) sd_mod(E) squashfs(E) lz4_decompre=
ss(E) loop(E) overlay(E) ext4(E) crc16(E) mbcache(E) jbd2(E) nls_cp437(E) v=
fat(E) fat(E) efivarfs(E) nls_ascii(E) hid_generic(E) usbhid(E) hid(E) virt=
io_net(E) net_failover(E) virtio_blk(E) failover(E) ahci(E) libahci(E)=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
Oct 16 10:24:44 vyos kernel:  crc32c_intel(E) i2c_i801(E) i2c_smbus(E) liba=
ta(E) lpc_ich(E) scsi_mod(E) scsi_common(E) xhci_pci(E) xhci_hcd(E) virtio_=
pci(E) virtio_pci_legacy_dev(E) virtio_pci_modern_dev(E) virtio(E) virtio_r=
ing(E)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20
Oct 16 10:24:44 vyos kernel: CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      =
      E      6.6.108-vyos #1
Oct 16 10:24:44 vyos kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2=
009), BIOS Arch Linux 1.17.0-2-2 04/01/2014=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20
Oct 16 10:24:44 vyos kernel: RIP: 0010:nf_ct_seqadj_set+0xbf/0xe0 [nf_connt=
rack]
Oct 16 10:24:44 vyos kernel: Code: ea 44 89 20 89 50 08 eb db 45 85 ed 74 d=
e 80 3d 51 6d 00 00 00 75 d5 48 c7 c7 68 57 ad c0 c6 05 41 6d 00 00 01 e8 7=
1 28 dd dc <0f> 0b eb be be 02 00 00 00 e8 63 fc ff ff 48 89 c3 e9 66 ff ff=
 ff=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
Oct 16 10:24:44 vyos kernel: RSP: 0018:ffff9a66c00e8910 EFLAGS: 00010286
Oct 16 10:24:44 vyos kernel: RAX: 0000000000000000 RBX: 0000000000000014 RC=
X: 000000000000083f
Oct 16 10:24:44 vyos kernel: RDX: 0000000000000000 RSI: 00000000000000f6 RD=
I: 000000000000083f
Oct 16 10:24:44 vyos kernel: RBP: ffff89387978fb00 R08: 0000000000000000 R0=
9: ffff9a66c00e87a8
Oct 16 10:24:44 vyos kernel: R10: 0000000000000003 R11: ffffffff9ecbab08 R1=
2: ffff89387978fb00
Oct 16 10:24:44 vyos kernel: R13: 0000000000000001 R14: ffff893872e18862 R1=
5: ffff893842f8c700
Oct 16 10:24:44 vyos kernel: FS:  0000000000000000(0000) GS:ffff893bafc8000=
0(0000) knlGS:0000000000000000=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20
Oct 16 10:24:44 vyos kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
Oct 16 10:24:44 vyos kernel: CR2: 000055fbc64ec690 CR3: 000000011de22001 CR=
4: 0000000000370ee0
Oct 16 10:24:44 vyos kernel: Call Trace:
Oct 16 10:24:44 vyos kernel:  <IRQ>
Oct 16 10:24:44 vyos kernel:  __nf_nat_mangle_tcp_packet+0x100/0x160 [nf_na=
t]
Oct 16 10:24:44 vyos kernel:  nf_nat_ftp+0x142/0x280 [nf_nat_ftp]
Oct 16 10:24:44 vyos kernel:  ? kmem_cache_alloc+0x157/0x290
Oct 16 10:24:44 vyos kernel:  ? help+0x4d1/0x880 [nf_conntrack_ftp]
Oct 16 10:24:44 vyos kernel:  help+0x4d1/0x880 [nf_conntrack_ftp]
Oct 16 10:24:44 vyos kernel:  ? nf_confirm+0x122/0x2e0 [nf_conntrack]
Oct 16 10:24:44 vyos kernel:  nf_confirm+0x122/0x2e0 [nf_conntrack]
Oct 16 10:24:44 vyos kernel:  nf_hook_slow+0x3c/0xb0
Oct 16 10:24:44 vyos kernel:  ip_output+0xb6/0xf0
Oct 16 10:24:44 vyos kernel:  ? __pfx_ip_finish_output+0x10/0x10
Oct 16 10:24:44 vyos kernel:  ip_sublist_rcv_finish+0x90/0xa0
Oct 16 10:24:44 vyos kernel:  ip_sublist_rcv+0x190/0x220
Oct 16 10:24:44 vyos kernel:  ? __pfx_ip_rcv_finish+0x10/0x10
Oct 16 10:24:44 vyos kernel:  ip_list_rcv+0x134/0x160
Oct 16 10:24:44 vyos kernel:  __netif_receive_skb_list_core+0x299/0x2c0
Oct 16 10:24:44 vyos kernel:  netif_receive_skb_list_internal+0x1a7/0x2d0
Oct 16 10:24:44 vyos kernel:  napi_complete_done+0x69/0x1a0
Oct 16 10:24:44 vyos kernel:  virtnet_poll+0x3c0/0x540 [virtio_net]
Oct 16 10:24:44 vyos kernel:  __napi_poll+0x26/0x1a0
Oct 16 10:24:44 vyos kernel:  net_rx_action+0x141/0x2c0
Oct 16 10:24:44 vyos kernel:  ? lock_timer_base+0x5c/0x80
Oct 16 10:24:44 vyos kernel:  handle_softirqs+0xd5/0x280
Oct 16 10:24:44 vyos kernel:  __irq_exit_rcu+0x95/0xb0
Oct 16 10:24:44 vyos kernel:  common_interrupt+0x7a/0xa0
Oct 16 10:24:44 vyos kernel:  </IRQ>
Oct 16 10:24:44 vyos kernel:  <TASK>
Oct 16 10:24:44 vyos kernel:  asm_common_interrupt+0x22/0x40
Oct 16 10:24:44 vyos kernel: RIP: 0010:pv_native_safe_halt+0xb/0x10
Oct 16 10:24:44 vyos kernel: Code: 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1=
f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 90 0f 00 2d 29 9a 3=
e 00 fb f4 <c3> cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90=
 8b=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
Oct 16 10:24:44 vyos kernel: RSP: 0018:ffff9a66c009bed8 EFLAGS: 00000252
Oct 16 10:24:44 vyos kernel: RAX: ffff893bafcaaca8 RBX: 0000000000000001 RC=
X: 0000000000000001
Oct 16 10:24:44 vyos kernel: RDX: 0000000000000000 RSI: 0000000000000083 RD=
I: 0000000000064cec
Oct 16 10:24:44 vyos kernel: RBP: ffff8938401f2200 R08: 0000000000000001 R0=
9: 0000000000000000
Oct 16 10:24:44 vyos kernel: R10: 000000000001ffc0 R11: 0000000000000000 R1=
2: 0000000000000000
Oct 16 10:24:44 vyos kernel: R13: 0000000000000000 R14: ffff8938401f2200 R1=
5: 0000000000000000
Oct 16 10:24:44 vyos kernel:  default_idle+0x5/0x20
Oct 16 10:24:44 vyos kernel:  default_idle_call+0x28/0xb0
Oct 16 10:24:44 vyos kernel:  do_idle+0x1ec/0x230
Oct 16 10:24:44 vyos kernel:  cpu_startup_entry+0x21/0x30
Oct 16 10:24:44 vyos kernel:  start_secondary+0x11a/0x140
Oct 16 10:24:44 vyos kernel:  secondary_startup_64_no_verify+0x178/0x17b
Oct 16 10:24:44 vyos kernel:  </TASK>
Oct 16 10:24:44 vyos kernel: ---[ end trace 0000000000000000 ]---
Oct 16 10:24:45 vyos kernel: nf_conntrack_ftp: find_pattern `227 ': dlen =
=3D 51
Oct 16 10:24:45 vyos kernel: nf_conntrack_ftp: Pattern matches!
Oct 16 10:24:45 vyos kernel: nf_conntrack_ftp: Skipped up to 0x0 delimiter!
Oct 16 10:24:45 vyos kernel: nf_conntrack_ftp: Match succeeded!
Oct 16 10:24:45 vyos kernel: nf_conntrack_ftp: conntrack_ftp: match `192,16=
8,13,2,209,129' (20 bytes at 2149072380)=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20
Oct 16 10:24:45 vyos kernel: nf_conntrack_ftp: ftp: dataoff(40) >=3D skblen=
(40)
```

According to callstack, despite installing nf_nat_follow_master() helper,
the nfct_seqadj() call comes almost immediately after, before any
potential setups on already confirmed conntrack.

```
net/netfilter/nf_conntrack_proto.c: nf_confirm()

net/netfilter/nf_conntrack_ftp.c: help()
        nf_ct_expect_init()
        nf_nat_ftp()

net/netfilter/nf_nat_ftp.c: nf_nat_ftp()
        exp->expectfn =3D nf_nat_follow_master;
        nf_nat_mangle_tcp_packet()

net/netfilter/nf_nat_helper.c: __nf_nat_mangle_tcp_packet()
    nf_ct_seqadj_set()

net/netfilter/nf_conntrack_seqadj.c: nf_ct_seqadj_set()
        if (unlikely(!seqadj)) {
                WARN_ONCE(1, "Missing nfct_seqadj_ext_add() setup call\n");
                return 0;
        }
```

Andrii Melnychenko (1):
  nf_conntrack_ftp: Added nfct_seqadj_ext_add() for ftp's conntrack.

 net/netfilter/nf_conntrack_ftp.c | 3 +++
 1 file changed, 3 insertions(+)

--=20
2.43.0

