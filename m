Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301C747D474
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243563; cv=pass; b=D2y6pIHYDaC9Nzay+3+yqxnNvY3ftYuO2dFxSwpafZ2RtMaBrGmMl544FQ7NppR6D2dHpug3KWF+LQqsnrIa+zogE6U1NDWJ90ZBV7N5HUdPhzSiTuBmmLtfWOIw6wLPyuZTFsEo6lvZfiQe7Hkw54VIEz7Os585JbiuiYTpCj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243563; c=relaxed/simple;
	bh=jS8ArBwCoxi0ZC8lSzOco3wnvg9v8hl21Hj3QvmTP7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uoUz36Cr9ousfsKxwkO69v/bHjMPMFXTmGA0BoYEESm6m+k6dRa1TGCyP842ZgaSHJID54li7cpEq0OlP4oEk2G41GxIJkGT4vJ+Re5OkFPCIVBGN0flmhWyGmIMPM2QA6f+M8skJQNZlq0QCgUwTJIaG+cyyeTa7gfvCM2SWuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EUMbjYdR; arc=pass smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EUMbjYdR"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5c39cb2115cso998559e0c.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 09:32:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787243561; cv=none;
        d=google.com; s=arc-20260327;
        b=f6Y0Y/NP5R2SRxasIvmXNICUxec5HneWZWnBaflIvNcc2TNuXkqnPvIu40PwqHCbd7
         wx+mDOqAAXqChEQQkk+3FcVDNAOeKDwNJwDcolr2kCXTvryKbxDXK9mteXLuZ3npfxFM
         TPSccG4fXtxP+dSOIl9dYIIhquHjOcwUTG2HVhj41xHumc6gXmaRHeHSh/nt8pekl02t
         OCyhVnJ7G7EX2xSkCoh9zG4R/VtsxbwQaFlz+Qe68FE7GsVii9C3o7+Yk7iZVbkQ6AOU
         S3PbA45s6VK1FHCnSvPhgfXIHnbUHeRxEu1CJg8TRTDvzBS6YQ3sOT2X7r6AURK0lytq
         3VFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dxvC9jorGqrS1P5caJ2PaG8v1cvsULEMVRgXviFLmWE=;
        fh=1ktU3/Th7SmvqZSpU18w67JIquaK18wLFpbOnDoiKX4=;
        b=PPryw8zA/kQR3vdLZDDYeZOBZVle3ivTdYvMmwhGB6e7nRD2zMNuG9VnNQgJSOWmmN
         qDVLMzZwP8NOb6pSf3fL8e8dT0AAC8JuCs/DXRpZhHC+zjh5266bzbGBAnovNdxTEKpL
         MMm/zna2XjjL1Vzad5hGHLCDnU6HZ6CNqn8AYDZ5epFPP3wHHudVynCqBJKwO9AErxFn
         SuD8UQayNtihbd97nuOUwHQ3nKxS9fM/2uVhB6okhT6tkDZwwyPy7n8Y1t7WlT6RTWQw
         MXDQm786Mz+aDCnIAOFvCZhRRjv6dVJ7jdgQ2AaoZpss9IKepcUy34/agkXYoNx0igPe
         nsSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787243561; x=1787848361; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dxvC9jorGqrS1P5caJ2PaG8v1cvsULEMVRgXviFLmWE=;
        b=EUMbjYdRO2pWCePCtCKcaBzqhMh3Xn4dkjgEs77dej781w/U1sK4vPiOEnZemVJB2A
         K5YGdZ7BLurmOEE25dY8Wn5tPZpVRnEZWySu2OE4zHnpl1VBRDobVS4dTv0p6JqNM/F3
         P0yRYFmcEKVTXoj8rSieBVZ9P3mlyl7aq70n3h9vfZYrMQ7rv/mIWM7EH7ZMVlbBmuMM
         LnNX9nQjWGj7aha4SsFJ7Bfw+KQHtAv3kgmJx6VmSPVKCDZCClLlAPEQTDF8HUZkCcdA
         Xlx0skK55dbc7acDab06Hh7rn09dFq/qWOU7Xdoaj45HwBjEwGTqQgQIN2xFG2PQhLow
         jMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787243561; x=1787848361;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dxvC9jorGqrS1P5caJ2PaG8v1cvsULEMVRgXviFLmWE=;
        b=fiXEF6CzD7wE9QYU89Hdu6CkwPeqPg6a2Iu8TuGDD3LeZXnKxlyCieoThTieYeVlW+
         /ljsfmGnjeTiZWVV3P+D8Wd3g/t+jN6YU4BUqB2tUgDlRHv0SnDHBW0LligInJD41qrG
         sLfKc+wE2P/Tx7d88/4yPNpQ66MICExc7HDQ9IjiH4QryCMylV7Pxfk2K/GA+MYN5tuw
         FVycED6DDSnNy09LVWCOt/8vw9DzUfWMwCP3RknL6b7NuNLB2k+TEuqxpjQcjfrFIwnM
         8TlPMWNjW8yRAnQtwHMW35qLSgy0A5usMLrrhLXj/qTfZiQTxsoDLSCUR2M1rK3bnacw
         HDrA==
X-Gm-Message-State: AOJu0YwqH6jqoPXL45NcBhXsPdmC+fWaequhtOi+fNerQ5JTRi49eATu
	UL9PB9JV/TZ4zXnzRtTUcpH+hmQM8b1YRUPSZg5xrlN26SrpKeqt9aN9Br0HUr6omqPVuvG5AC+
	fKSzQQCEv1Mx1rQY2WcIfpaUf1f+UNeU=
X-Gm-Gg: AR+sD110gqFmnHwjBrGiN8ZpRj/CpDpG45fVa/UouKr1pcDGGrTnSpPLNOr+mwoUULj
	MUNngHyj2zbjeIFRW0xUzEPICY1/j8FPAOCBLhpH49w8fYukJEl0a0+QkBrJTRNWdam7HR6Oucp
	8yRixXPVfWjqqe4bQuWGkzPRzP7ixSdgwJFuvBELI7Tz/4Skm++zPgL9PSFRq1mh73piANGe0cP
	wCkCDn6mXIPbhxOkPYJ5GuQ1NY5snU+KpyD8YIEC+d8kv5ziO+dxI8Gs7SKwn3Cc5hBFbXz+nvU
	jP0ohp31Xc0Qzku1qsCrNlHaAQreptXqkPkfdzJwu2Dzc8WgWrcVMa5N22F1NT32TakTVsPH7+S
	ikw==
X-Received: by 2002:a05:6122:6b02:b0:5bd:b47d:1865 with SMTP id
 71dfb90a1353d-5c5ef23303fmr2333057e0c.5.1787243560917; Thu, 20 Aug 2026
 09:32:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALkUMdRXAB1nGsBhg77zg2VGZyh-D+rL8kxqDDiEs6qmcXev=g@mail.gmail.com>
 <aoHISuGf2vzWk2s0@strlen.de> <CALkUMdRqwCXbA+9tSFgxxA=pBCAPymRbLBa-UXUi6PE1qytvAA@mail.gmail.com>
 <aoMlCi9pduIyddFU@strlen.de>
In-Reply-To: <aoMlCi9pduIyddFU@strlen.de>
From: Vimal Agrawal <avimalin@gmail.com>
Date: Thu, 20 Aug 2026 22:02:29 +0530
X-Gm-Features: AcwNN1VF9PfkI0KRJ8NGLPpWRMHH8sa5pHAXn9otASE5Wv3EH7tFuXemtMwkt7w
Message-ID: <CALkUMdRTdv9rHqgNO29mWNk6VDbMM8X0kJ8DP5pdWM+nJOpH1w@mail.gmail.com>
Subject: Re: netfilter: nf_nat: race in nf_nat_setup_info() corrupts
 nat_bysource list (GPF / soft lockup)
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org, 
	Vimal Agrawal <vimal.agrawal@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian,

The specific precondition =E2=80=94 br_flood() cloning skbs that share one
unconfirmed ct =E2=80=94 is stock br_netfilter behavior, not anything in ou=
r
custom module; nf_ct_drop_unconfirmed()'s own comment already names
this exact case (br_netfilter/multicast routing). The only thing our
module does is decide, per-packet, whether to route a given skb
through NFQUEUE =E2=80=94 which is exactly what the NFQUEUE API is for, not=
 an
unusual or abusive use of it. What's missing isn't anything in our
module; it's that nf_ct_drop_unconfirmed()'s "am I the exclusive owner
of this unconfirmed ct" check only runs at NFQUEUE-enqueue time. A
sibling clone that never goes through NFQUEUE =E2=80=94 e.g. one that takes
the plain synchronous forward path while another clone of the same ct
is off in NFQUEUE + reinject =E2=80=94 never hits that check at all, and st=
ock
kernel code doesn't check it anywhere else on that path either.

Agreed, and we're not disputing that this is not a complete fix. But
auditing and converting every extension-add call site and every
non-atomic ct->status write across nf_conntrack_core.c, every ALG
helper (ftp/sip/pptp/h323/irc), and ctnetlink is a much larger effort
than we can responsibly take on as part of resolving two specific
production crashes. We'd like to keep the scope of this fix limited to
nf_nat_setup_info() =E2=80=94 the exact function both crashes faulted in, w=
ith
live disassembly confirming the fault site in both cases =E2=80=94 rather t=
han
trying to fix the whole class in one patch. A broader fix (e.g. a
common checkpoint that prevents the sharing from ever reaching any of
these unguarded sites, generalizing what nf_ct_drop_unconfirmed()
already does at NFQUEUE-enqueue time) seems like the right direction
longer-term, but feels like it deserves its own design discussion
rather than being folded into a fix for this specific bug report.

With that scope, here's what we're proposing (corrected from your
sketch: test_and_set_bit() takes the bit number first, address second
=E2=80=94 yours had them swapped =E2=80=94 and this wires up the actual dro=
p on the
losing path, which your version fell through past):

+++ b/net/netfilter/nf_nat_core.c
@@ -839,17 +839,25 @@ nf_nat_setup_info(struct nf_conn *ct,
                                      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tu=
ple);
                lock =3D &nf_nat_locks[srchash % CONNTRACK_LOCKS];
                spin_lock_bh(lock);
+               /* Concurrent callers can reach here for the same,
+                * still-unconfirmed ct (skb_clone()/GSO segmentation/
+                * nf_ct_attach() can share one ct across skbs processed on
+                * different CPUs before it is confirmed). test_and_set_bit=
()
+                * makes the check-and-mark atomic under this same lock, so
+                * only the first caller links the node; a losing caller
+                * drops instead of double-linking and corrupting the list.
+                */
+               if (test_and_set_bit(IPS_SRC_NAT_DONE_BIT, &ct->status)) {
+                       spin_unlock_bh(lock);
+                       return NF_DROP;
+               }
                hlist_add_head_rcu(&ct->nat_bysource,
                                   &nf_nat_bysource[srchash]);
                spin_unlock_bh(lock);
+       } else {
+               set_bit(IPS_DST_NAT_DONE_BIT, &ct->status);
        }

-       /* It's done. */
-       if (maniptype =3D=3D NF_NAT_MANIP_DST)
-               ct->status |=3D IPS_DST_NAT_DONE;
-       else
-               ct->status |=3D IPS_SRC_NAT_DONE;
-
        return NF_ACCEPT;
 }
 EXPORT_SYMBOL(nf_nat_setup_info);

This makes the check-and-mark atomic under the same lock that protects
the list insert, so a losing concurrent caller drops instead of
double-linking nat_bysource. Does keeping this fix scoped to
nf_nat_setup_info() seem reasonable to you, with the broader
extension/status-write question left open for separate discussion?

I can send the formal patch thereafter.

Vimal

On Mon, Aug 17, 2026 at 8:43=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Vimal Agrawal <avimalin@gmail.com> wrote:
> > I do see some conntrack updates passed nf_nat_initialized check in
> > nf_nat_setup_info so ideally it should not do anything for the second
> > or other run for the same conntrack.
> > How about locking out the whole of nf_nat_setup_info on ct->lock. i..e
> > spin_lock_bh(&ct->lock) at the start of the function and unlock before
> > return.
>
> It would be good to understand that this isn't a 3rd party module bug
> first.
>
> As I said, conntrack doesn't expect unconfirmed conntracks racing
> on multiple CPUs.
>
> Minimal hack (not even compile tested):
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -815,16 +815,12 @@ nf_nat_setup_info(struct nf_conn *ct,
>                                       &ct->tuplehash[IP_CT_DIR_ORIGINAL].=
tuple);
>                 lock =3D &nf_nat_locks[srchash % CONNTRACK_LOCKS];
>                 spin_lock_bh(lock);
> -               hlist_add_head_rcu(&ct->nat_bysource,
> -                                  &nf_nat_bysource[srchash]);
> +               if (!test_and_set_bit(&ct->status, IPS_SRC_NAT_DONE_BIT))
> +                       hlist_add_head_rcu(&ct->nat_bysource,
> +                                          &nf_nat_bysource[srchash]);
>                 spin_unlock_bh(lock);
> -       }
> -
> -       /* It's done. */
> -       if (maniptype =3D=3D NF_NAT_MANIP_DST)
> -               ct->status |=3D IPS_DST_NAT_DONE;
> -       else
> -               ct->status |=3D IPS_SRC_NAT_DONE;
> +       } else
> +               set_bit(&ct->status, IPS_DST_NAT_DONE_BIT);
>
>         return NF_ACCEPT;
>  }
>
> But its not enough, if we assume racing unconfirmed conntracks are now al=
lowed, then
> all places adding conntrack extensions are buggy, and all direct ct->stat=
us changes
> (not using set_bit APIs) are buggy too.
