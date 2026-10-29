Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793269775;
	b=qyGQXMFnc8HSq/ZsrVP45aa/52bP7DpwiJeAtYuf+GSwIffYnkuA3cIeGJHacg2Z21tI
	 NvuHX0ESmvZmGSFxjtErfAVdoFmCKESOBdA0zg8M6PN59F9F1uXSZzQWbI4a6NWJSeOik
	 ZL4jGg3XWeZ0bXhAyBval5+aPKXEacNBA9/kbxi+DpKl1gbo6VpuVuLS9nrSK6ZfHtbwb
	 uEfvddYyp7R4eVmwo1kZNdj9Bjt11n4N4zJFKL0kfWFJkFHErgzrqUGZSJr2XlXYSy9tJ
	 xPwrGbQE/wiD5JQn7OKpBTU5z4ca6pSpUjCkLhUbGE0XYOhzqJo4f2fpRo7OKHjg0+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793269775;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=8i3h1G7Jr2jMbZnnzaYSDrTekyKH7Lo7ejx1TWhzmXQ=;
	b=X0uiENZ2Nh7Bj6mXt5hjh/I7/Vi/mXZZkhUkqAYKThf0rqyKY0ytglDHQWDUnHO2j+d4
	 EURNzXNt8B85ZfufZtxlcXfp4difbbJMk9tgQRtSgBMolJuhIkzwVG2hZBRhFZVKRWRbd
	 NlDssoV/sfBvMEFcHlAUXHpAqhCSXRJplWWleOEwyPRvksKeaFjk0QT3S0/drA4mVLbxn
	 A3tXQeVFDmQ10gaB2Yi9j1Yis6y2sq+0NbmkKqyF4xWC5Nge8IZHQbe1raesWqSTglO2e
	 gMt4rfcY6vWXkZqKZQE/EGH4x2kJNV0kTKeDa4O5csr05bRPrKD6Tys3UE6rLE1cDrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFA2606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 10:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDFA2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 82C9460369; Thu, 29 Oct 2026 11:29:31 +0100 (CET)
Date: Thu, 29 Oct 2026 11:29:25 +0100
From: Florian Westphal <fw@strlen.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Philip Dodd <orange.spyderman@gmail.com>, 1149525@bugs.debian.org,
	netfilter-devel@vger.kernel.org
Subject: Re: invalid pointer in nf_conntrack
Message-ID: <auMgBQDEedGU8iiT@strlen.de>
References: <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <59d64272-e162-486c-99c2-6f61feead01b@gmail.com>
 <auDhy6OW5SrGg3jv@monoceros>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <auDhy6OW5SrGg3jv@monoceros>

Uwe Kleine-König <ukleinek@debian.org> wrote:
> 
> this is about a bug report filed against the Debian 7.2.12 kernel. Further
> context can be found at https://bugs.debian.org/1149525.
> 
> Note this is an arm64 machine, and the problem doesn't reproduce on 7.3.
> 
> On Mon, Oct 26, 2026 at 08:36:01AM +0100, Philip Dodd wrote:
> > 7.2.12+deb14-arm64 is affected in the same way, reproduced by just loading
> > the nf_conntrack module shortly after boot.
> > 
> > After the failure:
> >     nf_conntrack module use count: 0
> >     net.netfilter.nf_conntrack_count: 0
> >     nf_conntrack hashsize: 65536
> >     /proc/sys/kernel/tainted: 128
> > 
> > No nf_nat or xt_* modules were loaded.

If thats the case, why is there a conntrack entry in the first place?
Is 'enable_hooks' modparam used?

If not, conntrack hooks are not registered so it cannot pick up
any entries (you need some rules configured that require conntrack
without that modparam on).

That would imply that hlist_nulls_for_each_entry_rcu() is causing loop
execution for an empty list.

> The problematic code location is
> 
> 	if (nf_ct_is_expired(tmp)) {
> 
> in net/netfilter/nf_conntrack_core.c with
> 
> 	static inline bool nf_ct_is_expired(const struct nf_conn *ct)
> 	{
> 		return (__s32)(READ_ONCE(ct->timeout) - nfct_time_stamp) <= 0;
> 	}
> 
> .
> 
> In assembly that is:
> 
>     2f78:       9a812000        csel    x0, x0, x1, cs  // cs = hs, nlast
>     2f7c:       cb1c0000        sub     x0, x0, x28
>     2f80:       9ada0c00        sdiv    x0, x0, x26
>     2f84:       8b00039c        add     x28, x28, x0
>     2f88:       f94042e0        ldr     x0, [x23, #128]
>     2f8c:       37180300        tbnz    w0, #3, 2fec <gc_worker+0x184>
>     2f90:       f9400318        ldr     x24, [x24]
>     2f94:       37000a78        tbnz    w24, #0, 30e0 <gc_worker+0x278>
>     2f98:       3940df00        ldrb    w0, [x24, #55]
>     2f9c:       9ba98800        umsubl  x0, w0, w9, x2
>     2fa0:       8b000317        add     x23, x24, x0
> *   2fa4:       b9400ae1        ldr     w1, [x23, #8]
>     2fa8:       f940036b        ldr     x11, [x27]
> 
> I think the original issue was a few lines above (i.e.
> ldrb w0, [x24, #55]), because the tripping address was 0000000000010037
> (with 55 = 0x37). That is in nf_ct_tuplehash_to_ctrack(h).
> 
> All in all it looks like `h` is invalid.

Its a garbage address, yes.

> Does that ring a bell? After starring at the code for a while I don't
> spot the culprit. Also looking over the changes between 7.2.12 and 7.3
> I don't spot a suspicious commit.

Never seen this before.
