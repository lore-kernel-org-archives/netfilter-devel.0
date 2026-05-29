Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE8B3E8C45
	for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 16:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780072733; cv=none; b=nJVI1dfsD0GeLKuy0YEziwFh1TbWxElEb6bSWkUryNO0EfhXUbCTyjuj3lNOKHIuIi2FJdaewDMOXZY5LwjbXOxfCBNWGuF4y6ImoX/oKfE20MZVuv407e7Pqwv2rpjV/1TzurDMtnpSGU5ELfWhMpXU8OuhactqxGjSyOM4DcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780072733; c=relaxed/simple;
	bh=jwoe3wjypS3H+lSXKr3FdiiXDyHsR9LQTB7de2+zLnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sufJy63/bgvwOdaRtVT8r86j4FP61q4bR3eNhX3hCTxic6eufa3n3LE8mWo0TAACyHr47OODP0+xUPtqr5y4xilp9xz850Ois0H8FdYSDcuFzwsmCr/tGrf7UFh+YuZMJ9G83drfZEVTj2FEb/dSNSEUIyIBcxUmQVukyxMNf5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io; spf=none smtp.mailfrom=jrife.io; dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b=MAeG8+J0; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=jrife.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b="MAeG8+J0"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-304f9bc869aso36718eec.2
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 09:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrife-io.20251104.gappssmtp.com; s=20251104; t=1780072730; x=1780677530; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/nKnw+x4cl15+kDr2Ce4fuloF/y4l3Bx7DOy+eoD/UI=;
        b=MAeG8+J0ceRhYuUI9Hy7ZFY56POyzYjaVhjeYGtzokOQO1qbDTY1Yhua38fQHGFxC7
         0juRnW4WcrAw3JDK4UEZlCzASqo50p0/DC4uI7NWt7V0tEt6HfIzdAXnWPMzfcbgxXQy
         /yeAfVjwYyXjxmLnjMr8lCRhm2la+Dwc5hn406hePKMKjihVHiQUTtadGQTTs1NKIcwM
         RK4Eoc9yqUQK37LCqgBHTbWQoi9KOta1GO9+K3SXY60THp7vQh3e0nyuS53xCN56LH3f
         mLeavCy/jFPPeM0ezWIYJuYJGAMH106J9UbZ4Ge+HTtbOxgMiY1275myytmHjvo1mdpD
         kkqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780072730; x=1780677530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/nKnw+x4cl15+kDr2Ce4fuloF/y4l3Bx7DOy+eoD/UI=;
        b=JNeBt5lbxU1+a1vxO6fpcZhIe6/GwL1bNKN9UEP1WchSsAQk5mD0O0kVAatTgSqeXu
         +Z6EVGgq3BJsDmupc1IYzPTluxwzsTFR7EnTB6qvu1piWcm//LdKOlgsKTeeoOsd6ujV
         PzlfRZ8eutsbh/NozHAu082bvGJqP1TUdPoFME3hAwdHzIcBXVnkcQJfgWebJ9/R5shN
         4PozvX2n8v43I3aiOzq45P0xbfdwhYZxZB885T+J0ZzK/x5CKfLCDomYXkHvUHfFdOT5
         B7vA82OC2ZMII5t1OObxZAWr7ytW8kdnboktYutqcD1wXzxV76Fnwkru2k/G6pMwqfB3
         T/KA==
X-Forwarded-Encrypted: i=1; AFNElJ+YbFPvVA7fSk2P5MvL0CMZWJFhEC1JLowwHD9YDu7SdUjmfv9su+OHd0JQPQDXQ/nJu4YEuJ8A5s8S7rwDtFw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0+OMj9WU+7LNlj77ZmzrR5X7JbdZPqEA5rMcwTaJzzys8roki
	vBIRx3d+A4VFqz4HsX3jNCazOSiYoT6zrAJtTJFFWfyD0xFvG4mX9uHGOjP6pt/tULY=
X-Gm-Gg: Acq92OFB9Ctrpvdj/1dDakLeMarrskDh3V4ZJzLct7tnvqBxq6tMU69sv8wl+DITkRo
	kkgVNWKuoA5/IAcZkdFuZczExqWMPmzWaedgkq5kc7imLpT6ruwes8Tyg8cmqeFRAs8I03Ux2m+
	eTb6aDRJke2U7Abk3RDG+dTR0RYNGQDJD8sUJL5MBrmWIWP6fCa1ZaZVY6ISQehfS+0+IskL4o7
	Noxk692fvflLiM4ajH8on3JXj0c+yBwguAp4SRsF5gF3lzcw6G1CwBTWdO7K0nPPLrdPk7VC7pM
	Vltoed3swva9uLjlySjlGO+s7xfo6eOTFgo0wpRmfmklgsug5YEoH6uik3xlgdNXiu4VbpwLld/
	nqWUcFJdjN3CaWnaE7wJ8AdxLbbwQWXh1pjSQUZVOAsu6hgeg71YxIT0akF+1SDQEXNx2XErXsK
	yjWRpTJ83gUJI9XSD6DOsbgp4O
X-Received: by 2002:a05:693c:2c8c:b0:2da:b05a:5a7d with SMTP id 5a478bee46e88-304fa31c4a2mr147195eec.0.1780072729955;
        Fri, 29 May 2026 09:38:49 -0700 (PDT)
Received: from m2 ([83.171.251.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ed5a114dsm1741479eec.24.2026.05.29.09.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:38:49 -0700 (PDT)
Date: Fri, 29 May 2026 09:38:47 -0700
From: Jordan Rife <jordan@jrife.io>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net, 
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org, yonghong.song@linux.dev, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v7 4/7] selftests/bpf: add bpf_icmp_send kfunc
 cgroup_skb tests
Message-ID: <v5xjdjtvowd4h7eo2icpehyg3nz4b7r4bzwa3cow3pqzofsksj@pnxqsomhmp6j>
References: <20260526153708.279717-1-mahe.tardy@gmail.com>
 <20260526153708.279717-5-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526153708.279717-5-mahe.tardy@gmail.com>

On Tue, May 26, 2026 at 03:37:05PM +0000, Mahe Tardy wrote:
> This test opens a server and client, enters a new cgroup, attach a
> cgroup_skb program on egress and calls the bpf_icmp_send function from
> the client egress so that an ICMP unreach control message is sent back
> to the client. It then fetches the message from the error queue to
> confirm the correct ICMP unreach code has been sent.
> 
> Note that, for the client, we have to connect in non-blocking mode to
> let the test execute faster. Otherwise, we need to wait for the TCP
> three-way handshake to timeout in the kernel before reading the errno.
> 
> Also note that we don't set IP_RECVERR on the socket in
> connect_to_fd_nonblock since the error will be transferred anyway in our
> test because the connection is rejected at the beginning of the TCP
> handshake. See in net/ipv4/tcp_ipv4.c:tcp_v4_err for more details.
> 
> Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
> ---
>  .../bpf/prog_tests/icmp_send_kfunc.c          | 149 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/icmp_send.c |  38 +++++
>  2 files changed, 187 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
>  create mode 100644 tools/testing/selftests/bpf/progs/icmp_send.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> new file mode 100644
> index 000000000000..0dc6b6ceafb4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> @@ -0,0 +1,149 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +#include <linux/errqueue.h>
> +#include <poll.h>
> +#include "icmp_send.skel.h"
> +
> +#define TIMEOUT_MS 1000
> +
> +#define ICMP_DEST_UNREACH 3
> +
> +#define ICMP_FRAG_NEEDED 4
> +#define NR_ICMP_UNREACH 15
> +
> +static int connect_to_fd_nonblock(int server_fd)
> +{
> +	struct sockaddr_storage addr;
> +	socklen_t len = sizeof(addr);
> +	int fd, err;
> +
> +	if (getsockname(server_fd, (struct sockaddr *)&addr, &len))
> +		return -1;
> +
> +	fd = socket(addr.ss_family, SOCK_STREAM | SOCK_NONBLOCK, 0);
> +	if (fd < 0)
> +		return -1;
> +
> +	err = connect(fd, (struct sockaddr *)&addr, len);
> +	if (err < 0 && errno != EINPROGRESS) {
> +		close(fd);
> +		return -1;
> +	}
> +
> +	return fd;
> +}
> +
> +static void read_icmp_errqueue(int sockfd, int expected_code)
> +{
> +	struct sock_extended_err *sock_err;
> +	char ctrl_buf[512];
> +	struct msghdr msg = {
> +		.msg_control = ctrl_buf,
> +		.msg_controllen = sizeof(ctrl_buf),
> +	};
> +	struct pollfd pfd = {
> +		.fd = sockfd,
> +		.events = POLLERR,
> +	};
> +	struct cmsghdr *cm;
> +	ssize_t n;
> +
> +	if (!ASSERT_GE(poll(&pfd, 1, TIMEOUT_MS), 1, "poll_errqueue"))
> +		return;
> +
> +	n = recvmsg(sockfd, &msg, MSG_ERRQUEUE);
> +	if (!ASSERT_GE(n, 0, "recvmsg_errqueue"))
> +		return;
> +
> +	cm = CMSG_FIRSTHDR(&msg);
> +	if (!ASSERT_NEQ(cm, NULL, "cm_firsthdr_null"))
> +		return;
> +
> +	for (; cm; cm = CMSG_NXTHDR(&msg, cm)) {
> +		if (cm->cmsg_level != IPPROTO_IP || cm->cmsg_type != IP_RECVERR)
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
> +		return;
> +	}
> +
> +	ASSERT_FAIL("no IP_RECVERR/IPV6_RECVERR control message found");
> +}
> +
> +static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel, int code)
> +{
> +	int srv_fd = -1, client_fd = -1;
> +	struct sockaddr_in addr;
> +	socklen_t len = sizeof(addr);
> +
> +	srv_fd = start_server(AF_INET, SOCK_STREAM, "127.0.0.1", 0, TIMEOUT_MS);
> +	if (!ASSERT_GE(srv_fd, 0, "start_server"))
> +		return;
> +
> +	if (getsockname(srv_fd, (struct sockaddr *)&addr, &len)) {
> +		close(srv_fd);
> +		return;
> +	}
> +	skel->bss->server_port = ntohs(addr.sin_port);
> +	skel->bss->unreach_code = code;
> +
> +	client_fd = connect_to_fd_nonblock(srv_fd);
> +	if (!ASSERT_OK_FD(client_fd, "client_connect_nonblock")) {
> +		close(srv_fd);
> +		return;
> +	}
> +
> +	/* Skip reading ICMP error queue if code is invalid */
> +	if (code >= 0 && code <= NR_ICMP_UNREACH)
> +		read_icmp_errqueue(client_fd, code);
> +
> +	close(client_fd);
> +	close(srv_fd);
> +}
> +
> +void test_icmp_send_unreach_cgroup(void)
> +{
> +	struct icmp_send *skel;
> +	int cgroup_fd = -1;
> +
> +	skel = icmp_send__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel_open"))
> +		goto cleanup;
> +
> +	cgroup_fd = test__join_cgroup("/icmp_send_unreach_cgroup");
> +	if (!ASSERT_OK_FD(cgroup_fd, "join_cgroup"))
> +		goto cleanup;
> +
> +	skel->links.egress =
> +		bpf_program__attach_cgroup(skel->progs.egress, cgroup_fd);
> +	if (!ASSERT_OK_PTR(skel->links.egress, "prog_attach_cgroup"))
> +		goto cleanup;
> +
> +	for (int code = 0; code <= NR_ICMP_UNREACH; code++) {
> +		/* The TCP stack reacts differently when asking for
> +		 * fragmentation, let's ignore it for now.
> +		 */
> +		if (code == ICMP_FRAG_NEEDED)
> +			continue;
> +
> +		trigger_prog_read_icmp_errqueue(skel, code);
> +		ASSERT_EQ(skel->data->kfunc_ret, 0, "kfunc_ret");
> +	}
> +
> +	/* Test an invalid code */
> +	trigger_prog_read_icmp_errqueue(skel, -1);
> +	ASSERT_EQ(skel->data->kfunc_ret, -EINVAL, "kfunc_ret");
> +
> +cleanup:
> +	icmp_send__destroy(skel);
> +	close(cgroup_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/icmp_send.c b/tools/testing/selftests/bpf/progs/icmp_send.c
> new file mode 100644
> index 000000000000..6d0be0a9afe1
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/icmp_send.c
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +/* 127.0.0.1 in host byte order */
> +#define SERVER_IP 0x7F000001
> +
> +#define ICMP_DEST_UNREACH 3
> +
> +__u16 server_port = 0;
> +int unreach_code = 0;
> +int kfunc_ret = -1;
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
> +	    tcph->dest != bpf_htons(server_port))
> +		return SK_PASS;
> +
> +	kfunc_ret = bpf_icmp_send(skb, ICMP_DEST_UNREACH, unreach_code);
> +
> +	return SK_DROP;
> +}
> +
> +char LICENSE[] SEC("license") = "Dual BSD/GPL";
> --
> 2.34.1
> 

Reviewed-by: Jordan Rife <jordan@jrife.io>
