Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B0F5CDF1
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2026 11:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773660690; cv=none; b=VLBqJ6xDIU/UuANSJAa6dXKu5GmJAamEKPuoff5N6j0wLKAA82hdbeJx21HxUmMvMclM4egPVn9kOaV4PrzPu4vIHtYsxduKX9hwhcf/SGQTSrgr+M0F2CGZWGuG8tyaWcpQg6818YITIlGwAI4Vc6kjZ4oOo6AIFXh5N37FM18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773660690; c=relaxed/simple;
	bh=x41eV31hxlJisnvjCZwRk3vzucU2fR+zFSyw+lr74rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hFxqLQuIm9i/OLa3M68yQMi3a03sVFv4NzWWjhRy0COlwCUI0ae288tA4syWHYaiIFPVorE0valXTB8dsG9CPSph8V7vr7Rtm2pcjUj0CTcv0pH0gxBUuwr6TubcaPv5svxIOHLOec5JnUCxg8BZX0zNJMlOs242pNGIsTYx/zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e0yQ7JD+; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e0yQ7JD+"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35a07c4b17dso1843871a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2026 04:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773660689; x=1774265489; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nUxyvqJzviVhefD42KOA7qmDsxVaOxQooZbeSkgqO4A=;
        b=e0yQ7JD+wFYf2RhwmiPwGIx2Wpt+KWJLAOJE79ZXRtiS/hm6tnYtu6b+bMwgX7BBzS
         MNaK2kqnZfOZEU6uL+d5sU9e24PHQCCNysMBSDnd9onvtv4/b9I/6OsDBTg3YnGNL8Cw
         cTYEojYH/CGCPdls9yXymnYZ8N2q1ITA0VLMvRDs3TBpdbStBfcBoNJGWsalLawfL9+J
         vISOKjO1qM62GyNvDlcDreWy8Jz9ZOZGuAbrtEUE+Nad3ugZGG9WvxEZyEc676h4ZIA6
         /S0WX1643PCjFYQX7T0SdKfmcj4NhsA8XAdYlLTHMT65kwHz1dYxCwWrsGLXl5iSHlZk
         c6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773660689; x=1774265489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nUxyvqJzviVhefD42KOA7qmDsxVaOxQooZbeSkgqO4A=;
        b=YECt+SzUkV1dulQA1uwJBng5wq15IZOXlAmUgof0fZDtaIEyaszlf2Pb4ij4yXK+f7
         1ff7VuhRAJrQ3QEMfnn0l/Taou8oRBWNRl46GfWH3dUkx4ie8FtEfEqnp3BIkwHDI6tg
         TQsvd/C6SphwJ83TgNTU58P7awyaC91T4Mn/MacfpDc3TWlJCNKxxlQNrVrei4+BSe7m
         WZbG3w/QZaRqnCYxYXR50RSjfFsTeLttR/PxEj302yKlaeqO3J/qFi486Iuwwx4VsUCO
         K2YpDWlCxnYw14Ur/UkfWRypbaGBr2CAnQxFf2ImrZl8bX/Fwpz1WIl0gczMQGOdZXcT
         M2Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVG32lxD5oRI+JGvkHbX2iSXwH9vbemjBA5Uz4Y45zFvXNAQpz67ydvYMpwF3lItP9mVvfBfo21/EHM+HdDB+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOhJhkP+pAFRIaR53D2ubldmM+DTqEAxctEWI6nSJhYKmrPQjk
	Tj95J02Q1zdsuaqWBb+yN9kXl4cn8ioESRMIOtMDBh8kP53lid2ofKBG
X-Gm-Gg: ATEYQzzyKFeRp9mvW5b0s7s5736hwKb9qFk4Gs9tKFkpU+hkl3ZlTtSLA0RzRJHGR50
	sNJ9rXswQLvsUu+k21WjLbFcGCFVkXC68FM2EVQ0z9wR/E5KM+g84/jLh+4N/G5LhIfZ3eiBzLo
	LDZN11HkuU51x5CA+sE0b6gQ63YqokqB5FpTwiH6l93zZnFaiRco3PdTbjiqXKGtczkNb0rFPiu
	MvgKOWO66hnJHo1y2czlx5ojIPu7q3rkDVOt2n3aYS3fcdWNFYTzcZjFfXNsn8jQU0ewdjSswsx
	PBjT+5jOBUfHFW0/HjyrYInXgtm65Ik1YfgchxW4qtmqODAhEgkGzU26r3s2dae9kmJ+/GWsY1j
	xCWDpNZFM+4uI9rCCqY8vCkSgGTeTKfbEgr1xejM0sCYn4cLZ+iRtAOLPscdBp3iWX0N7LDahhK
	sftJ16/QBeh8BfyYjgUDg5MniNcfwnJd7hbpkD1kiKLQ==
X-Received: by 2002:a17:903:1447:b0:2ae:4800:141a with SMTP id d9443c01a7336-2aecaad02c7mr133260025ad.32.1773660688800;
        Mon, 16 Mar 2026 04:31:28 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b055cb5d60sm35787965ad.30.2026.03.16.04.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 04:31:28 -0700 (PDT)
Date: Mon, 16 Mar 2026 20:31:24 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org, imv4bel@gmail.com
Subject: Re: [PATCH net] netfilter: nf_flow_table_offload: fix heap overflow
 in flow_action_entry_next()
Message-ID: <abfqDMSC0cTGuvp0@v4bel>
References: <aaxe-uH2Qr6qM4E9@v4bel>
 <aax2yZtJce0d19gd@strlen.de>
 <abfhRFfZ1LOgWEsf@strlen.de>
 <abfoTBGLhav-iPQb@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abfoTBGLhav-iPQb@v4bel>

On Mon, Mar 16, 2026 at 08:23:56PM +0900, Hyunwoo Kim wrote:
> On Mon, Mar 16, 2026 at 11:53:56AM +0100, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > > > flow_action_entry_next() increments num_entries and returns a pointer
> > > > into the flow_action_entry array without any bounds checking.  The array
> > > > is allocated with a fixed size of NF_FLOW_RULE_ACTION_MAX (16) entries,
> > > > but certain combinations of IPv6 + SNAT + DNAT + double VLAN (QinQ)
> > > > require 17 or more entries, causing a slab-out-of-bounds write in the
> > > > kmalloc-4k slab.
> > > > 
> > > > The maximum possible entry count is:
> > > >   tunnel(2) + eth(4) + VLAN(4) + IPv6_NAT(10) + redirect(1) = 21
> > > > 
> > > > Increase NF_FLOW_RULE_ACTION_MAX to 24 (with headroom) to cover the
> > > >  
> > > > -#define NF_FLOW_RULE_ACTION_MAX	16
> > > > +#define NF_FLOW_RULE_ACTION_MAX	24
> > > 
> > > This fix looks rather fragile.
> > > 
> > > What guarantees that this stays right-sized?
> > > 
> > > Can you add a BUILD_BUG_ON or if needed, run-time check?
> > 
> > Ping.  I'm not even sure if there is a bug to begin with, see Pablos
> 
> Sorry for the late reply.
> 
> To clarify, I triggered the overflow using a dummy device that accepts
> TC_SETUP_FT, as I don't have real offload-capable hardware. The 17 entry
> scenario requires double VLAN (QinQ) + IPv6 + SNAT + DNAT simultaneously,
> which is unlikely in real-world deployments, so it is hypothetical.
> 
> > response.  How did you conclude there is a missing bounds check and that
> > this increase is the best fix?
> > 
> > Normally there should be a check that prevents such a configuration.
> > If thats missing, please add one instead of increasing this define.
> 
> So, should I send a v2 with a bounds check, or drop this patch?

+ Since this is not a real-world environment, it seems better not to apply 
the patch.
