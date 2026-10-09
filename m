Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C97C233942
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 00:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791507230; cv=pass; b=cqAEswl2C7w7KfDuCtg7qrAUXTEpIzZfXSzJm+N+/qMrtRpjC3MfWuNw1Oxj9MM9c6oJBlpRkl0ho+rkmLBpNfXgAElnxodupERbHeoBmVFmOdokGJb9/Vb6BURi3FkMjxQMagmbFeMlvmDgeAbP1BXcV2gP6Wv+BBLANTm8VXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791507230; c=relaxed/simple;
	bh=AWknfzEFpzGmpkMF9sYgI+TWzCiS/N433cTlHc+Ph18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUYaQAiKlV9egVsWgbhoT9QjC3NE7kWLYeKsYbXAFB2IwQeJZDJKsoi51m142TM8fzO4XcY+eTDdoO2QEaf8GtUm8pV7eiPuTfxNodqrhcBdMsxvysSPWopDjB0smvZcAE4c3DW+0zh8xu4FEUGsLBCtnHP6zTW3v3C9fKn6vFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=UyxszUKD; arc=pass smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="UyxszUKD"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3a20dec69f9so29137691fa.3
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2026 17:53:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791507226; cv=none;
        d=google.com; s=arc-20260327;
        b=IgQIBPP6F0jfKUyc+sFeaOLBE3NMysJQQVuB2UnQvINKvdlFI4QQ7WhxBzUMgxlqOx
         G8Ts1MhejZaAdyVGjS8JLyfvFfNkj94CGoFh051U7Gck8otj17u1xVDi+HSY8k4SfAy6
         rLF6JmvoyYWgO10AHV/Z1oN42/J3rcaxt82ITHtYh4Twm9QYCVSSmu1ZiA7ImpW1nT/r
         lGfoW956aJRSJ3W/Hj2HKbqwISYJ/OGqS5E3tOemjBCHVkb8zVJmvNS1TJbPSsZH5bw3
         iAAVMyNtBpgVlZTH2G13xqxKJtpeqtGVX0O+kF0tJunVyMH14QVdpGH09QtQe2m2iyUZ
         JckQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=44xPAcgOwQzTnyl/t1xPXJpBrnBuNE+L+PLkUpOBjbo=;
        fh=PplTYoodvAVoOM8iXuW+ZbjhCiD2DZG9X8C81x6G13c=;
        b=OIHhnckXUp0WVgH3FKK+EnjSrkX7pEeiaY044i3DZIvLHXTRRh9OBtuplVwN/CwzMR
         9ygvzr6Q7j4x/QVzWINvF4STkEYmBNM+YMFL6JREKEQfCMEYjyNL/0fbZOK8i7cm5Gd2
         MCT8IO9cn1HkGzV+OSc3hFXO5bwUxfOOALahxXKi3quFyeCl86mjkfuTz3CncwzFkdh/
         AMmJFZYj4TP8JC1bQHJ66RG6uzW5LGp0Yo5gBQYpxALQrIOZUzY5+JflzF56DBIxpOfH
         EiQ8tDUT5/SMQI5mbdJxF2EgiKTsWPIxPkUN/hkccHlMdYB1axILoO+4BF3qOiqc50xW
         PFqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1791507226; x=1792112026; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=44xPAcgOwQzTnyl/t1xPXJpBrnBuNE+L+PLkUpOBjbo=;
        b=UyxszUKDVWuGVHPX4abzW+AeDXhvb58S4C03tuPSy8hvKlPF0RZsZcUn/hKrIalMnF
         Lv45JqLXu9rKtfhItUWpJVso4xZUzxBUb00SRnweLk3ziYt4yOBY3DGA7a/gquH6jJdo
         xTKVvp5D1YVoXjiDDtjV7emv8rKGxloQUnM0TqjUtc9j7LprEqUVnDA3z1J1bmnH7cik
         ydgbeofcuFgl9NyJgOeGjM5sRdo9YdzrW4lCxXyeYwRf8kytbpjtiqKplL09qZe1zPln
         xiqsn4NJ+gnSmgvn+aWyr+GIfMJb9w7ZD+4hp1I9kH/R0RuMAmHc6Dyz73RQpG+OpprJ
         K3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791507226; x=1792112026;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=44xPAcgOwQzTnyl/t1xPXJpBrnBuNE+L+PLkUpOBjbo=;
        b=m8kvgJnQhPPTq+3dA2/yI0Uxj5jx/oDKaSSxMbUnJNw02EhLtdO3K8fllaH/ZM4hMR
         cnS0OuO7o93EHZcalWgXpQmA2DBhHeTTIw/N4zSj8ljIfWmMA8wXpurY7rcD1o5sdCVQ
         fMksiGuFZDgQiNoNq3ZN9R67M9yUfxKpCyHMxw7o0GjuA+FWdRjIHsnjy9D2xHZNBpZ5
         V7pP6nMbe0CXRGniEDFte+lII3DvfpfeplWoZi+a1OBxUNNc6iRuZWWwQy/k1CZi3JFx
         ZD1s1Qjb6B+BNp6XeMZc+EjW50WrZLYfjwNEBUBFmtd2COVcJyVnjbPqTSoDWMGwddp9
         SVGA==
X-Gm-Message-State: AFq9FYILsWYFyCP7Rpym5XOCAVbtAVTTazWS/nS/LLqz1kIJIKNJXj0C
	RP5rQ9CdwFXCuiO/WCgxmexTrK64gMNU395++3NfxGIlPVuACbfJn/1J2J7SxOTGYDFp/Raazyg
	wg4EmA4HU6PijE0610uYl0y1k0owEhCZey9/u76lVYBDrBDWgeUC1smzObG8yNEA7
X-Gm-Gg: AYBFou1vLWR0EHKxg8uNoCWEkDU62ifchlPEWydO9dnXaCSoSgjT0IjdzeYRzBVEuxu
	Te/NmYYpdwvC88WyDzgFzRh436eyYWGHQicNdnCb+1veM3cOHwifDK2LiW/co5V03inmSPL6N3C
	jBhNv4nM9FGZGBR/8gHf6X9zENJ15ItPAYEl5aiXNgT9D+YHQ7C2HZQT6q8KtoacSnR+q1uAzRE
	M1B91gg24pVnhoWB8T8WGbq4y/+aFRvxSxj8AXgI3bGxIGkcvz4azL7AeTyYs3Is/okEIuZOznm
	sJEX+2eyMXzNqL/7BFHj/e82m17NVRCc1YKbPs/eBFwFWclzRenDjMExwFqDtlOUuJWvM1vhRGx
	+ILkMopFImw==
X-Received: by 2002:a05:651c:b27:b0:3a9:9b67:25f7 with SMTP id
 38308e7fff4ca-3a9c53b0b19mr653481fa.4.1791507226238; Thu, 08 Oct 2026
 17:53:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791429178.git.zihanx@nebusec.ai> <82abaa776053bb3e716095a783722452d87fa039.1791429178.git.zihanx@nebusec.ai>
 <asgxFmPajqm8ze-N@chamomile>
In-Reply-To: <asgxFmPajqm8ze-N@chamomile>
From: zihan xi <zihanx@nebusec.ai>
Date: Fri, 9 Oct 2026 08:53:34 +0800
X-Gm-Features: AclHuK-3q7mgCGH5rylAbXKOJL0xe6_Twh56inN6uWureKZzzJmTBPYBZSSWZ64
Message-ID: <CAANe3eRByLG7Sg+DMcx8VSn8fsZxiFxAQ2YgYg-LLSjMu5F1dQ@mail.gmail.com>
Subject: Re: [PATCH nf v6 1/1] netfilter: nf_dup: reject TEE and
 IPv4/IPv6/netdev nft dup in userns
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc, 
	davem@davemloft.net, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	kaber@trash.net, jengelh@medozas.de, vega@nebusec.ai, root@tr0jan.top
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 8:11=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> On Thu, Oct 08, 2026 at 07:08:16AM +0000, Zihan Xi wrote:
> > The packet-duplication frontends can permit repeated packet duplication=
 and
> > resource consumption when configured in a network namespace owned by a
> > non-initial user namespace. Users with CAP_NET_ADMIN in that namespace =
can
> > configure the affected rules.
> >
> > No use case for TEE or nft dup in such namespaces has been identified.
> > Reject TEE and IPv4/IPv6/netdev nft dup rule or expression setup with
> > -EPERM there, without adding checks to packet-processing fast paths.
> >
> > This is a namespace policy restriction, not a general fix for asynchron=
ous
> > duplication behavior. Rules remain installable in init_user_ns-owned
> > network namespaces, and their existing packet-processing behavior is
> > unchanged.
>
> This patch does not refer to NFQUEUE anymore, which allows to trigger
> the OOM sequence that is described. I think it is relevant to
> understand why this is being proposed to be disable in userns.
>
> I read Florian proposed this approach, but I have to admit I get a bit
> nervous when it comes to restricting features in this way
> (sledgehammer!).
>
> Why saving current->in_nf_duplicate in the struct nf_queue_entry is
> not an option? So restoring current->in_nf_duplicate on packet
> reinjection can be done? Are there concerns about this can be abused
> in more way via async/escape paths similar to NFQUEUE?
>
> Thanks.

Hi Pablo,

Thanks for the review. You're right that the v6 commit message became too
generic and omitted NFQUEUE, which is central to the demonstrated trigger.

The relevant sequence is that an IPv4 or IPv6 duplicate reaches an NFQUEUE
hook while current->in_nf_duplicate is set. NFQUEUE retains the skb and
returns NF_STOLEN, so the original ip_local_out() or ip6_local_out() call
unwinds and the duplication helper clears the task-local flag. When a later
NF_ACCEPT verdict reinjects the skb, hook traversal resumes after the queue=
d
hook in the verdict-processing context, where the original task-local guard
is no longer set. A later duplication rule can then duplicate the packet
again, causing repeated packet processing and resource consumption.

The OOM panic log included in the v6 cover letter came from a separate run
as root in a guest configured with panic_on_oom=3D1. It does not demonstrat=
e
that the unprivileged user-namespace run can directly panic the host; the
demonstrated impact is resource consumption.

I don't currently see a reason to rule out saving the duplication state in
struct nf_queue_entry; I had not fully evaluated that approach. I will
check whether the saved state can be applied only while reinjection resumes
hook traversal, while preserving and restoring the verdict-processing
task's prior in_nf_duplicate state on all exit paths. I will also audit
entry-copy paths, including NFQUEUE GSO segmentation. I have not
implemented or validated this approach yet.

Saving only in_nf_duplicate would not address every frontend. In
particular, nft_dup_netdev uses the separate nf_dev_xmit_recursion()
counter around dev_queue_xmit(). I will audit that path and other
asynchronous continuations before deciding whether queue-entry state
propagation is sufficient or whether additional changes are needed.

I will reassess the current user-namespace restriction after that review,
rather than present it as a general fix for asynchronous duplication.

Best regards,
Zihan Xi

>
> > Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel thro=
ugh Xtables too")
> > Fixes: 502061f81d3e ("netfilter: nf_tables: add packet duplication to t=
he netdev family")
> > Cc: stable@vger.kernel.org
> > Reported-by: Vega <vega@nebusec.ai>
> > Assisted-by: LLM
> > Co-developed-by: Luxing Yin <root@tr0jan.top>
> > Signed-off-by: Luxing Yin <root@tr0jan.top>
> > Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
> > ---
> > changes in v6:
> >   - reroll the unchanged four-file setup-time restriction on nf.git mai=
n at
> >     ab699d296e06
> >   - do not present v5 build or runtime results as v6 validation
> >   - v5 Link:
> >     https://lore.kernel.org/all/20260929125832.25316-1-zihanx@nebusec.a=
i/
> > changes in v5:
> >   - describe the patch as a non-initial-userns setup restriction, not a
> >     general recursion fix; state that init_user_ns behavior is unchange=
d
> >   - remove path-specific trigger details and run-specific metrics from =
the
> >     public commit and cover prose
> >   - drop d877f07112f1 from Fixes: because it added a later frontend, no=
t the
> >     shared duplication behavior addressed by this restriction
> >   - record the v5 build and setup-time validation, distinguishing them =
from
> >     earlier unpatched-baseline and root-OOM runs
> >   - v4 Link:
> >     https://lore.kernel.org/all/cover.1790408011.git.zihanx@nebusec.ai/
> > changes in v4:
> >   - add Fixes tags for TEE, IPv4/IPv6 nft dup, and netdev nft dup
> >     frontends
> >   - clarify that fcd53c51d037 only added a synchronous guard
> >   - clarify that this restricts non-initial user namespaces and does no=
t
> >     fix asynchronous recursion in init_user_ns-owned network namespaces
> >   - state explicitly that the netdev loop was not runtime-reproduced
> >   - v3 Link:
> >     https://lore.kernel.org/all/cover.1790042930.git.zihanx@nebusec.ai/
> > changes in v3:
> >   - reroll the fix against the latest nf.git main after no follow-up on=
 v2
> >   - add the Co-developed-by trailer and matching Signed-off-by
> >   - v2 Link:
> >     https://lore.kernel.org/all/cover.1788425393.git.zihanx@nebusec.ai/
> > changes in v2:
> >   - drop the persistent struct sk_buff::nf_duplicated field and nf_copy=
()
> >     change from v1
> >   - disable IPv4/IPv6 duplication in non-initial user namespaces
> >   - v1 Link:
> >     https://lore.kernel.org/all/cover.1787903722.git.zihanx@nebusec.ai/
> > ---
> >  net/ipv4/netfilter/nft_dup_ipv4.c | 4 ++++
> >  net/ipv6/netfilter/nft_dup_ipv6.c | 4 ++++
> >  net/netfilter/nft_dup_netdev.c    | 4 ++++
> >  net/netfilter/xt_TEE.c            | 4 ++++
> >  4 files changed, 16 insertions(+)
> >
> > diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft=
_dup_ipv4.c
> > index d53a65ddbd7b..db62e30456e4 100644
> > --- a/net/ipv4/netfilter/nft_dup_ipv4.c
> > +++ b/net/ipv4/netfilter/nft_dup_ipv4.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/init.h>
> >  #include <linux/module.h>
> >  #include <linux/netlink.h>
> > +#include <linux/user_namespace.h>
> >  #include <linux/netfilter.h>
> >  #include <linux/netfilter/nf_tables.h>
> >  #include <net/netfilter/nf_tables.h>
> > @@ -37,6 +38,9 @@ static int nft_dup_ipv4_init(const struct nft_ctx *ct=
x,
> >       struct nft_dup_ipv4 *priv =3D nft_expr_priv(expr);
> >       int err;
> >
> > +     if (ctx->net->user_ns !=3D &init_user_ns)
> > +             return -EPERM;
> > +
> >       if (tb[NFTA_DUP_SREG_ADDR] =3D=3D NULL)
> >               return -EINVAL;
> >
> > diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft=
_dup_ipv6.c
> > index 95ec27b3971c..6219ef57633e 100644
> > --- a/net/ipv6/netfilter/nft_dup_ipv6.c
> > +++ b/net/ipv6/netfilter/nft_dup_ipv6.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/init.h>
> >  #include <linux/module.h>
> >  #include <linux/netlink.h>
> > +#include <linux/user_namespace.h>
> >  #include <linux/netfilter.h>
> >  #include <linux/netfilter/nf_tables.h>
> >  #include <net/netfilter/nf_tables.h>
> > @@ -35,6 +36,9 @@ static int nft_dup_ipv6_init(const struct nft_ctx *ct=
x,
> >       struct nft_dup_ipv6 *priv =3D nft_expr_priv(expr);
> >       int err;
> >
> > +     if (ctx->net->user_ns !=3D &init_user_ns)
> > +             return -EPERM;
> > +
> >       if (tb[NFTA_DUP_SREG_ADDR] =3D=3D NULL)
> >               return -EINVAL;
> >
> > diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_net=
dev.c
> > index 06866799e946..8d9dfd18475c 100644
> > --- a/net/netfilter/nft_dup_netdev.c
> > +++ b/net/netfilter/nft_dup_netdev.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/init.h>
> >  #include <linux/module.h>
> >  #include <linux/netlink.h>
> > +#include <linux/user_namespace.h>
> >  #include <linux/netfilter.h>
> >  #include <linux/netfilter/nf_tables.h>
> >  #include <net/netfilter/nf_tables.h>
> > @@ -37,6 +38,9 @@ static int nft_dup_netdev_init(const struct nft_ctx *=
ctx,
> >  {
> >       struct nft_dup_netdev *priv =3D nft_expr_priv(expr);
> >
> > +     if (ctx->net->user_ns !=3D &init_user_ns)
> > +             return -EPERM;
> > +
> >       if (tb[NFTA_DUP_SREG_DEV] =3D=3D NULL)
> >               return -EINVAL;
> >
> > diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
> > index 5d34ceb893ed..51c643987526 100644
> > --- a/net/netfilter/xt_TEE.c
> > +++ b/net/netfilter/xt_TEE.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/module.h>
> >  #include <linux/skbuff.h>
> >  #include <linux/route.h>
> > +#include <linux/user_namespace.h>
> >  #include <linux/netfilter/x_tables.h>
> >  #include <net/net_namespace.h>
> >  #include <net/netns/generic.h>
> > @@ -95,6 +96,9 @@ static int tee_tg_check(const struct xt_tgchk_param *=
par)
> >       struct xt_tee_tginfo *info =3D par->targinfo;
> >       struct xt_tee_priv *priv;
> >
> > +     if (par->net->user_ns !=3D &init_user_ns)
> > +             return -EPERM;
> > +
> >       /* 0.0.0.0 and :: not allowed */
> >       if (memcmp(&info->gw, &tee_zero_address,
> >                  sizeof(tee_zero_address)) =3D=3D 0)
> > --
> > 2.43.0
> >
