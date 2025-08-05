Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6073B2BDC07
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Aug 2025 23:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754436420; cv=none; b=K5D22k1UZgGUWZeUdLkunW16ljKLvlszeRCYOr5gSLyDwvxp1aSeH+nHU1ZZEPAOX9hU42hLRCPy3VGX0Y2aLyJkegaVzEUpZ9ppE4SfU/bARQmJ9fBSX76ZDwxXH0rfYFbzTFxFWol12sNdW0FOu5P5so6kjBIR58dXsDcUqLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754436420; c=relaxed/simple;
	bh=NaAhpHPoE/CgeUVUKtzxCBxShAzJ09rbedL4LcLiOg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=etfoDls3QY2SkVvcJTsu4c+huD9RvAHK3MPXggAbaupGQMOsiBhDBBRYbNR5De4FR8nc1ytbZeYJnrcKdS8NCNfM9/n4tUZ8QyEJhNMKjWnzRCtTTG4LgnLJCb3XJ5WesFTqEHcYG9lxWgZbiZoezGL3tMYBROrZ2B7fBUxUqUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io; spf=none smtp.mailfrom=jrife.io; dkim=pass (2048-bit key) header.d=jrife-io.20230601.gappssmtp.com header.i=@jrife-io.20230601.gappssmtp.com header.b=h5jErAyW; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=jrife.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jrife-io.20230601.gappssmtp.com header.i=@jrife-io.20230601.gappssmtp.com header.b="h5jErAyW"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b350c85cf4eso661255a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Aug 2025 16:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrife-io.20230601.gappssmtp.com; s=20230601; t=1754436417; x=1755041217; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zx+oiqooAwPzNS/YMhZ49cCnzGoAGZM53/g+t+5q8+g=;
        b=h5jErAyWo8k666MlIfU+cZUZs+J+9fv+oBLqF1xgN+M9BZcmo4X3JGHRDD2tLfjJx1
         SMedYLv/+feJk0ma+U3/HC6IUZmMP4feJvwc9Dx8wGA+k7C5cWURVBDLqC5IUe1gQA3/
         gR5R7WrHw0c0eanV2S3+1aT3KFQ4op7zsbzkteW9IgFGnxaE7ldjkDgdi1RGrFJVpbzk
         lLEHPV+HNNwgVkSxu31qBP076aUXJfbI6YwZPk2nm8q30YlFHMgizxALu/lKs2HyKnW/
         MA4tl1mVxGiCXbjs+u9N5AoaivMRzNdqqSTiJ3RKgGrcZHy5NnzKTCPL+i8rvY0h4P5k
         +XCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754436417; x=1755041217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zx+oiqooAwPzNS/YMhZ49cCnzGoAGZM53/g+t+5q8+g=;
        b=I4n01KBOOK9/5TlJyGWSy810GEFBbloQnfQkkpPLqqH7QmFWCB+cAbkZFTks/2GAdr
         hoVn6WCJWS3DlC+m/ngv3ZmJ6Oii/U33mpUTZVuVG2Sc/UgVx830EYwHf0iPMgy39LTy
         4ByusAtgX+oH7jvCBEsC7H7fTtnicOKKGG1lxwBtfONkT7xw1D+ONl3qHAEvubYMI/DN
         3+rQfsWNqMQq8D2kjdv5Np8RhqU+AqakDZGk3ZEqJRyG+ATyMHreZQVczINkRb33hQ1Y
         PLZyt2SPVJTSO+qwjrRhu1K5bqJM+wNekP9NBMAxIGIAlAZBB0MegOez6pzoI/xTfJeu
         peTw==
X-Forwarded-Encrypted: i=1; AJvYcCUpB1hBdOTy3BX2QyKpQVTtR0xagSgcNTu73/0N3nfe3St98Fixm+tKpXu/40nnhgH2uovCS3JEya0PEXCLhLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP3W7/cbj27zhc6yVsyWN4DQkwtzo7/UZxwVasxJJEoT7jxAFE
	BfYvgYbt1dz2ZRSRmvxCyIeFOtFasZzYbYepi0lGuHqCPkcxIBOpYN11R3i+pKibbYk=
X-Gm-Gg: ASbGncveF4TYHJvEQgZ+xcUdgHGDnciF9bMb4VrPjoiLYi9XPSdzDcBT5v7lMCRd8zh
	DKL6Y5uthncVoTnw4iDzEKgFag1Yu1F1kW923Yjo4fuQB37Zdox8QCBOo/dYbFWyrSB5JnHOkQ9
	sdRhg2Ohk++76B12e+xBlbDXEBBpkrO5ucoFdbUPZMrIVbLGF4dD2dWCWNR8NJUrIvD4m8qdwpl
	JjjfGTD6JSvTCWMZnWOPwcs8hGpMpoJPemGxLalBT8HWE9OsPC2k3SMGuaulYNR4s4LvXcvMKtI
	KNVwW0ruwmsMTB2x7jj4fsiQd3itHMr6uV8ggfN8nOorW3EDCKgq48+qy2MVnm8oPV4vQBfFMsy
	0nc4cZLcU
X-Google-Smtp-Source: AGHT+IERONxmTD61d4f3RYiiQssL9JgLjjqbM0O7px9BrFZpdBvGVRFN3vYqnBcE95RQkFliyt141g==
X-Received: by 2002:a17:90b:1a8f:b0:31e:cdc1:999e with SMTP id 98e67ed59e1d1-32166c0f332mr343268a91.1.1754436416553;
        Tue, 05 Aug 2025 16:26:56 -0700 (PDT)
Received: from t14 ([2001:5a8:4528:b100:2ebd:da68:3248:a843])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-320f4909b8bsm13192504a91.16.2025.08.05.16.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 16:26:56 -0700 (PDT)
Date: Tue, 5 Aug 2025 16:26:53 -0700
From: Jordan Rife <jordan@jrife.io>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: lkp@intel.com, alexei.starovoitov@gmail.com, andrii@kernel.org, 
	ast@kernel.org, bpf@vger.kernel.org, coreteam@netfilter.org, 
	daniel@iogearbox.net, fw@strlen.de, john.fastabend@gmail.com, martin.lau@linux.dev, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, oe-kbuild-all@lists.linux.dev, 
	pablo@netfilter.org
Subject: Re: [PATCH bpf-next v3 4/4] selftests/bpf: add icmp_send_unreach
 kfunc tests
Message-ID: <usz5bhydsiejr37owgt3zypckzh7fa7ygmhsyaaiprsljx7iy5@ipopnr5n4ds7>
References: <202507270940.kXGmRbg5-lkp@intel.com>
 <20250728094345.46132-1-mahe.tardy@gmail.com>
 <20250728094345.46132-5-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728094345.46132-5-mahe.tardy@gmail.com>

On Mon, Jul 28, 2025 at 09:43:45AM +0000, Mahe Tardy wrote:
> This test opens a server and client, attach a cgroup_skb program on
> egress and calls the icmp_send_unreach function from the client egress
> so that an ICMP unreach control message is sent back to the client.
> It then fetches the message from the error queue to confirm the correct
> ICMP unreach code has been sent.
> 
> Note that the BPF program returns SK_PASS to let the connection being
> established to finish the test cases quicker. Otherwise, you have to
> wait for the TCP three-way handshake to timeout in the kernel and
> retrieve the errno translated from the unreach code set by the ICMP
> control message.
> 
> Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
> ---
>  .../bpf/prog_tests/icmp_send_unreach_kfunc.c  | 99 +++++++++++++++++++
>  .../selftests/bpf/progs/icmp_send_unreach.c   | 36 +++++++
>  2 files changed, 135 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c
>  create mode 100644 tools/testing/selftests/bpf/progs/icmp_send_unreach.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c
> new file mode 100644
> index 000000000000..414c1ed8ced3
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c
> @@ -0,0 +1,99 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +#include <linux/errqueue.h>
> +#include "icmp_send_unreach.skel.h"
> +
> +#define TIMEOUT_MS 1000
> +#define SRV_PORT 54321
> +
> +#define ICMP_DEST_UNREACH 3
> +
> +#define ICMP_FRAG_NEEDED 4
> +#define NR_ICMP_UNREACH 15

small nit: Any reason why ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED, and
NR_ICMP_UNREACH are redefined here? I think you should just be able to
#include <linux/icmp.h> this at the top to avoid redefining these.

> +
> +static void read_icmp_errqueue(int sockfd, int expected_code)
> +{
> +	ssize_t n;
> +	struct sock_extended_err *sock_err;
> +	struct cmsghdr *cm;
> +	char ctrl_buf[512];
> +	struct msghdr msg = {
> +		.msg_control = ctrl_buf,
> +		.msg_controllen = sizeof(ctrl_buf),
> +	};
> +
> +	n = recvmsg(sockfd, &msg, MSG_ERRQUEUE);
> +	if (!ASSERT_GE(n, 0, "recvmsg_errqueue"))
> +		return;
> +
> +	for (cm = CMSG_FIRSTHDR(&msg); cm; cm = CMSG_NXTHDR(&msg, cm)) {
> +		if (!ASSERT_EQ(cm->cmsg_level, IPPROTO_IP, "cmsg_type") ||
> +		    !ASSERT_EQ(cm->cmsg_type, IP_RECVERR, "cmsg_level"))
> +			continue;
> +
> +		sock_err = (struct sock_extended_err *)CMSG_DATA(cm);
> +
> +		if (!ASSERT_EQ(sock_err->ee_origin, SO_EE_ORIGIN_ICMP,
> +			       "sock_err_origin_icmp"))
> +			return;
> +		if (!ASSERT_EQ(sock_err->ee_type, ICMP_DEST_UNREACH,
> +			       "sock_err_type_dest_unreach"))
> +			return;
> +		ASSERT_EQ(sock_err->ee_code, expected_code, "sock_err_code");
> +	}
> +}
> +
> +void test_icmp_send_unreach_kfunc(void)
> +{
> +	struct icmp_send_unreach *skel;
> +	int cgroup_fd = -1, client_fd = 1, srv_fd = -1;
> +	int *code;
> +
> +	skel = icmp_send_unreach__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel_open"))
> +		goto cleanup;
> +
> +	cgroup_fd = test__join_cgroup("/icmp_send_unreach_cgroup");
> +	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
> +		goto cleanup;
> +
> +	skel->links.egress =
> +		bpf_program__attach_cgroup(skel->progs.egress, cgroup_fd);
> +	if (!ASSERT_OK_PTR(skel->links.egress, "prog_attach_cgroup"))
> +		goto cleanup;
> +
> +	code = &skel->bss->unreach_code;
> +
> +	for (*code = 0; *code <= NR_ICMP_UNREACH; (*code)++) {
> +		// The TCP stack reacts differently when asking for
> +		// fragmentation, let's ignore it for now
> +		if (*code == ICMP_FRAG_NEEDED)
> +			continue;
> +
> +		skel->bss->kfunc_ret = -1;
> +
> +		srv_fd = start_server(AF_INET, SOCK_STREAM, "127.0.0.1",
> +				      SRV_PORT, TIMEOUT_MS);
> +		if (!ASSERT_GE(srv_fd, 0, "start_server"))
> +			goto for_cleanup;
> +
> +		client_fd = socket(AF_INET, SOCK_STREAM, 0);
> +		ASSERT_GE(client_fd, 0, "client_socket");
> +
> +		client_fd = connect_to_fd(srv_fd, 0);
> +		if (!ASSERT_GE(client_fd, 0, "client_connect"))
> +			goto for_cleanup;
> +
> +		read_icmp_errqueue(client_fd, *code);
> +
> +		ASSERT_EQ(skel->bss->kfunc_ret, SK_DROP, "kfunc_ret");

It might be worth testing that the kfunc returns -EINVAL when the code
is outside the accepted range as well for completeness.

> +for_cleanup:
> +		close(client_fd);
> +		close(srv_fd);
> +	}
> +
> +cleanup:
> +	icmp_send_unreach__destroy(skel);
> +	close(cgroup_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/icmp_send_unreach.c b/tools/testing/selftests/bpf/progs/icmp_send_unreach.c
> new file mode 100644
> index 000000000000..15783e5d1d65
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/icmp_send_unreach.c
> @@ -0,0 +1,36 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +char LICENSE[] SEC("license") = "Dual BSD/GPL";
> +
> +int unreach_code = 0;
> +int kfunc_ret = 0;
> +
> +#define SERVER_PORT 54321
> +#define SERVER_IP 0x7F000001
> +
> +SEC("cgroup_skb/egress")
> +int egress(struct __sk_buff *skb)
> +{
> +	void *data = (void *)(long)skb->data;
> +	void *data_end = (void *)(long)skb->data_end;
> +	struct iphdr *iph;
> +	struct tcphdr *tcph;
> +
> +	iph = data;
> +	if ((void *)(iph + 1) > data_end || iph->version != 4 ||
> +	    iph->protocol != IPPROTO_TCP || iph->daddr != bpf_htonl(SERVER_IP))
> +		return SK_PASS;
> +
> +	tcph = (void *)iph + iph->ihl * 4;
> +	if ((void *)(tcph + 1) > data_end ||
> +	    tcph->dest != bpf_htons(SERVER_PORT))
> +		return SK_PASS;
> +
> +	kfunc_ret = bpf_icmp_send_unreach(skb, unreach_code);
> +
> +	/* returns SK_PASS to execute the test case quicker */
> +	return SK_PASS;
> +}
> --
> 2.34.1
> 

Jordan
