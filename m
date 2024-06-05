Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC4B192B62
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 17:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717607076; cv=none; b=fUOpOtjsMWOkIMZihvIpbQjQmZby/4w+tV+nVbWyHkxq2y9URUc0jMr00eeFjEIEb6jXVqQ683eIrCrx9pOeBzFe0Kk52Z41RFTislwN0LW/iKooK0GJgvJ54B/elEZspjqy1lMzrwGABXW2505Q1s+OldUXAZA4K1tZHTg9bWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717607076; c=relaxed/simple;
	bh=xBnLcGJNYkCr4hFC35be6L2lEyTlLQ3eS2mQ026felE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lTBwZsoF0vsl0BB7i//YtpAqx234a6ui3yqLbfuOUMU9h+b9g3hzww3kpY0mGMqB5LJ0PBHlkO6mpAFLMN2OJrLqloY2y3wuA7cqywSXkhPUaUO7bMdAG21cQTvYVSFqO9JTq4YlJbQXLoJlO6X+UEDcICiVzbUG4Os9fR5E9zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e1NLoEMM; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e1NLoEMM"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-629fe12b380so39554007b3.1
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2024 10:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717607073; x=1718211873; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MIvEv+leeNSj8OFRkkIA/f4lYD7DJjk6WiBrdV4cIqM=;
        b=e1NLoEMM6Bq2pg9uM1tZJD7oDaXcaszv8I47XlZqsNHaqYWnlP3BVGwACz7jBkoPpA
         wa2g0BEh4hGxdbUMxrAFRzReuF436A+yp6+twWIuozwLH47SyNQY7rafCbbFbZ34y6V5
         67SHIoVLgEekj1QDNN727anpMeUXCr01idW0hsgA6HBMzboAmIMOogw70F0NiI+tEaqe
         M99DZErlSsnbKhI6LtmKY641Wt1FlMRpl22WJ/K/4Di0jmTO0H6jedkAxqj8kTD4lSaT
         oIT8zc5rM+oVq38AaL264Kuo8rZKlS5QDRe0CGEMyZ2T2Reen/SFoi4psFCMqSWtZ4x7
         z3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717607073; x=1718211873;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MIvEv+leeNSj8OFRkkIA/f4lYD7DJjk6WiBrdV4cIqM=;
        b=ebi72sSCjJ9gAkMsiPLBSSSvI06aV9Sybpm6tGWK3I8qSFthFRmx0DlSRnooR5XOkb
         XPoca7sqLhbX1uNpWjk6gSl9sB3eHq7UjfdtAWVt3BsNeGcnzo4T6hO9IYhEZbAG/R8H
         5K4iI8g+1YO5nGeiXiKZhr2CI022ijy11SSdmxsfWSc+7y0vALXyC4po+MR4Z6jn20vr
         7Qff125uNerDmhIo0qY4V4bXMGL6hTf9rHbRjpGlZWPU57OoIr2vKsBTvE/1j7mfw9My
         5D/DHhAMvLOuJ1nO3w4OC7u52vE0CvZmBx9SG/OtgRCmRrkkfrc3DzW71oGa309tLWHj
         QpPw==
X-Forwarded-Encrypted: i=1; AJvYcCVLJ1ghS567YgxVAfw2HkKPlC31CcSpFQkHKKCRfbjQAaZno8uonpz/Jkykm5aVniVJucr6rvgJ10kQ3MnnrR7NAnMJCryEzw1N7GeiI5en
X-Gm-Message-State: AOJu0Yy1eZ5sy9Le5in9uaxnrkAowHS/yMBSD8y+484beJc88juouoAx
	kBbmNhU0m6Fs5Apwibb6jSOqwKgNOUOjlHUi15nxhscEMGuthQvR7cObVtMpNOmepwYWmdnoXzh
	Ymg==
X-Google-Smtp-Source: AGHT+IHrAa1mXbNDzjNwFQzkwpq7M0s5LXLVc9H92HxJd2sIsLyDLUGEkJ81jMFCqFmiOlYtju8AgOeCLbU=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:690c:6c0a:b0:627:a961:1b32 with SMTP id
 00721157ae682-62cbb5e0aedmr6679437b3.6.1717607073264; Wed, 05 Jun 2024
 10:04:33 -0700 (PDT)
Date: Wed, 5 Jun 2024 19:04:30 +0200
In-Reply-To: <ff5ce842-7c67-d658-95b6-ba356dfcfeaf@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240524093015.2402952-2-ivanov.mikhail1@huawei-partners.com>
 <ZlRY-W_30Kxd4RJd@google.com> <ff5ce842-7c67-d658-95b6-ba356dfcfeaf@huawei-partners.com>
Message-ID: <ZmCantjZlyxL8jzh@google.com>
Subject: Re: [RFC PATCH v2 01/12] landlock: Support socket access-control
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Thu, May 30, 2024 at 03:05:56PM +0300, Mikhail Ivanov wrote:
> 5/27/2024 12:57 PM, G=C3=BCnther Noack wrote:
> > On Fri, May 24, 2024 at 05:30:04PM +0800, Mikhail Ivanov wrote:
> > > +/**
> > > + * struct landlock_socket_attr - Socket definition
> > > + *
> > > + * Argument of sys_landlock_add_rule().
> > > + */
> > > +struct landlock_socket_attr {
> > > +	/**
> > > +	 * @allowed_access: Bitmask of allowed access for a socket
> > > +	 * (cf. `Socket flags`_).
> > > +	 */
> > > +	__u64 allowed_access;
> > > +	/**
> > > +	 * @family: Protocol family used for communication
> > > +	 * (same as domain in socket(2)).
> > > +	 */
> > > +	int family;
> > > +	/**
> > > +	 * @type: Socket type (see socket(2)).
> > > +	 */
> > > +	int type;
> > > +};
> >=20
> > Regarding the naming of struct landlock_socket_attr and the associated
> > LANDLOCK_RULE_SOCKET enum:
> >=20
> > For the two existing rule types LANDLOCK_RULE_PATH_BENEATH (struct
> > landlock_path_beneath_attr) and LANDLOCK_RULE_NET_PORT (struct
> > landlock_net_port_attr), the names of the rule types are describing the
> > *properties* by which we are filtering (path *beneath*, *network port*)=
, rather
> > than just the kind of object that we are filtering on.
> >=20
> > Should the new enum and struct maybe be called differently as well to m=
atch that
> > convention?  Maybe LANDLOCK_RULE_SOCKET_FAMILY_TYPE and struct
> > landlock_socket_family_type_attr?
> >=20
> > Are there *other* properties apart from family and type, by which you a=
re
> > thinking of restricting the use of sockets in the future?
>=20
> There was a thought about adding `protocol` (socket(2)) restriction,
> but Micka=C3=ABl noted that it would be useless [1]. Therefore, no other
> properties are planned until someone has good use cases.
>=20
> I agree that current naming can be associated with socket objects. But i
> don't think using family-type words for naming of this rule would be
> convenient for users. In comparison with net port and path beneath
> family-type pair doesn't represent a single semantic unit, so it would
> be a little harder to read the code.
>=20
> Perhaps LANDLOCK_RULE_SOCKET_PROTO (struct landlock_socket_proto_attr)
> would be more suitable here? Although socket(2) has `protocol` argument
> to specify the socket protocol in some cases (e.g. RAW sockets), in most
> cases family-type pair defines protocol itself. Since the purpose of
> this patchlist is to restrict protocols used in a sandboxed process, I
> think that in the presence of well-written documentation, such naming
> may be appropriate here. WDYT?
>=20
> [1]
> https://lore.kernel.org/all/a6318388-e28a-e96f-b1ae-51948c13de4d@digikod.=
net/

It is difficult, I also can't come up with a much better name.  In doubt, w=
e
could stick with what you already have, I think.

LANDLOCK_RULE_SOCKET_PROTO alludes to "protocol" and even though that is th=
e
general term, it can be confused with the third argument to socket(2), whic=
h is
also called "protocol" and is rarely used.

Micka=C3=ABl, do you have any opinions on the naming of this?


> > (More about the content)
> >=20
> > The Landlock documentation states the general approach up front:
> >=20
> >    A Landlock rule describes an *action* on an *object* which the proce=
ss intends
> >    to perform.
> >=20
> > (In your case, the object is a socket, and the action is the socket's c=
reation.
> > The Landlock rules describe predicates on objects to restrict the set o=
f actions
> > through the access_mask_t.)
> >=20
> > The implementation is perfectly in line with that, but it would help to=
 phrase
> > the documentation also in terms of that framework.  That means, what we=
 are
> > restricting are *actions*, not protocols.
> >=20
> > To make a more constructive suggestion:
> >=20
> >    "These flags restrict actions on sockets for a sandboxed process (e.=
g. socket
> >    creation)."
>=20
> I think this has too general meaning (e.g. bind(2) is also an action on
> socket). Probably this one would be more suitable:
>=20
>   "These flags restrict actions of adding sockets in a sandboxed
>   process (e.g. socket creation, passing socket FDs to/from the
>   process)."

Sounds good.  (Although I would not give "passing socket FDs to/from the
process" as an example, as long as it's not supported yet.)


> > > + * - %LANDLOCK_ACCESS_SOCKET_CREATE: Create a socket.
> >=20
> > Can we be more specific here what operations are affected by this?  It =
is rather
> > obvious that this affects socket(2), but does this also affect accept(2=
) and
> > connect(2)?
> >=20
> > A scenario that I could imagine being useful is to sandbox a TCP server=
 like
> > this:
> >=20
> >    * create a socket, bind(2) and listen(2)
> >    * sandbox yourself so that no new sockets can be created with socket=
(2)
> >    * go into the main loop and start accept(2)ing new connections
> >=20
> > Is this an approach that would work with this patch set?
>=20
> Yes, such scenario is possible. This rule should apply to all socket
> creation requests in the user space (socket(2), socketpair(2), io_uring
> request). Perhaps it's necessary to clarify here that only user space
> sockets are restricted?
>=20
> Btw, current implementation doesn't check that the socket creation
> request doesn't come from the kernel space. Will be fixed.

Two brief side discussions:

* What are the scenarios where that creation request comes from kernel spac=
e?
  If this is used under the hood for network-backed file systems like NFS, =
can
  this result in surprising interactions when the program tries to access t=
he
  file system?

* To be clear, I think it would be useful to support the scenario above, wh=
ere
  accept() continues to work. - It would make it easy to create sandboxed s=
erver
  processes and they could still accept connections, but do no other networ=
king.

But to bring it back to my original remark, and to unblock progress:

I think for this patch set (focused on userspace-requested socket creation)=
, it
would be enough to clarify in the documentation which operations are affect=
ed by
the LANDLOCK_ACCESS_SOCKET_CREATE right.


> > (It might make a neat sample tool as well, if something like this works=
 :))
> >=20
> >=20
> > Regarding the list of socket access rights with only one item in it:
> >=20
> > I am still unsure what other socket actions are in scope in the future;=
 it would
> > probably help to phrase the documentation in those terms.  (listen(2), =
bind(2),
> > connect(2), shutdown(2)?  On the other hand, bind(2) and connect(2) for=
 TCP are
> > already restrictable differently.))
>=20
> I think it would be useful to restrict sending and receiving socket
> FDs via unix domain sockets (see SCM_RIGHTS in unix(7)).

That seems like a reasonable idea.  Would you like to file an issue on the
Landlock bugtracker about it?

https://github.com/landlock-lsm/linux/issues


> > > +	/* Checks that all supported socket families and types can be store=
d in socket_key. */
> > > +	BUILD_BUG_ON(AF_MAX > (typeof(socket_key.data.family))~0);
> > > +	BUILD_BUG_ON(SOCK_MAX > (typeof(socket_key.data.type))~0);
> >=20
> > Off-by-one nit: AF_MAX and SOCK_MAX are one higher than the last permit=
ted value,
> > so technically it would be ok if they are one higher than (unsigned sho=
rt)~0.

(Did you see this remark?)


> > I see that this function traces back to Micka=C3=ABl's comment in
> > https://lore.kernel.org/all/20240412.phoh7laim7Th@digikod.net/
> >=20
> > In my understanding, the motivation was to keep the key size in check.
> > But that does not mean that we need to turn it into a uintptr_t?
> >=20
> > Would it not have been possible to extend the union landlock_key in rul=
eset.h
> > with a
> >=20
> >    struct {
> >      unsigned short family, type;
> >    }
> >=20
> > and then do the AF_MAX, SOCK_MAX build-time checks on that?
> > It seems like that might be more in line with what we already have?
>=20
> I don't think that complicating general entity with such a specific
> representation would be a good solution here. `landlock_key` shouldn't
> contain any semantic information about the key content.

Hm, OK.  I think that is debatable, but these are all things that are
implementation details and can be changed later if needed.  Sounds good to =
me if
we fix the undefined behaviour in the key calculation.


> > > +	/* Denies inserting a rule with unsupported socket family and type.=
 */
                                        ^^^^^^^^^^^^^^^^^^^^^^^^^

Is the wording "unsupported socket family" misleading here?

(a) It is technically a "protocol family" and a "socket type", according to
    socket(2). (BTW, the exact delineation between a "protocol family" and =
an
    "address family" is not clear to me.)

(b) "unsupported" in the context of protocol families may mean that the ker=
nel
    does not know how to speak that protocol, which is slightly different t=
han
    saying that it's outside of the [0, AF_MAX) range.  If we wanted to che=
ck
    for the protocol family being "supported", we should also probably retu=
rn
    -EAFNOSUPPORT, similar to what we already return when adding a "port" r=
ule
    with the wrong protocol [1]?

    [1] https://docs.kernel.org/userspace-api/landlock.html#extending-a-rul=
eset

I suspect that -EINVAL is slightly more correct here, because this is not a=
bout
the protocols that the kernel supports, but only about the range.  If we wa=
nted
to return errors about the protocol that the kernel supports, I realized th=
at
we'd probably also have to check whether the *combination* of family and ty=
pe
makes sense.  In my understanding, the equivalent errors for type and proto=
col,
ESOCKTNOSUPPORT and EPROTONOSUPPORT, only get returned based on whether the=
y
make sense together with the other values.


> > > +	if (family < 0 || family >=3D AF_MAX)
> > > +		return -EINVAL;
> > > +	if (type < 0 || type >=3D SOCK_MAX)
> > > +		return -EINVAL;
> >=20
> > enum sock_type (include/linux/net.h) has "holes": values 7, 8 and 9 are=
 not
> > defined in the header.  Should we check more specifically for the suppo=
rted
> > values here?  (Is there already a helper function for that?)
>=20
> I think that a more detailed check of the family-type values may have a
> good effect here, since the rules will contain real codes of families
> and types.
>=20
> I haven't found any helper to check the supported socket type value.
> Performing a check inside landlock can lead to several minor problems,
> which theoretically should not lead to any costs.
>=20
> * There are would be a dependency with constants of enum sock_types. But
>   we are unlikely to see new types of sockets in the next few years, so
>   it wouldn't be a problem to maintain such check.
>=20
> * enum sock_types can be redefined (see ARCH_HAS_SOCKET_TYPES in net.h),
>   but i haven't found anyone to actually change the constants of socket
>   types. It would be wrong to have a different landlock behavior for
>   arch that redefines sock_types for some purposes, so probably this
>   should also be maintained.
>=20
> WDYT?

Thinking about it again, from a Landlock safety perspective, I believe it i=
s
safe to keep the checks as they are and to check for the two values to be i=
n the
ranges [0, AF_MAX) and [0, SOCK_MAX).

Even if we permit the rule to be added for an invalid socket type, there do=
es
not seem to be any harm in that, as these sockets can't be created anyway.
Also, given the semantics of these errors in socket(2), where also the
*combinations* of the values are checked, it seems overly complicated to ch=
eck
all these combinations.  I think it would be fine to keep as is, I was most=
ly
wondering whether you had done any deeper analysis?

It might be worth spelling out in the struct documentation that the values =
which
fulfil 0 <=3D family < AF_MAX and 0 <=3D type < SOCK_MAX are considered val=
id.  Does
that sound reasonable?

P.S., it seems that the security/apparmor/Makefile is turning the "#define"=
s
into C code with lookup tables, but it seems that this is only used for
human-readable audit-logging, not for validating the policies.

=E2=80=94G=C3=BCnther
