Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4943B4EB3
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 22:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779833159; cv=none; b=aKBTsv/RAJSv1si7rGtnMH8+iuQPXg1FQ8AQMxlXABOk+9D5CMGzvO06Dnr03CjrGQ055fiuulwmWTttANhDYqAXfrUDIepgb9uPvGOmO98BxYmsAGYZqdicbRUS55RNAyyCYhUg5aS5bX9WQi3UjmxDaBCyI7yo/6dnnsLYsd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779833159; c=relaxed/simple;
	bh=C78b5poi3bSTja5V936ICsKObcEGAs89jD96jmfKXCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uh3wCZaH3FBy61yLUVziivDMNArLa7ZZVLut1BZ9UHfFw6D3szkZPEus6M1uKbUpumk/gN2RMfHBDvdXnMjPeKbAblBBtKEp4wsjuYVOCnTt8SVvJW4AWMBAbBoEF39cgPH0MyYWtLqee5hQX7XSc/sFcWw3hSvopSCxvxwKR4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P74rbxrg; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P74rbxrg"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49039a8851fso55456875e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 15:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779833156; x=1780437956; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BrsRP55ngJzmPgULfDOa9vPoNMFJrZuin8EfAlT8prQ=;
        b=P74rbxrgRaUjzgc6NUVm6CM9EF7DUsgoUMeVPPHwM6PtaZnm1lAiaBz25lDh1ceK0x
         SLEc3aZogZdfAPCdJd6OEgDRJIfNcGw/egC3cooR3RIfFg4yu6abM5U1i+ZpD+HWi/P3
         nCcqOW+MvlCXLnHckHJKjBBUgNUwcb5bW4T7qvnOs0oQ9ZnIr/Uso8mpWGhOSdbpyV/H
         AF9uo8jADsgPYE4zs5TWSJx5uCDM8VpQRJxVSkzJ8dzi432g2hnto1V77S9LY28n7nqg
         mdHEA2vCYnIlXll6TqwJlugvii4z8OhfWgiG10zm2rQyQApbFA5E9BuYhLW1lYs92J/t
         Luhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779833156; x=1780437956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BrsRP55ngJzmPgULfDOa9vPoNMFJrZuin8EfAlT8prQ=;
        b=jW9KDfhvSV+iyEqpHtJXtfj53dX9vqkz+dZeS0CuFtUNNKlnlDQKDj1HBCrd3yVuZS
         oVMtlfr/htRlKh2+OxsD6QIOyNOIZHNqfBw+bDeq8NLejzp8NBYFaquB5xQmxzNr438s
         /Cu5jD+4Yw6hmfZwtwxjPCFg7RdZ3ih+SD/4/mIo1naDi+mo9d5S1uYIlEf57ExxZ1Ja
         JvRtVD9SrA6qWY3skfJuxtLaZZCzGcf+EyQyXmOJkXwoZL1e4I1oIhz6A6EA1juwY+93
         RTkCimemrSblsxHAy1ar36t8bIFQLIKCfSGvZ0GXCAGaiUCb+626IrZHlW4Ix1M9Aj06
         efPA==
X-Forwarded-Encrypted: i=1; AFNElJ9INnFk0rrp0+PhFUAC2RXIv10QyOKsOlKp04BDvmLVEUDUXROBhBdfjq1GnjRDoWfSi6uR14KEDtqe1iDDtAY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0cS9+Qe87xSziAzLAXrvKBhzLXWQi1df7sKxt7p4Q3pPxNIms
	89qU5m64+EjELiC4MMM0ewn7AiHQrOHTAyVSvU0XsSfep+6LWi7rCjN2
X-Gm-Gg: Acq92OFaLRj2q6E5HKnRSnOby5VngdWr5QmmpI7uCD7qtlKdTnfYvyWRNwsOMFUMX15
	jkEJLV3JmvKQw60tHBa4Gmj89B4vhaNOYI61gk8sJAhmheNRRMmpeqkq8mCeQJuxA7Ukf+OsHx+
	8No3hODLFMIUut7yB7YXlkPKSByjm81IOPy8E55fXCD+yCAlTBlxi/kJ1WUFqIbwsKXrtYteHcM
	O51ues3hmpqpUbJd9+zkaFp2WmolfDjz6n4i65uiun+s8wBFZrYuq3+iEoV5xjBf9m2gFwaONpd
	24gHf5uXQ9y/10sNVdBSYxuW59tBWI0N/EVD5iNA7ttRN+tTqlB93mvaKNMALRtH3EBwqt90SC3
	/TDH63lOXeTY2SVKZDMLP/6wA0UXd7pZOHyx/HpfCdPuoQrQS1f7U5zc3Tzr3ecoXx1GRDeC/nQ
	gDZ3xOoZJrbtjDcjxnb0PRDyedAe4N5hszp1WuYcbuHblleSjCZA==
X-Received: by 2002:a05:600c:6296:b0:490:5321:2466 with SMTP id 5b1f17b1804b1-49053212604mr246924855e9.20.1779833155621;
        Tue, 26 May 2026 15:05:55 -0700 (PDT)
Received: from gmail.com ([2a01:e0a:488:3510:15a1:dbd2:86bb:c4e9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490809c3b4esm2749995e9.31.2026.05.26.15.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 15:05:54 -0700 (PDT)
Date: Wed, 27 May 2026 00:05:51 +0200
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
	yonghong.song@linux.dev, jordan@jrife.io, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, martin.lau@kernel.org,
	eddyz87@gmail.com, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v7 4/7] selftests/bpf: add bpf_icmp_send kfunc
 cgroup_skb tests
Message-ID: <ahYZPw8pvpJifRRS@gmail.com>
References: <20260526153708.279717-5-mahe.tardy@gmail.com>
 <1dd140384d8509230a38c31f8753dec9a21f77f585178e41a60746b5f631fb40@mail.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dd140384d8509230a38c31f8753dec9a21f77f585178e41a60746b5f631fb40@mail.kernel.org>

On Tue, May 26, 2026 at 04:20:12PM +0000, bot+bpf-ci@kernel.org wrote:
> > diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> > new file mode 100644
> > index 000000000000..0dc6b6ceafb4
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> > @@ -0,0 +1,149 @@
> 
> [ ... ]
> 
> > +static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel, int code)
> > +{
> > +	int srv_fd = -1, client_fd = -1;
> > +	struct sockaddr_in addr;
> > +	socklen_t len = sizeof(addr);
> > +
> > +	srv_fd = start_server(AF_INET, SOCK_STREAM, "127.0.0.1", 0, TIMEOUT_MS);
> > +	if (!ASSERT_GE(srv_fd, 0, "start_server"))
> > +		return;
> 
> Jordan Rife raised a style concern in v6 about using ASSERT_OK_FD
> instead of ASSERT_GE for file descriptor checks. While this was addressed
> for client_fd and cgroup_fd, the srv_fd check here still uses ASSERT_GE.
> Should this be ASSERT_OK_FD for consistency?
> 
> https://lore.kernel.org/bpf/q46w47cqezttz2otf76tncxu7sovhywy2dqwcbajigp64uhbtz@eimvxfeeexuz/

Indeed, this is a miss, not sure it's worth submitting a new version
just for it, but will be fixed if I need to push another version.

> 
> [ ... ]
> 
> > +void test_icmp_send_unreach_cgroup(void)
> > +{
> > +	struct icmp_send *skel;
> > +	int cgroup_fd = -1;
> > +
> > +	skel = icmp_send__open_and_load();
> > +	if (!ASSERT_OK_PTR(skel, "skel_open"))
> > +		goto cleanup;
> > +
> > +	cgroup_fd = test__join_cgroup("/icmp_send_unreach_cgroup");
> > +	if (!ASSERT_OK_FD(cgroup_fd, "join_cgroup"))
> > +		goto cleanup;
> > +
> > +	skel->links.egress =
> > +		bpf_program__attach_cgroup(skel->progs.egress, cgroup_fd);
> > +	if (!ASSERT_OK_PTR(skel->links.egress, "prog_attach_cgroup"))
> > +		goto cleanup;
> > +
> > +	for (int code = 0; code <= NR_ICMP_UNREACH; code++) {
> > +		/* The TCP stack reacts differently when asking for
> > +		 * fragmentation, let's ignore it for now.
> > +		 */
> > +		if (code == ICMP_FRAG_NEEDED)
> > +			continue;
> > +
> > +		trigger_prog_read_icmp_errqueue(skel, code);
> > +		ASSERT_EQ(skel->data->kfunc_ret, 0, "kfunc_ret");
> > +	}
> > +
> > +	/* Test an invalid code */
> > +	trigger_prog_read_icmp_errqueue(skel, -1);
> > +	ASSERT_EQ(skel->data->kfunc_ret, -EINVAL, "kfunc_ret");
> > +
> > +cleanup:
> > +	icmp_send__destroy(skel);
> > +	close(cgroup_fd);
> 
> Jordan Rife raised a concern in v6 about the cleanup path potentially
> closing an invalid file descriptor. Should this be guarded with
> 'if (cgroup_fd != -1)' before calling close(cgroup_fd)?
> 
> https://lore.kernel.org/bpf/q46w47cqezttz2otf76tncxu7sovhywy2dqwcbajigp64uhbtz@eimvxfeeexuz/

Indeed another miss, could be fixed as well if I send a new version, not
sure it's a big deal.

> 
> > +}
> 
> [ ... ]
> 
> 
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md
> 
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26459248718

