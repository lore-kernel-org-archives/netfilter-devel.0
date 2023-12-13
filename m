Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fDzStcoN"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93AF83
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 08:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702485165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OY4qvkBvXm+dbkOzAT2p880oLN6wUkDekqt8TDLDFoY=;
	b=fDzStcoNQ4fzkyW6psN8LJ8FPl4ufzb12OtqQwxYf+z1UGZh2plXOOciRzzHmSwZZwC8gh
	CjiAvV0ABe5QdMuEzwachxADhuRnuVjg2i0cIKuiASgF8zRA12jrAShTPGo0vmM/zWucXR
	vjQOmQDRsD+Edv+IVbQ9Q/iOhlSrWJU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-zWkiHNvGO6KpuDbHL51ClQ-1; Wed, 13 Dec 2023 11:32:41 -0500
X-MC-Unique: zWkiHNvGO6KpuDbHL51ClQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a1cf7d2af71so77387166b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 08:32:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702485160; x=1703089960;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OY4qvkBvXm+dbkOzAT2p880oLN6wUkDekqt8TDLDFoY=;
        b=Wqp2NHYXE/9aZCwLbNh0V7Nw2SXs0RGfrC3IXphFE4pHgmQtFMspDU2hlQo58DwH1k
         eqeyjJKt8zqJbUHd2itNQZIxMV/OuXCJhEDY2bd8x8LAlDI9VkL38uVt7GQ2iHPH45JE
         1cCFyOMVnnhBz1U7HNxjNgXgGwuh3cPilqeoQzKanQvMkhNEhpHuH+4N7VJ++RZ1NWEW
         D6Dak9iFnYWqPXhXLKS3WEQndU/tbwfnBkV4ZQpFZzG8VVtflUUZiMKdXOuv0hmjjd05
         AG9KVxCkzzQis/GK0Q3YH+P6RxvJSBEt5B8HiRmuigBBbrvgTycoJW3vRFja3l2LTGyw
         DARg==
X-Gm-Message-State: AOJu0YzC/SSJv3SSPhl4P2uX6a4WDxlWKvBP6ZPObe85dxpAMX/X7BaE
	qmKoFd2YOPI9rg0NWCL5bsKeftaEsnOUjliOV/fVJh665YypXmlzoHkCusB3RSTKZ3YJr/ltLjn
	O9f3i1Gx5dh+2lga4gvEszmE57O3G
X-Received: by 2002:a17:907:a709:b0:a1c:7661:d603 with SMTP id vw9-20020a170907a70900b00a1c7661d603mr9504420ejc.4.1702485160801;
        Wed, 13 Dec 2023 08:32:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFhBtl6oeea6vTk1DOcT6lfcdIwkcDbP2APVdpz+p24rewPW61GZdR1O2WlQ/4cGDV8wO7TQ==
X-Received: by 2002:a17:907:a709:b0:a1c:7661:d603 with SMTP id vw9-20020a170907a70900b00a1c7661d603mr9504401ejc.4.1702485160437;
        Wed, 13 Dec 2023 08:32:40 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id un7-20020a170907cb8700b00a1b65249053sm7966924ejc.128.2023.12.13.08.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 08:32:39 -0800 (PST)
Message-ID: <17fbf1879c790d2dd59ec6367d01002b5d3b5f3a.camel@redhat.com>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
From: Thomas Haller <thaller@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, Eric
 Garver <eric@garver.life>, netfilter-devel@vger.kernel.org, Florian
 Westphal <fw@strlen.de>
Date: Wed, 13 Dec 2023 17:32:39 +0100
In-Reply-To: <ZXnKpoMQnsoTK6sA@calendula>
References: <20231208130103.26931-1-phil@nwl.cc>
	 <ZXhbYs4vQMWX/q+d@calendula> <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
	 <ZXji-iRbse7yiGte@egarver-mac> <ZXmgAu3u2w+Xjh8+@orbyte.nwl.cc>
	 <ZXnKpoMQnsoTK6sA@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 (3.50.2-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2023-12-13 at 16:15 +0100, Pablo Neira Ayuso wrote:
> On Wed, Dec 13, 2023 at 01:13:54PM +0100, Phil Sutter wrote:
>=20
> > >=20
> > > I don't think we need a persist flag. If we want it to persist
> > > then
> > > we'll just avoid setting the owner flag entirely.
> >=20
> > The benefit of using it is to avoid interference from other users
> > calling 'nft flush ruleset'. Introducing a "persist" flag would
> > enable
> > this while avoiding the restart/crash downtime.
>=20
> I think this 'persist' flag provides semantics the described above,
> that is:
>=20
> - keep it in place if process goes away.
> - allow to retake ownership.
>=20

Isn't the problem to solve that `nft flush ruleset` deletes tables
owned by somebody else (firewalld)?

Using the owner flag for that seems wrong, if the overall semantics of
that flag are not desired.

A "persist" flag sounds like a good solution. It would just have
informational value (for user space) to be skipped by `nft flush
ruleset`.


Thomas

