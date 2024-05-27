Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598F6167260
	for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 21:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716845253; cv=none; b=kpkBDlI13ohqtTbFLaN7NrY1Vigm6f3yXexzyXZ5IU7toXcpxfBSIbAoe106gEIf7CB00re7xuV8k5omWI3j/h4fFmZ7mmy+kfbLB9TrUQd7z5aZjXUDHmHap9vIYPPChiVPHWzEa1Pkc9CAJiP8SDV+fp9+dpQg86v1XOEOpU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716845253; c=relaxed/simple;
	bh=MOKhfWccensreMFlRubUql71+RAADhhqO5cGNzIre5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LpuAkCakRjh5Doe8ZWp1TVtHl9I5EEAKb2IttR8PWY5CNUZSJrOhBfoBcT4GWBvUzODVJ0kpiPL/tqU32T0HFmRe7OmqxRq+PLVP1ISCKbGRJtGqmLFkydIRuHsFq25yPNrgVfQST27WTAddNjLa4+Rs9AknXdlu+xkDxwpr55Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HxQNAvPf; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HxQNAvPf"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df771b4eacbso240077276.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 14:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716845250; x=1717450050; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G6ApPA8Hp1zvsFYSzsSUf+LZhx/4YAFyMZPpxudaXOs=;
        b=HxQNAvPfMK8vnNAY9+2V3JG5h/0EeMYBv6jKIvWSgvLjQNkosgwhHNCd3e8MXZBdrr
         iuECFiNYKC5IygfYMNlcS68Gfc9xRmgGO/KvfMeBfd+zSlFHqhpM7NQbOracisuN7Ub/
         CenUScItWqg0yBr52da/qG8GdjmhO2bzRRTGsl/P9fiu2AzfDKZ9AGktnc3mN0tf7YSR
         0l7l8EVqLRsOOM5xFCrNKce7I+aO7xljHhKY92VCdshAlYD/ppn/wA773zqMkBClVKUs
         mDlY7D+YhfbyyE/EPEWZAhWCuMWSMZJqAxYjjM/1TzA93OZL9WwqVe25fP5s2IzcEFni
         Z0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716845250; x=1717450050;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G6ApPA8Hp1zvsFYSzsSUf+LZhx/4YAFyMZPpxudaXOs=;
        b=hR/yQNp1EbThbS6vgCBHyZM90vDE8zenpecy049zcpiXS/ZdKTtrJNWamHcyB0JMuu
         cunQKPPTmcYVB0CSNDEBR4aaVqyYCGPhqvd5xGq2j2uKkSD3JKAIRevb6MtU+q+v/xdE
         f4YPKnskzQ9J11/69ZGuByuCOsJvLepycX54TLoC6r4D04Z9EtqxU17F8+97Nh3ATHGS
         aOEMk8hxBCwshvOdmLQidNXG/loQ0U9UMlTgBK0d9Pw5P2rd4lRd8a93JsL/lka/8kJP
         d1L5LbV9S+cXCs0PY3Q4GRfhmLrn/fUDoLq2KFRbdOXkKDKvpEoSBP9IzygzZQDOXsNp
         DxHg==
X-Forwarded-Encrypted: i=1; AJvYcCWH3WZUDxf1JrObQGrf0d683tJcLuxmnRqkTeeF8AXGZ7t7aaWhKoL+MRRLnIyIFgv/kosvnaGgcSye0CdFycH9Gh7TTs0ld8z/iSgp+mIL
X-Gm-Message-State: AOJu0Yy3YhGpJ6LSo7jhvb/haM6M/Vwe0TAJka4UPgQsB2vD4YiQORaC
	f3uUrpUKjXoiYR9Nxw+F+oj8e8zsZseLqZBFRRhX9CqbUd72W7wils2Zq0SUxxXCT5u4ucg/RSq
	TzA==
X-Google-Smtp-Source: AGHT+IH4gIkjFAwt/OFUaTh30uKqCejZR1YDpKaC1n++u54HeDgZ5N668CbWhXI8iNWHT4IwvEYltO3r/lI=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6902:72d:b0:dee:60e9:69f4 with SMTP id
 3f1490d57ef6-df77239930emr2957325276.10.1716845250354; Mon, 27 May 2024
 14:27:30 -0700 (PDT)
Date: Mon, 27 May 2024 23:27:28 +0200
In-Reply-To: <20240524093015.2402952-8-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com> <20240524093015.2402952-8-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZlT6wGIRbQI4pjmK@google.com>
Subject: Re: [RFC PATCH v2 07/12] selftests/landlock: Add protocol.inval to
 socket tests
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 24, 2024 at 05:30:10PM +0800, Mikhail Ivanov wrote:
> Add test that validates behavior of landlock with fully
> access restriction.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>=20
> Changes since v1:
> * Refactors commit message.
> ---
>  .../testing/selftests/landlock/socket_test.c  | 34 +++++++++++++++++++
>  1 file changed, 34 insertions(+)
>=20
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testi=
ng/selftests/landlock/socket_test.c
> index 31af47de1937..751596c381fe 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -265,4 +265,38 @@ TEST_F(protocol, rule_with_unhandled_access)
>  	EXPECT_EQ(0, close(ruleset_fd));
>  }
> =20
> +TEST_F(protocol, inval)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr =3D {
> +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE
> +	};
> +
> +	struct landlock_socket_attr protocol =3D {
> +		.allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +		.family =3D self->srv0.protocol.family,
> +		.type =3D self->srv0.protocol.type,
> +	};
> +
> +	struct landlock_socket_attr protocol_denied =3D {
> +		.allowed_access =3D 0,
> +		.family =3D self->srv0.protocol.family,
> +		.type =3D self->srv0.protocol.type,
> +	};
> +
> +	int ruleset_fd;
> +
> +	ruleset_fd =3D
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/* Checks zero access value. */
> +	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +					&protocol_denied, 0));
> +	EXPECT_EQ(ENOMSG, errno);
> +
> +	/* Adds with legitimate values. */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +				       &protocol, 0));
> +}
> +
>  TEST_HARNESS_MAIN
> --=20
> 2.34.1
>=20

Code is based on TEST_F(mini, inval) from net_test.c.  I see that you remov=
ed
the check for unhandled allowed_access, because there is already a separate
TEST_F(mini, rule_with_unhandled_access) for that.

That is true for the "legitimate value" case as well, though...?  We alread=
y
have a test for that too.  Should that also get removed?

Should we then rename the "inval" test to "rule_with_zero_access", so that =
the
naming is consistent with the "rule_with_unhandled_access" test?

=E2=80=94G=C3=BCnther
