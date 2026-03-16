Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633CF286D5D
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2026 11:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773660242; cv=none; b=oIt1hBMxCJOV7zbvJUIWbiGXDUnGV2QGpvqvlq30w64XbrElfZDG6YtkV0fVE9llgtPBSUH/P21HoL/+f6tnPiZoIgXboYbC1DkX4MDueu4V36olcZrxFIzUVQv6jRXSJdFy/fjDkJe8q74EN4Swq+8SUdfotGT+FOhlEGM7FP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773660242; c=relaxed/simple;
	bh=WXqCX/DwBCUUGd2jxkGds1I18CJzM7++LkFVv7eZUz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AONC5wiLllQZN1fZK97MADi1XPabncqBrBvhYPsZN5NZqyYJHN1IaBFS1p067FFVynKjW6EMhpgu7qZ7ijFxJJaPCJTIFsXRkAO0VXhvJNJhz0AtYosdOt7YFFZ/yzcaXgeSQvwhcLhsqVFUIBYckin3ljVsFGEnVAhRf10iw90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c91I5Sta; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c91I5Sta"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82a124f3a5bso2245112b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2026 04:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773660241; x=1774265041; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=99La0VK9SzA1EiGQSH9RsVBy9sx23iujvFhJrIbJm3c=;
        b=c91I5Sta9FPou4QPyGld1nQtc6FYG+eV4/i6WzSa98TAmefoRw8phDMP+FMRt3uqbr
         l5HiIr8J1aXqDqCvFW7MrCt7dFLhR4H1c4xRivk4lNxlMmOkVBT0zYJBzOeIKBRU9+oj
         C5csM30Nk5Vld7ybHd5dtjnjW/EtW/OSNCvehnXltBTK0lof/Yp5ZGxEZhrf6ZlxW5iN
         5n/9sshvHozlfeB29rlSIzjMcfQK/SmsYshoCxwX+rvdAAlW3n74qBcGtWCa5rh6WFjf
         dt6y1UPEa0TAAur3Gva6ABTRd72bvhIkgYcd9p6QSKxV3L1A9gnZJKi15ry7plOxjJtZ
         fbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773660241; x=1774265041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99La0VK9SzA1EiGQSH9RsVBy9sx23iujvFhJrIbJm3c=;
        b=Dsv2si27sZiEAVSGsra3VqfihM31r29bVkD77AVtZA4rHk6GVwNZ0KxKaEdTBBhGKe
         wquvwmb45n7BVQPzBI50U/0nYJr1Zh15Oc0V7JvpLqd7SKSxUguPDrdTNehc+ZfMKM/H
         e49HbHKLC8rBZLRBfr8dDMWrJhdwvcTjdQcQe48cc8HJIYdx0N4GpopVeZTLchx964xD
         VZWh4Te6VcTM5NC+/ZwKNqFXMVYS2WQ4tQqVckX9qk4y/G9XyYmlPMjCpy1xtUiax6Bl
         Uk6KL5MAPtAiaMo9QSA4VzhgH/dBOUKCnD+g5dT102Pc54JnEcC1BHZtp8MyrTqbM/Ez
         niDw==
X-Forwarded-Encrypted: i=1; AJvYcCVdQ7sfV9fil0xNq4AA4+rpqVfoBXht5Zj6ItSotwIWk+Fj3mzMmlCLmRHNejLOl+90Wcosmp2C+mnZ4EECkZs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3mtyeGeQ/PWNgQsCyl9sMG8weD4Mn2oKvGkQejqStm7Yv5AKv
	6Bloz6+cz/dzdcfyQR0IDMmqBt7YLu9pg6wIzmSAQbDSVz6KOvadOYbl
X-Gm-Gg: ATEYQzyU8NmqP9QC8G3PBQPlDRM+0kkdme+P+DDa/EdC80yw4TW018/k68/khZfbo5s
	3OvBAJcF52TyW/bzTWNAnFkkAanaKAbPF5KDRbe/Y3Ioar1WstdW62RC3BidNs2zp1vkNZ+Y3Yp
	Tz4Mf4QYfAt/s+Y6YpKOkEUh/C92u43W1vT0sSQ5uAbThsIQb+QVE4dVwY49S/rNCsW1McxXF7U
	t+NIIeGasqWQ1F+ySZaaJ3WcfRBFA1s30hhOuvYICwtyiP+uaEKnLS5nDfE0RymuVkvyl45qXVc
	G4GJoSiWHdZhfNB0EZs/c1Wad8roRt13I/RQkBIhFxtcPVHJ7ZHIfX//0cs5FSkJwOLpfKqZhZl
	iYX9RSzgz7hJX+oueRaVcB7rHlxAb2jA00J86HB+9EK+DYHwUpFvXDUW7WE/m0Mv8ee3SV7HCms
	HPkYCQplLDlwmv9jcOFNfQXOlgzstmE4I559V5e+IKMVsfUrYXikGe
X-Received: by 2002:a05:6a20:2588:b0:398:962e:83d7 with SMTP id adf61e73a8af0-398ecd32e67mr12122687637.43.1773660240526;
        Mon, 16 Mar 2026 04:24:00 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c740000056esm4842239a12.24.2026.03.16.04.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 04:24:00 -0700 (PDT)
Date: Mon, 16 Mar 2026 20:23:56 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org, imv4bel@gmail.com
Subject: Re: [PATCH net] netfilter: nf_flow_table_offload: fix heap overflow
 in flow_action_entry_next()
Message-ID: <abfoTBGLhav-iPQb@v4bel>
References: <aaxe-uH2Qr6qM4E9@v4bel>
 <aax2yZtJce0d19gd@strlen.de>
 <abfhRFfZ1LOgWEsf@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abfhRFfZ1LOgWEsf@strlen.de>

On Mon, Mar 16, 2026 at 11:53:56AM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > > flow_action_entry_next() increments num_entries and returns a pointer
> > > into the flow_action_entry array without any bounds checking.  The array
> > > is allocated with a fixed size of NF_FLOW_RULE_ACTION_MAX (16) entries,
> > > but certain combinations of IPv6 + SNAT + DNAT + double VLAN (QinQ)
> > > require 17 or more entries, causing a slab-out-of-bounds write in the
> > > kmalloc-4k slab.
> > > 
> > > The maximum possible entry count is:
> > >   tunnel(2) + eth(4) + VLAN(4) + IPv6_NAT(10) + redirect(1) = 21
> > > 
> > > Increase NF_FLOW_RULE_ACTION_MAX to 24 (with headroom) to cover the
> > >  
> > > -#define NF_FLOW_RULE_ACTION_MAX	16
> > > +#define NF_FLOW_RULE_ACTION_MAX	24
> > 
> > This fix looks rather fragile.
> > 
> > What guarantees that this stays right-sized?
> > 
> > Can you add a BUILD_BUG_ON or if needed, run-time check?
> 
> Ping.  I'm not even sure if there is a bug to begin with, see Pablos

Sorry for the late reply.

To clarify, I triggered the overflow using a dummy device that accepts
TC_SETUP_FT, as I don't have real offload-capable hardware. The 17 entry
scenario requires double VLAN (QinQ) + IPv6 + SNAT + DNAT simultaneously,
which is unlikely in real-world deployments, so it is hypothetical.

> response.  How did you conclude there is a missing bounds check and that
> this increase is the best fix?
> 
> Normally there should be a check that prevents such a configuration.
> If thats missing, please add one instead of increasing this define.

So, should I send a v2 with a bounds check, or drop this patch?
