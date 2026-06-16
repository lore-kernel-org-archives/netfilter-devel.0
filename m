Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C68638D3E8
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2026 22:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781649266; cv=none; b=u04VnQ+SpbnHM8XfF5yqXNcZBtRxmn+vEbsf647JySSo8CtEoSFqW5oLjkzYQYrODain5D82pR7jZJjQTjXzYQNtnV2lNRHGyAr+dS+3v7r5HE076QXVH4z29ekCyRrkgjhg2Z92/Cp2/9aRn4ErYsdwH0zXZZ+xDomR9v/DLJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781649266; c=relaxed/simple;
	bh=+k+Z5QT8jwp2bFgq5LnQarAVCm6xtVohhvDgImufK9I=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=lt6bTlKx55GPpo4zp/ytAUaqXywT0Mk+0p6fujd4EhEXXNH1xgeWs89PpFn6VysQY394f+UQSAg0ibDEMLP1pVBWo/IL1zeIaLbOV5TaEOKQidMcvbwLwl5CfGfIsSCHBDK2Ewe9h3bWOsBNdeOFc+OlhsQmxFyqWh1+lNuNStc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com; spf=pass smtp.mailfrom=etsalapatis.com; dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b=R/2h6asC; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b="R/2h6asC"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-13810b63a1aso11370830c88.1
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2026 15:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1781649263; x=1782254063; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MD5iZFuM9ZopY66WGxBJxUk9sqbEsapLkycXT2EpEGQ=;
        b=R/2h6asC6iYJaz6+jj9LMjgxjwPi7mM3ZZNfOAyFvCMwbWcpodwzbzijY/iuEYIkNO
         DtRMmQABUM7IfbI8wXTbMR/T/2k3LrLICoaDzIAhuDL+H2pcW3zULb3WemuHb6CVMyOy
         NBh+k6WLXtC62G1Z3tJFnozyasl3X/9AInT+PM7wLqUkKlOsm1BFVWMazQHyD93E9FQ9
         h417s2SK4yERe10W2FDqPiPwyuXnAdSz4RKgqytBhuNkR2n/Rf92fFVxKyiSMbadc1gu
         GGbf18sZYrJGsTcdiGK96jZnPonSYEGUjFWUBW0uY2iYmhX9RwRlfQ/jLHaVPm/CKszG
         HWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781649263; x=1782254063;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MD5iZFuM9ZopY66WGxBJxUk9sqbEsapLkycXT2EpEGQ=;
        b=rlsVrgfaPLhTqJT7BrC3R46/Td+r0qrsLyxBJI9lqV07sV3PnQw8+MK3CKtSJQl40l
         7SPBod+g5FpXOo82I3FLgl55Nk4yUwXoFX2ZZ56QmsIUU0yPTrCyVzxkOAphCUE+obvY
         6anYV0Z3GINSHzg9Altwckfo3fYRobkj5MAr2tbWDnf5XbjEf5HXiyBnFA/rkNKT40MN
         Ppqp/KXSSoOdqLMdBFru8g1J1i9Jp1MyrFa3VvOJ9Sz5vp0hnN0HiZKuXSH1n36hlvJf
         MXAYI5EiFaiCw2+IY5zqeDjtVHQvTug+aL9vuOOiWpQEZKjAHgLFdlsM3WnYiRfXPtLD
         J87g==
X-Forwarded-Encrypted: i=1; AFNElJ+VbhjJNYIbEUCamJkdTxCPh3KEdPnnE9oviobBsG+74ZG6/HBA/eTHJF3x/eZnt7ZGzqff4O/3Qwoynf4cr6g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzbpn99SSZuisyl8GZsIHeqUW3oPwc8IBIrhGEVZDyj1MF4xUKu
	SV684U3DWmWdaA0pZT8ApBgZHX83DXgwzIfrCWP5m7AQzeFEm+/cLZORcqEqy+i0Dv4=
X-Gm-Gg: Acq92OFFW2jgHZx/MU2JO92cZ+YKqBsS1BmAhpqh+F3viIFrqIhzmi62KKQBTZxgNNq
	HHiVT9kQvBvEnjZc/l7ByQEeieJB/VK4hmJF3Pvded87yHGTuDCTSWmyuyacEEI9vQJP8Ppnd+v
	iOpasRaFQzX8q1O+LmB4jWfAYOGndzrXAci87A7LJcp3utYAEP54/Tx1766N9SmGdV9ev5o91sv
	2TrizH1e+HKEawJfKKLkmSo2ZwxUsbTsCPnwbFnwYIS7FF4JzBOlvDFlkmzbp8IcpxZnPzvW2fS
	VSOJoxt7V890TiBEQdszNAXwdwPN15XbuFbSWs/KoTIDFNhjmQusT9gQHBgdgWuHd4weCtuVCAJ
	qFy1Vgg0p6PoPQJ9zGWjiHvOwuYK625M7j+/e4t0pLDgfF7sjehVVkulSt5/XYir0+YWREoec3p
	MopxTK
X-Received: by 2002:a05:7022:6b82:b0:12f:c7c3:f5ab with SMTP id a92af1059eb24-1398f66bbd2mr534919c88.2.1781649263283;
        Tue, 16 Jun 2026 15:34:23 -0700 (PDT)
Received: from localhost ([2620:10d:c090:600::1a8e])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b97570asm14146633c88.12.2026.06.16.15.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 15:34:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Jun 2026 18:34:19 -0400
Message-Id: <DJATYAJ7LUNT.NHNYXVW1RTGV@etsalapatis.com>
Cc: <pablo@netfilter.org>, <fw@strlen.de>, <phil@nwl.cc>,
 <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
 <pabeni@redhat.com>, <horms@kernel.org>, <andrii@kernel.org>,
 <eddyz87@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
 <memxor@gmail.com>, <martin.lau@linux.dev>, <song@kernel.org>,
 <yonghong.song@linux.dev>, <jolsa@kernel.org>, <emil@etsalapatis.com>,
 <shuah@kernel.org>, <kartikey406@gmail.com>, <coreteam@netfilter.org>,
 <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Cover small conntrack opts
 error writes
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Yiyang Chen" <chenyy23@mails.tsinghua.edu.cn>, <bpf@vger.kernel.org>,
 <netfilter-devel@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <cover.1781586477.git.chenyy23@mails.tsinghua.edu.cn>
 <c4c898dd23181b676ebf6b6b4d9c54f51bb69c75.1781586477.git.chenyy23@mails.tsinghua.edu.cn>
In-Reply-To: <c4c898dd23181b676ebf6b6b4d9c54f51bb69c75.1781586477.git.chenyy23@mails.tsinghua.edu.cn>

On Tue Jun 16, 2026 at 1:42 AM EDT, Yiyang Chen wrote:
> Add a conntrack kfunc regression check for opts__sz values that do not
> cover opts->error. The BPF program initializes opts->error with a guard
> value, calls the lookup and allocation kfuncs with opts__sz set to
> sizeof(opts->netns_id), and verifies that the guard is still intact
> after the kfunc returns NULL.
>
> Without the conntrack wrapper guard, the kfunc error path overwrites
> that guard with -EINVAL even though the verifier checked only the first
> four bytes of the options object.
>
> Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

> ---
>  .../testing/selftests/bpf/prog_tests/bpf_nf.c |  6 +++++
>  .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 +++++++++++++++++++
>  2 files changed, 32 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/test=
ing/selftests/bpf/prog_tests/bpf_nf.c
> index b33dba4b126e2..14d4c1793aed5 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> @@ -5,6 +5,8 @@
>  #include "test_bpf_nf.skel.h"
>  #include "test_bpf_nf_fail.skel.h"
> =20
> +#define CT_OPTS_ERROR_GUARD 0x12345678
> +
>  static char log_buf[1024 * 1024];
> =20
>  struct {
> @@ -119,6 +121,10 @@ static void test_bpf_nf_ct(int mode)
>  	ASSERT_EQ(skel->bss->test_einval_reserved_new, -EINVAL, "Test EINVAL fo=
r reserved in new struct not set to 0");
>  	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for ne=
tns_id < -1");
>  	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for le=
n__opts !=3D NF_BPF_CT_OPTS_SZ");
> +	ASSERT_EQ(skel->bss->test_einval_len_opts_small_lookup, CT_OPTS_ERROR_G=
UARD,
> +		  "Test no error write for lookup opts__sz before error field");
> +	ASSERT_EQ(skel->bss->test_einval_len_opts_small_alloc, CT_OPTS_ERROR_GU=
ARD,
> +		  "Test no error write for alloc opts__sz before error field");
>  	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4p=
roto !=3D TCP or UDP");
>  	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for ba=
d but valid netns_id");
>  	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for fail=
ed lookup");
> diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/test=
ing/selftests/bpf/progs/test_bpf_nf.c
> index 076fbf03a1268..df43649ecb785 100644
> --- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> @@ -10,6 +10,8 @@
>  #define EINVAL 22
>  #define ENOENT 2
> =20
> +#define CT_OPTS_ERROR_GUARD 0x12345678
> +
>  #define NF_CT_ZONE_DIR_ORIG (1 << IP_CT_DIR_ORIGINAL)
>  #define NF_CT_ZONE_DIR_REPL (1 << IP_CT_DIR_REPLY)
> =20
> @@ -19,6 +21,8 @@ int test_einval_reserved =3D 0;
>  int test_einval_reserved_new =3D 0;
>  int test_einval_netns_id =3D 0;
>  int test_einval_len_opts =3D 0;
> +int test_einval_len_opts_small_lookup =3D 0;
> +int test_einval_len_opts_small_alloc =3D 0;
>  int test_eproto_l4proto =3D 0;
>  int test_enonet_netns_id =3D 0;
>  int test_enoent_lookup =3D 0;
> @@ -124,6 +128,28 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, stru=
ct bpf_sock_tuple *, u32,
>  	else
>  		test_einval_len_opts =3D opts_def.error;
> =20
> +	opts_def.error =3D CT_OPTS_ERROR_GUARD;
> +	ct =3D lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> +		       sizeof(opts_def.netns_id));
> +	if (ct) {
> +		bpf_ct_release(ct);
> +		test_einval_len_opts_small_lookup =3D -EINVAL;
> +	} else {
> +		test_einval_len_opts_small_lookup =3D opts_def.error;
> +	}
> +
> +	opts_def.error =3D CT_OPTS_ERROR_GUARD;
> +	ct =3D alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> +		      sizeof(opts_def.netns_id));
> +	if (ct) {
> +		ct =3D bpf_ct_insert_entry(ct);
> +		if (ct)
> +			bpf_ct_release(ct);
> +		test_einval_len_opts_small_alloc =3D -EINVAL;
> +	} else {
> +		test_einval_len_opts_small_alloc =3D opts_def.error;
> +	}
> +
>  	opts_def.l4proto =3D IPPROTO_ICMP;
>  	ct =3D lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
>  		       sizeof(opts_def));

