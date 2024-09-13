Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47D647F7A
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726239855; cv=none; b=TurKrLKW2hVHA4//FV+i/bqHbn9Cw4RctsQT92wN1LQlnvK29Hvl0GsDO+ZxapxZitDLC4ENWCpY5LOQOA37stcA+RJUB4mS4ZuhXiVN6Y0oYAdr0XeIZVM9/d1DQP92XTHno1lPVOhVpqX2ylykKwI2w1hdXlex1s4Z5k0S0po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726239855; c=relaxed/simple;
	bh=9Jq5heZv6b/G0/qHl7vyQQclyuTLGMSCenWr/F3FZfE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCZAuKb/lx6R/fgRgosORocoNGWIKMkwXaL3ytrgN1l90Zo26Zyd2S2NVuHqnCzfkHhzsz748jxfMu002Dva1vBZdBSJkp3Y1Q3NVxDpgykIfdpzh25aQ2DQGkjXyXPj86s6rXrztKybQlZFAhd898TTG8M9eW44mcWdgQ2/MME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CmxZI3yD; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CmxZI3yD"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1dab3a941fso1819519276.3
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 08:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726239853; x=1726844653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kMooRL8xhzsH6xqnm/1sRryKaBRAuskayMhnUalpEU0=;
        b=CmxZI3yDZgrEGn2hG3MhYemyLPuqSNq0EYjBK35GppBGK8p2OWhfrLdTHrvZkHBUQ3
         BNVVrgOr6Ue3rAoimRl2RJUiSoOa0gC8VlOaeynfkJfKm/C5ME+CF+DGit6A4rvrCSMv
         phUZ5LH8Jh+EuRCML6hB+chkmwI+8WWORHayZoMSm4T7Yed0fKXO4L2mLaqNfSf9LLHo
         9LDWm7sypeCX/UBjlwTB7MFianBkIsVtG8mbPdyL3XoEqI75mZpBcw73qbtwgyR+5H4K
         PZ1QJu0tQr/mU1A/V3Ufu7XkV53xdhRIqAOcUAqUGTStuTkN7ACkNfpwWv80+fgegyCS
         ANKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726239853; x=1726844653;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kMooRL8xhzsH6xqnm/1sRryKaBRAuskayMhnUalpEU0=;
        b=C1Ty0QLePz7UGaIfABdCpn1jouUwfWkmK6beiKL93NvVSLvJL+htxpUjqA2wIyuxD3
         UEcKrmXoRQiKDUiUaLwCwwMIivhOXuej9ZCSQNtjJC1ReTEyShn+vK2IEL9SOHwAYdk1
         QjiFWV63zMGwryNEie9pSrK1Y9pq/WhPoyBMuR6lllVy+hlw4WWLG5U3yeZU+JttMeVy
         rYfvs3/lrv0GFk6K0E4sZs8Pie6bWtjWDSCjmWaWrJqe9YU/kWcj8lflUvaMVbyA7R2e
         EsIDniIps4fIaBzhxJomx13O/Tjbev0lQE7UCh0AYlJEnjYlpsOIkWV8dpFaOzQHMsyD
         nlkw==
X-Forwarded-Encrypted: i=1; AJvYcCU6bWi12LPqgV1ziYvTHzob3JpfGJDUAdYT6BTVDtc4FtTSSm0CzcsmbOXfNUJcCPcUOM05eMEr6DXbLZVZqkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDd1c8Lud+DrvbdKTTA0SNDc5HCfs5SBAQZIX0lKcCSnSKPYyq
	LVRZubeMGVNjRMfWDZmFaVj9Fp9ZDCtJtgtD6uId/gFawMcubUComvIWJ7VJ6T/fmvkZ8CxzrR9
	K+Q==
X-Google-Smtp-Source: AGHT+IHPZMCyWHT83M1ghRe6sD+Qw6yM3pzsmUI3KueeQSwZIV+gzAa9f5lmoK6+cuhUcGnAFCxQrkHWJbA=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a25:c586:0:b0:e03:53a4:1a7 with SMTP id
 3f1490d57ef6-e1db0122872mr5902276.10.1726239852809; Fri, 13 Sep 2024 08:04:12
 -0700 (PDT)
Date: Fri, 13 Sep 2024 17:04:10 +0200
In-Reply-To: <fd6ef478-4d0b-03f2-78f6-8bfd0fc3a846@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-7-ivanov.mikhail1@huawei-partners.com>
 <ZuAP8iSv_sjmlYIp@google.com> <fd6ef478-4d0b-03f2-78f6-8bfd0fc3a846@huawei-partners.com>
Message-ID: <ZuRUagjolNjXsS3r@google.com>
Subject: Re: [RFC PATCH v3 06/19] selftests/landlock: Test adding a rule for
 unhandled access
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 11:19:48AM +0300, Mikhail Ivanov wrote:
> On 9/10/2024 12:22 PM, G=C3=BCnther Noack wrote:
> > Hi!
> >=20
> > On Wed, Sep 04, 2024 at 06:48:11PM +0800, Mikhail Ivanov wrote:
> > > Add test that validates behaviour of Landlock after rule with
> > > unhandled access is added.
> > >=20
> > > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> > > ---
> > > Changes since v2:
> > > * Replaces EXPECT_EQ with ASSERT_EQ for close().
> > > * Refactors commit title and message.
> > >=20
> > > Changes since v1:
> > > * Refactors commit message.
> > > ---
> > >   .../testing/selftests/landlock/socket_test.c  | 33 ++++++++++++++++=
+++
> > >   1 file changed, 33 insertions(+)
> > >=20
> > > diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/t=
esting/selftests/landlock/socket_test.c
> > > index 811bdaa95a7a..d2fedfca7193 100644
> > > --- a/tools/testing/selftests/landlock/socket_test.c
> > > +++ b/tools/testing/selftests/landlock/socket_test.c
> > > @@ -351,4 +351,37 @@ TEST_F(protocol, rule_with_unknown_access)
> > >   	ASSERT_EQ(0, close(ruleset_fd));
> > >   }
> > > +TEST_F(protocol, rule_with_unhandled_access)
> > > +{
> > > +	struct landlock_ruleset_attr ruleset_attr =3D {
> > > +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> > > +	};
> > > +	struct landlock_socket_attr protocol =3D {
> > > +		.family =3D self->prot.family,
> > > +		.type =3D self->prot.type,
> > > +	};
> > > +	int ruleset_fd;
> > > +	__u64 access;
> > > +
> > > +	ruleset_fd =3D
> > > +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> > > +	ASSERT_LE(0, ruleset_fd);
> > > +
> > > +	for (access =3D 1; access > 0; access <<=3D 1) {
> > > +		int err;
> > > +
> > > +		protocol.allowed_access =3D access;
> > > +		err =3D landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> > > +					&protocol, 0);
> > > +		if (access =3D=3D ruleset_attr.handled_access_socket) {
> > > +			EXPECT_EQ(0, err);
> > > +		} else {
> > > +			EXPECT_EQ(-1, err);
> > > +			EXPECT_EQ(EINVAL, errno);
> > > +		}
> > > +	}
> > > +
> > > +	ASSERT_EQ(0, close(ruleset_fd));
> > > +}
> > > +
> >=20
> > I should probably have noticed this on the first review round; you are =
not
> > actually exercising any scenario here where a rule with unhandled acces=
s is
> > added.
> >=20
> > To clarify, the notion of an access right being "unhandled" means that =
the
> > access right was not listed at ruleset creation time in the ruleset_att=
r's
> > .handled_access_* field where it would have belonged.  If that is the c=
ase,
> > adding a ruleset with that access right is going to be denied.
> >=20
> > As an example:
> > If the ruleset only handles LANDLOCK_ACCESS_FS_WRITE_FILE and nothing e=
lse,
> > then, if the test tries to insert a rule for LANDLOCK_ACCESS_SOCKET_CRE=
ATE,
> > that call is supposed to fail -- because the "socket creation" access r=
ight is
> > not handled.
>=20
> This test was added to exercise adding a rule with future possible
> "unhandled" access rights of "socket" type, but since this patch
> implements only one, this test is really meaningless. Thank you for
> this note!
>=20
> >=20
> > IMHO the test would become more reasonable if it was more clearly "hand=
ling"
> > something entirely unrelated at ruleset creation time, e.g. one of the =
file
> > system access rights.  (And we could do the same for the "net" and "fs"=
 tests as
> > well.)
> >=20
> > Your test is a copy of the same test for the "net" rights, which in tur=
n is a
> > copy of teh same test for the "fs" rights.  When the "fs" test was writ=
ten, the
> > "fs" access rights were the only ones that could be used at all to crea=
te a
> > ruleset, but this is not true any more.
>=20
> Good idea! Can I implement such test in the current patchset?

Yes, I think it would be a good idea.

I would, in fact, recommend to turn the rule_with_unhandled_access test int=
o that test.

The test traces its roots clearly to

  TEST_F(mini, rule_with_unhandled_access)  from net_test.c

and to

  TEST_F_FORK(layout1, rule_with_unhandled_access)  from fs_test.c


and I think all three variants would better be advised to create a ruleset =
with

struct landlock_ruleset_attr ruleset_attr =3D {
	.handled_access_something_entirely_different =3D LANDLOCK_ACCESS_WHATEVER,
}

and then check their corresponding fs, net and socket access rights using a
landlock_add_rule() call for the access rights that belong to the respectiv=
e
module, so that it exercises the scenario where userspace attempts to use t=
he
access right in a rule, but the surrounding ruleset did not restrict the sa=
me
access right (it was "unhandled").

In spirit, it would be nicest if we could create a ruleset where nothing at=
 all
is handled, but I believe in that case, the landlock_create_ruleset() call =
would
already fail.

=E2=80=94G=C3=BCnther

P.S.: I am starting to grow a bit uncomfortable with the amount of duplicat=
ed
test code that we start having across the different types of access rights.=
  If
you see a way to keep this more in check, while still keeping the tests
expressive and not over-frameworking them, let's try to move in that direct=
ion
if we can. :)
