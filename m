Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0119146019
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 19:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712605758; cv=none; b=GxLRp4elu7iuau8aD6sIjpPaIIjHZbxPU5LikoevwchuUOISRNUsTqbR/ZxeEk2mJjKgMq5otfKiZoN7H1HZpa07NeGfv+Ky6/wErIYr9hEFvWRl7BJmdMQlfViazLmboBfu5MRDKrJgU//Hf1eckPLGrovGL4H3erUAn9zHyXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712605758; c=relaxed/simple;
	bh=4VwVkJ15ie8oUnERlTxvN5nffzGsfOJzaRKC0uM48eI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dIle5a88STKvvh7ihjPfkXO43DCW8rFeVBWk1gFeKce3iIMK6eTqaPSq1YV+Nb/LWdRpDDvEm4ic8YG85s1cOdswfbdXlr2eiPP1zcjMWCjgoWa9+3S8FGSn45pjky27Ub1nKKgC0NDR+mfjB28Ht7e8qLcZm1d2UTzJRVyDj6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V6xkBBj6; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V6xkBBj6"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso7898959276.1
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Apr 2024 12:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712605755; x=1713210555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aq405guPa3OPZRO9v26OPDN3Zw9hWnozHgBpKl4FcoU=;
        b=V6xkBBj6NTxNWgeDgA/cAzKtxzFWOds4KdSwz+0WGaLwxs6aouijdGOMrlKyjTJ55K
         kRjDKlFmFfcTY7Gna2at7h5FrflV+abRYehoUfLk6iHSkDvWnrS3nXvS++t0/U4Z5pqk
         QZTgF8cXg/gLMQExZ4dK2fShjJpVhn28jdoIWtPDIIriF8sWaca0MO6u9EDvAPNPzw8J
         UZ/xuM14IEnxVlv7NE1qNpF2x1+ejU3WPtOscs+O58ECxKGQsglanWV8umqyTt60tzSq
         J06pleWISRw3GLI7fRDoW1ebAtF7ljwMsvZQRpbPuCEqvUS+Nud0ue70CU4aSajeFP/R
         8Jqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712605755; x=1713210555;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aq405guPa3OPZRO9v26OPDN3Zw9hWnozHgBpKl4FcoU=;
        b=shm7rPpEnz8um7dt7AgRRUOzvK+fvNHcmtcDscKhPQxv/QY6eI8wDrj/zJrTYC8ADz
         hFdwdm2ra9jIJQQ4ma3XlD5JT06wtiF2T4MvpyVOCGfFBXTUK20Tp6GCm69TIDY2CT9R
         S2njBMOQHwjc+SeXsB+m8MwpTQFP7B2GUA9LYy1KT932sGLWxuqa6gXowbycBrQ3cz1V
         tz7hH4+e4VSL7DnmVSkH9eq7i/Td/DL93M6jCGJhILooWMM/JjsMmhMRjMIlaXucNdmc
         1FV0IndtJEtPExVBV2xlqRHshZ27/xUjbD/OJfPEPzgcf+AtpJu8hEyQhfM/cm09OBod
         +1gw==
X-Forwarded-Encrypted: i=1; AJvYcCW+q/h5aepavW8+qByLUPkFr1xgkLrxMFTNl1l3k/9PUCvEHRrgdu2PC+p0pDHKk+mt6OYKiQWVmFHYugWGOBLVTLYiQXw+mNoRJhY5F28K
X-Gm-Message-State: AOJu0YwkMEkmN61gNNh9JEZ6TYoW9iRzJwPgF2KDyVmzkTZ/H9qH8Ayv
	eLvDlknBcO9JaCCd4LSJs33xIsH5YUHOpA1OsoSPDDx4n9EkrKwbZ+1yDx9vSDA8MIZszbLkme6
	feA==
X-Google-Smtp-Source: AGHT+IEOvC2+HFvfUx+HVQIDT3l0tZKQZWg0eCxC+0TeQ/H78hrhDDQEqkf6GmdV35Kdx2aknK+7XH+Xzcw=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6902:100a:b0:dda:ce5f:b4c3 with SMTP id
 w10-20020a056902100a00b00ddace5fb4c3mr3253808ybt.1.1712605755482; Mon, 08 Apr
 2024 12:49:15 -0700 (PDT)
Date: Mon, 8 Apr 2024 21:49:13 +0200
In-Reply-To: <20240408093927.1759381-2-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com> <20240408093927.1759381-2-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZhRKOTmoAOuwkujB@google.com>
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

Just zooming in on what I think are the most high level questions here,
so that we get the more dramatic changes out of the way early, if needed.

On Mon, Apr 08, 2024 at 05:39:18PM +0800, Ivanov Mikhail wrote:
> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.=
h
> index 25c8d7677..8551ade38 100644
> --- a/include/uapi/linux/landlock.h
> +++ b/include/uapi/linux/landlock.h
> @@ -37,6 +37,13 @@ struct landlock_ruleset_attr {
>  	 * rule explicitly allow them.
>  	 */
>  	__u64 handled_access_net;
> +
> +	/**
> +	 * @handled_access_net: Bitmask of actions (cf. `Socket flags`_)
                           ^^^
			   Typo

> +	 * that is handled by this ruleset and should then be forbidden if no
> +	 * rule explicitly allow them.
> +	 */
> +	__u64 handled_access_socket;

What is your rationale for introducing and naming this additional field?

I am not convinced that "socket" is the right name to use in this field,
but it is well possible that I'm missing some context.

* If we introduce this additional field in the landlock_ruleset_attr, which
  other socket-related operations will go in the remaining 63 bits?  (I'm h=
aving
  a hard time coming up with so many of them.)

* Should this have a more general name than "socket", so that other planned
  features from the bug tracker [1] fit in?

The other alternative is of course to piggy back on the existing
handled_access_net field, whose name already is pretty generic.

For that, I believe we would need to clarify in struct landlock_net_port_at=
tr
which exact values are permitted there.

I imagine you have considered this approach?  Are there more reasons why th=
is
was ruled out, which I am overlooking?

[1] https://github.com/orgs/landlock-lsm/projects/1/views/1


> @@ -244,4 +277,20 @@ struct landlock_net_port_attr {
>  #define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
>  #define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
>  /* clang-format on */
> +
> +/**
> + * DOC: socket_acess
> + *
> + * Socket flags
> + * ~~~~~~~~~~~~~~~~

Mega-Nit: This ~~~ underline should only be as long as the text above it ;-=
)
You might want to fix it for the "Network Flags" headline as well.

> + *
> + * These flags enable to restrict a sandboxed process to a set of
> + * socket-related actions for specific protocols. This is supported
> + * since the Landlock ABI version 5.
> + *
> + * - %LANDLOCK_ACCESS_SOCKET_CREATE: Create a socket
> + */


> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index c7f152678..f4213db09 100644
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
> +	 * landlock_rule nodes with socket type, described by (domain, type)
> +	 * pair (see socket(2)). Once a ruleset is tied to a
> +	 * process (i.e. as a domain), this tree is immutable until @usage
> +	 * reaches zero.
> +	 */
> +	struct rb_root root_socket;

The domain is a value between 0 and 45,
and the socket type is one of 1, 2, 3, 4, 5, 6, 10.

The bounds of these are defined with AF_MAX (include/linux/socket.h) and
SOCK_MAX (include/linux/net.h).

Why don't we just combine these two numbers into an index and create a big =
bit
vector here, like this:

    socket_type_mask_t socket_domains[AF_MAX];

socket_type_mask_t would need to be typedef'd to u16 and ideally have a sta=
tic
check to test that it has more bits than SOCK_MAX.

Then you can look up whether a socket creation is permitted by checking:

    /* assuming appropriate bounds checks */
    if (dom->socket_domains[domain] & (1 << type)) { /* permitted */ }

and merging the socket_domains of two domains would be a bitwise-AND.

(We can also cram socket_type_mask_t in a u8 but it would require mapping t=
he
existing socket types onto a different number space.)


As I said before, I am very excited to see this patch.

I think this will unlock a tremendous amount of use cases for many programs=
,
especially for programs that do not use networking at all, which can now lo=
ck
themselves down to guarantee that with a sandbox.

Thank you very much for looking into it!
=E2=80=94G=C3=BCnther
