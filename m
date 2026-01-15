Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E021322B90
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 20:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768508616; cv=none; b=CJG4XJfxJLNS7IrJDUujcZg93MAKi96J8IGFQwT23Ho7pb2k+47xzgPyUsP9qhGloa6czrGfCkTf/kzp34hxsD/+TqgAl3R1w2zr13XVI31uU4Pin0JjJl9Rb50XanyiDk5e0Jwxw6nvi+tdts6PsQrhiImltFdktAFPdMOmAzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768508616; c=relaxed/simple;
	bh=v4VbyuHlsLAN9Qi9KQEanhbdOkoLP1XKUkHedyaivBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=GoPudNRR4tsZG5BgqXJZvxToP5uSovoGzwbj8EPWubdT5eR++YvMzuWhhJm8rQS5dlw7JXF/pUlZOj0JtuL9N9v0MUA8OHwitpS7aZ378pzIxvaFWK/zR/cZScQrZ0PFc9Sko3fklQv9ccyQm0EIGAZnuEAKbhuqN8svrZQ/tnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KoojCIHk; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KoojCIHk"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-888310b91c5so21439076d6.1
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 12:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768508613; x=1769113413; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QT4VtKZ2jVRjq9kiQ0UZv9yZ2SnQkmOC6QOAKZj4ruo=;
        b=KoojCIHkWJ+d9iT6rnydGm0orU467+hQo+RigJxV8muDrn982qvPcDHiKkkSLgNWpp
         hSWsnyOFPnAk1gTWVv9nIVG795ZoXDiCpo4uZuzaCmmdZVr5rk3kYxOdrCRMfFHGVAaL
         0MT4KEn7fT1zXOO8CbvtSm/NlxdpjU0CprdIl4qbAlyOFDVuhAT6aAa6AiRhGqA7oBjM
         tu6HrEH+2ws4wiVJZZ4fQn2JoljMU84mj9uNG3id/C6twm4hNI+WjzedVazAsKC4XZ79
         4RxvBorHowypPghsA2KzMSluVNzaTbOeO7upzrNH/J+pIJo7WImyWgjE4VzpzBFiVMud
         49Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768508613; x=1769113413;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QT4VtKZ2jVRjq9kiQ0UZv9yZ2SnQkmOC6QOAKZj4ruo=;
        b=eGigN5gjG/6UnSnGEztMMRXgSkRNt5fzljwCwW9awmZgJn8Y7+qUjMb+NxLUyZlYQl
         TYH9JIoem+9DqVmtop9n6/uCYAIyDqqpEUAuCrugRZ8gPl0SPnAubnT/y9Tjpw4bZWJd
         pcQUqas//nCRw7liP/cZtNbdh7rkwWjzx8PAgadiGqBUaxXZCHVohCz7vNoANLdxeSha
         VFoH8thhs2i9Oky9CLK/zd+cqptwc2N1MpHRhLXxrzWXjs11RUZiL54q38Vgu5LmgnEx
         xX+PVVrI4LsDFRpm1pFfPC6d4arObYEvGsAw9iNyYpm76KoBUv09SrGjUoXm1pcEdxZV
         I7Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVCFofrWmXTJ6+28FJpwZMUOXYCnGm/8GAuBdiiKB/e2pUr+Et7plUAw5W6kO7yyXRbIWLeNL19WhRrO2SoG6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzexkldG91p43kznnNUPzjrZdh/SIkcR5RsEg71MiYFXAsZ9+jB
	LenjwHYbD9AY82mjPreyB7jQouL9MFnMP2ASRa105PY46IZW4BJr1rQHBZOjFtSKfPVPyuo959J
	e0/Pf3GgOQPqzL4sU9K3o93P4WBv4Yj8=
X-Gm-Gg: AY/fxX64Bv27aRGE6CguBSicpLFSqVaK/F9tVAgw3htTRZDl6RvDqsbjoKbINZMOKTk
	BFmfBkod/9ZbGrtSWiopnPp5OuIwfq6Nbvp2HNet7DppiHWfqQ4FMLloZD8tF1OJ1t1M0rCPXcJ
	9Sw7WnND9o5F0wZll1V15TkSyi/HYWYx0Zg456rCYv4UNAoUIeiThqnDsrrIHvO/ZivG+oS2lJp
	RW72YTEo05h/jsj+3OykATj04IDMg3hlm/HQEesEAlSiruZz4QR+yJDs6LVtgVNsgHMN5jdRWCe
	j+TPmmJioaqJbXgAgoSLvnatfTAMWA==
X-Received: by 2002:a05:6214:19ca:b0:888:6227:3e77 with SMTP id
 6a1803df08f44-89389f833c1mr55657976d6.4.1768508613197; Thu, 15 Jan 2026
 12:23:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113203041.419595-1-knecht.alexandre@gmail.com>
 <aRcnt9F7N5WiV-zi@orbyte.nwl.cc> <aRcwa_ZsBrvKFEci@strlen.de> <aWe16oO_R-GwM_Af@orbyte.nwl.cc>
In-Reply-To: <aWe16oO_R-GwM_Af@orbyte.nwl.cc>
From: Alexandre Knecht <knecht.alexandre@gmail.com>
Date: Thu, 15 Jan 2026 21:23:22 +0100
X-Gm-Features: AZwV_QjVk4IpocfgzRoq4o5PLlK1awV-75KIlz3vkNH7uhkeQBylmqRv1KkUcRs
Message-ID: <CAHAB8WzKr9rehUKWSZAPWZq_3QnLGbh2Py88WXpV9sE3_V3MZw@mail.gmail.com>
Subject: Re: [PATCH nf-next v4] parser_json: support handle for rule
 positioning without breaking other objects
To: Phil Sutter <phil@nwl.cc>, Alexandre Knecht <knecht.alexandre@gmail.com>, 
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Phil,

I'm deeply sorry for the delay, had a loss in my family, plus a
truckload of tasks to achieve at the end of year at work, I have the
patch nearly ready, need to review and retest it and I should push it
this weekend during my spare time.

Have a nice evening.

Le mer. 14 janv. 2026 =C3=A0 16:27, Phil Sutter <phil@nwl.cc> a =C3=A9crit =
:
>
> Alexandre, will you follow-up on this one? Feel free to ping me if
> something is unclear or you're stuck somewhere - we're there to help if
> needed!
>
> Thanks, Phil
>
> On Fri, Nov 14, 2025 at 02:36:43PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > > +/* Mask for flags that affect expression parsing context */
> > > > +#define CTX_F_EXPR_MASK  (CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY |=
 CTX_F_DTYPE | \
> > > > +                  CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F=
_MAP | \
> > > > +                  CTX_F_CONCAT)
> > >
> > > Maybe define as 'UINT32_MAX & ~(CTX_F_COLLAPSED | CTX_F_IMPLICIT)'
> > > instead?
> >
> > > >  struct json_ctx {
> > > >   struct nft_ctx *nft;
> > > > @@ -1725,10 +1731,14 @@ static struct expr *json_parse_expr(struct =
json_ctx *ctx, json_t *root)
> > > >           return NULL;
> > > >
> > > >   for (i =3D 0; i < array_size(cb_tbl); i++) {
> > > > +         uint32_t expr_flags;
> > > > +
> > > >           if (strcmp(type, cb_tbl[i].name))
> > > >                   continue;
> > > >
> > > > -         if ((cb_tbl[i].flags & ctx->flags) !=3D ctx->flags) {
> > > > +         /* Only check expression context flags, not command-level=
 flags */
> > > > +         expr_flags =3D ctx->flags & CTX_F_EXPR_MASK;
> > > > +         if ((cb_tbl[i].flags & expr_flags) !=3D expr_flags) {
> >
> > So when adding CTX_F_BLA as new expr flag, one has to rember to add it
> > to CTX_F_EXPR_MASK.  Given that I concur with Phil.
> >
> > > >   rule =3D rule_alloc(int_loc, NULL);
> > > >
> > > >   json_unpack(root, "{s:s}", "comment", &comment);
> > > > @@ -4352,8 +4374,21 @@ static struct cmd *json_parse_cmd(struct jso=
n_ctx *ctx, json_t *root)
> > > >
> > > >           return parse_cb_table[i].cb(ctx, tmp, parse_cb_table[i].o=
p);
> > > >   }
> > > > - /* to accept 'list ruleset' output 1:1, try add command */
> > > > - return json_parse_cmd_add(ctx, root, CMD_ADD);
> > > > + /* to accept 'list ruleset' output 1:1, try add command
> > > > +  * Mark as implicit to distinguish from explicit add commands.
> > > > +  * This allows explicit {"add": {"rule": ...}} to use handle for =
positioning
> > > > +  * while implicit {"rule": ...} (export format) ignores handles.
> > > > +  */
> > > > + {
> > > > +         uint32_t old_flags =3D ctx->flags;
> > > > +         struct cmd *cmd;
> > > > +
> > > > +         ctx->flags |=3D CTX_F_IMPLICIT;
> > > > +         cmd =3D json_parse_cmd_add(ctx, root, CMD_ADD);
> > > > +         ctx->flags =3D old_flags;
> > > > +
> > > > +         return cmd;
> > > > + }
> > >
> > > This use of nested blocks is uncommon in this project. I suggest to
> > > either introduce a wrapper function or declare the two variables at t=
he
> > > start of the function's body.
> >
> > Right, as json_parse_cmd() is small I would go for the latter.
> >
> > > > +# Verify all objects were created
> > > > +$NFT list ruleset > /dev/null || { echo "Failed to list ruleset af=
ter add operations"; exit 1; }
> > >
> > > This command does not do what the comment says. To verify object
> > > creation, either use a series of 'nft list table/chain/set/...' comma=
nds
> > > or compare against a stored ruleset dump. See
> > > tests/shell/testcases/cache/0010_implicit_chain_0 for a simple exampl=
e.
> >
> > Yes, please use stored dump and let the test wrapper validate this if
> > possible.  I understand this can't work when the script has to validate
> > intermediate states too, but the last expected state canand should be
> > handled via dump.  More dumps also enhance fuzzer coverage since the
> > dumps are used for the initial input pool.
> >
> > Also run "tools/check-tree.sh" and make sure it doesn't result in new
> > errors with the new test case.
> >
> > If you like you can also split the actual patch and the test cases in
> > multiple patches, but thats up to you.
> >
> >
