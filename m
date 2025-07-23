Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DA51F4628
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Jul 2025 03:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753240771; cv=none; b=loF9uEE0RpwcNXE+vp4JeV8aoLZVsL2NpkMnPmALLJqrej4zhLdR7UK9A4hK7Yee+f8MNQpVbYzit+MVi+lhD022iu0YqKZXF/cDaK0lT2TuEmi5aDY0oyjdMJuL0VL1r+c1fFNJ8MxbEaFwwGoWGuzVKJl3UFD/tuhmtIC6Hio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753240771; c=relaxed/simple;
	bh=N46QWE4lfp0Q1wkje5Xg/9N3rcuBiyxd/h+dfWprieY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3M1MvN1nUy2aoA6RSbM8Tc0DsIlDwaeBzPwInweig1wkfi+23cJqHltG2DV153Ifx3lf9Mk5tY2tNU5etRu/RN8Yvb9GlrX9JCdimIC2hnscezVnDzk5mDJF0EXdh33bLe+ZqpYmHWDQ7moQconIRuKhJ9o7jkc+UFWyRqrowg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l0jC2kHm; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l0jC2kHm"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-702cbfe860cso50942786d6.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 20:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753240768; x=1753845568; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LBoIATc/sSYEjG25jwii/Wq0FXunHHPWLW1xRO6r6ps=;
        b=l0jC2kHmZEJkdnYICgQ8xPBT7Hx9ddIDsV6ug25chhSCYoyYVZ/XcJgHl7vFgqC2ws
         NkfEolvY3OOCMZSht7/cmefe/GLH4KJSk5bh26GBc6grVBFL/3AvB6j3ieAJNIohdCKC
         M5QT/v5+9wtl13XplozMG230PK2JbegCGBwcpHLaBaDEL0a0C2iSCoIHEoGC6gU1N2ax
         uFRoMRDb9TqqJ1zDNi+2FyYDSa8I1NcoRmng3i1/sCoxuOwWOmUvRFRm+DI0u8v1ktKp
         Ss9biMLOup8+rrAnvhapDYGiZDKkxxek5c/++m629kPfEYLU54pJublLocznl+qS2gCs
         Ybnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753240768; x=1753845568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBoIATc/sSYEjG25jwii/Wq0FXunHHPWLW1xRO6r6ps=;
        b=iodYd7QmmOm8uwojKGrP7WDVY/T+Ps3a4pqOWS9MezSTaKW8VlAktazXFq9NepkSPa
         NpgD8pqhsVR0/uXXXExxWeh3PIHPzJGaAw51jEJJvHfXoWEQ3No/ES2wkXjaIWIGyQku
         lzSHrwKiXwhbruOhcSQBEqsPY97hEQDEEnEFMkVsPV97TCAVuJUfo5KpJVa+KGhbSUX/
         eXCFxzkSQavM8cxYoX0OecCt0Rn6JgpdauxkpqnUruUX+nwmjgT8WMIk2iRXZhwMNGnr
         V7pPzYJAQQ4kck4yAkaLNBlaD0KlzDzo9tfH+hAHJtISpCmZy8sCeAerHbEYMiRoI/rT
         RxCA==
X-Gm-Message-State: AOJu0YytefK7T91Ml1k+SF7gXjW6TmR0kV2D8WbzPoJK1BohsJe72oon
	6hjOiKcUPniwdGM43UiUF0A2mzsWcAGt95wyLlTOZxBOsbhCYAMo5Zp50tTFQA==
X-Gm-Gg: ASbGncuiQd/SQpuJt5SvCcZzY45RmFapibgf0dd/i5T7SwY33vwZt5QgAM82gtqQoYX
	xROWF+COSKsH3ovuv2iyhW7Vpuu4XRMAp9GEMDQZ5eeyFpxtr2Ir27UvbIuh83qMb9RyvBP2jHC
	IqymDzeuzKQwX8ycUutmkwyf45ik69zADEOmMnevWLptB4WPcmktl49GZjWyUw1CTevhUOpyRxN
	PbXzU1CCK743jhiGaaspMYunYcN2utSj0LRiTN1iktn7sr5dIZLqu7IZJxneQmA/1aQg5DTOVwG
	/QUWUTwhyNmixlW5oNn17cu8SXHRRRJfGJ3pL4Wi4weAXIqF3NouyoqAklj0RfWY/B9zNXCl2yk
	G0EWiiaST3712BpmEe6X0Z8JS0GlXAsELar9l/HmJfhjE+S19jRYW2kfSJN7cSMqUXA==
X-Google-Smtp-Source: AGHT+IEBajDRMI/ETVaWLU+3Gwq6zwo10FPyWjGjVcxr/ImSCJX93sgVAJIkH867c1O9oOWkuFN8vg==
X-Received: by 2002:a05:6214:1949:b0:700:bce1:495a with SMTP id 6a1803df08f44-707004b32f1mr22226056d6.1.1753240768345;
        Tue, 22 Jul 2025 20:19:28 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7051b8bb8b5sm60538796d6.6.2025.07.22.20.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 20:19:27 -0700 (PDT)
Date: Tue, 22 Jul 2025 23:19:26 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org, fw@strlen.de
Subject: Re: [PATCH v5 1/2] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <aIBUvgd9skYlzqEC@fedora>
References: <20250520030842.3072235-1-brady.1345@gmail.com>
 <aH7zWPAVRV8_1ehk@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH7zWPAVRV8_1ehk@calendula>

On Tue, Jul 22, 2025 at 04:11:36AM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 19, 2025 at 11:08:41PM -0400, Shaun Brady wrote:
> > +static bool nft_families_inc_jump(struct nft_table *table, struct nft_table *sibling_table)
> > +{
> 
> I think we mentioned about NFPROTO_BRIDGE here too.
> 

NFPROTO_BRIDGE was indeed brought up, which brought us to the current
implementation of nft_families_inc_jump.


---- excerpt ----
> Maybe it is better to have a global limit for all tables, regardless
> the family, in a non-init-netns?

Looks like it would be simpler.

The only cases where processing is disjunct is ipv4 vs. ipv6.

---- /excerpt ----

The current implementation includes all tables which are not:
1) the same table we're working with (tbl == other_tbl) (self)
2) tables where the protocol is tbl.family = v4, other_tbl.family = v6
(and vice versa)

I believe from this jumps from NFPROTO_BRIDGE to high protocols will be
counted.

> > +
> > +static int nft_table_validate(struct net *net, struct nft_table *table)
> 
> This function is called from abort path too. I suspect total_jump_count
> for this table will not be OK in such case. And this selftest does cover
> many cases.

The abort case is something I did not consider.  Would
nft_table_validate be called after a transaction rollback, and thusly a
likely set of tables that previously validated successfully?

Another potential save is that I don't update nft_table.total_jump_count
until after a successful validation of the table.

I might ask, how is the abort state different for validation, or is the
abort state when someone literally kills an update (and thus would be a
rollback?)?

Would a test case that attempts to demonstrate safety of the value
suffice?

> 
> > +			if(nft_families_inc_jump(table, sibling_table))
>                           ^
>                   coding style

I see it (or really, don't).  Will fix in v6.

> 
> > +	if (!net_eq(net, &init_net)) {
> > +		tbl = kmemdup(tbl, sizeof(nf_limit_control_sysctl_table), GFP_KERNEL);
> 
> Not checking error:
> 
>                 if (!tbl)
>                         ...

Good catch.  I think I can jump down to the same err_alloc label below.


Thanks for the feedback!


SB
