Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DD22356CB
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 09:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743586606; cv=none; b=SpHf2px+VOYqet+YAGqWIECEI93LGYP1ETz8Ri35S1fqJL89+4VTvFs5e7dkKEjhq3xCBWFL3043lWcarwcydVPoK0jzknGPCVsr4o0PcQYIiyBx9iTf2uxUhfvRQxZH0Nc0iwIadOHRRFNq8YFXa8WtVWEe9G5P7Cgu+3x8vNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743586606; c=relaxed/simple;
	bh=9FXByDhtXQPo26WfwDsjhSQ5+QQ+djvHZSnq1Td7Pww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pM6M7OkDdqGSJ2PtjdptpvUb5tkxm/ck5yejNdPaMzV7iF3oxhEzHZRBW/3kBQSeJi6PpaPwvnoUD5ENHfJ5osvWT+cyEkOx2lxUeJWeXjUWVseALVqV4EItSAd8Dbl5Uc/u2tVXt5Be9n6Ishwg6KDDgQgQNtwSAwBiCQY1C2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=miXfr0Lv; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="miXfr0Lv"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22438c356c8so125087185ad.1
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Apr 2025 02:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743586604; x=1744191404; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zOKS0P7hozNuI9mBYwyHdHB/M5XOwBk11Na2s/uqP7o=;
        b=miXfr0Lv+vWAQyer/OVTIDVYvP6Ch7FC4QolY4zPWiIeLkVO4CbviNvVc/c/ehvgrS
         ZshAMv6U5Ud76mRv7nqdfSIHm6arNu106QNVm/b7lGF+emxeqNOcxqJOBFjyvQvJwyBP
         jwNPB8FZauvE0tZA1MyGtm+dGPxF27kqRwLW+yDG6AyVM+vZFlEoPil1SfK+7wlhXk6x
         iRIFlzxdJqpnvwhNcFbSbVJZ5BQyr2s1k6cWqsTi8Znd+CaSygHRNL153XG46IviARLn
         yU7SAGBXPYJnh3aTTYyWsX/cXYQN7tZnWaEpftxDnA/AOdMNdz4rYT2UW/GryoyuYdFc
         gTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743586604; x=1744191404;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zOKS0P7hozNuI9mBYwyHdHB/M5XOwBk11Na2s/uqP7o=;
        b=qQdq1eMbp4uVfh2vpUlKDVgM1lb9DIVbnUee6W/gwFZpv8EGb6OPS4TzT3btE56bMy
         R9B46gkTHRZgWNtZKixHucPR7yNhQ9jCd4KECq+ZjGuEj4oEDTkZJEwHl/ahi+hJ4MAb
         oBlBMyY6FSjg66xbD5BYeWa0/BHVPhmX/2K+hxv+lzvDFrAWbzoqq3c0XDssFILanTr8
         g81P0h3f2EONUCKLieEJP4DE8Nwc0Q/bn6ZMMXp1SpBQhGQhrbR+5huh7qWx+pJolG6r
         7Sai2nlpjANFpNi2yi7zNdqBdSd3WIr5bntQiC6FTijFYgKlIiCH5n2GjRuQ4JEnQKjp
         k4nw==
X-Gm-Message-State: AOJu0YzQaIsPt4FIrb++fmknGCzb0mg6kTUXb3vDJVfwg2hxp9y2shce
	MPhpO3hl5LjQOd6+kS+6fljKpQqggjjFYAF5AVcpoaY3nDe3/ezqCVjF2Q==
X-Gm-Gg: ASbGnctiJw5p+nFMOgv0PAnB7O7hb9kh4Q7sMsWf88E2mODppgEFuNOMeqifzBZGUI3
	231l3JQTrK0byscq7tnPmoNVNJcz4s8cCdADO4MMK6lqF/yvlq7L+tg+QARFrPBJjPI6SGv7Dcg
	AELpKXsr0zm76gWg2hQfN2xn4IFDEtraqlKjuPzfvmWBBDFWQqYo3i7OzYwW0WiLT373czyjRhf
	Oylf9eZZxQqAPyZ2MhwlUeg/ia0UFgLNuBaNL+zoSQnsGqNP+gblZD5002+3aHslzr8toYihw6A
	pQkWT1T+ueZ8S+aN2ZLffuUWOBGE/EAHnChJ1cLx4SGRg8ImeZr3LMs2/pLXoIfQy6HazxFJeLU
	4AQlawYq5aoZh2k8Fgmeb8rmzYHC3wg==
X-Google-Smtp-Source: AGHT+IGpj2P9lvZ/UZ4VQes81USgyaBBkyvobPjsAxQzP93yxDViSozPbbGVAlD4Pv3MK26VaxTXHw==
X-Received: by 2002:a17:902:ec85:b0:223:635d:3e2a with SMTP id d9443c01a7336-2292f974adamr224559455ad.23.1743586604234;
        Wed, 02 Apr 2025 02:36:44 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2291f1cfb40sm103659585ad.107.2025.04.02.02.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 02:36:43 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
Date: Wed, 2 Apr 2025 20:36:40 +1100
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: "G.W. Haywood" <ged@jubileegroup.co.uk>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation oddity.
Message-ID: <Z+0FKKFKcofghbwp@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: "G.W. Haywood" <ged@jubileegroup.co.uk>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk>
 <bda3eb41-742f-a3c3-f23e-c535e4e461fd@blackhole.kfki.hu>
 <4991be2e-3839-526f-505e-f8dd2c2fc3f3@jubileegroup.co.uk>
 <Z899IF0jLhUMQLE4@slk15.local.net>
 <99edfdb-3c85-3cce-dcc3-6e61c6268a77@jubileegroup.co.uk>
 <Z9EoA1g/USRbSufZ@slk15.local.net>
 <f87285a5-f381-bb1f-3d31-97ef214946dd@jubileegroup.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f87285a5-f381-bb1f-3d31-97ef214946dd@jubileegroup.co.uk>

Hi Ged,

On Fri, Mar 28, 2025 at 01:55:11PM +0000, G.W. Haywood wrote:
> Hi there,
>
> In the document at
>
> https://netfilter.org/projects/libnetfilter_queue/doxygen/html/group__tcp.html#ga66fd94158867c63be8e4104d84050ac4
>
> 1. At the top of the page it mentions a diagram, but I don't see anything
> in my browsers.  Have I missed something?

No, the diagram is not there because the system where the document was built did
not have the *graphviz* package installed. Graphviz supplies the `dot` utility
which doxygen uses to create diagrams.

In the absence of graphviz, the "Collaboration diagram..." line should not be
there. This was a build issue, now fixed but not yet released.

If you're keen to see the diagram, you could email the webmaster requesting a
rebuild with graphviz installed.
>
> 2. Each section covering a function mentions the function name three times.
>
> Except in the section for the function
>
> nfq_tcp_snprintf
>
> which at the third attempt actually calls it
>
> nfq_pkt_snprintf_tcp_hdr
>
> and which had me confused for a while.
>
> 3. It also spells "human" as "humnan". :/

2. & 3. are actually on the same line. It's been like that forever - I've
submitted a patch to fix (and nfq_udp_snprintf, same fixes).
>
Cheers ... Duncan.
