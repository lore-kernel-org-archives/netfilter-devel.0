Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066992E762C
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 15:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979605; cv=none; b=ipACbHtjPr1JcSthmwBOvVzrLNhPRCxvyCXfinfPbt2lS0FWQfeB7qpLHbQhxJDMgSNW/oBbnqwy0LeZOWPHpO9WvABAqrNrEyarSU+exdG9l90nFnUlVKapz8mhBlEBGrIlQw/ZfoKR84tPIb9Enw1OuO9v05STLSHoIHvBdvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979605; c=relaxed/simple;
	bh=DHjmIyDQIMr7n7cXI8WfM9pUd8+GfEJ38byH88eaNMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXItejIIGAE+X3ZCTxuQJAwoiAwdin6MEUE7MQ8AD2NmIs8PQr5Afm/fxiiTWltxfT+V32mRgjMOpzGg9mgi2aRPcOP+rjM9g2eKGvyx4a2r7snkBItPSBgkJm+rP915rxgTMcblMEsbHV+xAcDKH/NX3CKHCuYqkTxYOC0+lSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2E94E6055C; Mon, 17 Aug 2026 17:13:15 +0200 (CEST)
Date: Mon, 17 Aug 2026 17:13:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Vimal Agrawal <avimalin@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org,
	Vimal Agrawal <vimal.agrawal@sophos.com>
Subject: Re: netfilter: nf_nat: race in nf_nat_setup_info() corrupts
 nat_bysource list (GPF / soft lockup)
Message-ID: <aoMlCi9pduIyddFU@strlen.de>
References: <CALkUMdRXAB1nGsBhg77zg2VGZyh-D+rL8kxqDDiEs6qmcXev=g@mail.gmail.com>
 <aoHISuGf2vzWk2s0@strlen.de>
 <CALkUMdRqwCXbA+9tSFgxxA=pBCAPymRbLBa-UXUi6PE1qytvAA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkUMdRqwCXbA+9tSFgxxA=pBCAPymRbLBa-UXUi6PE1qytvAA@mail.gmail.com>

Vimal Agrawal <avimalin@gmail.com> wrote:
> I do see some conntrack updates passed nf_nat_initialized check in
> nf_nat_setup_info so ideally it should not do anything for the second
> or other run for the same conntrack.
> How about locking out the whole of nf_nat_setup_info on ct->lock. i..e
> spin_lock_bh(&ct->lock) at the start of the function and unlock before
> return.

It would be good to understand that this isn't a 3rd party module bug
first.

As I said, conntrack doesn't expect unconfirmed conntracks racing
on multiple CPUs.

Minimal hack (not even compile tested):
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -815,16 +815,12 @@ nf_nat_setup_info(struct nf_conn *ct,
                                      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
                lock = &nf_nat_locks[srchash % CONNTRACK_LOCKS];
                spin_lock_bh(lock);
-               hlist_add_head_rcu(&ct->nat_bysource,
-                                  &nf_nat_bysource[srchash]);
+               if (!test_and_set_bit(&ct->status, IPS_SRC_NAT_DONE_BIT))
+                       hlist_add_head_rcu(&ct->nat_bysource,
+                                          &nf_nat_bysource[srchash]);
                spin_unlock_bh(lock);
-       }
-
-       /* It's done. */
-       if (maniptype == NF_NAT_MANIP_DST)
-               ct->status |= IPS_DST_NAT_DONE;
-       else
-               ct->status |= IPS_SRC_NAT_DONE;
+       } else
+               set_bit(&ct->status, IPS_DST_NAT_DONE_BIT);

        return NF_ACCEPT;
 }

But its not enough, if we assume racing unconfirmed conntracks are now allowed, then
all places adding conntrack extensions are buggy, and all direct ct->status changes
(not using set_bit APIs) are buggy too.
