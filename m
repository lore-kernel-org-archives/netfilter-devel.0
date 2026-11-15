Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.6.0.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794762224;
	b=XScixOfAx34qx8kx3OeGxwlZbDe+IARpOB/8AEPR/5I9GqBepSBkeiTXommWFJe0pDVo
	 96XsLXxVUnk4vwN6eKSMH7XdmvKmIlE2qVXcJRK2cJAIxliZ4+krnO/bFgTNtU2jsHcW6
	 nIsgIJ1FDIKky72CfqAsQDoXRNILi8uRMSOKovbRRi0hv/VeWlWPGtDwtIm7gzQLqy3Yv
	 XtA7gSgimS6m9rEvCQsEbE/2zIHs+MikAWcYV4ezW+a27wRDOpH1CRdpPeIOWcmqDp1zn
	 r3lvsNZSgM/VD7t2ZG3AytndBYD7RwRKGMpP41ouQPsXM1ygiwtF0R5wTl7sfrUn7wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794762224;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-deepspam;
	bh=8KBw67ZCE1Ci43MhnD68N+LUrvLP85MpQC8hJRojZB4=;
	b=fQAy3ofKzoT30XWymtMBWhV2gi6B0TI0qeb/1f7vJdGZw0x2SzQSj8zwdsYfdY2GayO/
	 fOKTESbkOahu4fSclDDnn1fmPbL3BEkQeVjI2pQMl+beKktYml1xY0UaozcaVrunelU9j
	 uU24e207v7BT3/luUYO9cDajSyj49ttV1pq1HZjv+Txr0DlgsTe/MfmQQ9pbqCpsuUyTh
	 YkDLOpg1E9jU+a/ABvLCMhHd5Wsdm+s8ISmKk5oZtT3KT+PhSi21veCc32dxtTcPO/5I7
	 2VuSlLb6UtlHc5v35gzp3HKb/DCiwVmlXmatuNQS9hqqbsNiery5WEURRGXji/WefoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	arc=none smtp.remote-ip=148.6.0.49
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A8B606A327
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 17:03:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23A8B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4jSHQ637nmz3sb0T;
	Sun, 15 Nov 2026 18:03:42 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id h7H5WnpqsKqq; Sun, 15 Nov 2026 18:03:40 +0100 (CET)
Received: from mentat.rmki.kfki.hu (254C22F0.nat.pool.telekom.hu [37.76.34.240])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4jSHQ40qzzz3sb0V;
	Sun, 15 Nov 2026 18:03:40 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id A7A1B140554; Sun, 15 Nov 2026 18:03:39 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id A45FD140141;
	Sun, 15 Nov 2026 18:03:39 +0100 (CET)
Date: Sun, 15 Nov 2026 18:03:39 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v10 0/6] ipset: replace internal hash table with
 rhashtable
In-Reply-To: <avbGlZBumFgTJyVY@strlen.de>
Message-ID: <4075f44d-baca-ce2c-3892-81652ef19ce7@netfilter.org>
References: <20261112143818.30638-1-fw@strlen.de> <9a882426-58aa-c14d-fe99-64538c98d293@netfilter.org> <avXuJ0GBdzyxK-_w@strlen.de> <bbc263cd-5ceb-f183-439b-44909adef4ed@netfilter.org> <avbGlZBumFgTJyVY@strlen.de>
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
X-deepspam: ham 0%

Hi Florian,

On Fri, 13 Nov 2026, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > I pushed a few of the test updates to ipset.git, but not this 
> > > 3-part-series:
> > > 
> > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261111101603.22698-1-fw@strlen.de/
> > > 
> > > First one passes on either rhashtable branch or main, but I'm not sure
> > > it should :-)
> > > 
> > > Resp. I'm not sure what the contract/expected behavior of net,iface set 
> > > type is when the address matches the net/mask entry, but the interface 
> > > doesn't.  I followed existing behaviour, so that test would enshrine 
> > > that: it stops matching more candidates.
> > 
> > Hm, it shouldn't. The expected behaviour is as follows: if the net/mask 
> > entry matches but the interface not, then the code should continue trying 
> > to find matching entries but just with the same mask value and not with 
> > other ones. That way the same net/mask entry behind multiple interfaces is 
> > supported and matched.
> 
> In that case a v11 might be needed; the conversion follows the observed
> behavior.

This is strange because the current code does return the expected 
behaviour. I have just updated the tests with a case which checks it.
 
> > I'll have a look at it.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
