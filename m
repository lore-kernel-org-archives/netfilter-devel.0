Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C431D33F8CD
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Oct 2025 13:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761138124; cv=none; b=pcUo3cMpFU+hLT1aXRjl2ctwMSea0DuZX0cg9E21fi1LbvJZdQmLvGlRSO0E+eIgF86yflbEZ9vLRcthJ05mgK9ci5bbHgDiYjp9cxkHg0k01LhAamvKA+uCH4snjxCPGH6AJNzyDbBTO6yQ512Sivwv8dvJH1ZmJEedx1B7nr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761138124; c=relaxed/simple;
	bh=YyOT6xckVX0MriiIl7HBo2d4T8KTUI4Zs0unfYBtZTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O9HOi9HMqUTP9x4t9xuyWbZ9i3jTtGN2vZptwc+ltigxUlGCN3Xwsfw5LNvj7PGLCrmG0+I0CwLWKxd0Z5etmFaCxIiHkNYR4VjBGrr7JKwgHOGKEYmiUcN0uwV2rJdUjnUdZ0+7a11SFfllKS9l5DqyUupPdStTBumOWG3mz0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=EMT3FnbT; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="EMT3FnbT"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7849f01e56eso42889127b3.0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Oct 2025 06:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761138122; x=1761742922; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YyOT6xckVX0MriiIl7HBo2d4T8KTUI4Zs0unfYBtZTE=;
        b=EMT3FnbTWISnp8qFS8tmeCFyrvbxL4ZJ3ydv8XGpLrnSQyGWnNTULQQ1Y4/Uv7YtmJ
         aejyuE/km3ZFPTNKjgN35GzsNqohMByj2wC3QhKxYd4BTwyYnzO8/PimtHyP4DWyoUmC
         HbQmXuGB7ijOqy+DW0+cnwrvuyAPzXLvEEvWLH3YlMN5N7hXu1htCCv0Ju4buO0PQYca
         BKJLZkFB2wj5fDbS8BIdY5l1/ZZC28uY8WFgIbJAQD/y9gzBsEBc9kAXHAh24JO4okOD
         wdm2j6AkVXrjr920Hq9FSNCStvE9MVB6Q6rWrwny4fxWx8knVoz6lCNVeNEuUjL+jY9z
         7kQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761138122; x=1761742922;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YyOT6xckVX0MriiIl7HBo2d4T8KTUI4Zs0unfYBtZTE=;
        b=LdtIVvCykJ8jegOtZKHHAP650l7VMZEzRGGw35mnZF43VWckvCmzxyHqODlJEox1cf
         ENCa3MbhBU7daCpZynp6UdoP3yoirO7ooApHQ5hM/XcIDCSoiw5Wc8fGVVYI/OKkcA/G
         Gwz+8hZ71a2N+DWPuRBQz+2h0OESXgbQL22lElSek1Q/LdQXPCW2Bp8KLLOG+e1TKZQO
         PYK6oSScXYzZ7IFLmYPX2guFPVTtDujIU+LX+b1nfCVCytHuOWKMq76TYJwUxBujxJgG
         rSWDdVoqu9tCzbSh2mK3e34hopMq8XG5fQBOjgTT026yM7FXciiHwIOVxPpevhMSjOr0
         yWMw==
X-Forwarded-Encrypted: i=1; AJvYcCVdVmTg1m57ikeLZqpYtiw/qkQL7dLoppgniQlWQHnmYi/7IPgnOVIBwPFVga1mbvW85oTE5Nyjx9vNaL88nT0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIKmdfEIg3s2Z1j2GZj+3s0G3Z2I5sliEQWNFEvD7ckQjBn1d8
	DbLNHf20G7ShBSApKShjsq6hYGq9vXqQoJJNK6WoDTo/Ik4wMsP9GIS95dbokQ3gfnk3CqVqQI6
	r5JPVbfNwha8BP2IrbIUcNaIhk8pp0CgqeSDk/ymbCw==
X-Gm-Gg: ASbGncs5QJkJ3H9p5uSQkBT9gREqW9HGqK3c9WBE42KjZT214FOgjNS14H3/IM63X0/
	ct8QZpRjUJLwiLhazr7IqfgzN9ah8zWUbGYG/NS7L/iSOdzY8WGzE7sYJliayr6m03StVLpnnL2
	ujc34Hngoacx7OJD/S9rPT2DWJo8ibzpjuL7Rqvyu5PN0g8cLhnNgqCCbXh9cinFqGfA9IxfXdG
	jgATyuFmlIQbIMq5O5+XgxeGuOxAwGQeLcr6JSyRSeIANGFM9iqfeFyvVmyj3mulk7NoEiX
X-Google-Smtp-Source: AGHT+IF9jG7efkMJkLjrKK96cUycd0uKP1eoJk4jV4LE5zYD+KPHywlzQYSMFmQ/paz3aQtOfKK1rFQpJc1+j+AphxY=
X-Received: by 2002:a05:690e:4182:b0:63e:d1f:d683 with SMTP id
 956f58d0204a3-63e161c551amr14636102d50.45.1761138121557; Wed, 22 Oct 2025
 06:02:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251021133918.500380-1-a.melnychenko@vyos.io>
 <20251021133918.500380-2-a.melnychenko@vyos.io> <aPeZ_4bano8JJigk@strlen.de>
 <aPghQ2-QVkeNgib1@calendula> <aPi8h_Ervgips4X4@strlen.de>
In-Reply-To: <aPi8h_Ervgips4X4@strlen.de>
From: Andrii Melnychenko <a.melnychenko@vyos.io>
Date: Wed, 22 Oct 2025 15:01:50 +0200
X-Gm-Features: AS18NWCJ-LY11lV6XRcH3jguswzoDQqltcrK4QfPMuRXpo5tSQWNpGqcBGGDgzU
Message-ID: <CANhDHd_iPWgSuxi-6EVWE2HVbFUKqfuGoo-p_vcZgNst=RSqCA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] nft_ct: Added nfct_seqadj_ext_add() for NAT'ed conntrack.
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org, phil@nwl.cc, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

> BTW, this fixes DNAT case, but SNAT case is still broken because flag
> is set at a later stage, right?

I've checked SNAT with the "PORT" FTP command - didn't reproduce the bug.
I assume that `nft_nat_eval()` -> `nf_nat_setup_info()` sets up seqadj
for the SNAT case.
