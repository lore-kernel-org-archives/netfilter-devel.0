Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4647377543;
	Mon, 22 Jun 2026 12:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782132111; cv=none; b=Lg0p+1cp+UwDa1k1o4QqP49lDVBdJq/0321Ez6IyNH0RY5GmWZonDxnzfGVdQlu6RgpqqO7aWRdTQCIyDeDBv3Ps+ugKzlxKwt8a9SKNZ/lluNO69J/tzPVM7h/RfidCXrxZffJZx8jVV8yBa2h4CMLQRNrMjai2zfkwLbgligc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782132111; c=relaxed/simple;
	bh=jfDMjVa+wKbuMF1RPWDXVqXHPxX0b8oTycJboxEMxfc=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=n9Plxk/Y/cfVBFvOMttDZpOj7Xray9bGaRhTNYiGQd1XbGU2WI7mmFPHIxpGiHdSTUtyKviOd7evTNgvipqWNBX7B6h8iHqAcbNH/hiCbXVXvOSxHkDchrc4n/Kk/YN/ftCYtVDfkHVMkwETB6I+CfuQGVXO6znhx2uDtIyQU9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TgWuS52l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TgWuS52l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307BF1F000E9;
	Mon, 22 Jun 2026 12:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782132110;
	bh=4iLJSoipRtnfr7If0YiOJXIrBoD2V1Vbzf8qdLxnze8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TgWuS52l663sbBK8AHbsx0sACO/DY6gtEPvAMGDD52zZjBnTurCqDCAV3umZJYBMI
	 db2MUkFiQvD1HC4OHteQXFXL6LOmRgSdcuf3U86tcZCsHg8Jw2MkS/m+PDcuDIy50P
	 cAVUKxf++43rr+ZXz2U4l3aj3yLj+WIVRcNQlydgghCcb6YwzvlC3PkbDy0eqF68dF
	 EDdlV1NKJ+FaoPlLbeMtgbhucF9UOevE4qNZmgdj9QMzhluU9rUsOSaYzUv6F4srUs
	 ebx/An9RumMHSSbIju0SSEH0Vm9uYiZul73qVRbrOrbumDixsMCH265p0y6dzm9KTE
	 jo/1zZnvQg13g==
Content-Type: multipart/mixed; boundary="===============6336517358572342155=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <91d16e0bd3107b1ecd332465cb9b68bb1655446bfc17eb06748457b2f02a73ef@mail.kernel.org>
In-Reply-To: <20260622120515.137082-5-mahe.tardy@gmail.com>
References: <20260622120515.137082-5-mahe.tardy@gmail.com>
Subject: Re: [PATCH bpf-next v8 4/7] selftests/bpf: add bpf_icmp_send kfunc cgroup_skb tests
From: bot+bpf-ci@kernel.org
To: mahe.tardy@gmail.com,bpf@vger.kernel.org
Cc: andrii@kernel.org,ast@kernel.org,daniel@iogearbox.net,edumazet@google.com,john.fastabend@gmail.com,jordan@jrife.io,kuba@kernel.org,martin.lau@linux.dev,netdev@vger.kernel.org,netfilter-devel@vger.kernel.org,pabeni@redhat.com,yonghong.song@linux.dev,mahe.tardy@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 22 Jun 2026 12:41:50 +0000 (UTC)

--===============6336517358572342155==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> new file mode 100644
> index 000000000000..f4e5b883d4c8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c

[ ... ]

> +static void read_icmp_errqueue(int sockfd, int expected_code)
> +{

[ ... ]

> +	for (; cm; cm = CMSG_NXTHDR(&msg, cm)) {
> +		if (cm->cmsg_level != IPPROTO_IP || cm->cmsg_type != IP_RECVERR)
> +			continue;

[ ... ]

> +	}
> +
> +	ASSERT_FAIL("no IP_RECVERR/IPV6_RECVERR control message found");

This isn't a bug, but the failure string names both IP_RECVERR and
IPV6_RECVERR:

	ASSERT_FAIL("no IP_RECVERR/IPV6_RECVERR control message found");

while the loop above only matches IPv4:

	if (cm->cmsg_level != IPPROTO_IP || cm->cmsg_type != IP_RECVERR)
		continue;

and the caller is AF_INET only (start_server(AF_INET, ...) with a
struct sockaddr_in).

Should the IPV6_RECVERR part of the string be dropped to match what the
code actually inspects?

> +}

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/27951892371
--===============6336517358572342155==--
