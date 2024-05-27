Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9384413A88B
	for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 09:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716803840; cv=none; b=iovtXlnhiOrHhRhJ054ENdtuG88ml0QA9n2YKivAlrHZwFc4gOoav45chQI+/o9OM7Ufqbh/Uv7Nhfu+ZEAzLLd+UxA2MYRB7MrOYh4e9+8AL7bwKtj3iiAUw0bi3gDhfmAiTPUg2LMVM+MhXdzfwjnDqdntqooKHHZY0BiqG+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716803840; c=relaxed/simple;
	bh=00zRpSuy9UZ+ctcCBhAUuXq1VcUQsMjLm84cR3tFet0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G3+7btlHx8Uxv7Y9RynF0QsVcclO9EkNl1JCsaxl21JpJRYewZI6VbMiucSKy6XHH/lS4/gtYOdrioTtM1KKSzSBJ3fZUH7lVzTG/sIxlpgX6WPXprkkZdSDBluo4mAgyN9OEzfJrf83qymV7nYaKljxmz9IYl5roUWPh3/tVbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oM3W1RlQ; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oM3W1RlQ"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5785f7b847cso2745691a12.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 02:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716803836; x=1717408636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1iPp5s+gOYctCSOUYM+xXHEFXW2dDQ2MPehs7Cpj1ro=;
        b=oM3W1RlQjOkNpRBfZ8rdTx1ugI/0fGLbKj9KHmOpJEtoMIP3M72oIbWnHhrVZRK4Il
         /99RrXEKkbhsGaBwf8tTlCepf3pheRKA7qAUH+DusWh+a0sA1Xum8fu60JYGQgQuTPV0
         Jd+6On9OUz7XJAIq1h+3ZVV0XGoN80iFvhgvuZ5fQ58HaT8q+T4nxsZeQuup0Z+cY6dU
         HGfhFUQbPoecr0s9Fu87a3OKpKl/zOsXMCc5iEFPs29d0MSpojsMuf0gQ2QU8gz4aY4H
         xYwIDRRhaYMHNNHOy5N8ICu3ScTFDL/mOw1yWaVLw3zaAZqAeKR6m1zKC93WOVt/9nrX
         dsjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716803836; x=1717408636;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1iPp5s+gOYctCSOUYM+xXHEFXW2dDQ2MPehs7Cpj1ro=;
        b=Y+p1FmCFVAQ4tjhtr9xxVRuo8NV683UTU9meDzQ9DQ0J1hwtkyErfWYiYswK2A67fF
         aafe1ySvp4q4kr3HmCGc9wZf0m/YQpO+ojJU1yacpXhpRtKTLbPLAoHTVZmrXDRFSC+/
         SW4rLBVizeacXgGP3JU1PewtA/lpiROQ7hPm/PMOQtlx62tMev6r4780HuTk+UkhOla/
         768Vj490P5DysPiG4lhQOcn9VRUVHHRN1iBJgkNhF3ojocLGNA7wqdasRGlMUGDpIxyp
         Ie+C0s0CVJZ94HrtjXUKJc2W/wT5+BJ1G5ORVm2x6g5nQHGOhbhh8kDSH0+S3e/xjOrV
         vmnw==
X-Forwarded-Encrypted: i=1; AJvYcCW/g6uhiOY34mFoC7VvwvdFd2x/QfrmE1dCPQej2GePqTKi9onb7Ep8TKRaittI4hyHT/et4snsp/EnVzkcgUTgbDsBosxv5wZtGgqhVMMJ
X-Gm-Message-State: AOJu0Yxc+3UoPTE7MVbxnDraqO9BwtnMdZYdqyM75Jq5cw1dyYia1D4h
	i2mqvZH3LaPZAs+dI1QpLN6lRDYPNjKQyUtIMHf6Z6NMgnT7hkTHqnEVluL4B8L4ofOMsB0yj97
	X7w==
X-Google-Smtp-Source: AGHT+IFVilsDABnTEJ4afyMTagmNIIeeiJVaf01iwO9SCd1rYw/daptUmoyFWzREjQEriBJFIVBpu/CXLqA=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a50:ed19:0:b0:578:593c:b06e with SMTP id
 4fb4d7f45d1cf-578593cb1b5mr11562a12.4.1716803835677; Mon, 27 May 2024
 02:57:15 -0700 (PDT)
Date: Mon, 27 May 2024 11:57:13 +0200
In-Reply-To: <20240524093015.2402952-2-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com> <20240524093015.2402952-2-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZlRY-W_30Kxd4RJd@google.com>
Subject: Re: [RFC PATCH v2 01/12] landlock: Support socket access-control
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 24, 2024 at 05:30:04PM +0800, Mikhail Ivanov wrote:
> * Add new landlock rule type that corresponds to the restriction of
>   socket protocols. This is represented as an landlock_socket_attr
>   structure. Protocol allowed by landlock must be described by
>   a family-type pair (see socket(2)).
>=20
> * Support socket rule storage in landlock ruleset.
>=20
> * Add flag LANDLOCK_ACCESS_SOCKET_CREATE that will provide the
>   ability to control socket creation.
>=20
> * Add socket.c file that will contain socket rules management and hooks.
>   Implement helper pack_socket_key() to convert 32-bit family and type
>   values into uintptr_t. This is possible due to the fact that these
>   values are limited to AF_MAX (=3D46), SOCK_MAX (=3D11) constants. Assum=
ption
>   is checked in build-time by the helper.
>=20
> * Support socket rules in landlock syscalls. Change ABI version to 6.
>=20
> Closes: https://github.com/landlock-lsm/linux/issues/6
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>=20
> Changes since v1:
> * Reverts landlock_key.data type from u64 to uinptr_t.
> * Adds helper to pack domain and type values into uintptr_t.
> * Denies inserting socket rule with invalid family and type.
> * Renames 'domain' to 'family' in landlock_socket_attr.
> * Updates ABI version to 6 since ioctl patches changed it to 5.
> * Formats code with clang-format.
> * Minor fixes.
> ---
>  include/uapi/linux/landlock.h                | 53 +++++++++++++++-
>  security/landlock/Makefile                   |  2 +-
>  security/landlock/limits.h                   |  5 ++
>  security/landlock/ruleset.c                  | 37 ++++++++++-
>  security/landlock/ruleset.h                  | 41 +++++++++++-
>  security/landlock/socket.c                   | 60 ++++++++++++++++++
>  security/landlock/socket.h                   | 17 +++++
>  security/landlock/syscalls.c                 | 66 ++++++++++++++++++--
>  tools/testing/selftests/landlock/base_test.c |  2 +-
>  9 files changed, 272 insertions(+), 11 deletions(-)
>  create mode 100644 security/landlock/socket.c
>  create mode 100644 security/landlock/socket.h
>=20
> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.=
h
> index 68625e728f43..a25ba5983dfb 100644
> --- a/include/uapi/linux/landlock.h
> +++ b/include/uapi/linux/landlock.h
> @@ -37,6 +37,13 @@ struct landlock_ruleset_attr {
>  	 * rule explicitly allow them.
>  	 */
>  	__u64 handled_access_net;
> +
> +	/**
> +	 * @handled_access_socket: Bitmask of actions (cf. `Socket flags`_)
> +	 * that is handled by this ruleset and should then be forbidden if no
> +	 * rule explicitly allow them.
> +	 */
> +	__u64 handled_access_socket;
>  };
> =20
>  /*
> @@ -65,6 +72,11 @@ enum landlock_rule_type {
>  	 * landlock_net_port_attr .
>  	 */
>  	LANDLOCK_RULE_NET_PORT,
> +	/**
> +	 * @LANDLOCK_RULE_SOCKET: Type of a &struct
> +	 * landlock_socket_attr .
> +	 */
> +	LANDLOCK_RULE_SOCKET,
>  };
> =20
>  /**
> @@ -115,6 +127,28 @@ struct landlock_net_port_attr {
>  	__u64 port;
>  };
> =20
> +/**
> + * struct landlock_socket_attr - Socket definition
> + *
> + * Argument of sys_landlock_add_rule().
> + */
> +struct landlock_socket_attr {
> +	/**
> +	 * @allowed_access: Bitmask of allowed access for a socket
> +	 * (cf. `Socket flags`_).
> +	 */
> +	__u64 allowed_access;
> +	/**
> +	 * @family: Protocol family used for communication
> +	 * (same as domain in socket(2)).
> +	 */
> +	int family;
> +	/**
> +	 * @type: Socket type (see socket(2)).
> +	 */
> +	int type;
> +};

Regarding the naming of struct landlock_socket_attr and the associated
LANDLOCK_RULE_SOCKET enum:

For the two existing rule types LANDLOCK_RULE_PATH_BENEATH (struct
landlock_path_beneath_attr) and LANDLOCK_RULE_NET_PORT (struct
landlock_net_port_attr), the names of the rule types are describing the
*properties* by which we are filtering (path *beneath*, *network port*), ra=
ther
than just the kind of object that we are filtering on.

Should the new enum and struct maybe be called differently as well to match=
 that
convention?  Maybe LANDLOCK_RULE_SOCKET_FAMILY_TYPE and struct
landlock_socket_family_type_attr?

Are there *other* properties apart from family and type, by which you are
thinking of restricting the use of sockets in the future?


> @@ -266,4 +300,21 @@ struct landlock_net_port_attr {
>  #define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
>  #define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
>  /* clang-format on */
> +
> +/**
> + * DOC: socket_access
> + *
> + * Socket flags
> + * ~~~~~~~~~~~~
> + *
> + * These flags enable to restrict a sanboxed process to a set of socket
> + * protocols. This is supported since the Landlock ABI version 6.

(Some phrasing remarks)

  * typo in "sanboxed"
  * Optional grammar nit: you can drop the "the" in front of "Landlock ABI
    version 6" (or alternatively use the phrasing as it was used in the FS
    restriction docs)
  * Grammar nit: The use of "enable to" sounds weird in my ears (but I am n=
ot a
    native speaker either).  I think it could just be dropped here ("These =
flags
    restrict a sandboxed process..." or "These flags control the use of..."=
).
    I realize that the wording was used in other places already, so it's ju=
st an
    optional remark.

(More about the content)

The Landlock documentation states the general approach up front:

  A Landlock rule describes an *action* on an *object* which the process in=
tends
  to perform.

(In your case, the object is a socket, and the action is the socket's creat=
ion.
The Landlock rules describe predicates on objects to restrict the set of ac=
tions
through the access_mask_t.)

The implementation is perfectly in line with that, but it would help to phr=
ase
the documentation also in terms of that framework.  That means, what we are
restricting are *actions*, not protocols.

To make a more constructive suggestion:

  "These flags restrict actions on sockets for a sandboxed process (e.g. so=
cket
  creation)."

Does it also need the following addition?

  "Sockets opened before sandboxing are not subject to these restrictions."


> + *
> + * The following access rights apply only to sockets:
                    ^^^^^^^^^^^^^^^^^^^
Probably better to use singular for now: "access right applies".

> + *
> + * - %LANDLOCK_ACCESS_SOCKET_CREATE: Create a socket.

Can we be more specific here what operations are affected by this?  It is r=
ather
obvious that this affects socket(2), but does this also affect accept(2) an=
d
connect(2)?

A scenario that I could imagine being useful is to sandbox a TCP server lik=
e
this:

  * create a socket, bind(2) and listen(2)
  * sandbox yourself so that no new sockets can be created with socket(2)
  * go into the main loop and start accept(2)ing new connections

Is this an approach that would work with this patch set?

(It might make a neat sample tool as well, if something like this works :))


Regarding the list of socket access rights with only one item in it:

I am still unsure what other socket actions are in scope in the future; it =
would
probably help to phrase the documentation in those terms.  (listen(2), bind=
(2),
connect(2), shutdown(2)?  On the other hand, bind(2) and connect(2) for TCP=
 are
already restrictable differently.))

> + */
> +/* clang-format off */
> +#define LANDLOCK_ACCESS_SOCKET_CREATE			(1ULL << 0)
> +/* clang-format on */
>  #endif /* _UAPI_LINUX_LANDLOCK_H */
> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
> index b4538b7cf7d2..ff1dd98f6a1b 100644
> --- a/security/landlock/Makefile
> +++ b/security/landlock/Makefile
> @@ -1,6 +1,6 @@
>  obj-$(CONFIG_SECURITY_LANDLOCK) :=3D landlock.o
> =20
>  landlock-y :=3D setup.o syscalls.o object.o ruleset.o \
> -	cred.o task.o fs.o
> +	cred.o task.o fs.o socket.o
> =20
>  landlock-$(CONFIG_INET) +=3D net.o
> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
> index 20fdb5ff3514..448b4d596783 100644
> --- a/security/landlock/limits.h
> +++ b/security/landlock/limits.h
> @@ -28,6 +28,11 @@
>  #define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_=
NET)
>  #define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS
> =20
> +#define LANDLOCK_LAST_ACCESS_SOCKET	    LANDLOCK_ACCESS_SOCKET_CREATE
> +#define LANDLOCK_MASK_ACCESS_SOCKET	    ((LANDLOCK_LAST_ACCESS_SOCKET <<=
 1) - 1)
> +#define LANDLOCK_NUM_ACCESS_SOCKET		__const_hweight64(LANDLOCK_MASK_ACCE=
SS_SOCKET)
> +#define LANDLOCK_SHIFT_ACCESS_SOCKET	LANDLOCK_NUM_ACCESS_SOCKET
> +
>  /* clang-format on */
> =20
>  #endif /* _SECURITY_LANDLOCK_LIMITS_H */
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index e0a5fbf9201a..c782f7cd313d 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -40,6 +40,7 @@ static struct landlock_ruleset *create_ruleset(const u3=
2 num_layers)
>  #if IS_ENABLED(CONFIG_INET)
>  	new_ruleset->root_net_port =3D RB_ROOT;
>  #endif /* IS_ENABLED(CONFIG_INET) */
> +	new_ruleset->root_socket =3D RB_ROOT;
> =20
>  	new_ruleset->num_layers =3D num_layers;
>  	/*
> @@ -52,12 +53,13 @@ static struct landlock_ruleset *create_ruleset(const =
u32 num_layers)
> =20
>  struct landlock_ruleset *
>  landlock_create_ruleset(const access_mask_t fs_access_mask,
> -			const access_mask_t net_access_mask)
> +			const access_mask_t net_access_mask,
> +			const access_mask_t socket_access_mask)
>  {
>  	struct landlock_ruleset *new_ruleset;
> =20
>  	/* Informs about useless ruleset. */
> -	if (!fs_access_mask && !net_access_mask)
> +	if (!fs_access_mask && !net_access_mask && !socket_access_mask)
>  		return ERR_PTR(-ENOMSG);
>  	new_ruleset =3D create_ruleset(1);
>  	if (IS_ERR(new_ruleset))
> @@ -66,6 +68,9 @@ landlock_create_ruleset(const access_mask_t fs_access_m=
ask,
>  		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
>  	if (net_access_mask)
>  		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
> +	if (socket_access_mask)
> +		landlock_add_socket_access_mask(new_ruleset, socket_access_mask,
> +						0);
>  	return new_ruleset;
>  }
> =20
> @@ -89,6 +94,9 @@ static bool is_object_pointer(const enum landlock_key_t=
ype key_type)
>  		return false;
>  #endif /* IS_ENABLED(CONFIG_INET) */
> =20
> +	case LANDLOCK_KEY_SOCKET:
> +		return false;
> +
>  	default:
>  		WARN_ON_ONCE(1);
>  		return false;
> @@ -146,6 +154,9 @@ static struct rb_root *get_root(struct landlock_rules=
et *const ruleset,
>  		return &ruleset->root_net_port;
>  #endif /* IS_ENABLED(CONFIG_INET) */
> =20
> +	case LANDLOCK_KEY_SOCKET:
> +		return &ruleset->root_socket;
> +
>  	default:
>  		WARN_ON_ONCE(1);
>  		return ERR_PTR(-EINVAL);
> @@ -175,7 +186,9 @@ static void build_check_ruleset(void)
>  	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
>  	BUILD_BUG_ON(access_masks <
>  		     ((LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS) |
> -		      (LANDLOCK_MASK_ACCESS_NET << LANDLOCK_SHIFT_ACCESS_NET)));
> +		      (LANDLOCK_MASK_ACCESS_NET << LANDLOCK_SHIFT_ACCESS_NET) |
> +		      (LANDLOCK_MASK_ACCESS_SOCKET
> +		       << LANDLOCK_SHIFT_ACCESS_SOCKET)));
>  }
> =20
>  /**
> @@ -399,6 +412,11 @@ static int merge_ruleset(struct landlock_ruleset *co=
nst dst,
>  		goto out_unlock;
>  #endif /* IS_ENABLED(CONFIG_INET) */
> =20
> +	/* Merges the @src socket tree. */
> +	err =3D merge_tree(dst, src, LANDLOCK_KEY_SOCKET);
> +	if (err)
> +		goto out_unlock;
> +
>  out_unlock:
>  	mutex_unlock(&src->lock);
>  	mutex_unlock(&dst->lock);
> @@ -462,6 +480,11 @@ static int inherit_ruleset(struct landlock_ruleset *=
const parent,
>  		goto out_unlock;
>  #endif /* IS_ENABLED(CONFIG_INET) */
> =20
> +	/* Copies the @parent socket tree. */
> +	err =3D inherit_tree(parent, child, LANDLOCK_KEY_SOCKET);
> +	if (err)
> +		goto out_unlock;
> +
>  	if (WARN_ON_ONCE(child->num_layers <=3D parent->num_layers)) {
>  		err =3D -EINVAL;
>  		goto out_unlock;
> @@ -498,6 +521,10 @@ static void free_ruleset(struct landlock_ruleset *co=
nst ruleset)
>  		free_rule(freeme, LANDLOCK_KEY_NET_PORT);
>  #endif /* IS_ENABLED(CONFIG_INET) */
> =20
> +	rbtree_postorder_for_each_entry_safe(freeme, next,
> +					     &ruleset->root_socket, node)
> +		free_rule(freeme, LANDLOCK_KEY_SOCKET);
> +
>  	put_hierarchy(ruleset->hierarchy);
>  	kfree(ruleset);
>  }
> @@ -708,6 +735,10 @@ landlock_init_layer_masks(const struct landlock_rule=
set *const domain,
>  		break;
>  #endif /* IS_ENABLED(CONFIG_INET) */
> =20
> +	case LANDLOCK_KEY_SOCKET:
> +		get_access_mask =3D landlock_get_socket_access_mask;
> +		num_access =3D LANDLOCK_NUM_ACCESS_SOCKET;
> +		break;
>  	default:
>  		WARN_ON_ONCE(1);
>  		return 0;
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index c7f1526784fd..a9773efd529b 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -92,6 +92,12 @@ enum landlock_key_type {
>  	 * node keys.
>  	 */
>  	LANDLOCK_KEY_NET_PORT,
> +
> +	/**
> +	 * @LANDLOCK_KEY_SOCKET: Type of &landlock_ruleset.root_socket's
> +	 * node keys.
> +	 */
> +	LANDLOCK_KEY_SOCKET,
>  };
> =20
>  /**
> @@ -177,6 +183,15 @@ struct landlock_ruleset {
>  	struct rb_root root_net_port;
>  #endif /* IS_ENABLED(CONFIG_INET) */
> =20
> +	/**
> +	 * @root_socket: Root of a red-black tree containing &struct
> +	 * landlock_rule nodes with socket type, described by (family, type)
> +	 * pair (see socket(2)). Once a ruleset is tied to a
> +	 * process (i.e. as a domain), this tree is immutable until @usage
> +	 * reaches zero.
> +	 */
> +	struct rb_root root_socket;
> +
>  	/**
>  	 * @hierarchy: Enables hierarchy identification even when a parent
>  	 * domain vanishes.  This is needed for the ptrace protection.
> @@ -233,7 +248,8 @@ struct landlock_ruleset {
> =20
>  struct landlock_ruleset *
>  landlock_create_ruleset(const access_mask_t access_mask_fs,
> -			const access_mask_t access_mask_net);
> +			const access_mask_t access_mask_net,
> +			const access_mask_t access_mask_socket);
> =20
>  void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>  void landlock_put_ruleset_deferred(struct landlock_ruleset *const rulese=
t);
> @@ -282,6 +298,20 @@ landlock_add_net_access_mask(struct landlock_ruleset=
 *const ruleset,
>  		(net_mask << LANDLOCK_SHIFT_ACCESS_NET);
>  }
> =20
> +static inline void
> +landlock_add_socket_access_mask(struct landlock_ruleset *const ruleset,
> +				const access_mask_t socket_access_mask,
> +				const u16 layer_level)
> +{
> +	access_mask_t socket_mask =3D socket_access_mask &
> +				    LANDLOCK_MASK_ACCESS_SOCKET;
> +
> +	/* Should already be checked in sys_landlock_create_ruleset(). */
> +	WARN_ON_ONCE(socket_access_mask !=3D socket_mask);
> +	ruleset->access_masks[layer_level] |=3D
> +		(socket_mask << LANDLOCK_SHIFT_ACCESS_SOCKET);
> +}
> +
>  static inline access_mask_t
>  landlock_get_raw_fs_access_mask(const struct landlock_ruleset *const rul=
eset,
>  				const u16 layer_level)
> @@ -309,6 +339,15 @@ landlock_get_net_access_mask(const struct landlock_r=
uleset *const ruleset,
>  	       LANDLOCK_MASK_ACCESS_NET;
>  }
> =20
> +static inline access_mask_t
> +landlock_get_socket_access_mask(const struct landlock_ruleset *const rul=
eset,
> +				const u16 layer_level)
> +{
> +	return (ruleset->access_masks[layer_level] >>
> +		LANDLOCK_SHIFT_ACCESS_SOCKET) &
> +	       LANDLOCK_MASK_ACCESS_SOCKET;
> +}
> +
>  bool landlock_unmask_layers(const struct landlock_rule *const rule,
>  			    const access_mask_t access_request,
>  			    layer_mask_t (*const layer_masks)[],
> diff --git a/security/landlock/socket.c b/security/landlock/socket.c
> new file mode 100644
> index 000000000000..1249a4a36503
> --- /dev/null
> +++ b/security/landlock/socket.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Landlock LSM - Socket management and hooks
> + *
> + * Copyright =C2=A9 2024 Huawei Tech. Co., Ltd.
> + */
> +
> +#include <linux/net.h>
> +#include <linux/socket.h>
> +#include <linux/stddef.h>
> +
> +#include "limits.h"
> +#include "ruleset.h"
> +#include "socket.h"
> +
> +static uintptr_t pack_socket_key(const int family, const int type)
> +{
> +	union {
> +		struct {
> +			unsigned short family, type;
> +		} __packed data;
> +		uintptr_t packed;
> +	} socket_key;
> +
> +	/* Checks that all supported socket families and types can be stored in=
 socket_key. */
> +	BUILD_BUG_ON(AF_MAX > (typeof(socket_key.data.family))~0);
> +	BUILD_BUG_ON(SOCK_MAX > (typeof(socket_key.data.type))~0);

Off-by-one nit: AF_MAX and SOCK_MAX are one higher than the last permitted =
value,
so technically it would be ok if they are one higher than (unsigned short)~=
0.

> +
> +	/* Checks that socket_key can be stored in landlock_key. */
> +	BUILD_BUG_ON(sizeof(socket_key.data) > sizeof(socket_key.packed));
> +	BUILD_BUG_ON(sizeof(socket_key.packed) >
> +		     sizeof_field(union landlock_key, data));
> +
> +	socket_key.data.family =3D (unsigned short)family;
> +	socket_key.data.type =3D (unsigned short)type;
> +
> +	return socket_key.packed;

Can socket_key.packed end up containing uninitialized memory here?

> +}

I see that this function traces back to Micka=C3=ABl's comment in
https://lore.kernel.org/all/20240412.phoh7laim7Th@digikod.net/

In my understanding, the motivation was to keep the key size in check.
But that does not mean that we need to turn it into a uintptr_t?

Would it not have been possible to extend the union landlock_key in ruleset=
.h
with a

  struct {
    unsigned short family, type;
  }

and then do the AF_MAX, SOCK_MAX build-time checks on that?
It seems like that might be more in line with what we already have?

> +
> +int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
> +				const int family, const int type,
> +				access_mask_t access_rights)
> +{
> +	int err;
> +
> +	const struct landlock_id id =3D {
> +		.key.data =3D pack_socket_key(family, type),
> +		.type =3D LANDLOCK_KEY_SOCKET,
> +	};
> +
> +	/* Transforms relative access rights to absolute ones. */
> +	access_rights |=3D LANDLOCK_MASK_ACCESS_SOCKET &
> +			 ~landlock_get_socket_access_mask(ruleset, 0);
> +
> +	mutex_lock(&ruleset->lock);
> +	err =3D landlock_insert_rule(ruleset, id, access_rights);
> +	mutex_unlock(&ruleset->lock);
> +
> +	return err;
> +}
> diff --git a/security/landlock/socket.h b/security/landlock/socket.h
> new file mode 100644
> index 000000000000..8519357f1c39
> --- /dev/null
> +++ b/security/landlock/socket.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Landlock LSM - Socket management and hooks
> + *
> + * Copyright =C2=A9 2024 Huawei Tech. Co., Ltd.
> + */
> +
> +#ifndef _SECURITY_LANDLOCK_SOCKET_H
> +#define _SECURITY_LANDLOCK_SOCKET_H
> +
> +#include "ruleset.h"
> +
> +int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
> +				const int family, const int type,
> +				access_mask_t access_rights);
> +
> +#endif /* _SECURITY_LANDLOCK_SOCKET_H */
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index 03b470f5a85a..30c771f5e74f 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -24,12 +24,14 @@
>  #include <linux/syscalls.h>
>  #include <linux/types.h>
>  #include <linux/uaccess.h>
> +#include <linux/net.h>
>  #include <uapi/linux/landlock.h>
> =20
>  #include "cred.h"
>  #include "fs.h"
>  #include "limits.h"
>  #include "net.h"
> +#include "socket.h"
>  #include "ruleset.h"
>  #include "setup.h"
> =20
> @@ -88,7 +90,8 @@ static void build_check_abi(void)
>  	struct landlock_ruleset_attr ruleset_attr;
>  	struct landlock_path_beneath_attr path_beneath_attr;
>  	struct landlock_net_port_attr net_port_attr;
> -	size_t ruleset_size, path_beneath_size, net_port_size;
> +	struct landlock_socket_attr socket_attr;
> +	size_t ruleset_size, path_beneath_size, net_port_size, socket_size;
> =20
>  	/*
>  	 * For each user space ABI structures, first checks that there is no
> @@ -97,8 +100,9 @@ static void build_check_abi(void)
>  	 */
>  	ruleset_size =3D sizeof(ruleset_attr.handled_access_fs);
>  	ruleset_size +=3D sizeof(ruleset_attr.handled_access_net);
> +	ruleset_size +=3D sizeof(ruleset_attr.handled_access_socket);
>  	BUILD_BUG_ON(sizeof(ruleset_attr) !=3D ruleset_size);
> -	BUILD_BUG_ON(sizeof(ruleset_attr) !=3D 16);
> +	BUILD_BUG_ON(sizeof(ruleset_attr) !=3D 24);
> =20
>  	path_beneath_size =3D sizeof(path_beneath_attr.allowed_access);
>  	path_beneath_size +=3D sizeof(path_beneath_attr.parent_fd);
> @@ -109,6 +113,12 @@ static void build_check_abi(void)
>  	net_port_size +=3D sizeof(net_port_attr.port);
>  	BUILD_BUG_ON(sizeof(net_port_attr) !=3D net_port_size);
>  	BUILD_BUG_ON(sizeof(net_port_attr) !=3D 16);
> +
> +	socket_size =3D sizeof(socket_attr.allowed_access);
> +	socket_size +=3D sizeof(socket_attr.family);
> +	socket_size +=3D sizeof(socket_attr.type);
> +	BUILD_BUG_ON(sizeof(socket_attr) !=3D socket_size);
> +	BUILD_BUG_ON(sizeof(socket_attr) !=3D 16);
>  }
> =20
>  /* Ruleset handling */
> @@ -149,7 +159,7 @@ static const struct file_operations ruleset_fops =3D =
{
>  	.write =3D fop_dummy_write,
>  };
> =20
> -#define LANDLOCK_ABI_VERSION 5
> +#define LANDLOCK_ABI_VERSION 6
> =20
>  /**
>   * sys_landlock_create_ruleset - Create a new ruleset
> @@ -213,9 +223,15 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>  	    LANDLOCK_MASK_ACCESS_NET)
>  		return -EINVAL;
> =20
> +	/* Checks socket content (and 32-bits cast). */
> +	if ((ruleset_attr.handled_access_socket |
> +	     LANDLOCK_MASK_ACCESS_SOCKET) !=3D LANDLOCK_MASK_ACCESS_SOCKET)
> +		return -EINVAL;
> +
>  	/* Checks arguments and transforms to kernel struct. */
>  	ruleset =3D landlock_create_ruleset(ruleset_attr.handled_access_fs,
> -					  ruleset_attr.handled_access_net);
> +					  ruleset_attr.handled_access_net,
> +					  ruleset_attr.handled_access_socket);
>  	if (IS_ERR(ruleset))
>  		return PTR_ERR(ruleset);
> =20
> @@ -371,6 +387,45 @@ static int add_rule_net_port(struct landlock_ruleset=
 *ruleset,
>  					net_port_attr.allowed_access);
>  }
> =20
> +static int add_rule_socket(struct landlock_ruleset *ruleset,
> +			   const void __user *const rule_attr)
> +{
> +	struct landlock_socket_attr socket_attr;
> +	int family, type;
> +	int res;
> +	access_mask_t mask;
> +
> +	/* Copies raw user space buffer. */
> +	res =3D copy_from_user(&socket_attr, rule_attr, sizeof(socket_attr));
> +	if (res)
> +		return -EFAULT;
> +
> +	/*
> +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
> +	 * are ignored by socket actions.
> +	 */
> +	if (!socket_attr.allowed_access)
> +		return -ENOMSG;
> +
> +	/* Checks that allowed_access matches the @ruleset constraints. */
> +	mask =3D landlock_get_socket_access_mask(ruleset, 0);
> +	if ((socket_attr.allowed_access | mask) !=3D mask)
> +		return -EINVAL;
> +
> +	family =3D socket_attr.family;
> +	type =3D socket_attr.type;
> +
> +	/* Denies inserting a rule with unsupported socket family and type. */
> +	if (family < 0 || family >=3D AF_MAX)
> +		return -EINVAL;
> +	if (type < 0 || type >=3D SOCK_MAX)
> +		return -EINVAL;

enum sock_type (include/linux/net.h) has "holes": values 7, 8 and 9 are not
defined in the header.  Should we check more specifically for the supported
values here?  (Is there already a helper function for that?)


> +	/* Imports the new rule. */
> +	return landlock_append_socket_rule(ruleset, family, type,
> +					   socket_attr.allowed_access);
> +}
> +
>  /**
>   * sys_landlock_add_rule - Add a new rule to a ruleset
>   *
> @@ -429,6 +484,9 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset=
_fd,
>  	case LANDLOCK_RULE_NET_PORT:
>  		err =3D add_rule_net_port(ruleset, rule_attr);
>  		break;
> +	case LANDLOCK_RULE_SOCKET:
> +		err =3D add_rule_socket(ruleset, rule_attr);
> +		break;
>  	default:
>  		err =3D -EINVAL;
>  		break;
> diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing=
/selftests/landlock/base_test.c
> index 3c1e9f35b531..52b00472a487 100644
> --- a/tools/testing/selftests/landlock/base_test.c
> +++ b/tools/testing/selftests/landlock/base_test.c
> @@ -75,7 +75,7 @@ TEST(abi_version)
>  	const struct landlock_ruleset_attr ruleset_attr =3D {
>  		.handled_access_fs =3D LANDLOCK_ACCESS_FS_READ_FILE,
>  	};
> -	ASSERT_EQ(5, landlock_create_ruleset(NULL, 0,
> +	ASSERT_EQ(6, landlock_create_ruleset(NULL, 0,
>  					     LANDLOCK_CREATE_RULESET_VERSION));
> =20
>  	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0,
> --=20
> 2.34.1
>=20

=E2=80=94G=C3=BCnther
