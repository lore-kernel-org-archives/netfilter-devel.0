Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C27E185B46
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2024 09:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727430509; cv=none; b=thnKhID/mtPoBWtK5fUEeaFGQrrFBMN4m8TfTPAt/A8RnmU55bAXlrIOKaGjG2k++RozJ8x8MNDFrliG3GlMfoUDT3XblaNeQPr/8iKkWLOx/PnXvmRKEQWdEQdkcznVm34AqhQomJmgqrLCRzo+C1hibzYZggy/v3XZ4EI7CZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727430509; c=relaxed/simple;
	bh=Kj3N4NdfD+U4vW9zdDukR5wNBF39mqc/ADvtUSwhlMs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DvY3IrBntFsI+PZXNIRx+RxXKKOz5VqxwwVNEx2rfX5Ia5HL4sCmZeqHjsR+QAglJyKP2gM0Ggsj8Eb5DPI/X2dzscXPA6fydF7s0CrhoefgM5HYrNPlZF8JWrFpXVoYaJF532NQUFg10uP3PNJ9V6a4CuRJ5WcIlHVYQ2VGhIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2GQeQr7s; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2GQeQr7s"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d7124939beso34731957b3.2
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2024 02:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727430505; x=1728035305; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BiWFpC/CfeVPjn63DCS8iK5skeienOgQd5K0dKU7AfA=;
        b=2GQeQr7s/86UWi+8s31HEAAn8+twebYGg3QHn5Hc7Qb8sID+nN2bO+i+OzJXHhRtP0
         R6sTH7Z5rJI3FAoVEu++WOg9Pcm0FuSF6+JlYu3hwyHrH+fOLvQGYLWv5OWEUpiec6TB
         i/9I4auvNPph9ZtklHWdrP3A2f3Zzc/fVPLtFmqi+BGJ1y1FglzFZS1+KK0klm/8/MBc
         F0KzpmQeO7AAGga2jIsnfcySpEWtP+iOEhHa84kiEXKVFIKwIepyvszbaKSO6Rzgd+NP
         E5XCM9sp+U4+bzGShJlAbq/stxMBLCMpC9o7o08aZHJSbSH17P9Yoi7/AK++x6Sceqjo
         ob/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727430505; x=1728035305;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BiWFpC/CfeVPjn63DCS8iK5skeienOgQd5K0dKU7AfA=;
        b=Cl3en78R45GUS3OtxokoLGTHknGOIo3YyeDqcvP8K4oEQ0+LwFr5j/9nevV86b0/Tc
         esuW90FGGu36iru9euu0VjHyEHWhrqBLhBtkXNgyPDFfRmgZCctlJGxi1hYb8OFKXqrT
         dFWTLqu3ogs90xDC1gzdFj5CUGJ2r5U7EuGd3thzwR/a1hNEU3VLioLafAX2Hh+lQHEk
         RtPjhJR3twk9c7H2sCjmnaIT8oTxxTD8zHmC/DABa9h259jSEGoml6lOPYJp4AZCKJZK
         VToTu4G2f3AfBHOIEwylTuAONFnewhb/qYjXt4JfQ3B47eTaBB8pFD6yitjmlTvsHXti
         gTIA==
X-Forwarded-Encrypted: i=1; AJvYcCVNBwDkdbDd5Xc3kb0Y3QpbDfWKcb9ftHPtY3YMDfihAFxFt2Du4mhuY8zPXuwgoQOj1q/GW/UVKy0aYx46d5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkVXoQgTVrMK8AYqlROFbbLjDjicPrgYhgn0RwO+CvVNGkXUJD
	ku971kMYAsezDS4jj52VcVqU+pzpCOULl9VwzKjQDlwqI/d/4ycdXzocbny5adQMoAjE6ZCNu7R
	+Fw==
X-Google-Smtp-Source: AGHT+IGmbkot20nT1NsSVAeyRJSauWT1lwWnzBH3fMLGruuszCigxyqzTw9CjGTA/e92egjzT9R4tONJBRw=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:690c:d8c:b0:663:ddc1:eab8 with SMTP id
 00721157ae682-6e2475a8a5cmr295817b3.4.1727430504978; Fri, 27 Sep 2024
 02:48:24 -0700 (PDT)
Date: Fri, 27 Sep 2024 11:48:22 +0200
In-Reply-To: <220a19f6-f73c-54ef-1c4d-ce498942f106@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-15-ivanov.mikhail1@huawei-partners.com>
 <ZurZ7nuRRl0Zf2iM@google.com> <220a19f6-f73c-54ef-1c4d-ce498942f106@huawei-partners.com>
Message-ID: <ZvZ_ZjcKJPm5B3_Z@google.com>
Subject: Re: [RFC PATCH v3 14/19] selftests/landlock: Test socketpair(2) restriction
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2024 at 03:57:47PM +0300, Mikhail Ivanov wrote:
> On 9/18/2024 4:47 PM, G=C3=BCnther Noack wrote:
> > On Wed, Sep 04, 2024 at 06:48:19PM +0800, Mikhail Ivanov wrote:
> > > Add test that checks the restriction on socket creation using
> > > socketpair(2).
> > >=20
> > > Add `socket_creation` fixture to configure sandboxing in tests in
> > > which different socket creation actions are tested.
> > >=20
> > > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> > > ---
> > >   .../testing/selftests/landlock/socket_test.c  | 101 +++++++++++++++=
+++
> > >   1 file changed, 101 insertions(+)
> > >=20
> > > diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/t=
esting/selftests/landlock/socket_test.c
> > > index 8fc507bf902a..67db0e1c1121 100644
> > > --- a/tools/testing/selftests/landlock/socket_test.c
> > > +++ b/tools/testing/selftests/landlock/socket_test.c
> > > @@ -738,4 +738,105 @@ TEST_F(packet_protocol, alias_restriction)
> > >   	EXPECT_EQ(0, test_socket_variant(&self->prot_tested));
> > >   }
> > > +static int test_socketpair(int family, int type, int protocol)
> > > +{
> > > +	int fds[2];
> > > +	int err;
> > > +
> > > +	err =3D socketpair(family, type | SOCK_CLOEXEC, protocol, fds);
> > > +	if (err)
> > > +		return errno;
> > > +	/*
> > > +	 * Mixing error codes from close(2) and socketpair(2) should not le=
ad to
> > > +	 * any (access type) confusion for this test.
> > > +	 */
> > > +	if (close(fds[0]) !=3D 0)
> > > +		return errno;
> > > +	if (close(fds[1]) !=3D 0)
> > > +		return errno;
> > > +	return 0;
> > > +}
> > > +
> > > +FIXTURE(socket_creation)
> > > +{
> > > +	bool sandboxed;
> > > +	bool allowed;
> > > +};
> > > +
> > > +FIXTURE_VARIANT(socket_creation)
> > > +{
> > > +	bool sandboxed;
> > > +	bool allowed;
> > > +};
> > > +
> > > +FIXTURE_SETUP(socket_creation)
> > > +{
> > > +	self->sandboxed =3D variant->sandboxed;
> > > +	self->allowed =3D variant->allowed;
> > > +
> > > +	setup_loopback(_metadata);
> > > +};
> > > +
> > > +FIXTURE_TEARDOWN(socket_creation)
> > > +{
> > > +}
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(socket_creation, no_sandbox) {
> > > +	/* clang-format on */
> > > +	.sandboxed =3D false,
> > > +};
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(socket_creation, sandbox_allow) {
> > > +	/* clang-format on */
> > > +	.sandboxed =3D true,
> > > +	.allowed =3D true,
> > > +};
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(socket_creation, sandbox_deny) {
> > > +	/* clang-format on */
> > > +	.sandboxed =3D true,
> > > +	.allowed =3D false,
> > > +};
> > > +
> > > +TEST_F(socket_creation, socketpair)
> > > +{
> > > +	const struct landlock_ruleset_attr ruleset_attr =3D {
> > > +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> > > +	};
> > > +	struct landlock_socket_attr unix_socket_create =3D {
> > > +		.allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> > > +		.family =3D AF_UNIX,
> > > +		.type =3D SOCK_STREAM,
> > > +	};
> > > +	int ruleset_fd;
> > > +
> > > +	if (self->sandboxed) {
> > > +		ruleset_fd =3D landlock_create_ruleset(&ruleset_attr,
> > > +						     sizeof(ruleset_attr), 0);
> > > +		ASSERT_LE(0, ruleset_fd);
> > > +
> > > +		if (self->allowed) {
> > > +			ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
> > > +						       LANDLOCK_RULE_SOCKET,
> > > +						       &unix_socket_create, 0));
> > > +		}
> > > +		enforce_ruleset(_metadata, ruleset_fd);
> > > +		ASSERT_EQ(0, close(ruleset_fd));
> > > +	}
> > > +
> > > +	if (!self->sandboxed || self->allowed) {
> > > +		/*
> > > +		 * Tries to create sockets when ruleset is not established
> > > +		 * or protocol is allowed.
> > > +		 */
> > > +		EXPECT_EQ(0, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
> > > +	} else {
> > > +		/* Tries to create sockets when protocol is restricted. */
> > > +		EXPECT_EQ(EACCES, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
> > > +	}
> >=20
> > I am torn on whether socketpair() should be denied at all --
> >=20
> >    * on one hand, the created sockets are connected to each other
> >      and the creating process can only talk to itself (or pass one of t=
hem on),
> >      which seems legitimate and harmless.
> >=20
> >    * on the other hand, it *does* create two sockets, and
> >      if they are datagram sockets, it it probably currently possible
> >      to disassociate them with connect(AF_UNSPEC). >
> > What are your thoughts on that?
>=20
> Good catch! According to the discussion that you've mentioned [1] (I
> believe I found correct one), you've already discussed socketpair(2)
> control with Micka=C3=ABl and came to the conclusion that socketpair(2) a=
nd
> unnamed pipes do not give access to new resources to the process,
> therefore should not be restricted.
>=20
> [1]
> https://lore.kernel.org/all/e7e24682-5da7-3b09-323e-a4f784f10158@digikod.=
net/
>=20
> Therefore, this is more like connect(AF_UNSPEC)-related issue. On
> security summit you've mentioned that it will be useful to implement
> restriction of connection dissociation for sockets. This feature will
> solve the problem of reusage of UNIX sockets that were created with
> socketpair(2).
>=20
> If we want such feature to be implemented, I suggest leaving current
> implementation as it is (to prevent vulnerable creation of UNIX dgram
> sockets) and enable socketpair(2) in the patchset dedicated to
> connect(AF_UNSPEC) restriction. Also it will be useful to create a
> dedicated issue on github. WDYT?

Thanks for digging up that discussion, that's exactly the one I meant.

I have a feeling that this may result in compatibility issues later on?  If=
 we
leave the current implementation as it is, then we are *blocking* the creat=
ion
of sockets through socketpair(2).  And then we would have users who add it =
as a
restricted ("handled") operation in their ruleset, and who would expect tha=
t
socketpair(2) can not be used.  When that API is already fixed, how do you
imagine that people should in the future allow socketpair(2), but disallow =
the
"normal" creation of sockets?

In my mind, I would have imagined that the LANDLOCK_ACCESS_SOCKET_CREATE ri=
ght
only restricts socket(2) invocations and leaves socketpair(2) working, and =
then
we could introduce a LANDLOCK_ACCESS_SOCKETPAIR_CREATE right in the future =
to
restrict socketpair(2) as well?

If we wanted to permit socketpair(2), but allow socket(2), would we have to
change the LSM hook interface?  How would that implementation look?


> (Btw I think that disassociation control can be really useful. If
> it were possible to restrict this action for each protocol, we would
> have stricter control over the protocols used.)

In my understanding, the disassociation support is closely intertwined with=
 the
transport layer - the last paragraph of DESCRIPTION in connect(2) is listin=
g
TCP, UDP and Unix Domain sockets in datagram mode. -- The relevant code in =
in
net/ipv4/af_inet.c in inet_dgram_connect() and __inet_stream_connect(), whe=
re
AF_UNSPEC is handled.

I would love to find a way to restrict this independent of the specific
transport protocol as well.

Remark on the side - in af_inet.c in inet_shutdown(), I also found a worryi=
ng
scenario where the same sk->sk_prot->disconnect() function is called and
sock->state also gets reset to SS_UNCONNECTED.  I have done a naive attempt=
 to
hit that code path by calling shutdown() on a passive TCP socket, but was n=
ot
able to reuse the socket for new connections afterwards. (Have not debugged=
 it
further though.)  I wonder whether this is a scnenario that we also need to
cover?


> > (On a much more technical note; consider replacing self->allowed with
> > self->socketpair_error to directly indicate the expected error? It feel=
s that
> > this could be more straightforward?)
>=20
> I've considered this approach and decided that this would
> * negatively affect the readability of conditional for adding Landlock
>   rule,
> * make checking the test_socketpair() error code less explicit.

Fair enough, OK.

=E2=80=94G=C3=BCnther
