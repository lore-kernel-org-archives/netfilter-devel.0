Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795161788;
	b=0Bi3KqCujjS7m/sYiyl3BeEgLsjKuqWmw5+qe/C+VGZPxm8+ejzN4jnKsj+N70gJH473
	 VHkO4qcxRpgPae3+a2f5vNgx+FMolDoOa1iNR7gb6MiVq5WFshE23hqX5ODvUHe6Cir0v
	 CGi+NqlXgjD6Wjt6k4XOAgyann4yjeQ2IkogWIjXyg9yBmevoFaGJoGxUi0OhN7SF7LvC
	 AQS8DeckX3RwfsU3VQLqPLj72wD4mWYnZ8aFVoeX8AfPRUiLWN5EfejoB/fNBf7pGXx3H
	 LIaW+IOT0mckp3A64DOpCsuovG5ciyu/OZkuk9AG0rSSxAD/1ICLdTO5w4MkKlOG54g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161788;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zumYa9UAyU5VCmz63GjqO3WCpCnOo3TIFw6JOC74pMc=;
	b=3uRK23xB+XAtc01Sew++2mNeDO4KiSsAWdB9lPsD61veA28b9WVl59to1TKKk77BsIm2
	 bH7FAyjux5vJOVuHnQiCnQ1yD8mT9XzdO7irTfBJo1lNKZMyRlApskHl8Ly4emVabTYWu
	 brtd/6aHCWCHb2YUEZsNSjBh5rqeJtR69Pzz33Q6ZzSsyyBKk0mx0L1jC2Va0+XoEG+S4
	 aMUQgzs7y6gMGpWCFuWueZj0sEAHeNvuo3nhTC5Tfar+MNftOd500AijHIBD83dJlYDu9
	 7lbVnSNflMSRQSluZiHrZt4xzWovERjLD4JwIZYYaXjcUrveGTETyfQ+URYO82rhFSQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="mbwDjUZ/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.48
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4CB606A320
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 08:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F4CB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mbwDjUZ/
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-9212dac247aso8229596d6.1
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 00:03:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795161787; cv=none;
        d=google.com; s=arc-20260327;
        b=B6JEzwVNd/AzteJ+DqZDPqw3TEYFfhkRxDzGoUgVM/9HwyQoq3eIrj0MMSVEIakilG
         yw0inmpyNYlWGLLw3Kw01Z2R57+BviHW495s3tnZcypIkECb5uIY6AythESbsPRHNEPM
         ho673L02IyHIxRTZ8cujtTFho/yyt9sFJC31xz6URdKl0s9JJlTASwmkX8BE/oB0jMzO
         a4aQ5PyGu6lWIwXwTSzzKFE0BHIAQIrkysT4gIy/urxKirk46cmWf6Lf6mIxGCPhn5Dl
         lKmUgbVygDsCA9UuWalaK9n91X+kqprXASN1bVWit1gD20DgsWuVJ9BBUr4GFQby7qU1
         s1XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zumYa9UAyU5VCmz63GjqO3WCpCnOo3TIFw6JOC74pMc=;
        fh=1X/8XlKZXeCs9cgz+a+iki4ezsJkHVfnDx+15AnoBa4=;
        b=NBOf29ga4j+EqbEbHPHBosVaSScaVOpziHO3FIYBHJ1eE4tvQH2P8vvNedkba2l0Dk
         xJFu7WnHbtkFFHaP0N8bnGxCfGe4+IjXCo2XEJgTjJYRIUluWqcjtmTBILeA0bhklPiQ
         mnzolHOCOS4TIQbeJcJlritOWioKr2sIqpmzLu3FIYSEeuDBbUf7Wj7ErASUMgnSdfr2
         s1cXlsH8iDmX9EAtrc3He/NcazpW8qgK44HZl1SFIy3RnH71Wn/XtC0sCBObWoHHzTsq
         FekVlZ+R02MsHFIAk0DEclCprD72HuJeS+SiDpOQJSmCYe/YS4hsnWcRnjOd+SGwonWH
         qd8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795161787; x=1795766587; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zumYa9UAyU5VCmz63GjqO3WCpCnOo3TIFw6JOC74pMc=;
        b=mbwDjUZ/gEzSgiOy8gH9kYe/6zjP9rTrM1GGlsE/qLI9jtI7XXhPRqwLHO9Cz3hOdf
         xxyXOCGIY+Etdn5hFmwudIThsZ0I0bR9QcaT+xPinFcAnPIQzrGY7f1I1w3nNDrqhHbp
         Rs2+6bPhkapKJ+1jRfC6o/qAtXIlBof+hu19je8JfebvfIvvQYzCi77DWS/1qHwhawln
         hWn/LKg/Tz6/vsXzb3BU1FRPqLy3Yz7cGv3TYLjjjKPs5nXdfNiaUBv7Abmm8SNCJhzV
         lyBH2fxBItDH3jaQjtlq04K6zKmyXEgtybh639WzCQD5b9sBpgJ0V7gWY8uQC5bGoM7N
         L2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795161787; x=1795766587;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zumYa9UAyU5VCmz63GjqO3WCpCnOo3TIFw6JOC74pMc=;
        b=HAiioQewh062L1jde51Rdqd6w9PYxSWemOFM1qF0z9Y6n2FSbnE3rgpvNLmUjjeNDM
         4cDM3kKbRFt3nB6H9bB0CdCeSbiGAVKbS44q18fWrQcjEBxxDwVtqP4xvYgPgAyvDUf0
         RdzgOW8aDjv8LMtDW9LsRaMUOfHtaoy0D95AVWcWQKX9lYtGL8gIKJwzNDsBNFF10gw7
         EctfOk++gWBpQMwZy7SAFVQt4rHGBMkXzqAb+gkeppd9ge/UT53Aa3qBPb9Q2kyuTTKB
         k4A//U4Qgy90F3IgWqiDrQWPJfKzxEU+3pk7KA/rfYGfd+AIATqP4RvslM4We5HW4NFJ
         2EMA==
X-Forwarded-Encrypted: i=1; AL+hErH/Z3cNSSmWgqTp8T2T8qUcm7thXM2NolRJYIcDZ4zo8skSlzhTTCGaHtxK31RDmXWCK+BB3Ixa9ZUImXowyHQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Pyi+/s+wNij2Ql13FR5JhHFGTlXI6VpCKLDCoL2qKRPVLoOKv
	XF/34KMJlduNCEmZYGbKN56N5379YkwbP20b4BILMjGBZFHYHNRoLsIu/p2Hj2SUrGhVvbarrp4
	D1vOBuQTu1Sni0D10mJxw7Il/szit16eg+sM/ibkxB+n6
X-Gm-Gg: AYBFou1nAD2LcYpB05nfuF9tLvERhJFq4fAmXxlWH3FgPAWyvHmF+D79heGxuzpruQ3
	ZDcABbVbwC852Kzl1dblEQpCsHJPgfQHfDA/X6xeFECwfoxxlQjNdr6Myr9Zp7BCuwR0v5e7mKp
	FyRVLhMrapOd4CaUp76FoaBWTPb4K4Ih5EO96I88f90GtJtWgf14OpdHRCMrpeFuVf1y4i6LlEW
	9sZLnT2ISshfhGlFNIEhc9pEneGuLDgUSjCsO5YP0j3wc+vRn4u0YQZlj/dUQOtyTuSqtLyVtZF
	7Pz0Lhz6TRqqsKLQKlOud8b9mrRk7F+ThVHVe7foz9bc+fESxttR6Ws6uPvBoI/xuIfrhzly4lK
	pval3syAr0hyWCa6fu+yZ4c2q53kl2Mw/YrTLSw==
X-Received: by 2002:a05:620a:2945:b0:949:6f9a:c049 with SMTP id
 af79cd13be357-949ba9e3599mr372536185a.32.1795161787372; Fri, 20 Nov 2026
 00:03:07 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1787158072.git.vega.cover-letter@nebusec.ai>
 <48840876b129e0094fbd8048e96fb6e3fae51055.1787158072.git.vega.cover-letter@nebusec.ai>
 <arLtL4Azj6d7Juxe@strlen.de>
In-Reply-To: <arLtL4Azj6d7Juxe@strlen.de>
From: Ruide Cao <caoruide123@gmail.com>
Date: Fri, 20 Nov 2026 16:02:57 +0800
X-Gm-Features: AclHuK94HU_zQ-CJ5VE_3gyrRqb6te0PgesO9hYSFOWrO-xw0grsmxSf2WM0nwc
Message-ID: <CACveakTTxBEhFRCo65y08ALwJKbOruto4mqOxbarKDE6YFLuxQ@mail.gmail.com>
Subject: Re: [PATCH nf 1/1] netfilter: ecache: bound destroy event redelivery
To: Florian Westphal <fw@strlen.de>
Cc: Ren Wei <weir@nebusec.ai>, netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, kaber@trash.net, vega@nebusec.ai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian,

Thank you for the explanation. I agree.

We will drop this patch and will not send a revised version.

Thanks,
Ruide

Florian Westphal <fw@strlen.de> =E4=BA=8E2026=E5=B9=B49=E6=9C=8823=E6=97=A5=
=E5=91=A8=E4=B8=89 05:03=E5=86=99=E9=81=93=EF=BC=9A
>
> Ren Wei <weir@nebusec.ai> wrote:
> > From: Ruide Cao <caoruide123@gmail.com>
> >
> > A conntrack whose destroy event cannot be delivered is kept on the
> > per-netns ecache list while the workqueue retries the notification.
> > The worker stops at the first failure and retries every 10 ms without
> > a lifetime limit. A listener that enables NETLINK_BROADCAST_ERROR and
> > never drains its receive queue can therefore retain conntracks and
> > keep the worker busy indefinitely.
>
> Yes, that's by design.  This feature intentionally blocks new
> conntracks.
>
> > +     if (!cnet->ecache.retry_deadline)
> > +             cnet->ecache.retry_deadline =3D jiffies + ECACHE_RETRY_TI=
MEOUT;
> > +
> > +     if (time_after_eq(jiffies, cnet->ecache.retry_deadline)) {
> > +             hlist_nulls_for_each_entry_safe(h, n, &cnet->ecache.dying=
_list,
> > +                                             hnnode) {
> > +                     struct nf_conn *ct =3D nf_ct_tuplehash_to_ctrack(=
h);
> > +
> > +                     hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIG=
INAL].hnnode);
> > +                     hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_REP=
LY].hnnode,
> > +                                          &evicted_list);
> > +             }
> > +             ret =3D STATE_DONE;
> > +             goto out_unlock;
> > +     }
>
> I doubt this is correct.  Userspace that can deal with missing destroy
> events SHOULD NOT enable reliable event delivery mode.
