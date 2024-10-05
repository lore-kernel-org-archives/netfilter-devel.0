Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE560158845;
	Sat,  5 Oct 2024 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728147435; cv=none; b=SYGrdzoEVPQCLUNgIaFUjGIqVh2KhYyAv5fub6Cw/gMnuIsGfCbAUiV7+V1WWMQQLVrzl2u9gVownPAwATwFgAOgvrCBIbbeIf/Z5Gvsl9VA3DWOV6+Z8KBvO4qSPFomzq3U/EaI6uTPXjb7m2L7C0xXhm6jtiZOQPrCDDTuuPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728147435; c=relaxed/simple;
	bh=YK/TaOhJ+Rh8S4jkmDYezgPNvOH6TcMj5BDQsqziPzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q9fvjB7pQFMWt2fKRNcPt2rGgRGBkZ+puYErgcRxuRVtZgahWLpleWadVNtnkXR3SUg6gq9gXaJUqpwkmAExiQOYiG7X4WJ5cprd7l2J3jbNWWKQ7sfkA/5V5FvibOZMxNpA1ONNnfriAe+y/J6XgD2m7O9C4JNOE/Wn4Gs2Huc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSKrxKzI; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSKrxKzI"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a83562f9be9so323685066b.0;
        Sat, 05 Oct 2024 09:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728147432; x=1728752232; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2ORImlwi7iW6BWXPaXdIsk9Ekb2AmAFHZJFcKaSQoCo=;
        b=mSKrxKzImYmHsuQElyx8End1pKBCjIsYGAzPNWgrpnox6eVTmu9xcwLGNhhgSdjGUt
         69NM7G482O2kU3maC1pFcCqJ1ZR+GWPr/WBMfKlGRAtHhbXPuYQU/Z1A54if/FAO1mZ8
         9rBIv0vMj+6f/DT0OjlRdHhvqWb5RfU4VnbY+DOAqpZ/bkYl4OUBlwFT3T8f0R+WjBfb
         arbzppaa/jjQnVgpiduprb8cHxET8uIldS4ecNI1QbSbh+ae6DmLQvKKaqJIwt35itX/
         xxv9hgktFfGJ0gkI3Cjc+4EAJRbW+YpmdM6WI+UMID3A0K9fRBmVRvwnVg5gyAiVjGwq
         UsRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728147432; x=1728752232;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ORImlwi7iW6BWXPaXdIsk9Ekb2AmAFHZJFcKaSQoCo=;
        b=TGAAWHYHgiJrIDLkenfLZufaJIXo9Eoao7cPQZ6me2Th9Qw/5KD96DnXjCELlEEWrj
         tvgGoxc72k6t5E5FWCTmWxnhLVU7T5/6Ug/zyk5cMgS1Nmn58ZBkNc2kNb7y5zNbuwcE
         s8ou/cuQj8l3Oci1tGO3jNFqvJG+e3DOMkea/o3h8R8/SSgGiE9gq2KLAYQKceBepRGD
         O9u/+YZpVCZM7c5Z0i7PdS93o2GVh7GNnm+wzkKiBgyHJAh02oTvgp82MhuKhob2/CKA
         vs7fK57OYcd0jro8KepPHFk0sZudm2UFpRJpo+Pw3Z/TnUQSsDSbVNhB0juVk+dTyEbt
         jMqg==
X-Forwarded-Encrypted: i=1; AJvYcCU68nxNP9K0B81QtAZEp46QEMlKctjNeKnxC5uBF671EbDMIybhAuSC+Yx6Bek0bb4vg5lMFFCb@vger.kernel.org, AJvYcCWDnWwK8ADoCkKS/4EOSFyfTxwmCQkAlcnFRQy+Ir0+rjG3GQeIXdN62emFeDl11x5JfNeMwJkrSMiiWUEtqKqD@vger.kernel.org, AJvYcCXiR9c/I/E/86j4SdL9s//TNKrRjjASJqDJOqjkQMZKpt5ceAgr/y5IoBp7ENWJ1WWSJxMYT0Dvwkjeex8QJRbC/yL26vY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8afrmPF+Yu7gWkQmtEUB5aI9Ga4xqKBJHennjTcN8zPx34NKX
	+oYJaTXMqRxSUE81D2omM5229oBKz3A/PYbOCn3VqB8DrCvZWCW/
X-Google-Smtp-Source: AGHT+IHlsonzX8MN48xQxdpUdoanhjVVdf89pDwViQXlFULoxDZPuJcrxjkKHJfnQfeQOOMKcVJ1ew==
X-Received: by 2002:a17:906:4787:b0:a7a:9447:3e8c with SMTP id a640c23a62f3a-a991bcf6214mr689612066b.3.1728147432137;
        Sat, 05 Oct 2024 09:57:12 -0700 (PDT)
Received: from localhost ([2a02:168:59f0:1:b0ab:dd5e:5c82:86b0])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8e05f3c06sm1157671a12.91.2024.10.05.09.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 09:57:11 -0700 (PDT)
Date: Sat, 5 Oct 2024 18:57:10 +0200
From: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, yusongping@huawei.com,
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v2 8/9] selftests/landlock: Test changing socket
 backlog with listen(2)
Message-ID: <20241005.c0501f9d61a8@gnoack.org>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-9-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240814030151.2380280-9-ivanov.mikhail1@huawei-partners.com>

On Wed, Aug 14, 2024 at 11:01:50AM +0800, Mikhail Ivanov wrote:
> listen(2) can be used to change length of the pending connections queue
> of the listening socket. Such scenario shouldn't be restricted by Landlock
> since socket doesn't change its state.

Yes, this behavior makes sense to me as well. 👍 __inet_listen_sk()
only changes sk->sk_max_ack_backlog when listen() gets called a second
time.

> * Implement test that validates this case.
> 
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  tools/testing/selftests/landlock/net_test.c | 26 +++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index 6831d8a2e9aa..dafc433a0068 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -1768,6 +1768,32 @@ TEST_F(ipv4_tcp, with_fs)
>  	EXPECT_EQ(-EACCES, bind_variant(bind_fd, &self->srv1));
>  }
>  
> +TEST_F(ipv4_tcp, double_listen)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_LISTEN_TCP,
> +	};
> +	int ruleset_fd;
> +	int listen_fd;
> +
> +	listen_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, listen_fd);
> +
> +	EXPECT_EQ(0, bind_variant(listen_fd, &self->srv0));
> +	EXPECT_EQ(0, listen_variant(listen_fd, backlog));
> +
> +	ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/* Denies listen. */
> +	enforce_ruleset(_metadata, ruleset_fd);
> +	EXPECT_EQ(0, close(ruleset_fd));
> +
> +	/* Tries to change backlog value of listening socket. */
> +	EXPECT_EQ(0, listen_variant(listen_fd, backlog + 1));

For test clarity: Without reading the commit message, I believe it
might not be obvious to the reader *why* the second listen() is
supposed to work.  This might be worth a comment.

> +}
> +
>  FIXTURE(port_specific)
>  {
>  	struct service_fixture srv0;
> -- 
> 2.34.1
> 

Reviewed-by: Günther Noack <gnoack3000@gmail.com>
