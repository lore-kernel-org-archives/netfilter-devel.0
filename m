Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A29540B6C9
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 16:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783959538; cv=pass; b=MeT+fXNjQE/IdZdOSoEtCg9VgONPe648g6m1HdAFBL69+0GYCfAorbcHSUjKZz+dsUwvD/NTWYCvtbbuD0HLVtvgLWe+6H36wFmCOosVq8u+ogz2BIGiU3Thjx9/tRvItPafOwOwmfJH+RB23E1BocJ5cSXz07q3VkgprrGxJ1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783959538; c=relaxed/simple;
	bh=IgUBDAc7uROr6GpgG1hnysnVvrlnG6dWZhfdYiIRH5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TmjKGXciwaehuiz13DkLPJ+imi/ts/jEtQDTbES/0rEKG0+ND3nQIVbfh8fNTSu7FVM0YtgXwWbfjo8fTqeThQeO6FR/AtqnmwOzVnOMEP4lf2602BUgFio4y3ni28sEsvv+FF1vyhEGWV8fyLFb2EjEZdLiOQKjSw3UYtzELt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oluFiQoF; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oluFiQoF"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15fd3a299eso17102066b.2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 09:18:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783959535; cv=none;
        d=google.com; s=arc-20260327;
        b=rOMiSfp0qP9v3cnsg5nUtmgQ/BreafpCZ+rsQq+jZBppqWYeOqFWwLOOE0JUoohX2f
         k3Mr0uPRZ8Syd+Sx/z2Pkzg+ZEV/7UeHl7fL9dmfXrMS7upiiCXrGDh2nRISopobeVj0
         UzKXnWj+bImNc4IhxKRpqPesGiRZVb0lApZHc0jWmuBMqbtjeAPIA3/SwsvHxZbmOkN7
         lr5B1xvw8/ZceOnBsaBOQuXiY09X39vZiUF29tWeCWigldHHPvxq73thfyPMoUkAHNUu
         3rPyJvjB3PHrebnxjnS1KNFGo6O95bWp01uWwt/oRSbUlhWfeB0rhxfniHM/YBw/Ssha
         hdSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9543NKwiKLQgsi8qtC001tzOTSQxH1KY7XkZdcSvQ5g=;
        fh=As8SCK08NAbb28pFaYsLlfUgNOcvu2idHNkQ/GyEERw=;
        b=FCyTDZFR5UUiQEouo6ytPfsZc3LU35zPf0Gq5bVZiMv0qFIrHi25bNOGzIWiUMHdW5
         +0j1HYXLNhGZ28L19obFkOOq2A2klUV9hcTuAcxF36x8ySkms7aJd0Iwl9zvoNv9lzuU
         TLjTZvgxR4oMGf/pZPrcLQC2vI3mKN0TMRp0sFRC4REvRY/3kJ3rA2U81tpBtxooHKug
         0FOXrdM8dwClaY9FGeC3xEym79s8B9z7CMGmkammGvLXwpR7glSMrC2Sxqpu7dhcvXv8
         3UUuitxdGPtz32mLFV+7QRbWC62Ys+q5H6eP2kl/1IV6I0DdUNZzN2u9v5figvtZKHNy
         CWEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783959535; x=1784564335; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9543NKwiKLQgsi8qtC001tzOTSQxH1KY7XkZdcSvQ5g=;
        b=oluFiQoFYYG44r0ELqIzMDSdOfXhcfK/1ZpAgwPQEOAdAZFsjWN4n/Y9gcZUvpIMjo
         urAIBVl41pOrgBfAOKgP7121xQKKuAP38ZQdnR1Br2l/rhsExXVnmreCvMSCIyLhG8Rl
         rT9KPWRzX2y1DBGiuvHDSdw3MI9475mdLayVxny/7qtPbJEo18D8IFUMudxGtwlZUysv
         mOy+lUlXoOVOY6CkoJT82m4DBZV3URGPpT6wjDh/mPuVmQ5tpxf736kUGJDkAQfDQ4+3
         BJERIacKsBclYNGKAYZCYeHEk4n6zXB1f7r3GnkexZTBc/wTs+egNVRXZl2yalKIFTBi
         HWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783959535; x=1784564335;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9543NKwiKLQgsi8qtC001tzOTSQxH1KY7XkZdcSvQ5g=;
        b=blXZ1LrAqOE7aAdfsSHWKjX8HSoAW+z+g/0M9hP+li2mqnFZjr9vl0eIdikypoFDDP
         Ae0KfrQ+DF8te1Vw9TMfja/xbTz0g2g+s5HCXeeFOp9uSKP7H3X77bdm/4AOn7B/MdBr
         tMNKOPAW378W3UEfWFMkifixrqFdlfEAwPofUnEQ02gxsyajUikgEFn1MS2p+wzMtS1j
         ypihhmyl9+90bqMFV0yeJlPNmaoAZoA4pMv7/WJUn0ZTGnst8bQC6s7BmPw1izU1JGjg
         cHrG6jaDBlKFQG2qFIj2huixPxEDwt8vmLAJ/q9nuWqCqjcz7GaJ2uqs/z1t7WxRoLns
         JaeQ==
X-Forwarded-Encrypted: i=1; AHgh+RpmgbAZztIsai3qc1rp2W1Ief9r7E3wStXRlSAMqChY1N9+BtyuCLr99S/CHY4vYPxJD5yc+XzmPpTCYoA7vLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxle0JqpLhNW+XgR1rXkmBDJZgxZAbfHTLT/25CPmi7xksvu4B7
	/nFYVwDJG/OwZMawtylqhH6FR0tGt4jSoxIV8wIVpmfM1S1TIo6Z1U/XyTM0IcMH1Acn4408gku
	GC4+N570uxSNL+Srh4K38N00dvFmlgYI=
X-Gm-Gg: AfdE7cmUTtRJxH4FQFiAPiCMqi5WykujnqS3cYG24Vt2+WCAeYch+rGLxW/S/Yn4NCi
	kGkYhF+8dNjMdtsEHWaYYG/+tgny4d9grwdy+IGcL+UkR0q5VyPyeZrD6/OLoKHyNx1azvyuBLA
	5hFLz/i8oey8zgV2dvdzZ/kGt8zkwcDGfMtZ5ofaczjAiOj7c+t6eOV8MdXxIHbTOvR8QwtT0Vq
	mpLRhJrs4rFsCUxlhje2W1jMggTp+qbHtV+nh4eBzvgsLilS86rTgcPm8BvOsqfZ90xBcjILeV8
	t48KNfjvUTQ6lCMWViNOTH8FVdCD
X-Received: by 2002:a17:907:94cf:b0:c16:242a:472f with SMTP id
 a640c23a62f3a-c16242a5889mr387661666b.23.1783959534948; Mon, 13 Jul 2026
 09:18:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260704062234.2625208-1-bestswngs@gmail.com> <e3bb8ad1-cb24-5d74-6ca6-a7a1e41fb133@blackhole.kfki.hu>
In-Reply-To: <e3bb8ad1-cb24-5d74-6ca6-a7a1e41fb133@blackhole.kfki.hu>
From: Weiming Shi <bestswngs@gmail.com>
Date: Tue, 14 Jul 2026 00:18:16 +0800
X-Gm-Features: AUfX_mwmodbrNCtcVBLuQvOELt3jqNJGuYrMFhI_EA5_XzVr_n3M1ChoNx00WdE
Message-ID: <CANgPUi1akLRZjwTxw_7_JzBs2tgDx5k5M32vE3hosmkfhkM+aw@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ipset: skip extension destroy on hash
 resize replay
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiang Mei <xmei5@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> =E4=BA=8E2026=E5=B9=B47=E6=9C=
=8813=E6=97=A5=E5=91=A8=E4=B8=80 20:59=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>
> On Fri, 3 Jul 2026, Weiming Shi wrote:
>
> > During a hash set resize, mtype_resize() copies each element into the
> > new table with memcpy(), so the new-table element shares the old-table
> > element's comment extension.  An xt_SET delete on the old table during
> > the resize destroys that shared comment via ip_set_ext_destroy() and
> > queues a replayed delete on h->ad.  After the table swap mtype_resize()
> > replays it with mtype_del() on the new table, whose copy still points a=
t
> > the freed comment, so ip_set_ext_destroy() frees it a second time:
> >
> > ODEBUG: activate active (active state 1) object: ... object type: rcu_h=
ead
> > WARNING: CPU: 3 PID: 5311 at lib/debugobjects.c:514 debug_print_object
> > Call Trace:
> >  <IRQ>
> >  kvfree_call_rcu (kernel/rcu/tree.c:3825)
> >  ip_set_comment_free (net/netfilter/ipset/ip_set_core.c:397)
> >  hash_ip4_del (net/netfilter/ipset/ip_set_hash_gen.h:1098)
> >  hash_ip4_kadt (net/netfilter/ipset/ip_set_hash_ip.c:96)
> >  ip_set_del (net/netfilter/ipset/ip_set_core.c:813)
> >  set_target_v3 (net/netfilter/xt_set.c:412)
> >  ipt_do_table (net/ipv4/netfilter/ip_tables.c:346)
> >  __ip_local_out (net/ipv4/ip_output.c:119)
> >  icmp_push_reply (net/ipv4/icmp.c:397)
> >  __icmp_send (net/ipv4/icmp.c:804)
> >  __udp4_lib_rcv (net/ipv4/udp.c:2521)
> >  ip_local_deliver (net/ipv4/ip_input.c:254)
> >  ip_rcv (net/ipv4/ip_input.c:569)
> >  </IRQ>
> >
> > The replay passes a NULL ext (the kernel-side delete that queued it
> > already destroyed the extensions), so skip ip_set_ext_destroy() when ex=
t
> > is NULL.  This also avoids the NULL ext->target dereference that was on=
ly
> > kept safe by the new table's ref being zero.
> >
> > Reachable from an unprivileged user namespace.
> >
> > Fixes: f66ee0410b1c ("netfilter: ipset: Fix \"INFO: rcu detected stall =
in hash_xxx\" reports")
> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> > net/netfilter/ipset/ip_set_hash_gen.h | 6 ++++--
> > 1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipse=
t/ip_set_hash_gen.h
> > index 5e4453e9e..bc909ae2d 100644
> > --- a/net/netfilter/ipset/ip_set_hash_gen.h
> > +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> > @@ -1080,9 +1080,11 @@ mtype_del(struct ip_set *set, void *value, const=
 struct ip_set_ext *ext,
> >                       mtype_del_cidr(set, h,
> >                                      NCIDR_PUT(DCIDR_GET(d->cidr, j)), =
j);
> > #endif
> > -             ip_set_ext_destroy(set, data);
> > +             /* On a resize replay the extensions were already destroy=
ed. */
> > +             if (ext)
> > +                     ip_set_ext_destroy(set, data);
> >
> > -             if (atomic_read(&t->ref) && ext->target) {
> > +             if (ext && atomic_read(&t->ref) && ext->target) {
> >                       /* Resize is in process and kernel side del,
> >                        * save values
> >                        */
>
> Please rebase your patch against the nf-next tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git): th=
e
> second chunk of your patch is not needed as it has been fixed.
>
> Thank you and best regards,
> Jozsef

Hi,

Thanks for your review. v2 sent.

Best regards,
Weiming Shi
