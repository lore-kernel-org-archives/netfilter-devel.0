Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F1D13D501
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 10:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719484017; cv=none; b=nsHmW5Ns+zIE3yH13KP4VQefEWip+h0LR8S6rH9Pe3aL/ooQnDdYRZzTfgClvcfbKx6KaWS5vpysRCKXXWwEruhW0QRxyS9HX3don6HjwQwcen2MYxHQhaBllfiBNzs1nZA4deO1qgyID/8vV3/3DUZ2uIIcLTuF5g+5Eydvmms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719484017; c=relaxed/simple;
	bh=3QqmYcyeBCquDq6d/CFZA8NfNKtrBlQMSQizqWXAJPA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OLPsoUFaq7DYaPCgRIJXflbbq3mHSRjz0MrktM3j6Lk+3cqlpE3OPJ/d0mLM1czkiiwSmNZWGQ6YkyU4PZC+pK3W5OBLujIG9hTFr1cEh6VH9ZoJb92R4aHZ9vCfTeLPVefdLXaRuRilKaGgKgVnsuwqhtLx1fFy0keMqek5zjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oq6emXzO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oq6emXzO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719484015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3QqmYcyeBCquDq6d/CFZA8NfNKtrBlQMSQizqWXAJPA=;
	b=Oq6emXzODp5HJyNUbELSOGSRwbyzjimNx9rNm2OjIZskgCKhWXDjMAoBw9C/atVpswwG1J
	vb8NfZRfzafGLToqm+VtD9cjff6nw0jxuK5GRWyQg4OCsBxYRFhdiGzd0DYDt6069zPFpr
	xr8Jp0k0WteINwHfEjl81rybopVQ9po=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-VU3SsvipM66nxtkZ5RT9ow-1; Thu, 27 Jun 2024 06:26:53 -0400
X-MC-Unique: VU3SsvipM66nxtkZ5RT9ow-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3673288dca3so236935f8f.3
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 03:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719484012; x=1720088812;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3QqmYcyeBCquDq6d/CFZA8NfNKtrBlQMSQizqWXAJPA=;
        b=pswp6OBczFWInwGdlLW6QAx0BtF4Uif/cM7w37n5SLoT9h8F7/v+YZi0B5l6f381mm
         Sv60u9nn227oIO02rXlMHQDgIVYZ3Ch3UX1uCZc0LKGFbPAOYZmGxjB/aSPQUCE7DkH4
         3D7MyEVXKxw6eDPGER8RKUEZDp9/mPa+jCltbPGLJcUKjy3hEbwc15VzSJ+7h07Pj8vG
         AZ09k0nVQTugdJmMqGVp10aeht5c9GT7NtQRsqPBm64wwhnEnMHmdks1ppvNRWqmrOVO
         tQEJ/wDMntKImSFKJMykDuDlirRVn8TrF+0CaUujNhFDRZNLD+sGob2HYkqsd1g+xV6A
         1U6Q==
X-Gm-Message-State: AOJu0Yw1QsiKUpbKTo+OZ6NXGb4nwRCwKkhE3WcJ1/Njy4oqTDWmRCao
	Y+ZOVe34RnG7DYF+I3xbF+EiHPdpMnuPEzVaYd8HmeKGnNkVU3N0alJssKNallA/HDZuWcjvIoy
	D4sFmXypmNXg/UMLPj/iEGWxBLrnIgH8aOUgys0oqNfAVaCnfYkIkxPTR9fv6N2COgg==
X-Received: by 2002:a5d:680f:0:b0:366:efc4:d424 with SMTP id ffacd0b85a97d-366efc4d8f4mr6930534f8f.4.1719484012696;
        Thu, 27 Jun 2024 03:26:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFv6bwA0KM1bgAx4tf//j4GBYVh691+mLqpJjoju4mMwtoyKW+SBX00qbiIq1K2nVKgHs+TZQ==
X-Received: by 2002:a5d:680f:0:b0:366:efc4:d424 with SMTP id ffacd0b85a97d-366efc4d8f4mr6930521f8f.4.1719484012284;
        Thu, 27 Jun 2024 03:26:52 -0700 (PDT)
Received: from gerbillo.redhat.com ([2a0d:3344:2716:2d10:663:1c83:b66f:72fc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3674357fe77sm1366402f8f.44.2024.06.27.03.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 03:26:51 -0700 (PDT)
Message-ID: <af44f85c7d27910c27d47436eff5813cee13452c.camel@redhat.com>
Subject: Re: [PATCH net 2/2] netfilter: nf_tables: fully validate
 NFT_DATA_VALUE on store to data registers
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Linus Torvalds
	 <torvalds@linuxfoundation.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net, 
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com, fw@strlen.de
Date: Thu, 27 Jun 2024 12:26:49 +0200
In-Reply-To: <Zny8zPf1UAYNKL0E@calendula>
References: <20240626233845.151197-1-pablo@netfilter.org>
	 <20240626233845.151197-3-pablo@netfilter.org>
	 <CAHk-=wibyec=ObQrd3pR+cUUchDGXFk3bTp435jOz+NP0xEzXw@mail.gmail.com>
	 <Zny8zPf1UAYNKL0E@calendula>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,
On Thu, 2024-06-27 at 03:13 +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 26, 2024 at 05:51:13PM -0700, Linus Torvalds wrote:
> > On Wed, 26 Jun 2024 at 16:38, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> > >=20
> > > Reported-by: Linus Torvalds <torvalds@linuxfoundation.org>
> >=20
> > Oh, I was only the messenger boy, not the actual reporter.
> >=20
> > I think reporting credit should probably go to HexRabbit Chen
> > <hexrabbit@devco.re>
>=20
> I would not have really know if you don't tell me TBH, else it would
> have taken even longer for me to react and fix it. Because they did
> not really contact me to report this issue this time.
>=20
> But if you insist, I will do so.

I'm sorry for the late reply.

I guess the most fair option would be adding both tags.=20

With a repost, this will not make it into todays PR, I hope it's not a
problem.

Thanks,

Paolo


