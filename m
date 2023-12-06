Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="acFgTjkd"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2D690
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 05:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701868924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E1ad/QLtBMLYSwfLFz8tg2Iom9y9cyPipjdmfvG8c2c=;
	b=acFgTjkd92rSxJqBWEy8GU6nwIS7aVHdMZ3ka3pwqIOk5QQD5ygW8MjGZWVFefnzJWXp+N
	yV8KV1KuIcup+wm6fL7d7oCgLMP48+f/Ul+2qNc/2U89BnFATUgj4uoSp/CgKB/ut5hvo2
	+nWPOiyUK6w1+GrvN72i3NP/qIFxSCY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-kkT8Rmv8PjywuEhCWQMU9w-1; Wed, 06 Dec 2023 08:22:02 -0500
X-MC-Unique: kkT8Rmv8PjywuEhCWQMU9w-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-54cc6ae088bso204905a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Dec 2023 05:22:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701868921; x=1702473721;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E1ad/QLtBMLYSwfLFz8tg2Iom9y9cyPipjdmfvG8c2c=;
        b=FXEoVe3J1dxPo1SCCU5h9WnHe0h0L9QnA2fhjXrnGul0Cc0Cd1+cV32E5T0ScnNnZP
         godMd4zpQw1/Y89UmiKpVhy9b40HCkDBbvYLU+hqOKXv8EsfFwICr/DkTxVVrZLKXNYY
         DhlipL7EhTR3qAiEo5eR/xBKYsxyRvg/1FaMYEaF3rY/C1uiQMgD5ar4WZWzkLQ1mDRk
         Y6lkDiUfj6frIOgdjulGQjDPzBys29dWUaLt7+JN3c/4fjzn+bGBuImpp44IgT9g8cxX
         xU6lT5h2CgJ08/JlmTH+b66+0wsZUaZZODU+p+QXBZCvtelF1tASbhWmkBD4nxIyXlDB
         GoAA==
X-Gm-Message-State: AOJu0Yzaaxmgr2bmF6YYmf6Kdd8oExstccDq/8EQmDuw1o6o/zffD3+D
	7+RM6eZaqh9Z2EJI+sIKYNcnYnk9EQV403ieUjvnRmG3no8zKqb25JOs/DrCtpcayrPLA1qcC93
	ytG2O+l1awkPdqE9V7qT9UAZs1dGS
X-Received: by 2002:a05:6402:2787:b0:54c:6431:6910 with SMTP id b7-20020a056402278700b0054c64316910mr1290868ede.0.1701868921558;
        Wed, 06 Dec 2023 05:22:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFA8/AfHKI1aNvTjKR4SLejHtsYzIlx26P3idtOvItA9ceRNJ08zFjTXxuKBzbYXDqGTAm0NQ==
X-Received: by 2002:a05:6402:2787:b0:54c:6431:6910 with SMTP id b7-20020a056402278700b0054c64316910mr1290853ede.0.1701868921137;
        Wed, 06 Dec 2023 05:22:01 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id h10-20020a50ed8a000000b0054cc903baadsm2427610edr.30.2023.12.06.05.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 05:22:00 -0800 (PST)
Message-ID: <1f932f8ddf653979454537b5be2739182ba3cab7.camel@redhat.com>
Subject: Re: [PATCH v2 nft] parser: tcpopt: fix tcp option parsing with NUM
 + length field
From: Thomas Haller <thaller@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Maciej =?UTF-8?Q?=C5=BBenczykowski?=
	 <zenczykowski@gmail.com>
Date: Wed, 06 Dec 2023 14:22:00 +0100
In-Reply-To: <20231206121653.GH8352@breakpoint.cc>
References: <20231205115610.19791-1-fw@strlen.de>
	 <fcb3ef457002c89246c24a79290d25498ef7b0b0.camel@redhat.com>
	 <20231206113836.GE8352@breakpoint.cc>
	 <5aece71107a2716d9e6742cbc4e159c8c65a5ba0.camel@redhat.com>
	 <20231206115906.GF8352@breakpoint.cc> <20231206120447.GG8352@breakpoint.cc>
	 <9d11bf95bd1b07e15cd7160ab310794ea5d4b8b0.camel@redhat.com>
	 <20231206121653.GH8352@breakpoint.cc>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 (3.50.1-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2023-12-06 at 13:16 +0100, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
> > > Instead, feed the json-nft file to nft, then do a normal list-
> > > ruleset,
> > > then compare that vs. normal .nft file.
> >=20
> > The .nft and .json-nft files are all fed back into `nft --check -
> > f`. So
> > that is happening too.
>=20
> Not really, this checks that the parser eats the input.
>=20
> > It will also comparing the raw files (after sanitize+prettify),
> > which
> > is closer to the original thing that is supposed to be tested. That
> > is
> > why it's done.
>=20
> "metainfo": {
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "json_schema_version": 1,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "version": "VERSION",
> "release_name": "RELEASE_NAME",
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "version": "VERSION"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "json_schema_version": 1
> }
> },
>=20
> i.e. it fails validation because the on-record file has a different
> layout/ordering than what is expected.

Does this mean all tests on `master` have this problem?

>=20
> But if you feed it into nft, nft list ruleset will generate the
> expected
> (non-json) output.

where do you encounter that? How to reproduce this?

Is this an old libjansson? Since 2.8 (2016), JSON_PRESERVE_ORDER is
implied. Maybe libnftables needs to set JSON_PRESERVE_ORDER flag at a
few places.

>=20
> > What issues do you mean? I don't see any. Did you test/review the
> > two
> > patches?
>=20
> The first one is applied.=C2=A0 The second one I applied locally.
>=20
> But its still picky about the formatting.

That's a problem...

