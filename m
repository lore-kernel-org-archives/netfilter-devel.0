Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9D81A0BF1
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2024 15:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727971026; cv=none; b=JlLllbAtfA4lcAAG7Pb/TaKNoKqDW7Yp2dt2FscKLvmodVNrsSYxAy869Ma4e0WI7k9ijvVkR7Hnr7O6QD5obPYjUdOMYUtRnQHeXXF9+FK4vkLAEP2tv5LW5rrglNuAs4zcbVF5VAw31/AQ9rcqq2b5FQNsNilSBKT0166bYh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727971026; c=relaxed/simple;
	bh=xHOi5Lf0IvWVhgxVhbhqQtygb2UfCQmRF5lhjJek5Q8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nGsjF7YIctqf8GMagT5otdqhnNSJiCqmE9Exh8ZMawlzCSqOOAmAuoL9eNrJ+c0nD9Z00MmEUemY9tUSu7JCoML3HuEoXBeZ3XKyB2X/1sOZmj2c14Wmk+vnIv10mGI5gGkjLAnNeJmG0hhA6rGx836auUAe+EBlS7eLsGoi7pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ui0qKw+v; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ui0qKw+v"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e26ba37314so16489957b3.0
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Oct 2024 08:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727971024; x=1728575824; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ANA39TOpcuns6nM/RHzotVTQdOidOSB3bseMOWlwhzc=;
        b=Ui0qKw+vxo85S7rdCMKUE+InGdii4atxUCT98xeCkaof4/3yI4yUDhFESvIOfMWcbs
         sVMX57uzcLDxt56gQN6Zr2ie5z+CpTQ3gn2N2aZR0d6bEbE99JVdwRcyQ1ygWGOAiERs
         wGG4phMskg9M410H0Rlsu+/W1eB4RD4G38XT9dcIsDgyxqibh7xO1kSomkv0lM5l4q3L
         IBKinXXUxAlDjdHsgidIWqRbQrdK4oAhgh6noe12lkhC0MrXaC9iTI7zcUy9/551f5ZI
         RkmJqOPHzRV8zSa57zYFHizy67QPK+G3Y2D8WpXcsgXnG1+jxzbOuuEDCYqQxRjZVv5c
         dUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727971024; x=1728575824;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ANA39TOpcuns6nM/RHzotVTQdOidOSB3bseMOWlwhzc=;
        b=juws4shiWrsP4eKHlsKb5APCAQlv+iFrx2F4xI8ELKcO7GQZfJdfqidKMl/Od6zsY/
         IUQFe45CaFa21KEImumNDmjNuj5uTi/A6ubz7fIfdQEChcDT1OjfJvwjYP7OhJFfuj//
         Bp1QUOWjvRYRBegpT+FSLec2GH7nnyUDTNqV6wNzaTtBcpfz0tXrx84v2KekD0WE4WeT
         GZTn1FXXR9HkXo9hvlFqZ3b1/pp84MOjMCTD1x5+UwYgn4VP/t3d1Iz4HURcwr1idJ7H
         V/qom/3/yuFAoq5q1w/g7NJrKguhZQmFHoHq79q2R0M5EX9XIcgb6e20R56ty/GC2onq
         HFiw==
X-Forwarded-Encrypted: i=1; AJvYcCVJ81kCE4LH5ceimFld8Eqsib5cT9xd80LlUU7VXPj8BvhIBI9s1EUMPv/e5kbONA1pckZlthwRMrKAUUv4q9o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXa0kNRwWhYjhBnVeoB33hetIrgJDBWhjc+IoJkJ6SlsFD83D8
	dDSacEdJlWQz49nj46EjAoiUL++zcvcum7ceccDT/FV3z5l92bkQ9/WjhiCFncHh10jsOA/Gl27
	VCQ==
X-Google-Smtp-Source: AGHT+IFGkl91aUl0uDsZuz+ZToMsULRRDlObNTTDFlEhY0kiRHDM95xA/oHO8kXCbm9oley4+8oTqKiFEn8=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:690c:6c01:b0:6e2:371f:4aef with SMTP id
 00721157ae682-6e2a2e357dcmr1312327b3.3.1727971024248; Thu, 03 Oct 2024
 08:57:04 -0700 (PDT)
Date: Thu, 3 Oct 2024 17:57:01 +0200
In-Reply-To: <20241003143932.2431249-2-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com> <20241003143932.2431249-2-ivanov.mikhail1@huawei-partners.com>
Message-ID: <Zv6-zacowieEo2mq@google.com>
Subject: Re: [RFC PATCH v1 1/2] landlock: Fix non-TCP sockets restriction
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 03, 2024 at 10:39:31PM +0800, Mikhail Ivanov wrote:
> Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> should not restrict bind(2) and connect(2) for non-TCP protocols
> (SCTP, MPTCP, SMC).
>=20
> Closes: https://github.com/landlock-lsm/linux/issues/40
> Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and c=
onnect")
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  security/landlock/net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/security/landlock/net.c b/security/landlock/net.c
> index bc3d943a7118..6f59dd98bb13 100644
> --- a/security/landlock/net.c
> +++ b/security/landlock/net.c
> @@ -68,7 +68,7 @@ static int current_check_access_socket(struct socket *c=
onst sock,
>  		return -EACCES;
> =20
>  	/* Checks if it's a (potential) TCP socket. */
> -	if (sock->type !=3D SOCK_STREAM)
> +	if (sock->type !=3D SOCK_STREAM || sock->sk->sk_protocol !=3D IPPROTO_T=
CP)
>  		return 0;
> =20
>  	/* Checks for minimal header length to safely read sa_family. */
> --=20
> 2.34.1
>=20

Thank you! Good catch!

Reviewed-by: G=C3=BCnther Noack <gnoack@google.com>
