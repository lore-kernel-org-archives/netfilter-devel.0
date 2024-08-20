Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0D6190489
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 13:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724159702; cv=none; b=ONhxjakwnt0sPjOuhWE1fE+EMV7F/mC7L54u8Af3wrihdLB8W5GttZ+jBidOfuifXfzk4R38XmStmd8+RjLFffxiY9WxnKfOSCQV/JrOWgTTuy8RtppTwmLcqndP8Z/FFhAR1+OsTQW0u8FcEP/c9wR/1iifK0/QV3maImPJGsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724159702; c=relaxed/simple;
	bh=9jgQ+1vrwGf1EE1h+wcj9789CbaH9JLZB84Jt/0ZMck=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hZfDeCG5SUMwNRuTXT1pbsrV4XvJm1dVLvvOLmmmDAPdn6GelR6qlyxfW2j0TIVI8IeggSoLQhaEpOh1xMGuxvX5Pr2lAv4sRlLyAZIfgYTx1mwgui6z0Kbpfd4bt1vEws2LDyUrUeGZbl9UHNC/2Vdn4hnL4ovjmDZRKbrhaCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZZwWCvd5; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZZwWCvd5"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b198ecf931so42221767b3.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 06:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724159699; x=1724764499; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3nWhI8gXJ1u+ZnJcSccXgcrTufxaDKaQRElUmDS9lAM=;
        b=ZZwWCvd5s00cPXSLT9K/EPt4tioaDV6lxBTbjXzd4scU3GAz3XxpGYmmaRPB35N8ZX
         giTVhEfDhKzWteN+MtMha/w1egbbQEy1vMgutZv65oma9teRTDOHAneU69a4o1yrR3RJ
         zJu9rj1gZZ8ERBKs4SiLOYjlDxPVba08zjFfFzF/rkmtN/0BT5CPMJUFhiJgXuQtFggt
         Tc6tEen9gLl31COrK1JEziAoDBfYpRjy6Y9ivvZBGPVQ0L5vdiU+eS9x1qRtVbwubeBs
         v2y0MjwmX/LNU1Wg+wo+DgeoDBm0/AnEFqg3tN9A38vgVkLrMWMhQ7K/3w/xFYfRyIuQ
         2bpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724159699; x=1724764499;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3nWhI8gXJ1u+ZnJcSccXgcrTufxaDKaQRElUmDS9lAM=;
        b=Ufjeg8tuCwfgCa7lXxniRTborvP1neGtks8BwumBxH8SHOEvDnTpHm9fu3EhS2Zyco
         W+mGv0ITg0tN8VzMCcu9qeyK5grce7ZhfDp6qhdoN+B1PpTTei6XQ9J8uJQc5kx4k3Rq
         8V8318eAr10heXxVjzS/pv+Oom9yQcWaQlZTwb1+Lq/n9pLgwG3VyKdhLO9XTFx3Xf4S
         S/tlhDRoYivcudlqWvGVYpHCbaYORey7UPpoY5y13mBDz+ZNgxSCK7YN2K5mmDwf7Os1
         CtLcu97THi7q7JLddSXFSfkUBZAii/ARb05IUnKWhI3rsEPhqRdo9ZCt/6/XpLZoBSwW
         1OzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQTGnaEJ8eLgAUkBTfbN5Kipj4wI4YxMZ3WMsKnBhwKM6LwoPdoRWNVOlBGZb0HIn343OwOjID7j9gfNopRas=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRTT0qCCMvtW9B3zfmq9UAegiUXSXyiqyxjYWdmeNikN4X8QA4
	VczIcynWkNDjXr5h/1j744yXkL4Qf29219Y9WHRG0ib9e7RYYKlv8T/blS1NoyRtsHxCIu9XI/m
	5aQ==
X-Google-Smtp-Source: AGHT+IFU2bkscghXM7tq14DZR0cDi75W24LK1tvneM78yUmfLo5ULVcgzQGJSvc+0K3T49tz/6bHq4v6J+c=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a25:cecf:0:b0:e0b:f6aa:8088 with SMTP id
 3f1490d57ef6-e164a945c5dmr52526276.1.1724159699140; Tue, 20 Aug 2024 06:14:59
 -0700 (PDT)
Date: Tue, 20 Aug 2024 15:14:56 +0200
In-Reply-To: <ZsO-pIGsTl6T5AL1@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-4-ivanov.mikhail1@huawei-partners.com> <ZsO-pIGsTl6T5AL1@google.com>
Message-ID: <ZsSW0H4FR3ElOPAy@google.com>
Subject: Re: [RFC PATCH v2 3/9] selftests/landlock: Support LANDLOCK_ACCESS_NET_LISTEN_TCP
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2024 at 11:52:36PM +0200, G=C3=BCnther Noack wrote:
> On Wed, Aug 14, 2024 at 11:01:45AM +0800, Mikhail Ivanov wrote:
> > * Add listen_variant() to simplify listen(2) return code checking.
> > * Rename test_bind_and_connect() to test_restricted_net_fixture().
> > * Extend current net rules with LANDLOCK_ACCESS_NET_LISTEN_TCP access.
> > * Rename test port_specific.bind_connect_1023 to
> >   port_specific.port_1023.
> > * Check little endian port restriction for listen in
> >   ipv4_tcp.port_endianness.
> > * Some local renames and comment changes.
> >=20
> > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> > ---
> >  tools/testing/selftests/landlock/net_test.c | 198 +++++++++++---------
> >  1 file changed, 107 insertions(+), 91 deletions(-)
> >=20
> > diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testin=
g/selftests/landlock/net_test.c
> > index f21cfbbc3638..8126f5c0160f 100644
> > --- a/tools/testing/selftests/landlock/net_test.c
> > +++ b/tools/testing/selftests/landlock/net_test.c
> > @@ -2,7 +2,7 @@
> >  /*
> >   * Landlock tests - Network
> >   *
> > - * Copyright =C2=A9 2022-2023 Huawei Tech. Co., Ltd.
> > + * Copyright =C2=A9 2022-2024 Huawei Tech. Co., Ltd.
> >   * Copyright =C2=A9 2023 Microsoft Corporation
> >   */
> > =20
> > @@ -22,6 +22,17 @@
> > =20
> >  #include "common.h"
> > =20
> > +/* clang-format off */
> > +
> > +#define ACCESS_LAST LANDLOCK_ACCESS_NET_LISTEN_TCP
> > +
> > +#define ACCESS_ALL ( \
> > +	LANDLOCK_ACCESS_NET_BIND_TCP | \
> > +	LANDLOCK_ACCESS_NET_CONNECT_TCP | \
> > +	LANDLOCK_ACCESS_NET_LISTEN_TCP)
> > +
> > +/* clang-format on */
> > +
> >  const short sock_port_start =3D (1 << 10);
> > =20
> >  static const char loopback_ipv4[] =3D "127.0.0.1";
> > @@ -282,6 +293,16 @@ static int connect_variant(const int sock_fd,
> >  	return connect_variant_addrlen(sock_fd, srv, get_addrlen(srv, false))=
;
> >  }
> > =20
> > +static int listen_variant(const int sock_fd, const int backlog)
>=20
> I believe socket_variant(), connect_variant() and bind_variant() were cal=
led
> like that because they got an instance of a service_fixture as an argumen=
t.  The
> fixture instances are called variants.  But we don't use these fixtures h=
ere.
>=20
> In fs_test.c, we also have some functions that behave much like system ca=
lls,
> but clean up after themselves and return errno, for easier use in assert.=
  The
> naming scheme we have used there is "test_foo" (e.g. test_open()).  I thi=
nk this
> would be more appropriate here as a name?
>=20
> > +{
> > +	int ret;
> > +
> > +	ret =3D listen(sock_fd, backlog);
> > +	if (ret < 0)
> > +		return -errno;
> > +	return ret;

listen() can only return -1 or 0.  It might be simpler to just return 0 her=
e,
to make it more obvious that this returns an error code.

> > +}

Another remark about listen_variant(): The helper functions in net_test.c r=
eturn
negative error codes, whereas the ones in fs_test.c return positive error c=
odes.
We should probably make that more consistent.

> > +
> >  FIXTURE(protocol)
> >  {
> >  	struct service_fixture srv0, srv1, srv2, unspec_any0, unspec_srv0;
> > @@ -438,9 +459,11 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_uni=
x_datagram) {
> >  	},
> >  };
> > =20
> > -static void test_bind_and_connect(struct __test_metadata *const _metad=
ata,
> > -				  const struct service_fixture *const srv,
> > -				  const bool deny_bind, const bool deny_connect)
> > +static void test_restricted_net_fixture(struct __test_metadata *const =
_metadata,
> > +					const struct service_fixture *const srv,
> > +					const bool deny_bind,
> > +					const bool deny_connect,
> > +					const bool deny_listen)
> >  {
> >  	char buf =3D '\0';
> >  	int inval_fd, bind_fd, client_fd, status, ret;
> > @@ -512,8 +535,14 @@ static void test_bind_and_connect(struct __test_me=
tadata *const _metadata,
> >  		EXPECT_EQ(0, ret);
> > =20
> >  		/* Creates a listening socket. */
> > -		if (srv->protocol.type =3D=3D SOCK_STREAM)
> > -			EXPECT_EQ(0, listen(bind_fd, backlog));
> > +		if (srv->protocol.type =3D=3D SOCK_STREAM) {
> > +			ret =3D listen_variant(bind_fd, backlog);
> > +			if (deny_listen) {
> > +				EXPECT_EQ(-EACCES, ret);
> > +			} else {
> > +				EXPECT_EQ(0, ret);
> > +			}
>=20
> Hmm, passing the expected error code instead of a boolean to this functio=
n was not possible?
> Then you could just write
>=20
>   EXPECT_EQ(expected_listen_error, listen_variant(bind_fd, backlog));
>=20
> ?  (Apologies if this was discussed already.)
>=20
> > +		}
> >  	}
> > =20
> >  	child =3D fork();
> > @@ -530,7 +559,7 @@ static void test_bind_and_connect(struct __test_met=
adata *const _metadata,
> >  		ret =3D connect_variant(connect_fd, srv);
> >  		if (deny_connect) {
> >  			EXPECT_EQ(-EACCES, ret);
> > -		} else if (deny_bind) {
> > +		} else if (deny_bind || deny_listen) {
> >  			/* No listening server. */
> >  			EXPECT_EQ(-ECONNREFUSED, ret);
> >  		} else {
> > @@ -545,7 +574,7 @@ static void test_bind_and_connect(struct __test_met=
adata *const _metadata,
> > =20
> >  	/* Accepts connection from the child. */
> >  	client_fd =3D bind_fd;
> > -	if (!deny_bind && !deny_connect) {
> > +	if (!deny_bind && !deny_connect && !deny_listen) {
> >  		if (srv->protocol.type =3D=3D SOCK_STREAM) {
> >  			client_fd =3D accept(bind_fd, NULL, 0);
> >  			ASSERT_LE(0, client_fd);
> > @@ -571,16 +600,15 @@ TEST_F(protocol, bind)
> >  {
> >  	if (variant->sandbox =3D=3D TCP_SANDBOX) {
> >  		const struct landlock_ruleset_attr ruleset_attr =3D {
> > -			.handled_access_net =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> > -					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +			.handled_access_net =3D ACCESS_ALL,
> >  		};
> > -		const struct landlock_net_port_attr tcp_bind_connect_p0 =3D {
> > -			.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> > -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +		const struct landlock_net_port_attr tcp_not_restricted_p0 =3D {
> > +			.allowed_access =3D ACCESS_ALL,
> >  			.port =3D self->srv0.port,
> >  		};
> > -		const struct landlock_net_port_attr tcp_connect_p1 =3D {
> > -			.allowed_access =3D LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +		const struct landlock_net_port_attr tcp_denied_bind_p1 =3D {
> > +			.allowed_access =3D ACCESS_ALL &
> > +					  ~LANDLOCK_ACCESS_NET_BIND_TCP,
> >  			.port =3D self->srv1.port,
> >  		};
> >  		int ruleset_fd;
> > @@ -589,48 +617,47 @@ TEST_F(protocol, bind)
> >  						     sizeof(ruleset_attr), 0);
> >  		ASSERT_LE(0, ruleset_fd);
> > =20
> > -		/* Allows connect and bind for the first port.  */
> > +		/* Allows all actions for the first port. */
> >  		ASSERT_EQ(0,
> >  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > -					    &tcp_bind_connect_p0, 0));
> > +					    &tcp_not_restricted_p0, 0));
> > =20
> > -		/* Allows connect and denies bind for the second port. */
> > +		/* Allows all actions despite bind. */
> >  		ASSERT_EQ(0,
> >  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > -					    &tcp_connect_p1, 0));
> > +					    &tcp_denied_bind_p1, 0));
> > =20
> >  		enforce_ruleset(_metadata, ruleset_fd);
> >  		EXPECT_EQ(0, close(ruleset_fd));
> >  	}
> > +	bool restricted =3D is_restricted(&variant->prot, variant->sandbox);
> > =20
> >  	/* Binds a socket to the first port. */
> > -	test_bind_and_connect(_metadata, &self->srv0, false, false);
> > +	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
> > +				    false);
> > =20
> >  	/* Binds a socket to the second port. */
> > -	test_bind_and_connect(_metadata, &self->srv1,
> > -			      is_restricted(&variant->prot, variant->sandbox),
> > -			      false);
> > +	test_restricted_net_fixture(_metadata, &self->srv1, restricted, false=
,
> > +				    false);
> > =20
> >  	/* Binds a socket to the third port. */
> > -	test_bind_and_connect(_metadata, &self->srv2,
> > -			      is_restricted(&variant->prot, variant->sandbox),
> > -			      is_restricted(&variant->prot, variant->sandbox));
> > +	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
> > +				    restricted, restricted);
> >  }
> > =20
> >  TEST_F(protocol, connect)
> >  {
> >  	if (variant->sandbox =3D=3D TCP_SANDBOX) {
> >  		const struct landlock_ruleset_attr ruleset_attr =3D {
> > -			.handled_access_net =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> > -					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +			.handled_access_net =3D ACCESS_ALL,
> >  		};
> > -		const struct landlock_net_port_attr tcp_bind_connect_p0 =3D {
> > -			.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> > -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +		const struct landlock_net_port_attr tcp_not_restricted_p0 =3D {
> > +			.allowed_access =3D ACCESS_ALL,
> >  			.port =3D self->srv0.port,
> >  		};
> > -		const struct landlock_net_port_attr tcp_bind_p1 =3D {
> > -			.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP,
> > +		const struct landlock_net_port_attr tcp_denied_connect_p1 =3D {
> > +			.allowed_access =3D ACCESS_ALL &
> > +					  ~LANDLOCK_ACCESS_NET_CONNECT_TCP,
> >  			.port =3D self->srv1.port,
> >  		};
> >  		int ruleset_fd;
> > @@ -639,28 +666,27 @@ TEST_F(protocol, connect)
> >  						     sizeof(ruleset_attr), 0);
> >  		ASSERT_LE(0, ruleset_fd);
> > =20
> > -		/* Allows connect and bind for the first port. */
> > +		/* Allows all actions for the first port. */
> >  		ASSERT_EQ(0,
> >  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > -					    &tcp_bind_connect_p0, 0));
> > +					    &tcp_not_restricted_p0, 0));
> > =20
> > -		/* Allows bind and denies connect for the second port. */
> > +		/* Allows all actions despite connect. */
> >  		ASSERT_EQ(0,
> >  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > -					    &tcp_bind_p1, 0));
> > +					    &tcp_denied_connect_p1, 0));
> > =20
> >  		enforce_ruleset(_metadata, ruleset_fd);
> >  		EXPECT_EQ(0, close(ruleset_fd));
> >  	}
> > -
> > -	test_bind_and_connect(_metadata, &self->srv0, false, false);
> > -
> > -	test_bind_and_connect(_metadata, &self->srv1, false,
> > -			      is_restricted(&variant->prot, variant->sandbox));
> > -
> > -	test_bind_and_connect(_metadata, &self->srv2,
> > -			      is_restricted(&variant->prot, variant->sandbox),
> > -			      is_restricted(&variant->prot, variant->sandbox));
> > +	bool restricted =3D is_restricted(&variant->prot, variant->sandbox);
> > +
> > +	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
> > +				    false);
> > +	test_restricted_net_fixture(_metadata, &self->srv1, false, restricted=
,
> > +				    false);
> > +	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
> > +				    restricted, restricted);
> >  }
> > =20
> >  TEST_F(protocol, bind_unspec)
> > @@ -761,7 +787,7 @@ TEST_F(protocol, connect_unspec)
> >  	ASSERT_LE(0, bind_fd);
> >  	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
> >  	if (self->srv0.protocol.type =3D=3D SOCK_STREAM)
> > -		EXPECT_EQ(0, listen(bind_fd, backlog));
> > +		EXPECT_EQ(0, listen_variant(bind_fd, backlog));
> > =20
> >  	child =3D fork();
> >  	ASSERT_LE(0, child);
> > @@ -1127,8 +1153,8 @@ TEST_F(tcp_layers, ruleset_overlap)
> >  	 * Forbids to connect to the socket because only one ruleset layer
> >  	 * allows connect.
> >  	 */
> > -	test_bind_and_connect(_metadata, &self->srv0, false,
> > -			      variant->num_layers >=3D 2);
> > +	test_restricted_net_fixture(_metadata, &self->srv0, false,
> > +				    variant->num_layers >=3D 2, false);
> >  }
> > =20
> >  TEST_F(tcp_layers, ruleset_expand)
> > @@ -1208,11 +1234,12 @@ TEST_F(tcp_layers, ruleset_expand)
> >  		EXPECT_EQ(0, close(ruleset_fd));
> >  	}
> > =20
> > -	test_bind_and_connect(_metadata, &self->srv0, false,
> > -			      variant->num_layers >=3D 3);
> > +	test_restricted_net_fixture(_metadata, &self->srv0, false,
> > +				    variant->num_layers >=3D 3, false);
> > =20
> > -	test_bind_and_connect(_metadata, &self->srv1, variant->num_layers >=
=3D 1,
> > -			      variant->num_layers >=3D 2);
> > +	test_restricted_net_fixture(_metadata, &self->srv1,
> > +				    variant->num_layers >=3D 1,
> > +				    variant->num_layers >=3D 2, false);
> >  }
> > =20
> >  /* clang-format off */
> > @@ -1230,16 +1257,6 @@ FIXTURE_TEARDOWN(mini)
> >  {
> >  }
> > =20
> > -/* clang-format off */
> > -
> > -#define ACCESS_LAST LANDLOCK_ACCESS_NET_CONNECT_TCP
> > -
> > -#define ACCESS_ALL ( \
> > -	LANDLOCK_ACCESS_NET_BIND_TCP | \
> > -	LANDLOCK_ACCESS_NET_CONNECT_TCP)
> > -
> > -/* clang-format on */
> > -
> >  TEST_F(mini, network_access_rights)
> >  {
> >  	const struct landlock_ruleset_attr ruleset_attr =3D {
> > @@ -1454,8 +1471,9 @@ TEST_F(mini, tcp_port_overflow)
> > =20
> >  	enforce_ruleset(_metadata, ruleset_fd);
> > =20
> > -	test_bind_and_connect(_metadata, &srv_denied, true, true);
> > -	test_bind_and_connect(_metadata, &srv_max_allowed, false, false);
> > +	test_restricted_net_fixture(_metadata, &srv_denied, true, true, false=
);
> > +	test_restricted_net_fixture(_metadata, &srv_max_allowed, false, false=
,
> > +				    false);
> >  }
> > =20
> >  FIXTURE(ipv4_tcp)
> > @@ -1485,22 +1503,21 @@ FIXTURE_TEARDOWN(ipv4_tcp)
> >  TEST_F(ipv4_tcp, port_endianness)
> >  {
> >  	const struct landlock_ruleset_attr ruleset_attr =3D {
> > -		.handled_access_net =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> > -				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +		.handled_access_net =3D ACCESS_ALL,
> >  	};
> >  	const struct landlock_net_port_attr bind_host_endian_p0 =3D {
> >  		.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP,
> >  		/* Host port format. */
> >  		.port =3D self->srv0.port,
> >  	};
> > -	const struct landlock_net_port_attr connect_big_endian_p0 =3D {
> > -		.allowed_access =3D LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +	const struct landlock_net_port_attr connect_listen_big_endian_p0 =3D =
{
> > +		.allowed_access =3D LANDLOCK_ACCESS_NET_CONNECT_TCP |
> > +				  LANDLOCK_ACCESS_NET_LISTEN_TCP,
> >  		/* Big endian port format. */
> >  		.port =3D htons(self->srv0.port),
> >  	};
> > -	const struct landlock_net_port_attr bind_connect_host_endian_p1 =3D {
> > -		.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> > -				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +	const struct landlock_net_port_attr not_restricted_host_endian_p1 =3D=
 {
> > +		.allowed_access =3D ACCESS_ALL,
> >  		/* Host port format. */
> >  		.port =3D self->srv1.port,
> >  	};
> > @@ -1514,16 +1531,18 @@ TEST_F(ipv4_tcp, port_endianness)
> >  	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> >  				       &bind_host_endian_p0, 0));
> >  	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > -				       &connect_big_endian_p0, 0));
> > +				       &connect_listen_big_endian_p0, 0));
> >  	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > -				       &bind_connect_host_endian_p1, 0));
> > +				       &not_restricted_host_endian_p1, 0));
> >  	enforce_ruleset(_metadata, ruleset_fd);
> > =20
> >  	/* No restriction for big endinan CPU. */
> > -	test_bind_and_connect(_metadata, &self->srv0, false, little_endian);
> > +	test_restricted_net_fixture(_metadata, &self->srv0, false,
> > +				    little_endian, little_endian);
> > =20
> >  	/* No restriction for any CPU. */
> > -	test_bind_and_connect(_metadata, &self->srv1, false, false);
> > +	test_restricted_net_fixture(_metadata, &self->srv1, false, false,
> > +				    false);
> >  }
> > =20
> >  TEST_F(ipv4_tcp, with_fs)
> > @@ -1691,7 +1710,7 @@ TEST_F(port_specific, bind_connect_zero)
> >  	ret =3D bind_variant(bind_fd, &self->srv0);
> >  	EXPECT_EQ(0, ret);
> > =20
> > -	EXPECT_EQ(0, listen(bind_fd, backlog));
> > +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
> > =20
> >  	/* Connects on port 0. */
> >  	ret =3D connect_variant(connect_fd, &self->srv0);
> > @@ -1714,26 +1733,23 @@ TEST_F(port_specific, bind_connect_zero)
> >  	EXPECT_EQ(0, close(bind_fd));
> >  }
> > =20
> > -TEST_F(port_specific, bind_connect_1023)
> > +TEST_F(port_specific, port_1023)
> >  {
> >  	int bind_fd, connect_fd, ret;
> > =20
> > -	/* Adds a rule layer with bind and connect actions. */
> > +	/* Adds a rule layer with all actions. */
> >  	if (variant->sandbox =3D=3D TCP_SANDBOX) {
> >  		const struct landlock_ruleset_attr ruleset_attr =3D {
> > -			.handled_access_net =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> > -					      LANDLOCK_ACCESS_NET_CONNECT_TCP
> > +			.handled_access_net =3D ACCESS_ALL
> >  		};
> >  		/* A rule with port value less than 1024. */
> > -		const struct landlock_net_port_attr tcp_bind_connect_low_range =3D {
> > -			.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> > -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +		const struct landlock_net_port_attr tcp_low_range_port =3D {
> > +			.allowed_access =3D ACCESS_ALL,
> >  			.port =3D 1023,
> >  		};
> >  		/* A rule with 1024 port. */
> > -		const struct landlock_net_port_attr tcp_bind_connect =3D {
> > -			.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> > -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +		const struct landlock_net_port_attr tcp_port_1024 =3D {
> > +			.allowed_access =3D ACCESS_ALL,
> >  			.port =3D 1024,
> >  		};
> >  		int ruleset_fd;
> > @@ -1744,10 +1760,10 @@ TEST_F(port_specific, bind_connect_1023)
> > =20
> >  		ASSERT_EQ(0,
> >  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > -					    &tcp_bind_connect_low_range, 0));
> > +					    &tcp_low_range_port, 0));
> >  		ASSERT_EQ(0,
> >  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > -					    &tcp_bind_connect, 0));
> > +					    &tcp_port_1024, 0));
> > =20
> >  		enforce_ruleset(_metadata, ruleset_fd);
> >  		EXPECT_EQ(0, close(ruleset_fd));
> > @@ -1771,7 +1787,7 @@ TEST_F(port_specific, bind_connect_1023)
> >  	ret =3D bind_variant(bind_fd, &self->srv0);
> >  	clear_cap(_metadata, CAP_NET_BIND_SERVICE);
> >  	EXPECT_EQ(0, ret);
> > -	EXPECT_EQ(0, listen(bind_fd, backlog));
> > +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
> > =20
> >  	/* Connects on the binded port 1023. */
> >  	ret =3D connect_variant(connect_fd, &self->srv0);
> > @@ -1791,7 +1807,7 @@ TEST_F(port_specific, bind_connect_1023)
> >  	/* Binds on port 1024. */
> >  	ret =3D bind_variant(bind_fd, &self->srv0);
> >  	EXPECT_EQ(0, ret);
> > -	EXPECT_EQ(0, listen(bind_fd, backlog));
> > +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
> > =20
> >  	/* Connects on the binded port 1024. */
> >  	ret =3D connect_variant(connect_fd, &self->srv0);
> > --=20
> > 2.34.1
> >=20
>=20
> =E2=80=94G=C3=BCnther
