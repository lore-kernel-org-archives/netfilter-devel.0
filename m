Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B158593A
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2024 15:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712935374; cv=none; b=o4nK8Ul3VwFf/zZi6b9qEZvmxZew8ozz/I4+UKfsJTECHHJO6iyR6IAWMK1yRVEnATEdakkLeb47ACgZt1XbPbIf91qfPQKT2a/0Q6gTRQD6d70x8Q2ML7xoO/SmROk/MEjM+wWQbB+91VqiEgecrGb2Tpq/MwrdNPMHKFlTi8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712935374; c=relaxed/simple;
	bh=5X7kke06e3UeJqdGUk8D4h504dj+BHWPB2iGiT+tvew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V2+UrE5PoqULdvYmpTmpG+yioQbsi8iKTWzwUgsM5xzngc98lNRGczGHgTeYSfIcZJCY8VFBTLA31DMIDIKpexdvbdN4jC2cPGDh1NllH4a3XdHy6YY/Hl9PN5dsY9qrygPNtSTDCTv1Zghwk0DNNyVJKS7Pz9XquyRBm8LM7Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vt8BzJ23; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vt8BzJ23"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-56fe8be5474so501934a12.0
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2024 08:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712935370; x=1713540170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P8KCiuTa4eqpPfBICrGrSkbJNxoli6JH+bflrAm6zF4=;
        b=vt8BzJ238VsU8az6Byh9RlypFt713AIPT19Oib7f2hAL85DyNvIBgozfU+XMLLdvpU
         PSLjOa3GxDLqz8Atba7WAil/HWgcUFxsSSDMGNoTFkmoDWdNoOl6LrTVe7b1OvOY6aVQ
         uQueMBRp8+okONujRF8LhWX2wGjsziYTfG5yRDuysOmQ5v52rK0WF3la2FaY/92HWoxN
         0WpYxPpEZYcsjgZy+j0v3NsXhVn9u0c4QceWrVIQs2A+1EdNe30cM1xQQ0TO+dqyASd2
         kIjbWe7xfoFXQkGkm8sI5foZ0+QrSt7oQJF1dsXisjep5t57vXPNV8w9cxR86q40v2aG
         b4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712935370; x=1713540170;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P8KCiuTa4eqpPfBICrGrSkbJNxoli6JH+bflrAm6zF4=;
        b=qPZu6i+8JoFEj7Ov3cGFMWq6xgmY7gQe9NaucSC9pflJ2SHK0iBNZRdsSAsgwLvN/l
         IfRP7l4E0sqWQDlysCF/hWGL6c5i+AKdv62jljcZaZH/836CdPC+EhK88yqw07kckzbQ
         OraXzAMG09DR7jwQ1tsC9QTIN1NEtJdwrx+wl9AC4dvdJLVj+2pCiY8gM7O0r0Amd2Zi
         Rk41CERLZqoIuFxmipYzsxOvpZDELhAnaLAlAfelcxUfGjC3RKgXtuMQNBKdnVs1GmyI
         yo3dBw1qGzSPUihHO+MZW8lqpUrG2RNh3dYoys5R1r9HNp7qY7fQrEiyn38c6iHT6oM0
         INkg==
X-Forwarded-Encrypted: i=1; AJvYcCXbc6Vn2uqcEi9+2vf1/URKlX7xXF3Ga/3xeUcXWXfiIxfEqUkJQRRBLFW9M9hEAbVqvqXvv8P8j/lOO/ty8MgOcmN+o0StmYxc7mZckaNV
X-Gm-Message-State: AOJu0Yx7htnC1NPS9l1dIAL5fGor3+q9fucsL+PSRnucjNHGIeQunGB0
	ZatkJdD3x7vRr0cHUAQYxxFJoWdude65aqIrYz3JadB+CcKneggHKQt/Ya4+9aipiNlH/CgOuW1
	GOw==
X-Google-Smtp-Source: AGHT+IFn6OTCBTX3jRnEItDINk05EZMP0OKiE6xd/OWCSVjBrlc+aKYZsDG6YOTcie1ufvccbBFlehXzPB8=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6402:348b:b0:570:5e:5fce with SMTP id
 v11-20020a056402348b00b00570005e5fcemr1737edc.0.1712935370179; Fri, 12 Apr
 2024 08:22:50 -0700 (PDT)
Date: Fri, 12 Apr 2024 17:22:48 +0200
In-Reply-To: <a7e8f467-036c-a3e0-e26b-b5ba966b4e9e@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
 <20240408093927.1759381-2-ivanov.mikhail1@huawei-partners.com>
 <ZhRKOTmoAOuwkujB@google.com> <a7e8f467-036c-a3e0-e26b-b5ba966b4e9e@huawei-partners.com>
Message-ID: <ZhlRuC-1va6DPfgO@google.com>
Subject: Re: [RFC PATCH v1 01/10] landlock: Support socket access-control
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Thu, Apr 11, 2024 at 06:16:31PM +0300, Ivanov Mikhail wrote:
> 4/8/2024 10:49 PM, G=C3=BCnther Noack wrote:
> > On Mon, Apr 08, 2024 at 05:39:18PM +0800, Ivanov Mikhail wrote:
> > > diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.=
h
> > > index c7f152678..f4213db09 100644
> > > --- a/security/landlock/ruleset.h
> > > +++ b/security/landlock/ruleset.h
> > > @@ -92,6 +92,12 @@ enum landlock_key_type {
> > >   	 * node keys.
> > >   	 */
> > >   	LANDLOCK_KEY_NET_PORT,
> > > +
> > > +	/**
> > > +	 * @LANDLOCK_KEY_SOCKET: Type of &landlock_ruleset.root_socket's
> > > +	 * node keys.
> > > +	 */
> > > +	LANDLOCK_KEY_SOCKET,
> > >   };
> > >   /**
> > > @@ -177,6 +183,15 @@ struct landlock_ruleset {
> > >   	struct rb_root root_net_port;
> > >   #endif /* IS_ENABLED(CONFIG_INET) */
> > > +	/**
> > > +	 * @root_socket: Root of a red-black tree containing &struct
> > > +	 * landlock_rule nodes with socket type, described by (domain, type=
)
> > > +	 * pair (see socket(2)). Once a ruleset is tied to a
> > > +	 * process (i.e. as a domain), this tree is immutable until @usage
> > > +	 * reaches zero.
> > > +	 */
> > > +	struct rb_root root_socket;
> >=20
> > The domain is a value between 0 and 45,
> > and the socket type is one of 1, 2, 3, 4, 5, 6, 10.
> >=20
> > The bounds of these are defined with AF_MAX (include/linux/socket.h) an=
d
> > SOCK_MAX (include/linux/net.h).
> >=20
> > Why don't we just combine these two numbers into an index and create a =
big bit
> > vector here, like this:
> >=20
> >      socket_type_mask_t socket_domains[AF_MAX];
> >=20
> > socket_type_mask_t would need to be typedef'd to u16 and ideally have a=
 static
> > check to test that it has more bits than SOCK_MAX.
> >=20
> > Then you can look up whether a socket creation is permitted by checking=
:
> >=20
> >      /* assuming appropriate bounds checks */
> >      if (dom->socket_domains[domain] & (1 << type)) { /* permitted */ }
> >=20
> > and merging the socket_domains of two domains would be a bitwise-AND.
> >=20
> > (We can also cram socket_type_mask_t in a u8 but it would require mappi=
ng the
> > existing socket types onto a different number space.)
> >=20
>=20
> I chose rbtree based on the current storage implementation in fs,net and
> decided to leave the implementation of better variants in a separate
> patch, which should redesign the entire storage system in Landlock
> (e.g. implementation of a hashtable for storing rules by FDs,
> port values) [4].
>=20
> Do you think that it is bad idea and more appropriate storage for socket
> rules(e.g. what you suggested) should be implemented by current patch?
>=20
> [4] https://github.com/landlock-lsm/linux/issues/1

I realized that my suggestion might be at odds with Micka=C3=ABl's Landlock=
 audit
patch set [1].  IIRC, the goal there is to log the reasons for a denial,
together with the Landlock ruleset on which this decision was based.

[1] https://lore.kernel.org/all/20230921061641.273654-1-mic@digikod.net/

I'd recommend to wait for Micka=C3=ABl to chime in on this one before spend=
ing the
time to reimplement that.


=E2=80=94G=C3=BCnther
