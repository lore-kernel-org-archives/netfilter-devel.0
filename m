Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64B51885A6
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2024 09:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962015; cv=none; b=kk/+C4AhL0JgZFrnJ7Fc6ISksI8q9v5zLBFenLdwrW4kFPkgWlJMq9C61FB0AnykC8g3XS2tfLiznIPNZ3N2gUrQHi0y9Yrdj64tKLUYNhrV9rjgeN5bAu2VaOTDqDGSnKhQ+p0pGejSaQP8/iuOj4E6RosubWJIX3fMwNLsySQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962015; c=relaxed/simple;
	bh=bUjKo2hKjo47ALYGkcpnrzn7VI8TDc7sUV14SFfR5BY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X5abr/3UOUulFG87y/xyIbbjYPkov0C084hrNZY/KoTz5H1z7KIugbX9ChGD38xAWbu7QqEXFJmUvsUI+eX/jVdAi5Cj+r6Ea9JtA5GjTJqtmij/zcyZSg9ZperAbADUOCHegWJnCVIE2xlKyQXwBlJx4NHvIVCfk1rUHyMEzqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fLkWhyqZ; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fLkWhyqZ"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a8d1a00e0beso380277866b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2024 02:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725962012; x=1726566812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLwzZqGyb/MrVPN3DxT7ybP0Dg2vrqdUnFlphaKFoAA=;
        b=fLkWhyqZPrUn2RTPMIxVuvgazuhVpKBuHBjy+UKi1CMZ75bnyjKMOhznOTsf04RFCO
         xWpAdutKoMQDwJfwZHSl98o+T9vZm7TKMt9VVPkao++EmLebUaZcZ+1ZmeYgZovNNLmT
         2Knm+DtCGLmc2uMwMq1aWqTrmPSzd4jTGArnkLGV2S1A3oX6+u2BLlrZgjnXXQ1hPKwP
         SPUlRbTeWaHzXuL5E6KU/1Tn+RCPgd2ccyjpxZtWhy4WzRCRkmK8P0e3mLAmyIADnrX2
         2FpLF3lwrQNvkavEewEwRDtmihK6HWshWW+2FhbJGfw769A3i3G1mY3LTQoeHcOg2wLu
         rkag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725962012; x=1726566812;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QLwzZqGyb/MrVPN3DxT7ybP0Dg2vrqdUnFlphaKFoAA=;
        b=p/wzlXpw3WgrgAZ1Wl+Ma1MO9aI1vykK+OcPvSHWrXspkm+7T3wex0SFS7eE6CKHdx
         +IarRdygKSbzIFD2KYJC+QglaLqRlpXiZM3uFlHgXJu+eD+LKntFr+7yZwX4/bMvTH6X
         rGfckMwSdiy0TLhzwuuYQgmA0/ETNDoqpp9fPI/9sV7vdN8aMkjEBcRV1E4vFHKdA5Jo
         /euoguA0SifAeNBSVJ9Yz/gs3SRX7dqrdszKvfp4t/XqCyePrk06yYvfT+vbYgIafOMP
         bJu4Q3gL3+8Vh5wSpXXFRU5ou0nTDdYlccRhMwDupE0UJWGMRubHbGfdN9NWtr2D1e/u
         58KA==
X-Forwarded-Encrypted: i=1; AJvYcCWbIcvsddcxcBlBnLsh6qJQZE01RT34D1ZnSGDmTqutw4Vcp24/6n9GPeTASFO+WORSv89RDn+DIVhrJe4kfug=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKndFQT3C+n/mkop4aeFLoV3YGb9CMrjTS/xJ+JlOiUIbGqI4j
	TAuHhQvz4668Ljjd1XS4fHseMnEUa1XztXx8TghY6Y6dp6CsIRwAAue6DvKr32mQONsp7q7ZUxO
	I4Q==
X-Google-Smtp-Source: AGHT+IEKRkuwKZ+CzVsiEkxduxS73xjFyBD2cngHBnHjRzLoQtzVHwrcWcBID3PvyDTBlYs+V00WXsliOxM=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a17:906:3798:b0:a8a:802a:bfcc with SMTP id
 a640c23a62f3a-a8ffaec4543mr8266b.7.1725962011800; Tue, 10 Sep 2024 02:53:31
 -0700 (PDT)
Date: Tue, 10 Sep 2024 11:53:29 +0200
In-Reply-To: <20240904104824.1844082-5-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com> <20240904104824.1844082-5-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZuAXGVBbld3UfKH0@google.com>
Subject: Re: [RFC PATCH v3 04/19] selftests/landlock: Test adding a rule with
 each supported access
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2024 at 06:48:09PM +0800, Mikhail Ivanov wrote:
> Add test that checks the possibility of adding rule of
> `LANDLOCK_RULE_SOCKET` type with all possible access rights.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
> Changes since v2:
> * Replaces EXPECT_EQ with ASSERT_EQ for close().
> * Refactors commit message and title.
>=20
> Changes since v1:
> * Formats code with clang-format.
> * Refactors commit message.
> ---
>  .../testing/selftests/landlock/socket_test.c  | 31 +++++++++++++++++++
>  1 file changed, 31 insertions(+)
>=20
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testi=
ng/selftests/landlock/socket_test.c
> index 63bb269c9d07..cb23efd3ccc9 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -16,6 +16,9 @@
> =20
>  #include "common.h"
> =20
> +#define ACCESS_LAST LANDLOCK_ACCESS_SOCKET_CREATE
> +#define ACCESS_ALL LANDLOCK_ACCESS_SOCKET_CREATE
> +
>  struct protocol_variant {
>  	int family;
>  	int type;
> @@ -294,4 +297,32 @@ TEST_F(protocol, create)
>  	EXPECT_EQ(EACCES, test_socket_variant(&self->prot));
>  }
> =20
> +TEST_F(protocol, socket_access_rights)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr =3D {
> +		.handled_access_socket =3D ACCESS_ALL,
> +	};
> +	struct landlock_socket_attr protocol =3D {
> +		.family =3D self->prot.family,
> +		.type =3D self->prot.type,
> +	};
> +	int ruleset_fd;
> +	__u64 access;
> +
> +	ruleset_fd =3D
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	for (access =3D 1; access <=3D ACCESS_LAST; access <<=3D 1) {
> +		protocol.allowed_access =3D access;
> +		EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +					       &protocol, 0))
> +		{
> +			TH_LOG("Failed to add rule with access 0x%llx: %s",
> +			       access, strerror(errno));
> +		}
> +	}
> +	ASSERT_EQ(0, close(ruleset_fd));
> +}
> +
>  TEST_HARNESS_MAIN
> --=20
> 2.34.1
>=20

Reviewed-by: G=C3=BCnther Noack <gnoack@google.com>
