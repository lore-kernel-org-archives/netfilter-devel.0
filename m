Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41A83793CE
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244849; cv=none; b=iolZ79fb+99swHFHyCaABnxvhssC5rQMI7S5nZPoG8ueDj1mck8UP97KExA+boVvl7IsjLLT7shxBTReQdBCAJzTo2Ab/1TJroGvvGFN3xLzPiOZFH3FXD2rdLwDTiDjgzTj2S4pyCNUM5tRGNqb8w1tbahnOcpdgjWlSl8oMLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244849; c=relaxed/simple;
	bh=qI0pBVxW/E0c+P8237p6YjvLvf0YAi43SCrxWVIlWo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxQfYv49jVk7HNoJyhF7lOj3wafBm/hsyr/R6Rh8r6ndRjdrn1pBPNvvEhOFRE+g6bq72uX/qYUxu1pw9BuroxbO/ExIyCGIaRsCTzTjyzuv5u5oe4pB27hEzNrexuE2nORDt11YnM2RTdIHHOc9W46jVh0tBTRC7ldqyq6r9mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 45FD060424; Thu, 20 Aug 2026 18:54:04 +0200 (CEST)
Date: Thu, 20 Aug 2026 18:53:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Vimal Agrawal <avimalin@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org,
	Vimal Agrawal <vimal.agrawal@sophos.com>
Subject: Re: netfilter: nf_nat: race in nf_nat_setup_info() corrupts
 nat_bysource list (GPF / soft lockup)
Message-ID: <aocxJneF3V2jbwyg@strlen.de>
References: <CALkUMdRXAB1nGsBhg77zg2VGZyh-D+rL8kxqDDiEs6qmcXev=g@mail.gmail.com>
 <aoHISuGf2vzWk2s0@strlen.de>
 <CALkUMdRqwCXbA+9tSFgxxA=pBCAPymRbLBa-UXUi6PE1qytvAA@mail.gmail.com>
 <aoMlCi9pduIyddFU@strlen.de>
 <CALkUMdRTdv9rHqgNO29mWNk6VDbMM8X0kJ8DP5pdWM+nJOpH1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALkUMdRTdv9rHqgNO29mWNk6VDbMM8X0kJ8DP5pdWM+nJOpH1w@mail.gmail.com>

Vimal Agrawal <avimalin@gmail.com> wrote:
> The specific precondition — br_flood() cloning skbs that share one
> unconfirmed ct — is stock br_netfilter behavior, not anything in our
> custom module; nf_ct_drop_unconfirmed()'s own comment already names
> this exact case (br_netfilter/multicast routing). The only thing our
> module does is decide, per-packet, whether to route a given skb
> through NFQUEUE — which is exactly what the NFQUEUE API is for, not an
> unusual or abusive use of it. What's missing isn't anything in our
> module; it's that nf_ct_drop_unconfirmed()'s "am I the exclusive owner
> of this unconfirmed ct" check only runs at NFQUEUE-enqueue time.

Yes, but why is that not enough?

> sibling clone that never goes through NFQUEUE — e.g. one that takes
> the plain synchronous forward path while another clone of the same ct
> is off in NFQUEUE + reinject — never hits that check at all, and stock
> kernel code doesn't check it anywhere else on that path either.

Yes, but that is serialized, no?

If checks in nfnetlink_queue are supposed to make sure that we can't
have concurrent execution for unconfirmed conntracks, something that
plain bridge isn't supposed to cause (its a for-each loop, so first
skb->nfct gets confirmed, and rest is safe).

If even one skb gets processed by nfqueue, then the existing checks
are supposed to drop the packet on either queue or reinject.

See nf_ct_drop_unconfirmed() and entry->nf_ct_is_unconfirmed check
in nfqnl_reinject().

> +++ b/net/netfilter/nf_nat_core.c
> @@ -839,17 +839,25 @@ nf_nat_setup_info(struct nf_conn *ct,
>                                       &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
>                 lock = &nf_nat_locks[srchash % CONNTRACK_LOCKS];
>                 spin_lock_bh(lock);
> +               /* Concurrent callers can reach here for the same,
> +                * still-unconfirmed ct (skb_clone()/GSO segmentation/
> +                * nf_ct_attach() can share one ct across skbs processed on
> +                * different CPUs before it is confirmed). test_and_set_bit()
> +                * makes the check-and-mark atomic under this same lock, so
> +                * only the first caller links the node; a losing caller
> +                * drops instead of double-linking and corrupting the list.
> +                */
> +               if (test_and_set_bit(IPS_SRC_NAT_DONE_BIT, &ct->status)) {
> +                       spin_unlock_bh(lock);
> +                       return NF_DROP;
> +               }
>                 hlist_add_head_rcu(&ct->nat_bysource,
>                                    &nf_nat_bysource[srchash]);
>                 spin_unlock_bh(lock);
> +       } else {
> +               set_bit(IPS_DST_NAT_DONE_BIT, &ct->status);
>         }
> 
> -       /* It's done. */
> -       if (maniptype == NF_NAT_MANIP_DST)
> -               ct->status |= IPS_DST_NAT_DONE;
> -       else
> -               ct->status |= IPS_SRC_NAT_DONE;
> -
>         return NF_ACCEPT;
>  }
>  EXPORT_SYMBOL(nf_nat_setup_info);

Looks fine.  But I'd like to understand why its necessary resp.
what path is triggering the cloned-and-parallel case in the first place.

> Does keeping this fix scoped to
> nf_nat_setup_info() seem reasonable to you, with the broader
> extension/status-write question left open for separate discussion?

Yes, its fine, but I'd like to understand WHY this is happening first.
If we really have legitimate parallel cases that we can't handle, we
will eventually need a major redesign of conntrack engine.
