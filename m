Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F01D2F747A
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Nov 2025 10:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763806569; cv=none; b=Apy/T7/gugoWOmvId87xnarnJRiT9q8hbR/aIGVOMaGrd7HnGtaQR+R946Lh2jn54L4ScFwwBA2dKkHqgb5529we4dfLtcKiiqb/3E4aWwhy9HYNoOToCcuoHHJcgqiV2cQGRXCTpgLCYA6LHznhSVcRX0RKCBblEJkAMGLQjQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763806569; c=relaxed/simple;
	bh=okpyZGlEFjEuEDFNYuruZwkefkPmV4EIGxCGt77K1j4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8qzVyXDxh1VdqyTuYmrHPPhIAIru73V6ARH30707yOVj+hJ2NvxV90ziTGzNzDzd8smrC3RcBQBcQDjWzeVofDBg3GRqFW3EJnQlgmr5I3Vw5zHTv5pITvJPanv3d7Gp2MQdvq2lAFFnszSUx4ZFAseb0smblf2b8FBCyu0tno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eiNkRK7F; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eiNkRK7F"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b762de65c07so425173566b.2
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Nov 2025 02:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763806563; x=1764411363; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mS/vz1rW7oaq1ahBZ3rleu8uUoiOnYHPIRfP3oM2Z9Q=;
        b=eiNkRK7FWVQQ4EFDGPfIPJkC8lovp7vBYF/9D8EplMpXmMyibk0T1MjtegsoC2UPrl
         KpOrI2dRYkx8o7MmTvZiurG2k2MK3qPG3QzU4k71AAgU6yckiRV2R6FXtmiGvRYvHkll
         R9KjbSsjV2f3rx2nC3lHAAT2GGo7oG5ojlbeJ8HVTEK8/2qR/2TozhBL5nB0VA4rrXfF
         tu6Q33YDZN2VhkoevrlSxD/kN21wuSgXXXzNgGELpDggjNmswQDgH20wD+7CJzNy/E61
         NdiCVgCZ6FlE9Sbj9EMfrjbdBcvAqBHbQF20DHZO5tzsaSr9zjwN1hjAezc/7dVaY0P4
         8/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763806563; x=1764411363;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mS/vz1rW7oaq1ahBZ3rleu8uUoiOnYHPIRfP3oM2Z9Q=;
        b=lI7VnMQpTrgi/TR188DFzRF0pxzxCzes3QwmUKdZLwdGLWlQTP5SV1xsD4YuJiY0lG
         CyS7mRTa8DTIUatoptN53mr98kNJg6q8SmKLOcSUO2sF19clGklLUYX7ICzlF42hoQpC
         XVnG+QDWkiE7SEuyaMebvZCLYGgbRPKVxIGEHNaI4fQhCgXDkljEQ2G3uHqx8PZvw/im
         JL+8wP1Nm4TsB41xFaEmVHlo5VEXf9O9llLYksAZGSUDKP9g9Agx2n98x3x8QtRX2I42
         rgv9xVfWJU8osH+NJxeG2s+xaYVxVR0hekwrPP+Z4G5/Vp2rM5pdxUQ8sNgO/X1JAqX/
         67BQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDvr0+b1XNqnpXeJBu7g5SRFmLx9Hz7JtCLJiV8DCzzju7rt318cZxuyI0PI+LEp+jB9C41lHCe4iSp9oq8Pk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzl2E/Zi1E1rVnsgz6WGW9nTTgu1zPqNpcCFx6KAPBM3EeaVJ9
	Y5vhF37OgsqS/ZfrG+nNSaz1l+so8hvyGwNsFycoojGWK6/lnnxSYniF
X-Gm-Gg: ASbGncsSzzXmESvNTrEurblUggM3iP/qa+D0/K8IFzfdEO6o/kWPN6cXuPwrHP35BIp
	bbJheDe+CbA1nrEEnJ3cJtQ0+q5K/XweRkoEeFc/kcXckie2aNowp1JZeo9PSZ3i0NGyZ8mnE5j
	yVzicmcif2k3AUW/ktfNJ+hq+ybaYMp6BpUOzbfL5K8O+Lmbpa8Yr5+6stKuiyPrVgkLWEKmXrs
	mqDx5xplXFJbfUFaQkVgb/934m/R9zZ+INqK9w9pp5mLQ/OKJlT2VsCBKC7V9h71SYlPLNw0rU/
	BKNa0cQaXIsQBTcci1RZKQQzuZVgpZcF9EUATE/T6aJOyTJYayTP9bRAiK9ggwfhZ6NlQxYMPSW
	1PdXsv+55Ux6hI6MHoG/SVgJ0r+zFnjN9QojEJUMbBK9ErOzDkx7lfSqomk1cH494VelzxT8dRz
	S0K1HeNlz8ZbfmnY2i8TMIm5hCo0IbJ0esqtX/
X-Google-Smtp-Source: AGHT+IFvc6Tdcl0gKFGge7EMecimqjBsOE5KfFFBnMOWlWkZjJiEqjTrnAEKRSLZBoXUKpD+VYqOVw==
X-Received: by 2002:a17:907:1c26:b0:b70:5aa6:1535 with SMTP id a640c23a62f3a-b767157138dmr624288566b.18.1763806562727;
        Sat, 22 Nov 2025 02:16:02 -0800 (PST)
Received: from localhost (ip87-106-108-193.pbiaas.com. [87.106.108.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654ff3962sm698791966b.50.2025.11.22.02.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 02:16:02 -0800 (PST)
Date: Sat, 22 Nov 2025 11:16:00 +0100
From: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, gnoack@google.com, willemdebruijn.kernel@gmail.com,
	matthieu@buffet.re, linux-security-module@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	yusongping@huawei.com, artem.kuzin@huawei.com,
	konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v4 12/19] selftests/landlock: Test socketpair(2)
 restriction
Message-ID: <20251122.4795c4c3bb03@gnoack.org>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
 <20251118134639.3314803-13-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251118134639.3314803-13-ivanov.mikhail1@huawei-partners.com>

On Tue, Nov 18, 2025 at 09:46:32PM +0800, Mikhail Ivanov wrote:
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
> index e22e10edb103..d1a004c2e0f5 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -866,4 +866,59 @@ TEST_F(tcp_protocol, alias_restriction)
>  	}
>  }
>  
> +static int test_socketpair(int family, int type, int protocol)
> +{
> +	int fds[2];
> +	int err;
> +
> +	err = socketpair(family, type | SOCK_CLOEXEC, protocol, fds);
> +	if (err)
> +		return errno;
> +	/*
> +	 * Mixing error codes from close(2) and socketpair(2) should not lead to
> +	 * any (access type) confusion for this test.
> +	 */
> +	if (close(fds[0]) != 0)
> +		return errno;
> +	if (close(fds[1]) != 0)
> +		return errno;

Very minor nit: the function leaks an FD if it returns early after the
first close() call failed.  (Highly unlikely to happen though.)

> +	return 0;
> +}
> +
> +TEST_F(mini, socketpair)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
> +	};
> +	const struct landlock_socket_attr unix_socket_create = {
> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
> +		.family = AF_UNIX,
> +		.type = SOCK_STREAM,
> +		.protocol = 0,
> +	};
> +	int ruleset_fd;
> +
> +	/* Tries to create socket when ruleset is not established. */
> +	ASSERT_EQ(0, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
> +	ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +				       &unix_socket_create, 0));
> +	enforce_ruleset(_metadata, ruleset_fd);
> +	ASSERT_EQ(0, close(ruleset_fd));
> +
> +	/* Tries to create socket when protocol is allowed */
> +	EXPECT_EQ(0, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
> +
> +	ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);

You may want to check that landlock_create_ruleset() succeeded here:

ASSERT_LE(0, ruleset_fd)

> +	enforce_ruleset(_metadata, ruleset_fd);
> +	ASSERT_EQ(0, close(ruleset_fd));
> +
> +	/* Tries to create socket when protocol is restricted. */
> +	EXPECT_EQ(EACCES, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
> +}
> +
>  TEST_HARNESS_MAIN
> -- 
> 2.34.1
> 

Otherwise, looks good.
–Günther
