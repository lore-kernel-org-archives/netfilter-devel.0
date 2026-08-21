Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05F12F8EB0
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 05:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787291195; cv=pass; b=Ufq0o/ifAHjIQQ2N80MPBj/g0w72PIzQhPK/cQZg0VHKu2tW0VuLXdW7W3eAf8MtGOK0g8lT7Hs20XVl/IfdZq9XdwFcFUwtgtX85herbfc4HeDk/Rab2d2F+w5v6qNaFlmWSLp5r5nOtHrjK/nsgK3zQ5hOOD/C8iL3Obv3Px0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787291195; c=relaxed/simple;
	bh=JOPCp2CQQW5C5nuOAlDaFaoQdcA3MwILABFdXr7n0YU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J620OLrEXPVbhmg0p82dIHDtJZP56bUo/lCQ1BgDUuViS2hKDjYGwsd+LW7CdKB2lz2cp6MSGIF0UwH16nNXQHAv/d9AAZEdr4WOazJB5xIEqBrMuy5rdm84krXXdVIZUg4aywVJVfQMuBZE9VSFiw01zv1TKraxaQwA1mvteVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TzcH8Qos; arc=pass smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TzcH8Qos"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5bfb3347dc4so603272e0c.0
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 22:46:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787291193; cv=none;
        d=google.com; s=arc-20260327;
        b=iRTET4+LY9v9bo8drZLxdDPnvQ8NkJosjBRsZiw9U1wOGtanAlw9dML9baRAEa0tIz
         EXdZPWHBVV7vMH7WYJvuyB9jUbiq0fIo7/I/pLSlOOd6StCIBCD3ukPAADGJ7y8o/wc0
         VijvpXb4lXTo6Ym5Kf7wsnLdaBfgUdwSDCqV1XUxUdkvXYlOSDu7Xp+w44AvBnyCVOjA
         hq0vBtjiGxI2avL63Ttn/vywYbBW2MNnZmc3PpNvYoUFitFCz6wpvUFv6Hh/HmBk1VtX
         c0XaSp0LskEsxt4/gPRuhWP2V4P2ozYtw8zp9Rm/xBayg4Y2YL3UMWgswCYMwsXohOrm
         +bxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CcPrcEQCXFb51k8tEOmZtAmopV4A7bi5B6N8/JbUvLs=;
        fh=1ktU3/Th7SmvqZSpU18w67JIquaK18wLFpbOnDoiKX4=;
        b=Ihe5TOvsX6XPz5wY3SN9PJnPgownM1hZxEjtzSM9Y+93bjDvfY7PZGTzmQQjKVuqNM
         eaJCH9l1UbUs7elBQqR0E6TzJRXY4ZPDJt5ntNhVpkpgXqY7XUMYOn1d9U1z1Hg7pqOi
         QNBYsq3qFZG35EFiGbhw4682iI6gCcuve+lB0KmmUw962/zk2n34eJ5ebsIsF56zdebT
         /QfSNtZkHym0WT6qIunDkJZ2lTFXOtachSPhYt/Sbw/75nOeFePzVSs9iVhCuP9UHiIG
         Sq4NBZke614D0OBhWz9hLD/8kNBZqyKXF2yso1TrvQkF6N5bQj/q5jeL+me0j9a6kza9
         Hzrg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787291193; x=1787895993; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CcPrcEQCXFb51k8tEOmZtAmopV4A7bi5B6N8/JbUvLs=;
        b=TzcH8QosmLX05P45HywuqCNzvx+AXOGsOy+WjP2vgg/S1XFYmc32mjVombI6usE6CJ
         L+2rNagtdwgfXgXTkHkglyyU+QT/B31h/U60GpO0LonSgZNdU4InfWwMcrlwcqhXfPYk
         RlLtP8UVKITcb6v7cYYEzWFOfN17FrWIrkZa60DcI1sAiXTRdpoSEKbqLDROrv30ipJI
         fDMI5TQT36vLP0flg2g2keAjZ+kVJZM/kghZ4/x1ZoViF7fclsdD3fCQv1EVDFuIe5za
         T2NsTDw2dYNDL6iDwcLmTFHxauBqIdNPTgMyAvSSPAUuyvoR/EHborSyzJJRGAz+6/t/
         kONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787291193; x=1787895993;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CcPrcEQCXFb51k8tEOmZtAmopV4A7bi5B6N8/JbUvLs=;
        b=C/5ABfVspUei/bYhHfqRpawPN2nm3/kCT6K3kxPYkRBNjj8F4E46eMJn8clDQCRYB9
         aDh4wKUyv6lFRGvvO7MSox7p+cywMlInU02Tx7VaTY02Sv+euLwlUON+9dFiG3O+/DjB
         rYMfV9XuwyaVCb4DL5024q9SpjfDA+SPgQzvShcUrLghng+L7zLZPk1JtgUvnnIBdd3j
         kucyot9uYTJiNPhR8ccz9RBiAHtb2BK5mkp5sy5CCtc8mHD40NIPoe+YiwQhztp7Re2t
         /5bkRAt3ZavKa62lpYBx/IjAJKAOD99B/ew9b3McuCsh/HuRPSq+oZ67q6oOdRfPSS6U
         Zw+w==
X-Gm-Message-State: AFuF++kDOBmrwp/06G9qLeCScHwEsCNbIrw+XgUJXWaLW9gMyDbpkd+E
	pGu5d07/eRWceeSP0cBkrjS+OCCwZo1f+TSoBg76BKycv8syuCb6WD7JLMS46Kr44cgs2YMsRjd
	mLiyqpkhIUKdh39H7etMQWYKLYfxr7/U=
X-Gm-Gg: AR+sD12m7xJWGDpIVDpEAPAL5lc2r8djMp9n7906D27NjR8NLAQ7baDLjsSc9+fYWS1
	KnYaBOt9cf8ci/O05injUOAGY2KwPo2VD34M0FfPx0Z2wmlIpGW+6VdObR5+Zfm82SYSKPz4y+I
	JchRUX225ZgndQzRatArglsEfVVlKHCN+dEvxTTgmsMfv2R6A/ekVcWEEHim9K7e0iw9Qh+R0RC
	9LxAxwdkHdO5mZc2jwYghvl/DaTAR8r2/gwureIWSiJe1V3drV6AI1vtUZvgbv/h/iXvTe3o0Tw
	94Vk8N+ZXHrJLCbbsCitjFVaF1DEsKxBpy8lwGW1DZWCapvhbft4NGtZwXtFxu00FK0QEji+MaX
	Ttw==
X-Received: by 2002:a05:6122:469e:b0:5bf:8469:c7a0 with SMTP id
 71dfb90a1353d-5c5ff6cd0fbmr1615903e0c.3.1787291192677; Thu, 20 Aug 2026
 22:46:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALkUMdRXAB1nGsBhg77zg2VGZyh-D+rL8kxqDDiEs6qmcXev=g@mail.gmail.com>
 <aoHISuGf2vzWk2s0@strlen.de> <CALkUMdRqwCXbA+9tSFgxxA=pBCAPymRbLBa-UXUi6PE1qytvAA@mail.gmail.com>
 <aoMlCi9pduIyddFU@strlen.de> <CALkUMdRTdv9rHqgNO29mWNk6VDbMM8X0kJ8DP5pdWM+nJOpH1w@mail.gmail.com>
 <aocxJneF3V2jbwyg@strlen.de>
In-Reply-To: <aocxJneF3V2jbwyg@strlen.de>
From: Vimal Agrawal <avimalin@gmail.com>
Date: Fri, 21 Aug 2026 11:16:21 +0530
X-Gm-Features: AcwNN1VfHMWb0jJbRBN3IpwJWD_UTPbi8A-_QHQStvh1-5pDRwraz8HwmGPKqMQ
Message-ID: <CALkUMdQ_6aU8Sy8vTORReQ2=vr4TskbkhZQt3WRazwUMTNEOtg@mail.gmail.com>
Subject: Re: netfilter: nf_nat: race in nf_nat_setup_info() corrupts
 nat_bysource list (GPF / soft lockup)
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org, 
	Vimal Agrawal <vimal.agrawal@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The precondition for this race is br_flood() cloning skbs that share
one still-unconfirmed ct via skb_clone()'s __nf_copy() (which just
bumps the refcount and copies the same _nfct pointer). By itself,
that's not enough to race: br_flood() loops over its clones
sequentially, on the same CPU, so plain bridge flooding alone never
puts two clones of the same unconfirmed ct on different CPUs at the
same time.

What turns this into a cross-CPU race is our custom queueing hook's
per-packet decision. For a given set of cloned skbs sharing one ct,
our hook decides to send skb1 to NFQUEUE, while skb2 is not queued and
instead continues down the plain, synchronous forward path =E2=80=94 both s=
kbs
still pointing at the same unconfirmed ct. skb1 eventually comes back
into the kernel via nf_reinject(), driven by the userspace verdict,
and that reinject can run on a different CPU than the one that
originally queued it. Meanwhile skb2's synchronous path has been
running independently, on its own CPU, the whole time. So by the time
skb1 is reinjected, its SNAT processing in nf_nat_setup_info() can be
running concurrently with skb2's own SNAT processing, on two different
CPUs, both still holding the same unconfirmed ct =E2=80=94 which is exactly
the scenario that corrupts nat_bysource.


On Thu, Aug 20, 2026 at 10:24=E2=80=AFPM Florian Westphal <fw@strlen.de> wr=
ote:
>
> Vimal Agrawal <avimalin@gmail.com> wrote:
> > The specific precondition =E2=80=94 br_flood() cloning skbs that share =
one
> > unconfirmed ct =E2=80=94 is stock br_netfilter behavior, not anything i=
n our
> > custom module; nf_ct_drop_unconfirmed()'s own comment already names
> > this exact case (br_netfilter/multicast routing). The only thing our
> > module does is decide, per-packet, whether to route a given skb
> > through NFQUEUE =E2=80=94 which is exactly what the NFQUEUE API is for,=
 not an
> > unusual or abusive use of it. What's missing isn't anything in our
> > module; it's that nf_ct_drop_unconfirmed()'s "am I the exclusive owner
> > of this unconfirmed ct" check only runs at NFQUEUE-enqueue time.
>
> Yes, but why is that not enough?
>
> > sibling clone that never goes through NFQUEUE =E2=80=94 e.g. one that t=
akes
> > the plain synchronous forward path while another clone of the same ct
> > is off in NFQUEUE + reinject =E2=80=94 never hits that check at all, an=
d stock
> > kernel code doesn't check it anywhere else on that path either.
>
> Yes, but that is serialized, no?
>
> If checks in nfnetlink_queue are supposed to make sure that we can't
> have concurrent execution for unconfirmed conntracks, something that
> plain bridge isn't supposed to cause (its a for-each loop, so first
> skb->nfct gets confirmed, and rest is safe).
>
> If even one skb gets processed by nfqueue, then the existing checks
> are supposed to drop the packet on either queue or reinject.
>
> See nf_ct_drop_unconfirmed() and entry->nf_ct_is_unconfirmed check
> in nfqnl_reinject().
>
> > +++ b/net/netfilter/nf_nat_core.c
> > @@ -839,17 +839,25 @@ nf_nat_setup_info(struct nf_conn *ct,
> >                                       &ct->tuplehash[IP_CT_DIR_ORIGINAL=
].tuple);
> >                 lock =3D &nf_nat_locks[srchash % CONNTRACK_LOCKS];
> >                 spin_lock_bh(lock);
> > +               /* Concurrent callers can reach here for the same,
> > +                * still-unconfirmed ct (skb_clone()/GSO segmentation/
> > +                * nf_ct_attach() can share one ct across skbs processe=
d on
> > +                * different CPUs before it is confirmed). test_and_set=
_bit()
> > +                * makes the check-and-mark atomic under this same lock=
, so
> > +                * only the first caller links the node; a losing calle=
r
> > +                * drops instead of double-linking and corrupting the l=
ist.
> > +                */
> > +               if (test_and_set_bit(IPS_SRC_NAT_DONE_BIT, &ct->status)=
) {
> > +                       spin_unlock_bh(lock);
> > +                       return NF_DROP;
> > +               }
> >                 hlist_add_head_rcu(&ct->nat_bysource,
> >                                    &nf_nat_bysource[srchash]);
> >                 spin_unlock_bh(lock);
> > +       } else {
> > +               set_bit(IPS_DST_NAT_DONE_BIT, &ct->status);
> >         }
> >
> > -       /* It's done. */
> > -       if (maniptype =3D=3D NF_NAT_MANIP_DST)
> > -               ct->status |=3D IPS_DST_NAT_DONE;
> > -       else
> > -               ct->status |=3D IPS_SRC_NAT_DONE;
> > -
> >         return NF_ACCEPT;
> >  }
> >  EXPORT_SYMBOL(nf_nat_setup_info);
>
> Looks fine.  But I'd like to understand why its necessary resp.
> what path is triggering the cloned-and-parallel case in the first place.
>
> > Does keeping this fix scoped to
> > nf_nat_setup_info() seem reasonable to you, with the broader
> > extension/status-write question left open for separate discussion?
>
> Yes, its fine, but I'd like to understand WHY this is happening first.
> If we really have legitimate parallel cases that we can't handle, we
> will eventually need a major redesign of conntrack engine.
