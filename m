Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B305954CF5F
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 21:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790112954; cv=pass; b=ilTOyE2a2qFK7G6gUsJS6vl2ZCmzyH3fSk4jIiBWS7e9rdSinAT0TYRrZ5mvBlOtCHcOIYOVLnh9KRXqi4uPcJpyNYZG9XYy6Enx7SEbpBG+w8fKG0vzCP13xgtdk3Clpz3WLVAQz/98Wia6tDGtw0mIzXYNROqisty76+CEm00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790112954; c=relaxed/simple;
	bh=EvbVhKnw8RPUu8cuHWn+MNXVd2g9HdJedBQyZE6JTgA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BWM2E8UpuLmDkVDLSYN4qB1I60QnWLxEK7DjylN2IQUlKzXVuJoLG1+j1TGB4sDcLJ9NdgEtHXQL7ueFNA5Om3lP9imGU9Yw4UsXontWExW1amQ0JZ5cfzSNQEfs2fEkjwVMGLyyE72hwSXmqkaGlOiSd0i6c26pioxZ4r7X96Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=ebwMKZtX; arc=pass smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="ebwMKZtX"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469a34908so257773b3a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 14:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790112945; cv=none;
        d=google.com; s=arc-20260327;
        b=bE4jrt48jIruXoE6kNj5iNkAwZywyqDH2Tes2vvIpfaGmFvYHJjQlBcYxC8fViuyIf
         2nRsnAm/D+rd2jabrvNPX9jG/B4KO9cnuyuKM92B3bnruRIJh8BgKUGdbXbasSjD03fn
         e0oDGoQOTpsieq0l9WZdbb7c7MvwYn9ju01sAC4DmT0gSYcZoRUjVqsMHF7kZVQAiZKC
         KNVPHQD0u8bI6eAvJXgLt63GuaZHdmWlhGmMHdpPOHnN/lSmdC+5gRp11cFmAQqk1vRI
         PCEYyCU0GFYlGTKZ0bpHSLn876EWygEk0F/p1sNYFQwdbfFdmUWx6rdSeWw3TEwCvsio
         xp8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kdPzg2Ix4c1W2P1TMypn/Rnc27FR3sHCxu3cYUG6UQg=;
        fh=HUPTMbTY5kWeCy0jcd8GMLWROXYFX90Q4MxBWcIHyk8=;
        b=PoUAtXq5tHihaxHmG9qtxkRXP3ViSjnjjUxUekHMjC0jEMtYpHGSIaCnaGAgwD8UX0
         F7yNlXrIyy0xwXtTGZ4JQMUYuS+/Z/0nxdG+vNiGUCo6IQx+PuowVonr5Z1+M5eUIyCY
         XSqWpUiovfUxuYFXQW+xqG2/tHCthowFfsY2RHKtyCAXGNu/wajWaXStL8O0lWt5FWRB
         gHEvCLExQrRdNzNMyszCuUNqxs2Nq14/1FXsS7paEoF0EoIRnWLX3+G3Up0I3tVKTWz3
         H7q8SFkzX1TAh9XkyTcfTG8EHO/74zsGZJ4eYwDrzect1Zkq1AxgbFwqLAVAIBkqeJ+j
         oQmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1790112945; x=1790717745; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kdPzg2Ix4c1W2P1TMypn/Rnc27FR3sHCxu3cYUG6UQg=;
        b=ebwMKZtXQoXr3R9QTAZaITAjdkRxXnvNB4hA0ksEIQWNDChemNo1KmbtHdlTL7uvjg
         rnVEKZIeoG95s+Xj0juBpBCTFT0OKt+3XJClWr/pWt5ksopTlbsg1tlf1eLE2UG71bI2
         BbUHovLiCWjiy9ExQWHHWuC6qWeLGMUcvWzRM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790112945; x=1790717745;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kdPzg2Ix4c1W2P1TMypn/Rnc27FR3sHCxu3cYUG6UQg=;
        b=tnhG3LLCqgb8vShEx3N/piVOhW8FaWpuVqI8FmmvP4+zP+yEw5CjzhDEKkp3v4HouS
         7/iNoUTtsoYJ+HcGompkWYsEzBwR2G47lZQHLiFBgvsNQxwuo0ZNBO8JBYaFxjMOZgqz
         jMnL4f8e1BHSJDCAAfddR4ZBNxN8djoyeZMYO2huubE5m/mENaXARkwaxqmSsA3RT4hC
         MOekrgBFCnzbaoKqUguJiy5DX7cYc3KFd9hvopvRBe8OS0ekv+HM3QzekoO3FZYoEUe/
         armjbP/nW8DyI1IuTNzCWiHsbh88/Fek+hwrE4IVYmcw/eyLvAOIvZg7I9Ai4mus/bFF
         6aKg==
X-Forwarded-Encrypted: i=1; AKwUvByobji8Sp2S3mwrBlvTBFdqdryY24FRvX6/okbKsWy+CMS4C61+7y2LqXRj6JrUBF3tHxzKXolxQFkqPnww6tk=@vger.kernel.org
X-Gm-Message-State: AFuF++lXdnhqXuwCcZbpt206rdrjRpOMTDiQ9M1dU2PqD4J/UpkFlRxT
	NOCz8dNPyEOR+AjbVPB+fQ/BTMnA0EfyEFlKeGKfSPHE9zAM+d/2ja+dEZPHdvyzS7OdIi5IMq+
	cECRPIStZS4zt9rrHaXcf8ULTdaylSiIpnBdWLnKS
X-Gm-Gg: AYBFou3aAm3TJRdncZ0atIJnTzaKuEQ79noy0fzVQIQwmLZ7MhUt4y0ZUzp0JicmoUG
	yUDIXO2FIJrlXxGyGhHn57U5L8wVgL7oEfaZcmFqUixdQ3y5/WEN3zgQvx2+M6wePYtqCnLSdkS
	I6tT4++SkKHWRJpRpb4pzKmWQ1ClKKFn6FhXxaLIQAyIe8o+n5hiVusjoX4m7huxJoLqFMwPp5M
	er/v+lCH39uFCTtJpVEVHGGcf+O80kYIlatQnyi+Pxb46c2X6ADztDPQKPALqdeamTIzlWeFSdq
	1WdFeZayXNYtMqupZ8nFsG/FifJvmMbLv54iqZyS4V5a8vg6NfJwrmghO8/Ncobqj7IzkWl5dHk
	g+Q9ZUMv6CNKYcqNjDaK3IFlbFgd4d19+7BMcIvLPcOFw
X-Received: by 2002:a05:6a00:44c5:b0:874:708d:b62b with SMTP id
 d2e1a72fcca58-87d1b8a15admr654286b3a.32.1790112945505; Tue, 22 Sep 2026
 14:35:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921145655.3167436-1-i.maximets@ovn.org> <20260921145655.3167436-6-i.maximets@ovn.org>
In-Reply-To: <20260921145655.3167436-6-i.maximets@ovn.org>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 22 Sep 2026 17:35:32 -0400
X-Gm-Features: AcwNN1WPL-vgVShl6hqSyik6C8tmu3eMWMaigjhCeY6OG6KGXvvi-22yq5biirU
Message-ID: <CAM0EoMk96wo2-kupgidntihfxij_zffq2v=ddH-mGUNUH0q7Wg@mail.gmail.com>
Subject: Re: [PATCH net 5/6] net/sched: act_ct: remove 'add_helper' dead code
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Aaron Conole <aconole@redhat.com>, 
	Eelco Chaudron <echaudro@redhat.com>, Jiri Pirko <jiri@resnulli.us>, Xin Long <lucien.xin@gmail.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, linux-kernel@vger.kernel.org, dev@openvswitch.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 10:57=E2=80=AFAM Ilya Maximets <i.maximets@ovn.org>=
 wrote:
>
> This variable can only become 'true' when the connection is not
> confirmed, but it is only checked when it is confirmed.  So, it can be
> treated as being always false and just removed.
>
> Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
> ---
>  net/sched/act_ct.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index e72143d36b119..f62051ec9d57d 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -986,7 +986,6 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb,=
 const struct tc_action *a,
>         struct nf_hook_state state;
>         int nh_ofs, err, retval;
>         struct tcf_ct_params *p;
> -       bool add_helper =3D false;
>         bool skb_is_ours =3D false;
>         bool skip_add =3D false;
>         bool defrag =3D false;
> @@ -1096,14 +1095,14 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *=
skb, const struct tc_action *a,
>                 err =3D __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC=
);
>                 if (err)
>                         goto drop;
> -               add_helper =3D true;
> +
>                 if (nat && !nfct_seqadj(ct)) {
>                         if (!nfct_seqadj_ext_add(ct))
>                                 goto drop;
>                 }
>         }
>
> -       if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helpe=
r) : commit) {
> +       if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {
>                 err =3D nf_ct_helper(skb, ct, ctinfo, family);
>                 if (err !=3D NF_ACCEPT)
>                         goto nf_error;
> --
> 2.55.0
>
