Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE003A7E1E
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 14:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768919292; cv=pass; b=DuuP1nMI0OzjODFYBDxEGJH72K7FjsHb0e/wrLRtTPNgKYq2yEOqFJHv0EpqStgGPvlcdyATAzfEA+yRtlMHDnepeOAp3f7CD9e3gVqnI7Du3yVJXtrVXo3sJx/5D6yRWIV+fYyEufkngFBR6KnesvpV8T8/EZrp9NzcrJODhDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768919292; c=relaxed/simple;
	bh=TG6loHK4KIZM21kXBLOpGEZcQWXTDfo1aBVp080zCLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=d031iw1VE0Hiq4o7Q4JetEUJANopQmIQUVyLijCvwGHAk1ZlAEE3BqOfv377aAM9bI4tylVSQn6sI5h9G0lDZ0EDzgJBxbE/ueV0YZxM8K9bWHNSs4R0A+Ywe+osCPKVoyH6M7TsqBHdI7+Pv+cc82Iy71QjNxR+39lgepf/ZPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bbyWYpXS; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bbyWYpXS"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88a3b9ddd40so33050696d6.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 06:28:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768919290; cv=none;
        d=google.com; s=arc-20240605;
        b=f11yCTF5j908EPDU/n9+m2HaqbJWUiRHmJNyX4Wr7tM8J07oEh5JRVQdLSGhTt8JKd
         PMKIyaQydCiouUB8J2h2MjLE0yjJ7RIqCowpc5Wa9RE+haRfB6iq2vl0AziAPQwj4kgt
         PXAzauPLAiQpfr2V3XbEh7KkM6XLLOoF9H5GxE+QbtioX4atUY1VZZvSIY86IHTChOFl
         nIkO9gffGy26lNKgJIW7KdnSBsttajxGu0sHamRYcoDFDfYeUo2lKYbza0qdHuUeHJ0d
         gN7bs+CRFqmJRh4wECwpV0e4ldd04iQgRZQjXu5aRAjvcOY2atPCS74X/I4nsI7HHelo
         XUTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HygmSM4OGl7Ly5+qTDtZ6P4Y9dF5Ral7gKZ1ZSshBe0=;
        fh=GAKAh3yM/dB2U9f2vrAbympuJccD7cfEhxuKiKnIdZg=;
        b=Z8sqQ15bRvpA2Ahdl9tK3LbfI/Ed+aRJw4nSp8inVEYwHPkv2X2kZfcwvXzOn/OKOF
         F9YL3HF0nb0a553te92PRYy01pttBP86/K8wBeU6ml9z3Kng2jMgc0OTTiA6SH86Q/xE
         STGmrO2WNunzghAwrnD8jRV4YwGkoSbD1D/vgh6veOB7+yJFVu1f/LrQBCj1iLi4hwdD
         yTjLDikQl0CAWuo5D6YfkOlPWsPzPMd3ydCoN+6JVIUEEPsZxCItUEJ3tn1879KVqenQ
         rTGI7q3hVMKZPobBP8ZYl7vXhiV544u2kAG6xTfwSNQ7IVmdBODnJeZvc3EZzWWe62ZS
         qQKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768919290; x=1769524090; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HygmSM4OGl7Ly5+qTDtZ6P4Y9dF5Ral7gKZ1ZSshBe0=;
        b=bbyWYpXS3VAziC4Bnryc1HXTVTtt4yV1lvR2ENjY8KnQkVw9E/DEpye3IDsdZQ6X+T
         InaQ+A5LiTNSKsg/56gu/mj6qxlrIFmKygxwGCrnKvsg8kAdqm2MnzRlUdnSzmEHo6/s
         sGJqnIUosQ594Qy7LLO62tfxTxatcUG2/a/u1vGdKT3GhjwTG1NEo99Od1vPuC7gq/HN
         +iLRAksLoCCuAQsHV0ylFrOrxc966xjLm12MD0yVvshC0+qboZh8Tg4G6LTy4AruA72A
         bJDMLWMDP9NzIapsPfb945a9/W0qZselIfoIQp3GQTnYPC2mUja6OqOMaWBSL0Ff2WmR
         zZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768919290; x=1769524090;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HygmSM4OGl7Ly5+qTDtZ6P4Y9dF5Ral7gKZ1ZSshBe0=;
        b=ELDR6wmNzKjfocuxtsyrO9E9ivZHCAR5J/ftw3HVeVAzbort5vlAngyjmf1WgkpzJo
         gJow3LdznNyWQ0SHXpn//041e48V7wHjAEsljik6/uG0pV8kzAXE+5FJnSZrJVXE6rxf
         pzN9S0TFCU0S7mXJ2oFRRl8NqjO0Zgp1sgB1x9l2jhCMdD34DboG7m73LPIDi+anuID+
         aXZlkJm8JLL3g6pRJqQ0fRaObK4kUVIecgB9s0q1dCUej02qO9jrfRGKqutb82qhnJSF
         kNNuvZ8HeDxwX0Z/olBYckeJ99WrfSp80ooCS1p6h+YbB2MpF0tIEoTEm/h9tReRr8BS
         LJVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWukqUqxo3r8uX2pzwBf8p9riJmVa2hrnDPe4Hwhcx8/4GK9qx40wyAexNhbW7I3vWK/S3NQyEH6GhmfJIYcyI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7nwt1xnAre1K8HBMoUImlKlahuulFghQ+0IoZfNlFSkmmB6Oq
	lkEEE+OVX8/hGjqBWPaXVl/CwhvCxYbip+475sAf7pPMEiUr/5fOljvqISswf9LLGcgCRgL4+3o
	tFBmCe0WdQ7wI2PP2Gj+vGGtjxSq4/cfyrM96
X-Gm-Gg: AZuq6aL7bno7E2u2tXRrdmJEn89lad6dGH+qvJdFayMDi5QyeshmrVd5C9VZQR+8oli
	A8vRfdotXRtjpU1XDSVZNV3eH9lxbjtssZMTcp+Y+ovk+j4kpDxsKIZZc0Cv/shYhj5UkQc3Ed0
	X/6DRltU9uU+B9uRMh53xhi21diH2uAe+bFamDGNEtXtZW6qAa8f37z6qJB39GXWiXaUeHLL1Zx
	0+Z3UHxlD4Kf2B+K1nOpo38T+lVvV5dtZc4jmhDZuka5sJAF4AG8iOBTutVc6tMzA4PLpmGYOFz
	EsTZarRG61KIdE+IC77qiwS2IL1mqw==
X-Received: by 2002:a05:6214:1946:b0:890:808f:c26a with SMTP id
 6a1803df08f44-894638aaa9dmr26666906d6.30.1768919289471; Tue, 20 Jan 2026
 06:28:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260119140813.536515-1-knecht.alexandre@gmail.com>
 <20260119140813.536515-2-knecht.alexandre@gmail.com> <aW-MY7iZLC-iVuht@orbyte.nwl.cc>
In-Reply-To: <aW-MY7iZLC-iVuht@orbyte.nwl.cc>
From: Alexandre Knecht <knecht.alexandre@gmail.com>
Date: Tue, 20 Jan 2026 15:27:58 +0100
X-Gm-Features: AZwV_QhJQ7oMppOzvAfvRPH3QI8uXkJyeuk1DNqU7hQn2n_Yu988sHjjMI2sIq8
Message-ID: <CAHAB8WzhVzdiSQ47Pf79A-3O9F3cHek6euq=vWEP1rMcpbuixA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] parser_json: support handle for rule positioning
 in explicit JSON format
To: Phil Sutter <phil@nwl.cc>, Alexandre Knecht <knecht.alexandre@gmail.com>, 
	netfilter-devel@vger.kernel.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Phil,

Thanks for the comment, that's pretty straightforward to fix, I'm
afraid to do a lot of spamming if I post again a new series, so can
you confirm this is what you expect ?

Merged nested if-conditionals (cheap to expensive):
- if (!(ctx->flags & CTX_F_IMPLICIT) &&
- !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
- if (op =3D=3D CMD_INSERT || op =3D=3D CMD_ADD || op =3D=3D CMD_CREATE) {
- h.position.id =3D h.handle.id;
- h.handle.id =3D 0;
- }
- }
+ if (!(ctx->flags & CTX_F_IMPLICIT) &&
+   (op =3D=3D CMD_INSERT || op =3D=3D CMD_ADD || op =3D=3D CMD_CREATE) &&
+   !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
+     h.position.id =3D h.handle.id;
+     h.handle.id =3D 0;
+ }

Reverse Christmas Tree variable declarations:
- unsigned int i;
- json_t *tmp;
uint32_t old_flags;
struct cmd *cmd;
+ unsigned int i;
+ json_t *tmp;

Or maybe there's a solution to amend this series, not kinda used to
work with git send-email, so if I can resubmit without a new whole
series, could be good ! Otherwise, I'll just create a new one once you
confirm.

Maybe I'll wait for review on tests too before submitting everything again.

Enjoy your day !

Alex

Le mar. 20 janv. 2026 =C3=A0 15:08, Phil Sutter <phil@nwl.cc> a =C3=A9crit =
:
>
> Hi Alexandre,
>
> On Mon, Jan 19, 2026 at 03:08:11PM +0100, Alexandre Knecht wrote:
> > Implementation details:
> > - CTX_F_IMPLICIT flag (bit 10) marks implicit add commands
> > - CTX_F_EXPR_MASK uses inverse mask for future-proof expression flag fi=
ltering
> > - Handle-to-position conversion in json_parse_cmd_add_rule()
> > - Variables declared at function start per project style
>
> Thanks for your follow-up, just two nits:
>
> [...]
> > diff --git a/src/parser_json.c b/src/parser_json.c
> > index 7b4f3384..87266de6 100644
> > --- a/src/parser_json.c
> > +++ b/src/parser_json.c
> [...]
> > @@ -3201,6 +3209,18 @@ static struct cmd *json_parse_cmd_add_rule(struc=
t json_ctx *ctx, json_t *root,
> >               h.index.id++;
> >       }
> >
> > +     /* For explicit add/insert/create commands, handle is used for po=
sitioning.
> > +      * Convert handle to position for proper rule placement.
> > +      * Skip this for implicit adds (export/import format).
> > +      */
> > +     if (!(ctx->flags & CTX_F_IMPLICIT) &&
> > +         !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
> > +             if (op =3D=3D CMD_INSERT || op =3D=3D CMD_ADD || op =3D=
=3D CMD_CREATE) {
> > +                     h.position.id =3D h.handle.id;
> > +                     h.handle.id =3D 0;
> > +             }
> > +     }
>
> Please merge the nested if-conditionals. I suggest sorting expressions
> from cheap to expensive:
>
> |       if (!(ctx->flags & CTX_F_IMPLICIT) &&
> |           (op =3D=3D CMD_INSERT || op =3D=3D CMD_ADD || op =3D=3D CMD_C=
REATE) &&
> |           !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
>
> [...]
> > @@ -4344,6 +4364,8 @@ static struct cmd *json_parse_cmd(struct json_ctx=
 *ctx, json_t *root)
> >       };
> >       unsigned int i;
> >       json_t *tmp;
> > +     uint32_t old_flags;
> > +     struct cmd *cmd;
>
> Please use Reverse Christmas Tree notation, i.e. reverse-sort variable
> definitions by line length.
>
> Thanks, Phil
