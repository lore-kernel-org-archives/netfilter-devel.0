Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94993D47C8;
	Mon, 18 May 2026 13:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779110496; cv=none; b=V/ymv1x+C9cKfN6hHyjX6PYBirhAAi6MoWkkrnrVvPV5tV3nn99iWrHXlk1Kp9YGTHjOHk5Asx0Ckytm4oYRdxybZ2NovNvKl0Ned/p8w0MVDUFK0Pk8sCGl9iNE3p0woywas/B5rQjnfDRBY1ZE4Ic+f8qPZsjOGPYpcKnTM6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779110496; c=relaxed/simple;
	bh=e9dYNdljIJax+RaRv7W4LDSRtWrW8dwkc3PswrSfk88=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=l9UlmbE9pmdyoOFrbQgfmaqvCv6iBntbl+eWuB8Fd69VCGt7KxVkH1lQwgRlmQom8hjOTcR8bJlwBjRAqHsm2rQdpMTuoNKNKhblNPYsVBnIKI1AB4cvTZ0Zt0E1F6UTC1MV32hbafqReyzBMpklrO+Bm0XYkwr6k/nzIwocsMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+tgJWbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+tgJWbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F84C2BCB7;
	Mon, 18 May 2026 13:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779110496;
	bh=e9dYNdljIJax+RaRv7W4LDSRtWrW8dwkc3PswrSfk88=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=A+tgJWbUIGXosV+rx5ZfRHzflywrf+vUqzA4IB8i4JoLm0ZB+bRtkX9Cwg10v0UKJ
	 TunP6hm8sQcM8/HDCSly3INQg8WC/ZDn0lLonmsudoNehnFS4gyFz4WRUKrRaoaTPG
	 wfZrOs8Xo6Oaol8+pXfv2ohxNx+cwujZJybQrkoG5OJevKinzgGTPrYGCOEeOXZ1NT
	 i6U7qAhIfvXfXPd+9pkvEbfvNLE9uTyuFtkKG+I/5rFSvWS4v/d4TH5hwYYUVM6a/6
	 tRbGX1fjJwi7KAnUP5ZUnIrkRE9PKQa17aWLtnVfQhxSTv2jpA4mnjNMur/5kgqX3F
	 aXmVISleFP+eA==
Content-Type: multipart/mixed; boundary="===============6175790185743730408=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <f1c34c53dbda338bac68cdcbb48197412e542040617d8bd04c7c94a0de052f1a@mail.kernel.org>
In-Reply-To: <20260518122842.218522-6-mahe.tardy@gmail.com>
References: <20260518122842.218522-6-mahe.tardy@gmail.com>
Subject: Re: [PATCH bpf-next v6 5/6] selftests/bpf: add bpf_icmp_send kfunc IPv6 tests
From: bot+bpf-ci@kernel.org
To: mahe.tardy@gmail.com,bpf@vger.kernel.org
Cc: martin.lau@linux.dev,daniel@iogearbox.net,john.fastabend@gmail.com,ast@kernel.org,andrii@kernel.org,yonghong.song@linux.dev,jordan@jrife.io,netdev@vger.kernel.org,netfilter-devel@vger.kernel.org,edumazet@google.com,kuba@kernel.org,pabeni@redhat.com,mahe.tardy@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 18 May 2026 13:21:35 +0000 (UTC)

--===============6175790185743730408==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> index 4f0aed8152d3..d0ac0502f6df 100644
> --- a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> +++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c

[ ... ]

> @@ -81,14 +95,13 @@ static void read_icmp_errqueue(int sockfd, int expected_code)
>  }
>
>  static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel,
> -					    int code)
> +					    int code, int af, const char *ip)
>  {
>  	int srv_fd = -1, client_fd = -1;
>  	struct sockaddr_in addr;
>  	socklen_t len = sizeof(addr);
>
> -	srv_fd = start_server(AF_INET, SOCK_STREAM, "127.0.0.1", 0,
> -			      TIMEOUT_MS);
> +	srv_fd = start_server(af, SOCK_STREAM, ip, 0, TIMEOUT_MS);
>  	if (!ASSERT_GE(srv_fd, 0, "start_server"))
>  		return;

When af is AF_INET6, start_server() creates an IPv6 socket, but addr is
hardcoded as struct sockaddr_in which is 16 bytes.

Does this cause getsockname() to silently truncate the 28-byte
sockaddr_in6 structure because len is initialized to sizeof(addr)?

While reading addr.sin_port happens to work because sin_port and
sin6_port share the same offset, would it be better to use struct
sockaddr_storage here (like in connect_to_fd_nonblock() earlier in the
file) and extract the port conditionally based on the address family to
avoid type confusion?

Note: This concern was raised in v5 review by sashiko-bot@kernel.org,
but does not appear to have been addressed in v6. See
https://lore.kernel.org/bpf/20260515204444.D8204C2BCB0@smtp.kernel.org/

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26034287312
--===============6175790185743730408==--
