Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263391BB6B6
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 07:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727766592; cv=none; b=n9bvFgdceynJeBMLgSjzOuaZ6G0OISEZ3aS5L4FTtw0sLFbXWOurWaTIw0853PYSpCuvyteIUTWMasHG93jzIC56nhgYXzLuCvaf1QbQnzNNJ0vr1KnkZ3kUvmB8sokEUu3eGGF1fsvQA55vPYGEeBfWWKfX6IK4p5gQ1n5KVEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727766592; c=relaxed/simple;
	bh=EEfUkg12zVayrkF97+wBeybXQSiAExWRBd2BS7YcViM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oIcCc6/8hC0HaP15429SuoHNdCkcvX/dxm4aobDNC3JCid02gPW+UeTrqSKb4j3TElOYxEz3lbz8wVBTqdDp7JqgrRIL3qGEJeTTg4lfFsNRqXXkV7fFk2QsuUiLAZ94ls/bMZwHFWB/dX/PMi27DlNSCX+ummL29kSSgOWRve4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bk2QhsSH; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bk2QhsSH"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a8d2ecdf414so391144166b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Oct 2024 00:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727766588; x=1728371388; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G98NvXM62YT0B0WJqga1aEPWf2fMI/P8gKqX00JsaWE=;
        b=bk2QhsSH38N4UAxhEtUB72e65ixpvjBwARbkieNPWVAY6MIRTaE/RZxoQ9i+ZXtwkW
         6aMioBa3IuCSh1LxCsz+PArTk0iAcBS1Lb4e5r7D183qW+NkvyPhotyQoRwmTjnSc9am
         QfL5Vubi85A9ze2RM5c9Gec4D13OsOdY80qe8CoTNP1vh4u+XXuX4lIZyH+4Jc9sE9Oj
         bFZTN5U2TTfYdM+U4VN9iua2GEthNBOKqDs9VXNBoid3dqgQKZtN3dqVhqKhZS8K4Jme
         oK/zL141fxftRZTomiuF/jq/uUlY/8KHclR/C6LzV3qMtrnfj1uHwOVZRoEMss06R2Es
         gjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727766588; x=1728371388;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G98NvXM62YT0B0WJqga1aEPWf2fMI/P8gKqX00JsaWE=;
        b=OXpMP+DJapt5F6a0yeiP1BynxV0oirQD4lIK8XFREdqC8b6qLKT1rHE4DHhr0SqLcx
         SH+f2oORmraRS55XMyEtAWdTic3C5X7VMtEt5pblPS1N+cUCwBEpTbgDsSeWWAL2FWYH
         t7DSc5KOB31GVWu/ADbsYCCnE2/aZdtbuia2o/zhcuVYy66qYWROg144L5N1WZ5Mwr0M
         nwlykU46my4G6lJzxtZwdxka+UnZj3JW5eYiYD833g04oOHE4z9tPDZifZNwDBQVUpn/
         Xa+cCAi1OroLy9MXNisR1KWlBxPVSkjh0pwpbJLtY2wNgyx94xvm1jPz8JnHKKEaF01g
         8nYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeQNxJZ5OrJGUZA5uiwxwSQBSNWLkH/mbFJwuXEbpUtWhgnSMMyYu3rsAzaBZIJlTt/ySZCBPi2SmZERgZ1ho=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg9KSLqsMGINyM+c6SzOdLyTdSLX69dJph4SJ3ZhBl65ChZgC4
	xKKnZ/Rcbb3cJcWA0Lg0I+oew/GpVs6P9XSECigOQeEBjV0XtN7vQWtV6e4oQVpp46GUoK3Ltud
	m+Q==
X-Google-Smtp-Source: AGHT+IEFa2kdnyeozPEZpXPOZxvw+akB2zSXUlpMW74Sj1ivjTUlFPXTAwMlPI6ebFhigkPVCITJN5sj1kw=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a17:906:d214:b0:a8a:7d59:346d with SMTP id
 a640c23a62f3a-a93c4aab81dmr660266b.10.1727766588055; Tue, 01 Oct 2024
 00:09:48 -0700 (PDT)
Date: Tue, 1 Oct 2024 09:09:46 +0200
In-Reply-To: <20240904104824.1844082-20-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com> <20240904104824.1844082-20-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZvufroAFgLp_vZcF@google.com>
Subject: Re: [RFC PATCH v3 19/19] landlock: Document socket rule type support
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Wed, Sep 04, 2024 at 06:48:24PM +0800, Mikhail Ivanov wrote:
> Extend documentation with socket rule type description.
>
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  Documentation/userspace-api/landlock.rst | 46 ++++++++++++++++++++----
>  1 file changed, 40 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/use=
rspace-api/landlock.rst
> index 37dafce8038b..4bf45064faa1 100644
> --- a/Documentation/userspace-api/landlock.rst
> +++ b/Documentation/userspace-api/landlock.rst
> @@ -33,7 +33,7 @@ A Landlock rule describes an action on an object which =
the process intends to
>  perform.  A set of rules is aggregated in a ruleset, which can then rest=
rict
>  the thread enforcing it, and its future children.
> =20
> -The two existing types of rules are:
> +The three existing types of rules are:
> =20
>  Filesystem rules
>      For these rules, the object is a file hierarchy,
> @@ -44,14 +44,19 @@ Network rules (since ABI v4)
>      For these rules, the object is a TCP port,
>      and the related actions are defined with `network access rights`.
> =20
> +Socket rules (since ABI v6)
> +    For these rules, the object is a pair of an address family and a soc=
ket type,
> +    and the related actions are defined with `socket access rights`.
> +
>  Defining and enforcing a security policy
>  ----------------------------------------
> =20
>  We first need to define the ruleset that will contain our rules.
> =20
>  For this example, the ruleset will contain rules that only allow filesys=
tem
> -read actions and establish a specific TCP connection. Filesystem write
> -actions and other TCP actions will be denied.
> +read actions, create TCP sockets and establish a specific TCP connection=
.
> +Filesystem write actions, creating non-TCP sockets and other TCP
> +actions will be denied.
> =20
>  The ruleset then needs to handle both these kinds of actions.  This is
>  required for backward and forward compatibility (i.e. the kernel and use=
r
> @@ -81,6 +86,8 @@ to be explicit about the denied-by-default access right=
s.
>          .handled_access_net =3D
>              LANDLOCK_ACCESS_NET_BIND_TCP |
>              LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +        .handled_access_socket =3D
> +            LANDLOCK_ACCESS_SOCKET_CREATE,
>      };
> =20
>  Because we may not know on which kernel version an application will be
> @@ -119,6 +126,11 @@ version, and only use the available subset of access=
 rights:
>      case 4:
>          /* Removes LANDLOCK_ACCESS_FS_IOCTL_DEV for ABI < 5 */
>          ruleset_attr.handled_access_fs &=3D ~LANDLOCK_ACCESS_FS_IOCTL_DE=
V;
> +        __attribute__((fallthrough));
> +	case 5:
> +		/* Removes socket support for ABI < 6 */
> +		ruleset_attr.handled_access_socket &=3D
> +			~LANDLOCK_ACCESS_SOCKET_CREATE;

When I patched this in, the indentation of this "case" was off, compared to=
 the
rest of the code example.  (The code example uses spaces for indentation, n=
ot
tabs.)

>      }
> =20
>  This enables to create an inclusive ruleset that will contain our rules.
> @@ -170,6 +182,20 @@ for the ruleset creation, by filtering access rights=
 according to the Landlock
>  ABI version.  In this example, this is not required because all of the r=
equested
>  ``allowed_access`` rights are already available in ABI 1.
> =20
> +For socket access-control, we can add a rule to allow TCP sockets creati=
on. UNIX,
> +UDP IP and other protocols will be denied by the ruleset.
> +
> +.. code-block:: c
> +
> +    struct landlock_net_port_attr tcp_socket =3D {
> +        .allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +        .family =3D AF_INET,
> +        .type =3D SOCK_STREAM,
> +    };
> +
> +    err =3D landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +                            &tcp_socket, 0);
> +

IMHO, the length of the "Defining and enforcing a security policy" section =
is
slowly getting out of hand.  This was easier to follow when it was only fil=
e
system rules. -- I wonder whether we should split this up in subsections fo=
r the
individual steps to give this a more logical outline, e.g.

* Creating a ruleset
* Adding rules to the ruleset
  * Adding a file system rule
  * Adding a network rule
  * Adding a socket rule
* Enforcing the ruleset

>  For network access-control, we can add a set of rules that allow to use =
a port
>  number for a specific action: HTTPS connections.
> =20
> @@ -186,7 +212,8 @@ number for a specific action: HTTPS connections.
>  The next step is to restrict the current thread from gaining more privil=
eges
>  (e.g. through a SUID binary).  We now have a ruleset with the first rule
>  allowing read access to ``/usr`` while denying all other handled accesse=
s for
> -the filesystem, and a second rule allowing HTTPS connections.
> +the filesystem, a second rule allowing TCP sockets and a third rule allo=
wing
> +HTTPS connections.
> =20
>  .. code-block:: c
> =20
> @@ -404,7 +431,7 @@ Access rights
>  -------------
> =20
>  .. kernel-doc:: include/uapi/linux/landlock.h
> -    :identifiers: fs_access net_access
> +    :identifiers: fs_access net_access socket_access
> =20
>  Creating a new ruleset
>  ----------------------
> @@ -423,7 +450,7 @@ Extending a ruleset
> =20
>  .. kernel-doc:: include/uapi/linux/landlock.h
>      :identifiers: landlock_rule_type landlock_path_beneath_attr
> -                  landlock_net_port_attr
> +                  landlock_net_port_attr landlock_socket_attr
> =20
>  Enforcing a ruleset
>  -------------------
> @@ -541,6 +568,13 @@ earlier ABI.
>  Starting with the Landlock ABI version 5, it is possible to restrict the=
 use of
>  :manpage:`ioctl(2)` using the new ``LANDLOCK_ACCESS_FS_IOCTL_DEV`` right=
.
> =20
> +Socket support (ABI < 6)
> +-------------------------
> +
> +Starting with the Landlock ABI version 6, it is now possible to restrict
> +creation of user space sockets to only a set of allowed protocols thanks
> +to the new ``LANDLOCK_ACCESS_SOCKET_CREATE`` access right.
> +
>  .. _kernel_support:
> =20
>  Kernel support
> --=20
> 2.34.1
>=20

There is a section further below called "Network support" that talks about =
the
need for CONFIG_INET in order to add a network rule.  Do similar restrictio=
ns
apply to the socket rules as well?  Maybe this should be added to the secti=
on.

Please don't forget -- Tahera Fahimi's "scoped" patches have landed in
linux-next by now, so we will need to rebase and bump the ABI version one h=
igher
than before.

Thanks,
=E2=80=94G=C3=BCnther
