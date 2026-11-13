Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.6.0.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794556699;
	b=syGes6KDm1BDQMG3UTpnb2tuBdzBkyLvlIE79O7YJBQHu++35JtgdQ+AJcD1uV34LRW8
	 bsXwj/dShUxjerE1hCfSWmYeRlqJ8kvHSgJLR2tnNLTAcB1L81lVb5a3XG0/upNwYCSOl
	 gqxGIl86cPIz4MI0FJQJt1YycKqj8mN3hjGvEaa/mPfbgKvL1PowWcLOMR9uTLEOQhIC5
	 tGT/OtleLLmsUIziHkVw/NR+dzCIfuZHebz4+L/rfvrGQcRZQYv5X7ijm7ggdraS3YcaD
	 2lzNSeaT7NREi4eZ1aS6sV5E/t0f/ahjKzbeQmRYcXUVOVTeyuMNve4NMCPtpQodTxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794556699;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type;
	bh=46C57rqBoQ4K2bBhIX0KdTJnzSSPPKbmRGfz16Wa9b0=;
	b=jpsuKeusy0BlE0K1zULAm307RZvVS/bQQ/aIRp1kdSX/34c4AGBAaCYRaIPIq+JMsvEU
	 eyOTN1DGG4yBh8ByFIa8bvGXgAz4WOm7vOhzVj4hm6UkIpBC9QQ0TQbaGwmMknMSYZVrg
	 rCThzw0r0WAjw/7O3kS54k08C7cPd+6DfnkYrLz2nXC2oiQTNBFMh417TQ9Zv3sR5worg
	 amaFgnXKjE2+jrvoccAF/HQsC0qWY9OygCz3oRTqaXVtFg3wt6pYi6cBZHLQ/XTQVneaO
	 F5FnmYlut2FGOIv+oqJ8sZ/iOYgA3XsgCCkyurcJrNvSysKEoDMhp9jTz4wgUsHCEgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	arc=none smtp.remote-ip=148.6.0.50
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EF3606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 07:58:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3EF3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4jQqPZ1xNjzGFDCy;
	Fri, 13 Nov 2026 08:58:10 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id WBgcSww_-ake; Fri, 13 Nov 2026 08:58:08 +0100 (CET)
Received: from mentat.rmki.kfki.hu (254C2039.nat.pool.telekom.hu [37.76.32.57])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4jQqPW6WlFzGFDCJ;
	Fri, 13 Nov 2026 08:58:07 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id E862B14055D; Fri, 13 Nov 2026 08:58:06 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id E4CE2140053;
	Fri, 13 Nov 2026 08:58:06 +0100 (CET)
Date: Fri, 13 Nov 2026 08:58:06 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v10 0/6] ipset: replace internal hash table with
 rhashtable
In-Reply-To: <avXuJ0GBdzyxK-_w@strlen.de>
Message-ID: <bbc263cd-5ceb-f183-439b-44909adef4ed@netfilter.org>
References: <20261112143818.30638-1-fw@strlen.de> <9a882426-58aa-c14d-fe99-64538c98d293@netfilter.org> <avXuJ0GBdzyxK-_w@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Florian,

On Thu, 12 Nov 2026, Florian Westphal wrote:

> I pushed a few of the test updates to ipset.git, but not this 
> 3-part-series:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261111101603.22698-1-fw@strlen.de/
> 
> First one passes on either rhashtable branch or main, but I'm not sure
> it should :-)
> 
> Resp. I'm not sure what the contract/expected behavior of net,iface set 
> type is when the address matches the net/mask entry, but the interface 
> doesn't.  I followed existing behaviour, so that test would enshrine 
> that: it stops matching more candidates.

Hm, it shouldn't. The expected behaviour is as follows: if the net/mask 
entry matches but the interface not, then the code should continue trying 
to find matching entries but just with the same mask value and not with 
other ones. That way the same net/mask entry behind multiple interfaces is 
supported and matched.

In the original code the "multi" parameter handles the case: in the 
net,iface matching function (i.e. hash_netiface[46]_data_equal()) it is 
set to true if net/mask matches and in the outer generic matching function 
in mtype_test_cidrs() it is taken into account to break the loop of trying 
to match further in the ordered list of possible mask values in the set.

> I'd prefer if you could double-check that the semantics that the test
> is checking are sensible/correct.
> 
> 2 and 3 fail on main, in both cases I think these are bugs in
> the existing implementation.

I'll have a look at it.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
