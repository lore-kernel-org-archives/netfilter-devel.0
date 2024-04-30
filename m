Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3385143737
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 15:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714490777; cv=none; b=tS7IRJJm4CleJZ4vx6i9JZ4dlOny7HE75ZgmYkTvfoGLp5Xgi2+8Oz6mn/sSRMBei29h0sCRC7dRa3PEbc7VhonFG2c9rfsB0pGeXucqPm8CMdLIwXr2atkqzX6L64ePOYInY+ccZinxJRpgopHiU8jTCrSXKBo/qDSdkfdA5s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714490777; c=relaxed/simple;
	bh=c9Ag8VfQRB94PbUjuhJqTFgY7obCbq6vta84gkaHg2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kGI5KorNg01cqkFKuE8a6hWMMEeEUvczTensFN42foDUbFfQMJC/We3/otx5OImpU2GYWISIrnlECbgfczJK+8eP1ns1Zt9hDUrmTtoJ5omFFAoJ+0fvtWSnok81yWdZiWDhzk/NNs96TkO0Ky++n199BKqwRtjOorUKiMixRCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gygdwT46; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gygdwT46"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a4702457ccbso772733266b.3
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 08:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714490774; x=1715095574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9Ag8VfQRB94PbUjuhJqTFgY7obCbq6vta84gkaHg2A=;
        b=gygdwT46Gw3IltztLxgxfnx0NMDoC9HVA4pSxb3XSdgsc01BV6UfDr4YEsusePIrsX
         BXpcDhRXJM9oK+EG+JdN2dpfNSirWIoE7p7379i6CGonOvrXdbcr6GTUED/17mVNZN1G
         gnnS/xvMskyCVyQoyyAmLiQsmufeP7y6B5/YBUvcmVwqmUiDrCfwGk4Svfq/vTO5pFH4
         XFwUT1XDE3MJSG1wnhFw327dgMTp2yoJkDdskoavv49WLyp6ZC+WuqcNgxtEVDeSezaX
         1cqUlTl87afczhL+grdzi3CWiYeG+Lc7kKQB/SyuI9q2n5cj+FZ3I0D2XIULGN1t/lhp
         iVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714490774; x=1715095574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c9Ag8VfQRB94PbUjuhJqTFgY7obCbq6vta84gkaHg2A=;
        b=OEAqHby1uY2/Rv12Kog93oOKuC2QLRTx2ipcHlkBWLw32CIHzCldHuW5ivZLc78Pee
         LMU224cs3CkD5Ia09BPEC4fpHA/aC1pVrK6dIAXQbQEKm0sAsDYcHuiO1+RUG8a9Omtd
         IUvDZd/OcdLbl1gunw/3Zet6oKjF8l/oyrgXXNCvlr6UGTN+usRRsgG3yyThrfdOcK7x
         /bSEbFfc1HnK9rnWx7HTMyPYpsMaUmdN+LTV9DTjyz8LM0pi5WsHnPQlYfbuCqZDNxA2
         BfOrPyt4kgKnfgrzJLy0QaeV3cKytrN8DcQ+bRM3AKBUoK1hoBoEZ3CQ7D9yxsvPR2Ov
         EqdA==
X-Gm-Message-State: AOJu0YxiRpHLT4c5vDaejywNa2KM/d4qKEG+MOrKSrjjtfDkvVbzccCK
	0tr5w7SDvq1NxIUcqctUy91qP7TC9D7MXWlq0gu5mQSEqllecS9t6WcjzzLDJWuPDNCzdegIc6r
	ETJCjm3Aryej4uiOA+0R06zjEKKvvvRY9
X-Google-Smtp-Source: AGHT+IFDh/XrlxRVRNy+Z/70VmOi62zvxp7OldaPxo6s0AQpaQgiGoUtyurg8HAiDXJZZ7pN/mX165zDpgAIuilq5tI=
X-Received: by 2002:a17:906:557:b0:a52:54d8:6d21 with SMTP id
 k23-20020a170906055700b00a5254d86d21mr52827eja.7.1714490773655; Tue, 30 Apr
 2024 08:26:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAM9G1EADHBYk9Y-Y9RBHbAhqOPOMab41DOEh+PZZa6XKGm8drA@mail.gmail.com>
 <ZjEEOLOJX8bE6p1O@calendula>
In-Reply-To: <ZjEEOLOJX8bE6p1O@calendula>
From: Evgen Bendyak <jman.box@gmail.com>
Date: Tue, 30 Apr 2024 18:25:47 +0300
Message-ID: <CAM9G1EBgYqxBmVy_gsKDYkBD1X+rknKMABdjeF3u78vGb7Nt8g@mail.gmail.com>
Subject: Re: [libnetfilter_log] fix bug in race condition of calling
 nflog_open from different threads at same time
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In my firewall based on nftables, I use several different log
subsystem groups for packet capturing. This setup is used for a server
providing access to a large number of internet clients, with each
client in a separate VLAN. To expand the number of virtual networks,
QinQ technology is utilized. One group captures ARP packets (in
certain situations for new clients) coming from the network, for
further analysis. Another group captures DHCP packets sent by clients.
Also present groups for other various subsystems. These are not
heavily loaded groups in terms of packet volume. In the application
where this is processed, each group is handled by its own subsystem.
Each subsystem creates its own thread, where the relevant group for
that service is opened. Sometimes, after a restart, one group or
another would fail to function. It appeared as if data was coming
through the netlink socket, but when nflog_handle_packet was called,
the callback would not trigger. That's when I began investigating what
was wrong.

=D0=B2=D1=82, 30 =D0=BA=D0=B2=D1=96=D1=82. 2024=E2=80=AF=D1=80. =D0=BE 17:4=
6 Pablo Neira Ayuso <pablo@netfilter.org> =D0=BF=D0=B8=D1=88=D0=B5:
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
> Out of curiosity: How do you use this?
>
> There is a fanout feature to distribute packets between consumer
> threads to scale up.
>
> And I suspect you don't want packets that belong to the same flow be
> handled by different threads.
