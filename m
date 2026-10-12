Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A386282F17
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2026 01:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791768898; cv=pass; b=LNQKaQ6x2vNkJbHTqXs3RXtw1phwulDOIx/Nx8n8OHb4zIvWnRpjTvVSTcTi17V4YYtpVp7P04vjcJGB3iOeoEe8TCdDWfnFCohcUYpL/mhxJUfyHZ2A/Up2CUePBq1Fdz3wtCkusct0z5oWcnIzO4+Z5sWPcQu8XiNgc87NsK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791768898; c=relaxed/simple;
	bh=aly8Ri7veaZwhYIlSHE1+doVgz/jlh1chucRFEBfX+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JEpv7KyJU7l/8jflsNhJTF85NNSpuvSZ6lcatuO72rb0Fx1N7GidKtcdEkyK6pbvFpm5OHckcD3JHqVR9YOvU2MLDIxi8R3FEMtS9V27zI+rB3O3r3j8JXx+YImdgUkc8YOEoTVVUQHubmrehI+D12MBm7E3R6/Sp/brZvd1fSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=XYh+rQ6j; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="XYh+rQ6j"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3a771ad2a9aso27365511fa.0
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 18:34:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791768895; cv=none;
        d=google.com; s=arc-20260327;
        b=rZ5YllBmbysUO7a+Bygww1vP7mycXFKdCtlF9fco2nlkfEcbaY393b51R6t9cVm+gf
         D+E7iR53raQ3mugAJpu/mESiaFAkmivexRyatpItptCCgPlIC8Ka8kT3a11fmlvWzZtP
         0ybW6gnWtskye5BJtn7T+g8wAgqG4WHkfKla4MBuJA2PtwPy1dR8qAESBwFrQH7Mc+dc
         AmycMoeTtbX2IQApx60CJkJPYzeaRmX3lYXmFSzr87vBy6f5PfhP2obNcvvM+5N1ccPY
         eB+i8+wpr0ZubbQ59L2yonUHj/g2gJs7ilmclFZUrVVtXT4JaqnbYLEiIiTBymcSBwKT
         RpEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AdEIyyU+Z5pfTvB9TJbhK5u/LgBIOBFJdjwZ27xMEnE=;
        fh=m74E99BN/0Ap4HvhjRgjxnNOhlSfhS2Rx7LnmoDKDkY=;
        b=VLypJWbkfOEUYiB48ebyQGOeS/76WfDY3FFTb49AlVbxJ8cgXxx8TPEQOP2m91WsQA
         K6p7br1zn2BSjJWamxqgf75GOAuD8Kn3TMYWZIqFcBpsoDmHUjbyS/F+WaZti0EOGkzp
         nGx2sVMLD/4/2Gwjg7p8jABmr1KegRY3BqDydamv801cvQPL5pnEq4loCoLHN2Q6C3LK
         B/Ajd5IRCxu4a7phyk++mqoILql0KkcTcG8NEBd+l3pqyHrzThFlhNo/nH/CF3fUUCCO
         WTuNhiRhSet1AKCcRerWSiXv5o7dXB0wXohzdWSbhuEOM1NldkjtiUalGmuIMb2rcAkA
         eVbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1791768895; x=1792373695; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AdEIyyU+Z5pfTvB9TJbhK5u/LgBIOBFJdjwZ27xMEnE=;
        b=XYh+rQ6jB82M4EWVriZsaxQH9ZDmuCO16uzWUlH8ueZXEJQC+ckB7sWt4wKzz5ToL/
         tHveTI/carVb7RC0mRmPt/7TLjw7hDPiYGKN0WyI/epQShVqvtuEUp07R5qdrtMG8nAZ
         IgaDeRRlhsxzB3pGP6y8RTH7IdO51eM1Uk9foARNRvHPgAzFEMZUXyIA17Ztp4D3qZF1
         BJEouITY0Dq2+7GndSjSu3lJScdGWQJijs4OFNCCPeta+3/eI5b2L8HVW8uZpKLS53RD
         8OgMFvRIyJ3gblR4V5ni6WTor06oE0ZlESU7SpPoeJul1vZP0bKM/ObiHsJxul+qhJ5F
         S3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791768895; x=1792373695;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AdEIyyU+Z5pfTvB9TJbhK5u/LgBIOBFJdjwZ27xMEnE=;
        b=fWhzwe2PxmYC41pLW9wNLBQn0xI5mwRAJPKGGKzGB3dyW69YXeeA8eRY6OWQ5cuQ2B
         bKXhs+2id4bslqeyORIt6ime8Ub1zLC+T9i/DjgDozMCT7xD1Glg26dGkRghJQF6jhM4
         Ea4xIL+iIGjAQ8whEGztVfVeHte/vfg0kO48ux1xjlD4C1H8KTiVl5DadfiPBDYlQym9
         BAxy/oPsqL+M2meu41DNsBogOGKghxGav4zqrCgKX96FA8/cpG9Xode4N5mT4V/R/TYB
         O9hUt18V6VJSsO95yd9w1Muz7JqYeXFzKpuIcunHguKDDuDgx/8JLXehH8yGvcXNEqAG
         7CUA==
X-Forwarded-Encrypted: i=1; AKwUvBxIv0RJhA0PtYkUzskqcH1fqHjt3mF/isQfwzc9fnt/iFXuS4fgEPzM8AqjJRDEY8NcSoAKiQY954qKqel3qgQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYKZI4eQoULmO/6qLNNsYBOeVkpvNWjUnah/HFO7F44C87SyKkLi
	zjdS5eUWTfr5PU6NAGd+MsznNNAeZEMz7zaplNstwHPx1aZEne+c0vUVs+YsA+SBIypIoJ47s5N
	Cz3++NeaOvNtHCr+XVDDBe6rKoyODPL3EmQH6oA9mQec=
X-Gm-Gg: AYBFou0rjiScKXCNKx/3ui0k2O+JzSyOY2o3gWkoSIIwPaDtwrIZDZOEikeBQyZIpdY
	CHb42NKvTGJ32kIvfboCsrsQXnT5uSonmM0QXCZuz5px3s7FT4XBOqC+RTqXGPph7T/V3WGd/te
	AQkX54wpOiK9iN5UbUaxdQhWw+pk78oU1fsljaVzPrWRaOmwQAxG9VoCYWiO5jx25evNYJGcbJV
	vp7R97189F6tB0Sm+CVF7BgwcIAMXoPEM9VsnvFNghg8Zx7sj0AdFAxmMC669PzKNQp1y30pdIF
	N7kY1AYbfrFWSekhBTqN3Bn1YW/O1vT0U4zoIT37/xXyQdz0ULmF39h8qMw3HvPMJhSytgC6fDd
	+4TMSFA0C5g==
X-Received: by 2002:a2e:bc0a:0:b0:3a9:8731:c607 with SMTP id
 38308e7fff4ca-3a9c2c3d25emr18644251fa.23.1791768894422; Sun, 11 Oct 2026
 18:34:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791688819.git.zihanx@nebusec.ai> <9c51ddfce3069d585b6c9b87e7e1bf3a3b0a2761.1791688819.git.zihanx@nebusec.ai>
 <asukIMajFpbzx3PH@strlen.de>
In-Reply-To: <asukIMajFpbzx3PH@strlen.de>
From: zihan xi <zihanx@nebusec.ai>
Date: Mon, 12 Oct 2026 09:34:42 +0800
X-Gm-Features: AclHuK_b4jS89XmHA96-5o0gwhWMtJfin62SjAAWKdcnHQhaZ8Axe1wjTSUO_vg
Message-ID: <CAANe3eSDbPt8oJBADPQT4oy4rijBXMxm+h9dtKuwLaB9nh6rnw@mail.gmail.com>
Subject: Re: [PATCH nf v7 1/1] netfilter: nf_dup: preserve duplication guard
 across NFQUEUE
To: Florian Westphal <fw@strlen.de>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net, 
	edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org, kaber@trash.net, 
	jengelh@medozas.de, lukas@wunner.de, vega@nebusec.ai, root@tr0jan.top
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2026 at 10:58=E2=80=AFPM Florian Westphal <fw@strlen.de> wr=
ote:
>
> Zihan Xi <zihanx@nebusec.ai> wrote:
> > nf_dup_ipv4() and nf_dup_ipv6() set current->in_nf_duplicate while the
> > cloned skb traverses output hooks. NFQUEUE can retain the clone and ret=
urn
> > NF_STOLEN while that traversal is in progress. Once ip_local_out() or
> > ip6_local_out() returns, the task-local guard is cleared. NF_ACCEPT the=
n
> > resumes hook traversal after the queued hook in the verdict task, where
> > the guard is no longer set. A later dup rule can clone the packet again=
,
> > causing repeated packet processing and resource consumption.
>
> I find this waaaaay too complex.
>
> >  include/linux/sched.h            |  2 ++
> >  include/net/netfilter/nf_queue.h |  1 +
> >  net/ipv4/netfilter/ip_tables.c   |  5 ++++-
> >  net/ipv4/netfilter/nf_dup_ipv4.c |  5 ++++-
> >  net/ipv6/netfilter/ip6_tables.c  |  5 ++++-
> >  net/ipv6/netfilter/nf_dup_ipv6.c |  6 +++++-
> >  net/netfilter/nf_dup_netdev.c    | 13 ++++++++++++-
> >  net/netfilter/nf_queue.c         |  4 ++++
> >  net/netfilter/nfnetlink_queue.c  |  8 +++++++-
> >  9 files changed, 43 insertions(+), 6 deletions(-)
>
> Holy cow...  This is waaaay to large/complex, sorry.
>
> >       unsigned                        in_nf_duplicate:1;
> > +     unsigned                        in_nf_dup_netdev:1;     /* netdev=
 dup output is active */
> > +     unsigned                        in_nf_duplicate_reinject:1;     /=
* NFQUEUE resume */
>
> I don't understand this.
>
> >       struct nf_hook_state    state;
> > +     bool                    in_nf_duplicate;        /* skb is on a du=
plication path */
>
> OK.
>
> > diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tab=
les.c
> > index 809441ced..7c2027ef8 100644
> > --- a/net/ipv4/netfilter/ip_tables.c
> > +++ b/net/ipv4/netfilter/ip_tables.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/vmalloc.h>
> >  #include <linux/netdevice.h>
> >  #include <linux/module.h>
> > +#include <linux/preempt.h>
> >  #include <net/ip.h>
> >  #include <net/compat.h>
> >  #include <linux/uaccess.h>
> > @@ -270,7 +271,9 @@ ipt_do_table(void *priv,
> >        * but it is no problem since absolute verdict is issued by these=
.
> >        */
> >       if (static_key_false(&xt_tee_enabled))
> > -             jumpstack +=3D private->stacksize * current->in_nf_duplic=
ate;
> > +             jumpstack +=3D private->stacksize *
> > +                          (current->in_nf_duplicate ||
> > +                           (in_task() && current->in_nf_duplicate_rein=
ject));
>
> ?  Aside from me not getting the need for in_nf_duplicate_reinject, why
> is the in_task() needed but for in_nf_duplicate its not needed...?
>
> As those are bits they even reside on same address...
>
> >  {
> >       struct iphdr *iph;
> > +     bool in_nf_duplicate_reinject =3D in_task() &&
> > +                                     current->in_nf_duplicate_reinject=
;
>
> Same question.
>
> >  #include <linux/slab.h>
> >  #include <linux/init.h>
> >  #include <linux/module.h>
> > @@ -219,6 +220,9 @@ static int __nf_queue(struct sk_buff *skb, const st=
ruct nf_hook_state *state,
> >       *entry =3D (struct nf_queue_entry) {
> >               .skb    =3D skb,
> >               .skb_dev =3D skb->dev,
> > +             .in_nf_duplicate =3D current->in_nf_duplicate ||
> > +                               (in_task() && current->in_nf_duplicate_=
reinject) ||
> > +                               current->in_nf_dup_netdev,
>
> Why not simply
>
>         .in_nf_dup_netdev =3D current->in_nf_duplicate ?
>
>
> > +     bool old_in_nf_duplicate_reinject;
> >
> >       net =3D entry->state.net;
> >       pf =3D entry->state.pf;
> > +     old_in_nf_duplicate_reinject =3D current->in_nf_duplicate_reinjec=
t;
> > +     current->in_nf_duplicate_reinject |=3D entry->in_nf_duplicate;
>
> Don't understand the need to store the old current state here.
> Nor the "|=3D".
>
> > @@ -378,7 +382,7 @@ static void nf_reinject(struct nf_queue_entry *entr=
y, unsigned int verdict)
> >       if (!hooks || i >=3D hooks->num_hook_entries) {
> >               kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
> >               nf_queue_entry_free(entry);
> > -             return;
> > +             goto out;
> >       }
> >
> >       hook_entry =3D &hooks->hooks[i];
> > @@ -417,6 +421,8 @@ static void nf_reinject(struct nf_queue_entry *entr=
y, unsigned int verdict)
> >       }
> >
> >       nf_queue_entry_free(entry);
> > +out:
> > +     current->in_nf_duplicate_reinject =3D old_in_nf_duplicate_reinjec=
t;
>
> ... nor this.  AFAICS the only change we really need is to move the
> local_bh_disable/enable pair to cover the hook iteration is well in
> nf_reinject() to avoid BH interference clearing current->in_nf_duplicate
> resp. acting on wron rect "current" task state.
>
> I think we either need to find a way to make this patch way simpler or
> go back to the "no duplication/TEE in userns".  As I already wrote
> earlier, I see no use case for dup/TEE is namespaces, except for CI
> maybe.
>
> Also, I think there are many many other ways to make kernel eat lots of
> RAM, so I don't think there is any need to ftarget nf tree either.
>
> Sorry, I know you've been spinning on this for a while, but this is too
> hard for me to comprehend.

Hi Florian,

Thanks for the detailed review. I agree that v7 is too complex, and
that I haven't adequately justified the additional
task-local and queue-entry state. In particular, a single queue-entry
flag conflates the distinct IP and netdev
duplication states, and v7 does not establish why they can safely be
merged. The in_task() checks and the save/OR/
restore logic add further complexity. I will not resend v7 as-is.

I also considered your suggestion to extend the local_bh_disable() /
local_bh_enable() pair in nf_reinject() to cover
hook traversal. Based on the code, this alone does not appear to
preserve the duplication guard across the
asynchronous NFQUEUE verdict path: nf_dup_ipv4() and nf_dup_ipv6()
clear current->in_nf_duplicate when the original
output call returns, and the baseline NFQUEUE path does not otherwise
preserve that state. When a later userspace
NF_ACCEPT verdict resumes hook traversal in nf_reinject(), the guard
is not restored. Extending the BH-disabled region
could address a separate synchronous BH-interference case, but it
would not close this state-lifetime gap.

I'll revisit the queue and reinjection paths to look for a smaller,
correct fix that keeps the IP and netdev recursion
states separate. If I cannot find a sufficiently simple solution, I'll
report back with the analysis and ask whether
you prefer the user-namespace restriction you mentioned.

Best regards,
Zihan
