Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E1018A936
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 13:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726666414; cv=none; b=r+egrrZx9AW4RkRK25UuVUUdOavxX+t8iyljpvFrzATqWLTsfNKGBJmbs29NV3dxQ/KpajbjINluMAm+enmfm/xkcpdz3DpG3eH3/X+dPIUR58Lk0X42H7340U4Id2mkLiiOcC4vjyPmO766NjRX5jZAeHZG4IWPHxtacZVxGqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726666414; c=relaxed/simple;
	bh=ZW3P5B6GY2HqCgvSPp4xc5SafXcMWOMGEBo8AOGOeEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n4cdm+MEq2ZvUdfzoiEvgMYh1FPx4KlCmkMBSETHiwmcSvpkxNUe834nNCGiR75Jyv8w8Xz60Zn+9mtiWWbh3S1YYdoWOQqaifb776dDHFnawQfgpaH9URzpbhb2p1TRZFJRbdVHH+CK7WIFLMgtYlG8y0TeOGW/0wE89lBpr+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S1w2weHx; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S1w2weHx"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5c25f015a67so4019430a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 06:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726666411; x=1727271211; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NcNjCPrY1XkzDJZX4pZq9njut1QfSYUsTYLom6ltM0Y=;
        b=S1w2weHxJtQG2j/z12JHnzTiGhSOr1tjSTatQIpwS+XXKsz040/QNSi4MNSAkpMMhg
         ZiWGt/2VHytZW6afT6CJc6YalXpbJGRIje4bfhSSD4nB2KaDspy6RsDILyi26BI3pXI4
         JzDFFiQe00l1Hi/GkW2TLbsEQtBYZL4ZxonHJhSVi6/4PbFrFIclRiWgJ/vgij2h47oL
         jEP/pVBpjfDg0NB7ZJfnnSKS+MR7tVRWyOp5Tj4+Na20k2dqZ+94ecOPgnpINLwQVVPG
         IrxHN/yxboCF7t+mRRDS+MqClOOa+JJqIVc5rOhm6WsI2VyS9Sij29DP+dsRPyIQodNl
         loXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726666411; x=1727271211;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NcNjCPrY1XkzDJZX4pZq9njut1QfSYUsTYLom6ltM0Y=;
        b=p+QXN/SfQ1TNOyqQsdHDDPjjJKgjpIfWTdFTVIXXugZ9FqVHCgdFhXp0KJ/2lsDKhS
         1lD60ZSwrLw6TgA93g3xQDgWfP8DoTfNVzAAD7EgMTerPCvSbdPn3w9RAdPufhS9a9fJ
         PzpEAzIot17acGbKX9eC/5nchn3OcT52wioUaugtTlontBWc3No0k1f2Hx86Mdv0XHS6
         KKa8sQ+cCSPk3x5+0a97obq6Jz288ifT8/GS1w6q1o4TeiimDu+nxPzfbXuXVsw1Kzrb
         z3gqHJ+7zNmBNsSrxBYS2yntHzgbdPe3h22c4wFWTgbQFTzh0I1VMKuyV+cfAQuvcJ2x
         8BjA==
X-Forwarded-Encrypted: i=1; AJvYcCUFs7ATWDR3hS952iqohMJPvtu8Z9AAP6ltTNXDdzYpDhVKBD5zF1HXg8SVfixT+j7TlnONLdqyO8jVn5q2eHI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7v0ccIJJ2kBS1OBIUYh2ioTEAYegF1d/3MfQ5xbGuCrUT7cqI
	WKEGze4Zo34+6A3jiw2gEe3tvYwRjdzN+AC0ZIh6eoqqUa/TnoyC//B1DzRcZ0J3lGUNyFmnUzL
	Thg==
X-Google-Smtp-Source: AGHT+IHWiLYublKiojLvuDJBAq2jaNRP+Hjkf3JUsRiiH4wtpBSWfQmZ8JAKkfZt+6HBNL1SRJ6KnCgDHTc=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6402:5214:b0:5c3:c42e:d5e7 with SMTP id
 4fb4d7f45d1cf-5c41e2ad6d0mr10582a12.5.1726666410582; Wed, 18 Sep 2024
 06:33:30 -0700 (PDT)
Date: Wed, 18 Sep 2024 15:33:28 +0200
In-Reply-To: <20240904104824.1844082-14-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com> <20240904104824.1844082-14-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZurWqFq_dGWOsgUU@google.com>
Subject: Re: [RFC PATCH v3 13/19] selftests/landlock: Test packet protocol alias
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2024 at 06:48:18PM +0800, Mikhail Ivanov wrote:
> (AF_INET, SOCK_PACKET) is an alias for (AF_PACKET, SOCK_PACKET)
> (Cf. __sock_create). Landlock shouldn't restrict one pair if the other
> was allowed. Add `packet_protocol` fixture and test to
> validate these scenarios.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  .../testing/selftests/landlock/socket_test.c  | 75 ++++++++++++++++++-
>  1 file changed, 74 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testi=
ng/selftests/landlock/socket_test.c
> index 23698b8c2f4d..8fc507bf902a 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -7,7 +7,7 @@
> =20
>  #define _GNU_SOURCE
> =20
> -#include "landlock.h"
> +#include <linux/landlock.h>
>  #include <linux/pfkeyv2.h>
>  #include <linux/kcm.h>
>  #include <linux/can.h>
> @@ -665,4 +665,77 @@ TEST(kernel_socket)
>  	EXPECT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
>  }
> =20
> +FIXTURE(packet_protocol)
> +{
> +	struct protocol_variant prot_allowed, prot_tested;
> +};
> +
> +FIXTURE_VARIANT(packet_protocol)
> +{
> +	bool packet;
> +};
> +
> +FIXTURE_SETUP(packet_protocol)
> +{
> +	self->prot_allowed.type =3D self->prot_tested.type =3D SOCK_PACKET;
> +
> +	self->prot_allowed.family =3D variant->packet ? AF_PACKET : AF_INET;
> +	self->prot_tested.family =3D variant->packet ? AF_INET : AF_PACKET;

Nit: You might as well write these resulting prot_allowed and prot_tested s=
truct
values out in the two fixture variants.  It's one layer of indirection less=
 and
clarity trumps deduplication in tests, IMHO.  Fine either way though.


> +
> +	/* Packet protocol requires NET_RAW to be set (Cf. packet_create). */
> +	set_cap(_metadata, CAP_NET_RAW);
> +};
> +
> +FIXTURE_TEARDOWN(packet_protocol)
> +{
> +	clear_cap(_metadata, CAP_NET_RAW);
> +}
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(packet_protocol, packet_allows_inet) {
> +	/* clang-format on */
> +	.packet =3D true,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(packet_protocol, inet_allows_packet) {
> +	/* clang-format on */
> +	.packet =3D false,
> +};
> +
> +TEST_F(packet_protocol, alias_restriction)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr =3D {
> +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +	};
> +	struct landlock_socket_attr packet_socket_create =3D {
> +		.allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +		.family =3D self->prot_allowed.family,
> +		.type =3D self->prot_allowed.type,
> +	};
> +	int ruleset_fd;
> +
> +	/*
> +	 * Checks that packet socket is created sucessfuly without

Typo nit: "successfully"

Please also check in other locations, I might well have missed some ;-)

> +	 * landlock restrictions.
> +	 */
> +	ASSERT_EQ(0, test_socket_variant(&self->prot_tested));
> +
> +	ruleset_fd =3D
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +				       &packet_socket_create, 0));
> +	enforce_ruleset(_metadata, ruleset_fd);
> +	ASSERT_EQ(0, close(ruleset_fd));
> +
> +	/*
> +	 * (AF_INET, SOCK_PACKET) is an alias for the (AF_PACKET, SOCK_PACKET)
> +	 * (Cf. __sock_create). Checks that Landlock does not restrict one pair
> +	 * if the other was allowed.
> +	 */
> +	EXPECT_EQ(0, test_socket_variant(&self->prot_tested));

Why not check both AF_INET and AF_PACKET in both fixtures?
Since they are synonymous, they should both work, no matter which
of the two variants was used in the rule.

It would be slightly more comprehensive and make the fixture smaller.
WDYT?

> +}
> +
>  TEST_HARNESS_MAIN
> --=20
> 2.34.1
>=20

=E2=80=94G=C3=BCnther
