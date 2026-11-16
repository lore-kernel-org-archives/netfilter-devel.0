Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.79.31.78
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794873553;
	b=hwB71CMR7CQH2nUqxUW2ZA7QoXDW51HtfGu0NYKdycVMsaQsWbnRe7ZNspqSqkdl/j8S
	 bP7BdiwVqatoRzyepLWAtVjDFRxIoDxovaAwSwyx5iNx/FUPew2xiwnkX8nug+QPyaEqv
	 IY9sEgc16na1Ad3eDZf9NqmjMG+vbKa0TnQrjoJgZySPAM/v+NI5lnYUzqmDxW99kWnkj
	 1k/VBzQ6qJzk7xQFfHesSW5fo0jef01ufg2ufJfOdDQYhU0DI6GbFuZex2tUudnf1Iedp
	 a4IMxU4GUxxjR9VbEb6gRcrFltnvgGfy5UPKnFRNRvKOAs/qWqCVbWucWcxvdtRJKWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794873553;
	h=DMARC-Filter:Received:DKIM-Signature:Received:X-Gm-Message-State:
	 X-Received:MIME-Version:References:In-Reply-To:Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:X-GEOIP-COUNTRY:X-REAL-IP;
	bh=nin7jykf+1qwPlDmJuey+0ddsoOn/N4Mltgp5tKoVP4=;
	b=byY/LzhBRS/lFaKqmQqe7x96HK9VvpWUUtjA28U5u8sZtRXPb9d+e2Vga+tUcTI9kqKV
	 wLjE88kI3pHP/uPAhFRFyYHgtOoG3ecF57V/rob3xDkzfXT8CLP4R3YUPdqw+20EcH0jF
	 nmJj3leBEQua01OItGZguf5cpWwQ+Jp2GuCXVVPH4ySIeerSdgdj/0NhVllVOnT6/PyMJ
	 bCnRcqKG+1j93itdVHsXU8iWKky3k9r6K83kwmGGtlq7420qMihiPjJcXUvyioPtX+Sdk
	 LKBG0FcmGQdIQ/12cn0Wa7A4v+WOvTnLIomSJmNpuvA7V5TXxigv9k8xj5+yTSY6QWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openservis.cz;
	spf=pass smtp.mailfrom=openservis.cz;
	dkim=pass header.d=openservis.cz header.i=@openservis.cz header.a=rsa-sha256 header.s=openservis header.b=AalfMdcp;
	arc=none smtp.remote-ip=80.79.31.78
Received: from s01.openservis.net (s01.openservis.net [80.79.31.78])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B363C606A323
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 23:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B363C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openservis.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openservis.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=openservis.cz header.i=@openservis.cz header.a=rsa-sha256 header.s=openservis header.b=AalfMdcp
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(Authenticated sender: info@openservis.cz)
	by s01.openservis.net (Postfix) with ESMTPSA id E097021E
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 00:59:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=openservis.cz;
	s=openservis; t=1794873548;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=nin7jykf+1qwPlDmJuey+0ddsoOn/N4Mltgp5tKoVP4=;
	b=AalfMdcpjgwRnrXrFjIaFg/M0S2CtWwqzd/pOYOM9mGI70xKVDY45td0ap6w6rzP5gdLRo
	iywUD00KnPbY2OejY98t3VuJmROktyRF7fr96XzYhxq5PCQx+3dXq1g8VTD+nPZxqK7s/f
	uQrW793VqNVFPbKie65RhG4tnwEVH9MJgPZDKXp9aMdqjQek6OZtu4Mvw7bDOXFrbk4Q7J
	Mc0Y4w2bAhpoAgi51h0ZvS1HMg8pQDaSiCQnSJP1YescI0AJsgQg2kIGDawh/mthf0Eixf
	EVdyQPfcvElv3mg9i3NdkwuaN64NXaGFtRDMuFHqw51iYMgaEwJSmCOKm+Pw+w==
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5364648ae07so43567271cf.1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 15:59:08 -0800 (PST)
X-Gm-Message-State: APuU4Z/e1XL7x62LMjlhDEYfjPxQ/QIsLbag3LE3P0nL1Je1DUintkfR
	5SNmMyYYXxTOJHcJ691X+i45xuHZrE9aQi37VvamQZiQZUNGJbEY6nB2TNLgax7r4r2hLcXha2/
	1RIvXmopyur9DSXAOLjmXuv0cKM0o8/Q=
X-Received: by 2002:ac8:5f51:0:b0:535:2283:20a3 with SMTP id
 d75a77b69052e-55ac775f26bmr217181761cf.33.1794873547763; Mon, 16 Nov 2026
 15:59:07 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAFvzkdAXBNAWcHFNo6akAo63Wd8B_jvhkt=AEmuLR9fgPBEfGg@mail.gmail.com>
 <avuFkgYTcgaVISkg@strlen.de>
In-Reply-To: <avuFkgYTcgaVISkg@strlen.de>
Reply-To: info@openservis.cz
From: "OpenServis.cz" <info@openservis.cz>
Date: Tue, 17 Nov 2026 00:58:31 +0100
X-Gmail-Original-Message-ID: <CAFvzkdD-y0XZ7v1Yi8WC8uVdJhg3qDuFQRzfd5qaikc9QZn6Tg@mail.gmail.com>
X-Gm-Features: AclHuK_VQzfAeziU74sDSpTrMqHvPO1d76NDLas38q9C84hFt1lIf1I2KmLhkMY
Message-ID: <CAFvzkdD-y0XZ7v1Yi8WC8uVdJhg3qDuFQRzfd5qaikc9QZn6Tg@mail.gmail.com>
Subject: Re: [BUG] netfilter: synproxy: server ACK carries TSecr shifted
 twice, rejected by tcp_check_req() since v6.15
To: fw@strlen.de
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	coreteam@netfilter.org, pablo@netfilter.org, phil@nwl.cc, edumazet@kernel.org, 
	ncardwell@google.com, kuniyu@google.com, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-GEOIP-COUNTRY: US
X-REAL-IP: 209.85.160.176

Florian Westphal <fw@strlen.de> wrote:
> Please try this patch:
>
> netfilter: synproxy: fix double tsoff application in server ACK TSecr

Thanks, this fixes it here, for both IPv4 and IPv6.

Mainline 141b164bbe18 (v7.4-rc3) without and with the patch, same lab
script and rules as in the report, run in a QEMU/KVM guest, iptables
v1.8.11 (nf_tables), 1000 sequential connections each. IPv6 goes to a
listener on the SYNPROXY host itself (Docker userland proxy):

- without the patch: TcpExtTSEcrRejected +1048 (IPv4) and +1016
  (IPv6), 12 and 4 connections over 0.5 s (longest 1.69 s and
  1.67 s), TcpExtTCPSynRetrans +12 and +4
- with the patch: TcpExtTSEcrRejected +0 and +0, no connection over
  0.5 s, TcpExtTCPSynRetrans +0 and +0
- capture of one IPv4 connection with the patch: backend SYN-ACK
  "TS val 153206942", ACK from SYNPROXY "TS ecr 153206942" (without
  the patch 3776466496 vs. 3257743975, i.e. tsoff added twice)

All other checks of the lab still pass.

Tested-by: Dominik Shaim Ulrich <info@openservis.cz>
