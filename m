Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387C74BEE5E
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 20:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790109825; cv=pass; b=g6S65jB9xtp9eNSxbJ8GXKdzPR1KQWhpB58ozXVanmLqePnVUzneIGLRgC/5ZTFnufMRYfftDmuQ/zMmPC3EFMS5R6p0qO8tebz1ZydAboHo2ze6nO+LoN3ZizwfjOUrK6mO66BHqdulkT2HiHNCnmh4YMIQ4JtxEGAE5akKpzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790109825; c=relaxed/simple;
	bh=p21WGTeF5sTqb4Jtihp5eAQjvRYAP+4+Ui1owmVnpJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qn0R8mUP2EB8AhtovnCqnzH5nyKXtrr/pb411j2pu9O2z/ExCNQnNlK9rPn26LIHbNLMCOnLFWJ0Y0D0RmvLEQr4Wa4zeH1CPU0mG1bKD84+74CXP0WRj+fDsr4Y16FWAfg6KlNJrNCMAI5qEbhyWnyydFY3EWTVOJBQRaxgZPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KahFfhVA; arc=pass smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KahFfhVA"
Received: by mail-pz2-f40.google.com with SMTP id d2e1a72fcca58-87c90648f99so296457b3a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 13:43:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790109818; cv=none;
        d=google.com; s=arc-20260327;
        b=G4qmiI6/Rdx2rzY6wOLQEx2AvQCdKwUIDSrfp9vybBK2Uh0LwK4oujfJ6dlwlR1A0I
         4TZi/W2tHRkXL6E9xCe/IbIK3d+X2lqHhEUJ5uPZ1QXZtr4Jpmeil78OL/L8scXFyGYC
         JMgKv//82zsX3GKSXkt6hfSUTAD/b/fQuNqQqld+roOf6G6X0N7a9BUOzq9Fi0ST7UWl
         5pcPjCqsZp+BqJ9t4U4PbXpAnRejBCyQr/0pJimBUBC/raRamAyyvR68K5d6UOoU5uWw
         yl8G/aBgcJ4E6BY5Fc5p+uKg6v3W0lSC7zd/u9qC0J9PR6eXP9cB7yBzErzVCsq4s5Fr
         NVqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MfcOIqK9du/rFNRW98A9Zkgq23mL6C9Bh17nvMfYECA=;
        fh=3MEqcF/fEiNlhss0F9UQrru86XdwdBj3EHp6FUQBAOs=;
        b=cHouANcrrHrZsX4HnHKe/DN56a9+nav9MEOFb6+hqUgrxsp2tlx85sjF8w9NLf+twI
         QnDVsUajCwlh/r7ytXPACPvnw0d/tt7EeLBTuBqngrrkvY2Eg6o/4ycTKbwunszUJSzx
         xGY/Z348u8dcunL/LLqzHuSiCzMMHSblT+Hhtl+jd8R4LOIxP76pl5hCcgH/6E+Jm4kY
         REt1N4rIJsH8An6Pwk2pDC5l3Bcv7uIZ5MjVn7ZYqSq9nL1rvmxKELkALQ2YRuoS60fR
         KTdWUbE8NGNk4PPMvc6rpgOCmCKBt7hGmgSLiYoHDuuxh+wItQ9yk/3XhMlFpqKCK8vX
         XwQQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790109818; x=1790714618; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MfcOIqK9du/rFNRW98A9Zkgq23mL6C9Bh17nvMfYECA=;
        b=KahFfhVAl1zOli4/f84UtPothikHnIrypswEjYPe+dRdYAEigooZilfTr7SFP9NFUG
         7pep1gMTIXj34rHWMSZ5GI6UT8oTXrSoIT0PijLBS8zex5XIjVb5qKW4uYBPPedAZvpy
         PlygzzcRzt2eGe3feCBETaFYJkp/EIL5QycMtiFt1oufRbMFM9vLY0etZfyS9iMe3XKb
         8AUndaKPeR3Vay9BNHBJBtSb3YqnZHNBW52bAzwrga4kt++tF/JHKctz7RasW0GxlM/s
         oXlajhtzwgqVaodFrbCS0SpKJzdl0YMzlW/4qY+CnVqmSUVS9AQLkWn929LbxCLOHYni
         gvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790109818; x=1790714618;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MfcOIqK9du/rFNRW98A9Zkgq23mL6C9Bh17nvMfYECA=;
        b=PRYy5stUyI9l+bNewTuM1XI7uybMziExjmp64advZK/25Ii+Yswg6hCk2F2VijviAP
         fhl1hC7FKzDmphk+LNABOzdjnq3TR7A/pQZ2CtKS1S5Oz6Jl4dtzcYNGekIxX2sslxqi
         xFkNcJNqtZ384D4rBHK+HH4FAAl6rP0Luu0nvzpzd3i/X6/cykWEYxyoNVFy6+7FTc4s
         88O3gw6f0g0w2J7STBNUbduQSO5G0qWa4WY1ERmCKRbk+zqoCthp9zs70e+BdRVqmzEd
         CqWZ3gQuM3pJXFwUhm/9r7MT6HCCVjQzdfz0M1mbx01r3rOdJC2a4B1XCRrCu2M3Zmo1
         9CAw==
X-Forwarded-Encrypted: i=1; AKwUvBxmF5p9iN9RlslnjzlGNKU7NcBNaMEqR5hD+7uthZ9x96o5EaGpRkds4n285GJyoNU2PeUgnnH6tEm1bCx1s4M=@vger.kernel.org
X-Gm-Message-State: AFuF++nsdObiehFalTOEqmP6X+zN7re228jibdXAg5FQUklzpZxamXWr
	NK8XMRTtze0MRb8f4Kh3WiZAPi8DweUU4FrVAAcbrme3ksgmoWwUPVT2he2hWNq1RfVmaDQs8/G
	z+PNqLf2mCD3enlwIOtLUbqMCSWoGdio=
X-Gm-Gg: AYBFou1oa1aeb5aTwlO0gBNepbb0sK9DwEKVlAICUyTU+uK/I0kQA6MUz5dX266I23V
	iVdBsoOCUmrPUmAIboWWhtgyGD2G8pX6U5A4TAqWftzAI8ZQQ0ceVCMjAJ9a+JHjWQE/b+9hMU/
	gXdQpDRE/dAM58ylPeFrmy6D8g0cDbLMJ3LrRDgi2BE08z+ZvtGuxCr/grxclIfTa/PhvaEraQf
	OarzmUYiCqGyfRGFnxVzROfY8A+Es7QK7AkNK+1D7SLTUMHH2Ltp2b/MthWgQtj/gnJdfAaXYaS
	DfXNr8FlF/a6bSb24jxaP0R0oRXOGxtdB9RuRimhgGMNOcp5hufD0WfS+2ouCtNV+8KJNLfy29W
	4SIXEKZYygAGEn5Em1rfopy656rKKELRmCyEE6zbWC/T8lvlOrst2g+kXSWyghzVA
X-Received: by 2002:a05:6a00:3d4c:b0:873:2525:9a00 with SMTP id
 d2e1a72fcca58-87d178966c3mr805402b3a.0.1790109817966; Tue, 22 Sep 2026
 13:43:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921145655.3167436-1-i.maximets@ovn.org> <20260921145655.3167436-6-i.maximets@ovn.org>
In-Reply-To: <20260921145655.3167436-6-i.maximets@ovn.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 22 Sep 2026 16:43:25 -0400
X-Gm-Features: AcwNN1XXS07Kn-HMsx7mvoCbQqlPeyYonKF1juQSv29HAtUDdVHgyk--e7m0r5w
Message-ID: <CADvbK_d1zZp6ajv9p8S_AaWZpH2aw7WPF5=TomCFxX3yioVw_g@mail.gmail.com>
Subject: Re: [PATCH net 5/6] net/sched: act_ct: remove 'add_helper' dead code
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Aaron Conole <aconole@redhat.com>, 
	Eelco Chaudron <echaudro@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>, 
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

Reviewed-by: Xin Long <lucien.xin@gmail.com>
