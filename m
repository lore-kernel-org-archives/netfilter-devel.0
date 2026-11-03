Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713672;
	b=YGmtOPGTMFdJjiCbRqW5FUecSU2Wrt0P+DzTYt4p+fW5v/PORl2CxF+EIPcK9rOcBVvo
	 WSoiwUZa+Nnw1xUbvN1A3NSwyGyZ1/qmX8N9pQ7PEJtgI/ztm39nW9OUQwTjYO/FR+1Zx
	 nWQsseCRPU+TgGZ0xvEVe9k+kpgiioo4wiLxqtVjfX5mzdS3PzL/esA56YhnKVy5UODTe
	 X/DCzxT/eaGR/ad/PsXIQlIJNnzvqsGQe0kd5YTbtzaO1l8hbSBYse4NG92sw91p2EDUi
	 8fudQTTo8Dv5/aV7PXwSSsc9KRcNkawyxJXbzZulP8eAC58GnMZFhGvju6o1mxMk+1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713672;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=oUpZSCTSGUR8K6xjzzgjipiK2QKubzIftsQfjyW8SMc=;
	b=p0yyFnVnj5Py9dT7OpnF3IdViXkNY1JFZifkWuA0p6qTb0BX8q6v8j6JAkVJDiloBr+5
	 eLqM2U3yt3QQGmVrt71FrmcyeMu23rsVjch/nIguJ1gvzhQzuntN3D/Ak1gfCij3HGMTZ
	 F6nqdQBpxbYaMbYth+1GuHIZe05MKAD2mBPysHwMtZ5vySMDq6/b7P5oaEeNrsFJ1t0ed
	 2yCv3QSBgdKP7f6pwG03vkKRZLy8CxoKDdPqq8aEPqRVGoz438qwX8MyqZjyz/tWdFkdY
	 k0DM5VgCy1xFrJZkQ7FEPdCuu66Z+teRu221bfrSzuySX0OejMDy1v6VqlProE6Zjcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=sbRtRzVx;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A9DD5606A324;
	Tue,  3 Nov 2026 13:47:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9DD5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=sbRtRzVx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793713668;
	bh=oUpZSCTSGUR8K6xjzzgjipiK2QKubzIftsQfjyW8SMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sbRtRzVxYzv9EyzqGWkVgzo1TOErBXNx6QAAhDHUAJrC+3vc5unfnqJEGHzo+S/Qo
	 ghYNVwlK6Kc46lGTA34qHeDdkZY3hqxv6NhIWoyrH3EtOLJ1TFWUhm42xW3HsjSqV8
	 1Z6XQ1fBc1FcyzAEG4fvXhODyK3WYrZXfXDtx/LtxoMrzOYFcni/1ccxTNl44ErS+4
	 liKVAAsr76t8pxMDR1NHlHoXMA2djs68lg1nS0Dl+bTsV118ddEkUN/eeEDKH37cBl
	 FGAEx1dARRnOvqm9VrP/fax9ySczDhCvinqTyYQrhDgMQy3uc+dZ9SJDVvKwRteKkl
	 th7bvp9I5Gu2w==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E9EC460052;
	Tue,  3 Nov 2026 14:47:47 +0100 (CET)
Date: Tue, 3 Nov 2026 14:47:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 00/15] Netfilter/IPVS fixes for net
Message-ID: <aunmABdLpFILZvGt@chamomile>
References: <20261102005654.532438-1-pablo@netfilter.org>
 <b452b25b-37fd-48ab-a88c-feec6b82e9ec@redhat.com>
 <5dc1159d-e577-442f-a7b2-8d5dcc8cfb01@kernel.org>
 <aunlVk2Cn7ocgANE@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aunlVk2Cn7ocgANE@chamomile>

On Tue, Nov 03, 2026 at 02:44:57PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Nov 03, 2026 at 01:27:30PM +0100, Matthieu Baerts wrote:
> > Hi Paolo, Pablo,
> > 
> > On 03/11/2026 13:04, Paolo Abeni wrote:
> > > On 11/2/26 01:56, Pablo Neira Ayuso wrote:
> > >> Hi,
> > >>
> > >> The following batch contains Netfilter/IPVS fixes for net:
> > >>
> > >> 1) Add recursion count to nf_reject infrastructure to prevent stack
> > >>     overflow, from Fernando F. Mancera.
> > >>
> > >> 2) Address a infinite loop in RCU list traversal with the TWOS IPVS
> > >>     scheduler, from Darong Lu and Julian Anastasov.
> > >>
> > >> 3) Use kfree_rcu() to release IPVS parent application to fix UaF,
> > >>     from Chengfeng Ye.
> > >>
> > >> 4) Fix UaF in IPVS netns removal path due to releasing per-net protocol
> > >>     data too early, from Chengfeng Ye.
> > >>
> > >> 5) Fix unbounded growth of stale, unmatchable IPVS connection entries,
> > >>     from Julian Anastasov.
> > >>
> > >> 6) Restrict maximum master conntrack chain depth in ctnetlink,
> > >>     from Florian Westphal.
> > >>
> > >> 7) Preserve recursion count on nfqueue reinjection, from Zihan Xi.
> > >>
> > >> 8) Restore GRE timeout in the flowtable, otherwise, WARN_ON_ONCE()
> > >>     is reachable, from Michail Andreas Michalopoulos.
> > >>
> > >> 9) Check non-null gc transaction in nft_rbtree before queuing it for
> > >>     processing, from Xingyuan Mo.
> > >>
> > >> 10) Replace WARN_ON_ONCE() by DEBUG_NET_WARN_ON_ONCE() in
> > >>      nf_conntrack_bridge which is reachable if the protocol of the tag
> > >>      of a frame differs from the vlan_protocol of the bridge.
> > >>      From Laveesh Bansal.
> > >>
> > >> 11) Check x_tables target name is non-null before accessing it when
> > >>      building a new table, from Fernando F. Mancera.
> > >>
> > >> 12) Fix out-of-bound memory read in nf_conntrack_sip, from
> > >>      Joas Antonio Dos Santos.
> > >>
> > >> 13) Fix a memleak in nf_tables hardware offload when double deleting
> > >>      the same rule, in the same batch.
> > >>
> > >> 14) Use a mutex in xt_recent netns exit path instead of spinlock,
> > >>      since proc unregistration might sleep. From Cen Zhang.
> > >>
> > >> 15) Zero the nf_nat_range2 struct before filling it up, to avoid
> > >>      using stale uninitialized stack data to configure NAT with
> > >>      an esoteric NAT flags combination. From Florian Westphal.
> > >>
> > >> Please, pull these changes from:
> > >>
> > >>    git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git
> > >> nf-26-11-02
> > > I'm sorry, but something went very wrong on the nipa side: the tools did
> > > not pick this PR. Do you mind repost it verbatim?
> > 
> > It looks like the patches have not been tested, because of the kdoc
> > issue on patch 6/15:
> > 
> > https://netdev-ctrl.bots.linux.dev/logview.html?f=/logs/build/1198360/14931104/kdoc/stdout
> 
> I routinely run checkpath.pl, I will re-check what happened here.

Well, here I have a script that contains checkpatch.pl and the
following call as well:

$ scripts/kernel-doc -none net/netfilter/nf_conntrack_expect.c

but it shows nothing here.
