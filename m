Received: from mail-lr2-f22.google.com (mail-lr2-f22.google.com [74.125.230.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3D03AEF57
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 07:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974643; cv=pass; b=mbJL5DRjOqwzL4pJ3gwaF3Vs1f2mu1/qeY3F/OuLoDB/uW5irIq2BEaxqU16gg4N1AhLiILfkskEBXysde4qk36fYDlCQuJf1Pj4CG1vDUkp2j+L+YHOyOkdPskyxxgtB5nED0eEaJoBlEX1tWGfGwoweb6km91Ag0mSh0ymesk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974643; c=relaxed/simple;
	bh=kJH7+kos1l9lkpvaZyjlUUt9NhEpQOT2pMMtBb2piIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iua0+vAVp10erPWO/n65wxB29Ohi/rp2I/eKcC8vHO0MqLZDg7GHupLcbsLbDHVV1IjcPTY1XpI2qZzAfUfOnJzZTLV/Jrz2OkrP1Td4dD0+Pe9vio/ZQOHLqnzEqp96NwVDG0WR02YTMX51cUfz2XogWgPkAk/tCvZrZxytHoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=Hb/5K9Kq; arc=pass smtp.client-ip=74.125.230.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="Hb/5K9Kq"
Received: by mail-lr2-f22.google.com with SMTP id 38308e7fff4ca-3a2ff04155bso22112511fa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 00:10:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789974638; cv=none;
        d=google.com; s=arc-20260327;
        b=jtAOXSd0/isX7C8QcFtgpH3fJYacmqH3DihHy9mUa7snNehD6fkT3yEZMtwRykmkTU
         26Ol4TNRyNWIVVcM3K7I+mIYrbkqsWIdQcCqVs6WbnreqzSvjv+3lnfWDubQIs+6QT/r
         dwi8FuSRoYQAESg4ynR4BJjlVxOu7Dqp84PNBs9gSvf/eEGric6hnGCbER1Gh+dcu/qx
         0nbWYxRbrsVNOJkD5+Q+AAyefNdQn83pxnTv3upjvcToRu2xN/Az2G7zQXaxXqTAXcSW
         +qROAOZ0CvW4AzIdoqGcVQt2vCJl/AwZoANwjRNB+3jsEgswCBklZllgYJmq35r2BzRP
         FOlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ohcBhfXjMZ0w/piBj8Wfzyl/Cc0Gtqk0dL3r6ReUuIg=;
        fh=yrKkx8BvA6EFV/fwRntZ62f1HCPPJO3mUVgH+0Jwxec=;
        b=PToYqqadtizFJF9EUfIi9UoQqx/e1HM80Z9wUrPrCcqm0hgAVtfQJ1uPxfVcfnL50I
         bRIo9NJS+zUIEctKSVFaig74bUfeRlq5s8lTEYnZoLLijKlbA1SRfMRnCMl7nkE0zlI9
         0NWYJwLvAl0vOEheDey8mB4zqVL3oaBBExSZe8okzWtZ50Ral40uOfNGltOvbusF5YhO
         /LYbo/KTJd0SHXNH0QXFfFQ1WYD5ED0XQXR5ISwDiYYoUuqhNAYnmXf3VpDJHhJR8P1l
         uAxUX8A1CCApTUHoD6qE7pavu0qYaabZ7PfIxGHnTwTa0IsCw39JgSXqo9mIqsU2PGKw
         bv3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789974638; x=1790579438; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ohcBhfXjMZ0w/piBj8Wfzyl/Cc0Gtqk0dL3r6ReUuIg=;
        b=Hb/5K9KqMJ3aBi2GtHACmHMerZlDcswpnDm0o6VCgfQNYkS51BtgBLF/vzt5rS9WD5
         RCYM6xRGh1iUJpVeGwJM8qGnBh747L3cHn1P3aygbG3GFjLxe9mCKoK+eNZF1SsfxP8U
         sqXF3U5vkCzbLJl+zHiuofQ2CdNcPi4Nn577x2yti2l5TxTXttPjKz5ESWApzFFvsDnY
         LQK8CAbU6WFrvJd1pYQ2OQkDB+6J99qvYaq6NDrQESh2mjN4JXCxkTIM+UXwqS1joo/Q
         OqVodN9Eiqw2N0YXKJis5u8XS+1FXZKSo8bKDANYcNzuACGASmnmPQhowBvu2f9f5aap
         SjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789974638; x=1790579438;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ohcBhfXjMZ0w/piBj8Wfzyl/Cc0Gtqk0dL3r6ReUuIg=;
        b=veTuMRnL0m1JIEs26N5CoywM8iN65sEGp7Iqv+700TdX8Nqp8RROmJzcVaxPp8WxC1
         S764snaomrg0Et4N7tbGH9zMtLsxNdNMiZdh4Piy77MxuspUFeRCX6/kGfAiL+uD086D
         2LjjqauX28ISzFSrm4kk4WsXmPCyWXGzSJSLYXj/Nz9yUKxJeQWMpNB/s6Y4HoU+cSWG
         LG0OuopAR29QbT7rVYwGiXd23dj+wLy3Jd165+LmhcoKW4iPwt9AnH/p1Ud4VyvBHzPV
         ZKLyLgQhMkcMIrdIMF4HK6hsEKd2bTW70kWYYXBfpymmihi3fzN5pUe0awMYUOXKCT7/
         b0AQ==
X-Forwarded-Encrypted: i=1; AKwUvBwaR+YuZVifiZ5INQnba6MHh66RKD1NV8EvXhXGjSFg5YbTa/kIWJg40qcDS4QG0NLg+R/xt+2xTYsX4gx+Up8=@vger.kernel.org
X-Gm-Message-State: AFuF++lP626YyFfPNkfAVmHcAydY8sC/wiiZV1wf225i1vEhQrdR3fIu
	y6oRCeskXXoIJHRDc/Z8gkO680sGTAAToKLs/uRAaTumZedEJ0jQcbGmSVzSTG++gx4JQTXaTb/
	m/xrK9wR2fjFu9bjnOsg/g2E1hJewWhGny6vGXqFKbyQ=
X-Gm-Gg: AYBFou3b2RXvo452SAbxkokR01NZ5ChUbJZQcNoGJ6q8RnII9X5u7YVDtr1Jcha0n5B
	0Z6yB+Yjjy0pB2Xvys9FpQXIaugsOIHojAWWWzOuLtHQwInCYOSOD2q3/TQ/Mv88eZUh+fT8Kul
	IpzH+RgPR5xb+OOzXiOc/IyYxk1/+tSHGVpctHwFme1hdKTeBf7ACxIbXD2Ix/gq2dlm+HvNVPZ
	oibZWAzTQs3SVGjpQK0OMaLALMFsQlAhaACLQ7E7ZPp5Nk9mZ2hoUvGM3KuzpOoJ4J3VIzvE0NT
	gM8A/GYiBTZe9BBNvtJiiJ+di6yw5z1VexDBLvfS0D8fioNuQq0pfbAVc7QsTJx6r7zA2ECDoTy
	sSqCRp/PgNA==
X-Received: by 2002:a2e:a98c:0:b0:3a5:b187:c7a1 with SMTP id
 38308e7fff4ca-3a5fbf0215emr21570991fa.9.1789974637997; Mon, 21 Sep 2026
 00:10:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917030301.5502-1-zihanx@nebusec.ai> <178996076640.2160803.16028832049809238100@kernel.org>
 <e1efae34-24a7-3b24-22b0-6a838aa93d52@ssi.bg>
In-Reply-To: <e1efae34-24a7-3b24-22b0-6a838aa93d52@ssi.bg>
From: zihan xi <zihanx@nebusec.ai>
Date: Mon, 21 Sep 2026 15:10:26 +0800
X-Gm-Features: AcwNN1UcIHa_FP3_g69sLth774wwgDQwaw2Ruj6A1N9ozW6m1CE6EgqsboVPQSM
Message-ID: <CAANe3eSYSxU_OhSSsp8aML6XH2a8qm2+nZSmdJAzZ6Q6uxwN2A@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] ipvs: avoid stack overflow from recursive
 connection expiration
To: Julian Anastasov <ja@ssi.bg>
Cc: netdev-bot+sashiko@kernel.org, horms@verge.net.au, pablo@netfilter.org, 
	fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org, 
	lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 2:50=E2=80=AFPM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Mon, 21 Sep 2026, netdev-bot+sashiko@kernel.org wrote:
>
> > Thank you for your contribution! Sashiko AI review found 2 potential
> > issue(s) to consider.
> >
> > Critical: 0 =C2=B7 High: 1 (1) =C2=B7 Medium: 0 =C2=B7 Low: 1
> >
> > If you believe none of the issues are legitimate, please reply to each
> > issue of Medium severity or higher and explain why the AI is wrong.
> > If any of them are legitimate and you plan to respin, please let patchw=
ork
> > know by including "pw-bot: cr" as a separate line at the end of your re=
ply
> > (one such reply per series is enough).
> >
> > - [High] ipvs: use-after-free in ip_vs_conn_expire() due to timer re-
> >   arming race
> > - [Low] ip_vs_conn_del_put() (net/netfilter/ipvs/ip_vs_conn.c:1333-1346=
)
> >   keeps its old comment "Try to delete connection while holding=E2=80=
=A6
> >
> > Pre-existing issues:
> > - [High] ip_vs_conn_del_put() (net/netfilter/ipvs/ip_vs_conn.c:1336-134=
1)
> >   cancels the controller's timer, drops the caller's only reference on=
=E2=80=A6
> >
> > --
> >
> > ipvs: avoid stack overflow from recursive connection expiration
> >
> > This changes ip_vs_conn_del_put() to return whether it managed to delet=
e
> > the controller's timer, and makes ip_vs_conn_expire() loop back with th=
e
> > controller instead of recursing into itself.  The stated goal is to kee=
p
> > chain cleanup synchronous while using a single stack frame.
> >
> > v1 Link: https://lore.kernel.org/all/cover.1789110326.git.zihanx@nebuse=
c.ai/
>
>         Zihan, IPVS has conn refcounting which does not look
> natural: the hash table has reference and the timer callback
> has no reference. Let me try today to change the refcounting,
> so that unhashing occurs after last reference is dropped,
> the conn lookups already use inc_not_zero, so we will try
> to consider the timer_delete as successful stealing of
> the refcnt from the timer callback (yes, the callback should
> hold refcnt, not the hashing). But first let me try if the
> idea would be successful. As result, your change should
> be small as before, we should be able to delete conns safely.
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>

Hello Julian,

Thanks for looking into this.

The Sashiko report was generated for v2. I have already sent v3:
https://lore.kernel.org/all/cover.1789877273.git.zihanx@nebusec.ai/

I'll wait for your refcounting changes and then rework the iterative
expiration fix on top of them.

Regards,
Zihan
