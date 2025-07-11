Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EA4A59
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2025 03:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752204653; cv=none; b=nYoS61pxVY0FKENidKk12zoy9YR73EqCs7rivflGPFeG2/jjCOMpQgaDkleOs6rovUotqsfnLG2CWU3ANIPAoGuUt2oyimgkX2A2bxujDfvGpYvZWh2Ee23eKPqp9Tfh/gYpB16UUztkyQxsPvx18DIm74s01Ta6+Xw68MPa10Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752204653; c=relaxed/simple;
	bh=5B3KVRKxlNOvfdRPGUYCL0U4zWsWv0/b8k6FAcPTDq8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PxKwRDBLBzqTJbexu3M7uyTb22LLdVTB53RE9JgXCwhOrONh4b2HlrmaT2GVqjRtnMsld3WqOGD+AIjOrvmuko55eWfO5H4CM1hPPXfqFg6VR6QI9uIcIcWhwtH0xFu/wH2ar8pNyXbBFrnzNjrsJRFXGzd3UX4BDxmLFjtn7Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NoyAAZZQ; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NoyAAZZQ"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7d5d0ea6c8dso134570585a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Jul 2025 20:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752204651; x=1752809451; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HD4quT5XOTzJKTW55PVxldWC0doc3CvSqHiOgXxu5nk=;
        b=NoyAAZZQbMfHkaaLuoDKQEYzkGMubYZ2sNfbxAfxbPTLUKqjuCi+kTopycLBvj8x1s
         oM37EhWHJbaRZrQRqIWuVzA/HOkC/Z8Q5SEBkltZes1SvMrgxBbMtDis1Zznct7z1cxA
         1ZDD8LelrMZ1nvh5LRat3RsRwCGP8mWBeF4PjtM1yM0RimDylUg4DDdjHC7/TPn2twuT
         hvhvTi408qff4C6nwhyVfpL795OvMY28lsvxL5Wchp3UX1ps8RI6jQxektjYL2WVvk9e
         hqOHUUWa2kaRUzxnKftJFQZFOphp/Ah95iWfQD24HqqjPhm0r5hcYTQmHfs4ay8JoAG0
         bX/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752204651; x=1752809451;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HD4quT5XOTzJKTW55PVxldWC0doc3CvSqHiOgXxu5nk=;
        b=BI1irbjJHrwNTjVlmx9KSTw2hwgQ2CRYYveyMO//20msGDjCFhHldna5O6yhXq4hnD
         9CaZcwIc4TM5eM1JaQ1EivyKF2/HIQQeHSo5cJn8GL5JUxrNOKOvNFKxwYXoaYFN5yYJ
         fkPbBBcU7L/OF+IB9EzkoRYyl/sWWTITVj2eSbfFLVxRCBcDnSP9el/vVulRBSYKSWPm
         iMaXhQGE78uITJCX2UmN6plesH2vkE9XK+TH8KAi3FMYNph5N3Wn+s606ZGm4ux2z5oy
         1FHc+YkChVYctrldAbiwEgG4tW+ubDsVyCwgcIA+yglg75w5rI+WTKTeidjf/6u2mZsF
         TSTw==
X-Gm-Message-State: AOJu0Yxs3GONBjxzaWVPmiRjKa5sz77I/Uo20MzrTNJ6flhx0Z8g7zd3
	75E6H5XiYfAsRrxACr4D1XhRLgjnijOlE/44wRDYyl0GvRz2dRUzVRzLS6jseA==
X-Gm-Gg: ASbGnctijn+CfYig03wALp69Ff/T1C6LA0U4s1s2De5SWLpeWJELXajg2Ywckeh9rEc
	ENPmLAU3xWT2AktLlTQTc4tHj89WVLw2zJGn50FhAlou7WYMaBLH14IBBBTGvFYQbOW+sSicoU2
	tC/AhpCaT2u7afi2F2BITA8ol3Ml3oYGRsT2OcUCMevGTGbyY555fBsTfmgSqNcItCL4MISWuTM
	o1Gufmg8031Y2olI7ksq/Ux74kXEY49kyAnbVQAYWr/aW60S/8zbw068RMv/Ob1w79wvyF8BJW2
	ctk4k51fC3uXnY2+7nz6tQ37P/EExALb1KEwwJyfx4gNcSMsFizxBuhw4Tsmv8f+IRfc1InVMO/
	NgHr4D04n/C9GxfNY1aFWUWIDZx4hN2SoBkgGhApScP0U58v/G4Afhls=
X-Google-Smtp-Source: AGHT+IH6eFrnPgWYUFq1kysRUx7WPrbBpMSwxMdUNyhwLrVQdLeoiO4ORLPw9wXopnno5/E41kuXhA==
X-Received: by 2002:a05:620a:708e:b0:7d2:27b0:29ce with SMTP id af79cd13be357-7de04eba412mr270911285a.16.1752204650692;
        Thu, 10 Jul 2025 20:30:50 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7dcdbb1dca2sm176079085a.16.2025.07.10.20.30.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 20:30:50 -0700 (PDT)
Date: Thu, 10 Jul 2025 23:30:48 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: Feedback on variable sized set elements
Message-ID: <aHCFaArfREnXjy5Y@fedora>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

This email is mostly for education purposes.

I'm sure I bit off more than I could chew, but I attempted to write a proof of
concept patch to add a new set type, inet_addr, which would allow elements of
both ipv4_addr and ipv6_addr types.

Something to the tune of:

nft add set inet filter set_inet {type inet_addr\;}
nft add element inet filter set_inet { 10.0.1.195, 10.0.1.200, 10.0.1.201, 2001:db8::8a2e:370:7334 }

Figuring most of this would be implemented in the nft userland, I started
there, and was able to successfully get a new set type that allowed v4
addresses OR v6 addresses, depending on how I defined the datasize of
inet_addr (4 bytes or 16 bytes).

When leaving inet_addr size at the required (for both v4 and v6) 16 bytes
netlink would return EINVAL when adding v4 addresses to the set. We found in
nft_value_init:

                if (len != desc->len)
                        return -EINVAL;

with len being the nlattr (the v4 address) and desc being the nft_set_desc. 4 != 16.


My questions:

1) Is this feature interesting enough to pursue (given what would have to be
done to make it work (see next question))?  The set type only makes sense in
inet tables (I think...) and even then, would roughly be syntactic sugar for
what could be done (more efficiently) with two sets of the base protocols. But
hey, nice things make nice tools?


2) (assuming #1) I believe we would have to put a condition to check the set
type versus the nlattr type, and allow a size difference on
set(inet_addr)/set_elem(ipv4_addr) (I don't know if that has any
ramifications).

I found set.ktype, but that is indicated to be unused in the kernel, and
comes from userland any way, so I don't believe it can be reliably used
to map to a set type.

Another possible approach would be to create an API to transmit valid size
types for a set type from userland. We would still need to ID the set type,
and that has the above problems of set.ktype.

Do either of these approaches make sense and secondly do either seem tenable?
Are there other obvious paths forward to deal with variable set element sizes?


Thanks!


SB
