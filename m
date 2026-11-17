Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794933444;
	b=kAWFi7++uu6J+s0mGq9Pt7dsT8fhxRehmH6Opc+ZaaUPPmYR0X18TF1WPYx9gg4B4VrK
	 zMIFiwOv43OQV/xb3nX8swI+WDNQlD2+Um84lYkKqL0YowLEsFbGmDHkF/ad/VMlx60BE
	 /53BBPgX/TkInYON9VG+M9QZ09EEj0/R0p46XgBTGRWOro5XpFJivLdNSdnsrRece31b8
	 0X37vzmDNbcni+lymkH3PuXu+ceKuYBiTybDpnrcC4PVg6frRUbKaXZlxVKbzhLc1NX50
	 jYrqbM+pgJyMRdvY/H6ToxX3pCZc3uJj4rydLm5HtibadQejIUPNqLSuVqJPA4ko5/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794933444;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Dk536gR4sAld9G0Co0+KwmHfsUszZELHPoRp8d8uXgc=;
	b=4TrczPOhW4cEtwOlcrYJgTgLpZrFbhMaZQQnSq7DGvAESZczIO05W9c9nRDKFRT09CG6
	 20xJcBymQODdeOuHkSR0aTe2vXc+pNWxWP3/82V1PHWwrpKZYHbd5Q80096swmWJpLFeW
	 exGoizBiuHvtqrlkdTwCLedym4qDHjTL5mPfpMP8mo7smrS9tqPxAL044+823GXm737xk
	 XfRNxNIn6w94VvmN6rIE+jv31nEfo+5+N+AUV9ph//6WanVC/ZUiFRc1CXYe+NQ6QVk4I
	 MuhDRrC7Ux9ktlOAqdbSAevZhKI8Nol3wYV7kq0TRlZyy0l7jsWLE0/qOxB6xGBq6hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F072E606A330;
	Tue, 17 Nov 2026 16:37:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F072E606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 363A360342; Tue, 17 Nov 2026 17:37:21 +0100 (CET)
Date: Tue, 17 Nov 2026 17:37:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Ma Xinmeng <1564938642@qq.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf v2 2/2] selftests: netfilter: test re-owning an
 already dormant table
Message-ID: <avyCvycm9Tvdhp60@strlen.de>
References: <20261117161520.1031-1-1564938642@qq.com>
 <tencent_65062E982D816637E41FE6F24B678214DF09@qq.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_65062E982D816637E41FE6F24B678214DF09@qq.com>

Ma Xinmeng <1564938642@qq.com> wrote:
> Add a regression test for the nftables table-adoption path.  The test
> creates a dormant PERSIST OWNER table, lets the owning nft process exit
> so the table becomes an orphan, adds a basechain while the table is still
> dormant, and re-owns the orphan.
> 
> On the buggy tree this calls nf_tables_table_disable() and unregisters a
> hook that was never registered, which triggers WARN_ONCE("hook not
> found") and taints the kernel.  The test checks the taint state so it
> fails on the unfixed kernel and passes once the commit path only
> disables a table on a real awake-to-dormant transition.

Would you mind reworking this so we can place it in the nftables.git
shell tests?

tests/shell/testcases/transactions/ would be a good place, I think.

The test would be a bit simpler since nftables run-tests.sh already
does 'tainted kernel' checks, so it only needs the 'add table', 'add
chain', 'add table' sequence.
