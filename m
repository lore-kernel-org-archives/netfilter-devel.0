Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD0E2FE56F
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Sep 2025 17:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758130444; cv=none; b=ABMsIoroRlCjl60kg3WUJ06DVRpr6MeLlyZ7UuT+3kW8z99WyZ/xbcCtTYIvWZmqFCea052PGi6HmnrvKthkVwfzCHF+XZdxem7DUJFXjYslJqTPEege1qQN97LZhrH6YND94FAiqXUf2bc6ukNK2Hf7fRR11H32bzDmTn6hoH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758130444; c=relaxed/simple;
	bh=yL5XyHaFwcuHLoUx1QyC95VoaQkl9On6tV5d0jN31ds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JKp9HT6PlMqn2poiw3Y6tNqwJDl5MuNvQ4V3gjqdVf0KzhGj4DM5yCclawg2mWDqKB4opMz9iq4lkoR53uEzBze+qlORV6UhoMQbnGyOYsd5AKV5CIb9HA2yM4F0gl4jhluWuWB9soltLE5qUG/bOFP+JyL/gEUVJGYtZf2l4VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J0yP/l4N; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J0yP/l4N"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ebc706eb7bso1902885f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Sep 2025 10:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758130441; x=1758735241; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yL5XyHaFwcuHLoUx1QyC95VoaQkl9On6tV5d0jN31ds=;
        b=J0yP/l4NItgfofzDi1vOnSX26SRhdFol1FMmRTsqFXQh0Fr6ppZCUIyg6h7Eg+Eqck
         vEEHTfg9MpAF5t88iZ0Vm04CLIBttvQ4CiV0Q6jzjtDCge7ZsUbODPp7YmE0iEmM5XU1
         Gredxml3XQ3fuFebO/JutSNe4xWMniEbtwL2kVAOsADsLYyCplCduvhLUuRzeuZWQvJI
         AygXK+srDR7OibJWtI7eKBpYcxUxbJsd2GFqrdw1ejy1ICbgM+JoklsynzZwRAAyOqej
         5DAQANeLKmykyVCYd7NCpVPLUCRQh0IexrCpJzeZGLVUtzaFe17SXc08aHuhRYEeiNrE
         QJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758130441; x=1758735241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yL5XyHaFwcuHLoUx1QyC95VoaQkl9On6tV5d0jN31ds=;
        b=GokCTPaei+yedx/tm1cn1UHLZCjiGLjfY1xBGiZ047gZRjf7rTAmkc5Tyb/hNoVxVS
         OtN41A7KkWGZCZxt9ngm42RnM08qkJM0wV+TeZoZnGwnTSrN2dVN/tLX/UPAEsePUk2g
         JZpfe/oRAQYDUeIUeaSwefLZylEaFcTHlNCgr2GMXVDYGFoPz1TifEziMj0T3zDrcUqp
         vIA1Ql9TtRRRHY5lh0JYEmajNjyYxYa3pheFIT+oc8aAXkI+BEOBpQ1tlLvjogF8ksff
         Mf3XAoO8mxwqRytT3pBSRKE/QMgDF0hyiUUvRAp0ir2FHkDV8kqBpcVlabMxi7/A+i9y
         jE+A==
X-Forwarded-Encrypted: i=1; AJvYcCW4xYXH9BPKy1O6QlTgJ/IR+fShxgDgpcXHW6r2EoTbQ6bc38foSknAsPGHq7w+hq0mQrgRrJ35+MxR7PbQirU=@vger.kernel.org
X-Gm-Message-State: AOJu0YynXilXQEJWd0DeH20hyy0CbGB6+HrcSfT3yUPhsXxBnwX93srR
	aKJA/khsjfUsyGp+s47SxGyTcB4FESBDK/5H2j6+Xq566ULCT/Tl1M4ItV0AiP4mq9DHhgvV4vj
	K8NqFrsKf3m9UU2U7HlOtwGpsWse9mOg=
X-Gm-Gg: ASbGncs4uy0R3wRshJRcmvqnHZOZ+QMo0Fh8LRJI2oskDqNVg+Z185bYdV+qs8hXi9S
	rtqOEnnV7CZ/BT6iUlnkJg4UGtaFgD3hvWtNrXGOX+O3YYigsJ1TBZcM9ijxUEvMQBw0tYaGfhr
	m3ZarxJ7nJoK2ImGHZ17T8iTWujC3NeKh88mPQ+FUlVV9P7Q4grHBkqItA1/0f7GeieJWgVspZm
	pKUHweo+ZZNg47OXJNg4kVxZkJE70Rg0iwZbfb6CCFizNe8cyDHG1xFLVz+1qNlz/ebpHWRiA==
X-Google-Smtp-Source: AGHT+IFIekakt/qtCBuXHKbWzVPXXkmYhlyTYvqsmvchet7NYv9l3Wm0KRMpUtJR+6AdMpr7F8wEAHBguPkdlOWo5wU=
X-Received: by 2002:a5d:5886:0:b0:3e9:d0a5:e436 with SMTP id
 ffacd0b85a97d-3ecdf9c0293mr2893049f8f.23.1758130441067; Wed, 17 Sep 2025
 10:34:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912163043.329233-1-eladwf@gmail.com> <CA+SN3sp6ZidPXhZnP0E4KQyt95pp_-M9h2MMwLozObp9JH-8LQ@mail.gmail.com>
 <aMnnKsqCGw5JFVrD@calendula> <CA+SN3srpbVBK10-PtOcikSphYDRf1WwWjS0d+R76-qCouAV2rQ@mail.gmail.com>
 <aMpuwRiqBtG7ps30@calendula>
In-Reply-To: <aMpuwRiqBtG7ps30@calendula>
From: Elad Yifee <eladwf@gmail.com>
Date: Wed, 17 Sep 2025 20:33:49 +0300
X-Gm-Features: AS18NWCWJm6Q3Abh0YddM_GDXrUEQTX4N6NPDflaQKnikVlXZoxbAvkVWuncPyg
Message-ID: <CA+SN3spZ7Q4zqpgiDbdE5T7pb8PWceUf5bGH+oHLEz6XhT9H+g@mail.gmail.com>
Subject: Re: [PATCH net-next RFC] netfilter: flowtable: add CT metadata action
 for nft flowtables
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 11:18=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter=
.org> wrote:
> Just to make sure we are on the same page: Software plane has to match
> the capabilities of the hardware offload plan, new features must work
> first in the software plane, then extend the hardware offload plane to
> support it.

Thanks - I see what you meant now.

This isn=E2=80=99t a new feature that needs to be implemented in software
first. We=E2=80=99re not introducing new user semantics, matches, or action=
s
in nft/TC. no datapath changes (including the flowtable software
offload fast path). The change only surfaces existing CT state
(mark/labels/dir) as FLOW_ACTION_CT_METADATA at the hardware offload
boundary so drivers can use it for per-flow QoS, or simply ignore it.

When a flow stays in software, behavior remains exactly as today,
software QoS continues to use existing tools (nft/TC setting
skb->priority/mark, qdiscs, etc.). There=E2=80=99s no SW-HW mismatch
introduced here.
