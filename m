Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D43213A3EE
	for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 09:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716803979; cv=none; b=b0jrIpy6r1RDU3ezCGJyjlu2oXNUvsVSz4LoTT9lh6XLMdWC+Z6Rvs8okOBQcOWxXl1YEkAP3cpnzrPntCmfxdzMtHTcu+7XVZVRde9UpkY/sAXmu5op4mfZzMtzPranYw279zp9EtBBNz3Ou5/pAiJs0s0fGn1c3OO9BZ6Qny4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716803979; c=relaxed/simple;
	bh=/FHfxZVg440iDHCQlYnMSIWYIYy8cpjJGx+frYN6DL0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mgu+eKgsFj+Zl6Aw7ri/DTt67d7JruuSVbmN8Ch4bzFRZe8vuHzvWWCKJP9ImJYOPMVl+CW/Wc+K2MBhVNA/4Sp06GkVCNetomEGbQuZUJYgxYSS6uch85miyv1Lu0nAxlNhhmvlSUo+y+QGLXsyh0TcVcQVPBqT4vcwMvcgThU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eFwQFtZC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eFwQFtZC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716803977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QwYZ+XIV2SKNxYkqQZgxZSj3pnNljcEoq3xMNMGVYYA=;
	b=eFwQFtZCIfx9fqUeF52I+0BEz70PbpAV8tMCVhjtXqRvdgrVMKoI9ed9oXv8s+kjid5IEc
	dCxV5i2g+lSuXCqaphJFs87W12FBUcz6tO+GhAZin68ftMLM55Od1TNfmLoz4uZzDTZFsh
	lj0o5rM96S4Xk8kmvq1MBjgyVkG+ezw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-iAIqnjezP2SkzAfcIWygqw-1; Mon, 27 May 2024 05:59:35 -0400
X-MC-Unique: iAIqnjezP2SkzAfcIWygqw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6ab90673befso4753806d6.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 02:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716803975; x=1717408775;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QwYZ+XIV2SKNxYkqQZgxZSj3pnNljcEoq3xMNMGVYYA=;
        b=sXelROLWb1U5TeQ8bSAaToBfd1wktOsrijaeSEMfReTScam7/Df4kKQwZ7w1UNGCJP
         KKVI5H08HjYpKXjSUvhBxgzLfTLGCdxEP9viOx9LBcLI77x2bS6rhARUSXs+zshvc/hm
         lMeqkZQ1ZBNbVWNcm5YecwqRXXRI4eEqduLCAmyGkoNzAhA8O7R7fvLmhufT9c8cahoS
         rJ8jQFt+l9h2hbgJ+psr0yRnFKnd4LOnX6tJHMDNyveg50tNMzHYaDQ9iMTQBkRLAyg2
         mmE7ss8sXYzuy2N5JNM5pMhGhtbltSJyZPasK1K5GuMWe0Jqj67qucglr5/6PkpQ+vlV
         HYKA==
X-Forwarded-Encrypted: i=1; AJvYcCWEg62dlH4tYnCQXbSxGCquUN0q9GzPGxOx4qDxnaIppYJc4/EcIE6XyQ0K7FqdnFDvAIa7LW4yIAPJVhfWpwdyEQ39uNkmdjb9n5PFir+L
X-Gm-Message-State: AOJu0YzP6nsQz0tO1LVHT8dDb3L2vt+rSvqZI9AyIqy6B/aMq56ZPfMj
	V1xQlfYhJKPu+JOG8j0rQ58QhfY2q4cMXjcRvBQFNl2gxil5fM9XGgFKljG6LhtT4s15xVjOyy8
	r74MAZvlLPm2hVlt9OLgvzo6n4mQihYpRY4jmN/73h2YWpe5tuVo3D4hw+mqziOaQ1g==
X-Received: by 2002:a05:622a:1822:b0:43a:5595:7410 with SMTP id d75a77b69052e-43fb0e4891bmr101160951cf.2.1716803974699;
        Mon, 27 May 2024 02:59:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEn7s/iqOSLtUzLvvdoC9Y6PvM/H5rc9iBCIhvSEBtBUCk6k3VTc/Q6o/Zm3QIpAI7A0IYXyw==
X-Received: by 2002:a05:622a:1822:b0:43a:5595:7410 with SMTP id d75a77b69052e-43fb0e4891bmr101160701cf.2.1716803973969;
        Mon, 27 May 2024 02:59:33 -0700 (PDT)
Received: from gerbillo.redhat.com ([2a0d:3341:b094:ab10:29ae:cdc:4db4:a22a])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43fd16b2dc6sm3837091cf.63.2024.05.27.02.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 02:59:33 -0700 (PDT)
Message-ID: <57354e03b78f382e48b3bbc1eeec9dd14c3e940f.camel@redhat.com>
Subject: Re: [PATCH net 0/6,v2] Netfilter fixes for net
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
	edumazet@google.com, fw@strlen.de
Date: Mon, 27 May 2024 11:59:31 +0200
In-Reply-To: <ZlJYT2-sjA8gypwO@calendula>
References: <20240523162019.5035-1-pablo@netfilter.org>
	 <ZlJYT2-sjA8gypwO@calendula>
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

On Sat, 2024-05-25 at 23:29 +0200, Pablo Neira Ayuso wrote:
> Hi,
>=20
> On Thu, May 23, 2024 at 06:20:13PM +0200, Pablo Neira Ayuso wrote:
> > v2: fixes sparse warnings due to incorrect endianness in vlan mangling =
fix
> >     reported by kbuild robot and Paolo Abeni.
>=20
> I realized checkpatch complains on use of spaces instead of
> indentation in patch 4/6.
>=20
> I can repost the series as v3. Apologies for this comestic issue.

I think the overhead of a repost would offset the benefit of cleaning-
up that minor format issue.

You could follow-up on net-next if/as needed.

Thanks,

Paolo=20

