Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B892D36EAB9
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 21:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777496630; cv=none; b=atucqW9PjaM+eq8QL7KpIjS5rise2k8xGDC+jXFGKC8Ll//2ks+8gXa63JO9GsLx2+Xy+kUXgsreCAmfFrNSxHgl4v75IjFiQ4Y5vboYJmE4Fm96idpLEV6Wav7pLjvZIUuQbcm7yxGWSzlcsOcFovhBXmsfh7Kk1CYUGVWzxco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777496630; c=relaxed/simple;
	bh=2aA3uWTswagHEVLFA8v5skfAX/JT54EYEV9OQ+OofHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pnt6MLVfD2vMz3LpusH8QxHABv1j+5084Q0PuIpZrkD4H/XVzo2T0dKPMgP+5JockAebQ25hpf9xY1aLAGKo0oxN0yUOWPLOStDQALLpoUlwzBHf61sFwZRzjaq3xRAQY0vi0nj/DIsEpauGCb2JSgVIuLNnELfPM+jnxYTctnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MVLDABHH; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVLDABHH"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso1577385e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 14:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777496627; x=1778101427; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9eaYTnlxpHCY09/j5CrSkFztBrg3e6wlR9rFliILkCQ=;
        b=MVLDABHH2s+wca68H4L+y5daBBNCnTUMhWl6HRklW6MSdEAY4a6yOrY5kF9H2KYkxy
         nMNeIbT2Bp9W649poDIzsnnBlgtFphG1BsOmUM7RBiqNYf9eo7Z6bYShIjfKQgNufM2J
         1Tg61FURYlgeIfbFgNo8oKo1nzyRdmOqwVd2Ipzp4KKbZUVS+vR9elLc79ExJ/79Ijp2
         YDyL72gafLeamh7GrT0yuUYsnCdFACHI2ENscvafXVJsfrbQitd3Xgq5bME2LnQ1yAoh
         ob1NstAwBzNdtWtfzA09d5ECVRx+U5gXGcbSukpebnoPW1y8rFHisrwQ2v+LDiJ6g25D
         sqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777496627; x=1778101427;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9eaYTnlxpHCY09/j5CrSkFztBrg3e6wlR9rFliILkCQ=;
        b=MHkXyJqwpeXbNE7wx4LQRC7br2h3lTDhkt4LvGlg1RSuDCYoMk7tBxQKnE1LaEsaU5
         I15kYrqaENVDEXTRSIlJ+yV0och2eIl4vx/CocMBk7M5SbIc/X7IxjNjwqYFBldmbat2
         M5kChh/B61cuKnEyLi93ZUqJSjlYVApupqKt7XEqjMHteIz6nc8JsbK71jrYU5eJeayk
         ia378CDfUrrrZRZCjA55x/7jy/3zhg82iInJ/Aaz43aRNe8Wh4tU+7PMgSA0TBInrSKp
         p9Lg3UtjYBTo6yy0ba7dp8dVhiSEtbnJ0+MbJuEuXQqhHmrvYbePthS9p843LbCGbjhN
         iWnQ==
X-Forwarded-Encrypted: i=1; AFNElJ++AAPbfR8XKCqmvzrM+X4ESbLtHZuIwK5WoO3J6TVAaFhFbQepEKj6rwIH8s2X/2QNaKEnfY21ZizGk45OMAo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9wOaSw4Fo7iBi13BKYltQC9RYfFsCkk4JPOnuKIcqnLJudJDh
	1x9bXl3qzTYwzFy85jtnc/l1FVrwe26KrF2JzF35HTMZEbqbdB1C+6s=
X-Gm-Gg: AeBDievN/es0k8/ML478pUbKPTw/nWdcuRN9X62k1dhk6kEP3YTS3lyWvE2aikRkuaQ
	vpedtg8JEzFMeKPdE8Dnw/X5mURBnCsOUv+EgD825JwtvPG3Qggi8O//02sucYmpPSA+h0KBn8y
	zr0nz9hiNPi9yp0cXrOXz0rrgGDDas9FQmSbAKpw1egBuud4uowArqnacJzVqOtOAhQrJ1n9vBh
	8aOY2TGas3SEYV5mjqZoOCtsHmz3YCCl90WAckzNwXowahaBPVdZOpoFOBqk2EIU8uxT9l2/Hdm
	LQFApP4Jw0VAhpEqr++VBhQqpSuATxXeMDaTfENmn75tlBo9npnjWoXOWNgaqEtfDshpTllhdkx
	9Az/ZRtUHOeiGp7LPfFk5X0cfG3Vh3tqJhFF7WOEM8h6w17JmUqc4kTtKS+mBcjIwUn4+MIM7KG
	D+L9tzR9nfMfmCug==
X-Received: by 2002:a05:600c:350d:b0:48a:57e1:d8cc with SMTP id 5b1f17b1804b1-48a83e7055bmr3924695e9.9.1777496627067;
        Wed, 29 Apr 2026 14:03:47 -0700 (PDT)
Received: from debian ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a822c832fsm29134635e9.10.2026.04.29.14.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 14:03:45 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] netfilter: fix NULL ops race in iptable lazy init
Date: Wed, 29 Apr 2026 21:03:44 -0000
Message-ID: <177749662469.1430165.8044688741351868980@talencesecurity.com>
In-Reply-To: <20260429175613.1459342-1-tristmd@gmail.com>
References: <20260429175613.1459342-1-tristmd@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 30 Apr 2026 Phil Sutter wrote:
> Is this true? Your patch moves the ops allocation, but new_table->ops is
> still assigned after xt_register_table() has returned. AIUI, the race
> window is just reduced, not eliminated.

You are right -- I missed that new_table->ops is assigned after
xt_register_table() returns. The table becomes visible via list_add()
inside xt_register_table(), but the ops pointer is still NULL at that
point. Moving the allocation alone does not close the window.

We cannot assign ops before xt_register_table() because we need the
returned new_table pointer to set ops[i].priv.

Would a V2 that guards the pre_exit path instead be acceptable?
Something like:

  void ipt_unregister_table_pre_exit(struct net *net, const char *name)
  {
  	struct xt_table *table = xt_find_table(net, NFPROTO_IPV4, name);

  	if (table && table->ops)
  		nf_unregister_net_hooks(net, table->ops,
  				        hweight32(table->valid_hooks));
  }

This way cleanup_net simply skips the table if ops has not been assigned
yet. The register path will either complete and call
nf_register_net_hooks() normally, or fail and clean up via
__ipt_unregister_table().

Thanks,
Tristan
