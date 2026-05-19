Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5528F22576E
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 01:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779154446; cv=none; b=OVCKiJ7UhyCmDBEyOGBlytNnMrvvDdbC+FW4Ya4bTZfqUpuGlmD4UbIIPfCqhYDJEQfIWSjODskWn39dTL0ifVN2DLtJ/gQdaiDSFNZGN3jt7H/KpKSgO6purW/4LOy9FO9oMPtWh+Tnk32SpTGhyd/HUZgW/pHgm/0BVHKGG3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779154446; c=relaxed/simple;
	bh=AmBQrv7bGhZxxnssPV19XZEMDfMCZYZwefyDBqlF0sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUjoygQnT/H9hWQxC28zyzWQaYWpEinrxrO/y4errMyFO68OtCxaab4obsv/WoIN9KQV1hVF3rEvCcQZGslDbcPVsz90GKExEOMiUeYMPnhH6XOESSk+QxXQGbZaeVN1uBAYYHYQxaDbo0uxOMqX7FI4S80EfX3cyCYleHdTTBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io; spf=none smtp.mailfrom=jrife.io; dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b=sQim9IdP; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=jrife.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b="sQim9IdP"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b9a1896db5so5950555ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 18:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrife-io.20251104.gappssmtp.com; s=20251104; t=1779154445; x=1779759245; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pINLyxS4eQ1pTpZaDnr3VCbQL4QP6sJ4Z3GfPCiP49I=;
        b=sQim9IdP4eU8JOE+36nC+mN1SrXuEnqwVWg3Rs4hlXDk5ZVHhqGq5XquuEWASYZ96v
         ui6uzmu6PTAXqqQ9r6ujjJRCUNymtPTkPfLB8Xi2x+UoDUmzGvUyNQHgbLV59Psm1A63
         f2GQ9+AnNiXcAOpXDbd+8Z+3Fw7F0mh6+/S7K8zN8bhvv3hraeL8cwqZkMkwBKVIIHYq
         5JDYWu9QH6m6CRqXi2zn9x/tzP9psNNixq2aUx+pIDF5KlDmnVrdE2S3YI/sAibyin0p
         OiMQpINIztfikrxvaAKylZSP1QQdvB+rNiQQpaDMVqqtliqYTlpJKHA3iy9MJSLLixLZ
         tkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779154445; x=1779759245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pINLyxS4eQ1pTpZaDnr3VCbQL4QP6sJ4Z3GfPCiP49I=;
        b=PkOsZMt3e5P5oxIIsZ38q1CvHo0EsPAok7chL+cHbC95W7T2yjfDDngEv8ntsUYV8x
         4I3X4BCqhUhb3i1K2CR4frtjWfiVjRzPCcV5uNCiUZd5mFZRz6c9dLGdsFKMPhUB1eTD
         YwOIqecdPGvMhMQ1fwwkjrhu9d13xP/Q6JK2HCJDf9TTLWy16KrQUB62dv66TDSqZn1e
         ZXC0ZBO4MbIhZrrTCpuNSrjExGrO6OnnQ/VhRvSqv/WfszZrxLvcU2vR8dxv5UwROuFt
         4HUDIfJD/LlYZz4yo2bVWB1AtPZpOAbpSMtOpUVtaFiWzDfKRnbcDx0ClmfhcN68+U/A
         ELsA==
X-Forwarded-Encrypted: i=1; AFNElJ/wDEdPS+Ma44RU9aBHhJbzPIFDG8ceW0OXXBjQUY+MRLueQmvRzeqcLT2kGwIytXzWcPau5ffAl6toYGQ+zmQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEWSq+zPZVJQyDBJ+dHnaw8UHtNsTpShqqaKrgjJR0ZUTOSVk+
	wQlOqm71CsyLNef5A6wvJFz+EqYmL4LP0pwbzRYaWEgzT/j3A5plgQYDKNqkwIrqt94=
X-Gm-Gg: Acq92OFnfVF0uyVEBXpYFtx1Uz7AnsVAkq+tGyU2z4vExpTxlxPloM9ZESVQE9r5CjW
	SWGs5P19k1LV8JOKY2uwooruMjFsLmD4Mw00ZXbOx7HCvINn40Er6JxBLR2hJLJ3bZyTBuvw7Gd
	M9lcgb/BNVukaeSvwPB4PlF7BjyH/b1pHsnrgkmOQQRJnJJ/bksNghvzqcByWRO6Cp9SLIovqpB
	Gecas9gWjAWF+0ea0wuMlOFvw1mtBaIFELa8B6oMDcm9bayWMS1qyK36GqqBJGKqSML7dgrUzhi
	Sgpo/5tx3aOyrCfBeDHQACvpoFXZFuaYio0O9t6mlweYh+9FbMlvoplX61hQj6E8Rpz+zzNvCJs
	DaPLENDG3VSum3wJGFRXmh/jYH9si6rO2LX6r/iQrJNTFn9YgKvLwIdyOUu1HXorhw1sFqDcd9C
	9K73QcsYPKwTb0dLUuxhK76Lso
X-Received: by 2002:a17:903:1b45:b0:2ba:3376:2354 with SMTP id d9443c01a7336-2bd7e8b9c41mr97941405ad.5.1779154444744;
        Mon, 18 May 2026 18:34:04 -0700 (PDT)
Received: from m2 ([83.171.251.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d0fc4a9sm165471195ad.61.2026.05.18.18.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 18:34:04 -0700 (PDT)
Date: Mon, 18 May 2026 18:34:02 -0700
From: Jordan Rife <jordan@jrife.io>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net, 
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org, yonghong.song@linux.dev, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v6 4/6] selftests/bpf: add bpf_icmp_send kfunc
 tests
Message-ID: <q46w47cqezttz2otf76tncxu7sovhywy2dqwcbajigp64uhbtz@eimvxfeeexuz>
References: <20260518122842.218522-1-mahe.tardy@gmail.com>
 <20260518122842.218522-5-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518122842.218522-5-mahe.tardy@gmail.com>

On Mon, May 18, 2026 at 12:28:40PM +0000, Mahe Tardy wrote:
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
>  .../bpf/prog_tests/icmp_send_kfunc.c          | 152 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/icmp_send.c |  38 +++++
>  2 files changed, 190 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
>  create mode 100644 tools/testing/selftests/bpf/progs/icmp_send.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> new file mode 100644
> index 000000000000..4f0aed8152d3
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> @@ -0,0 +1,152 @@
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

Is the only customization here SOCK_NONBLOCK? Would it be possible to
simply extend network_helper_opts to make it possible via the existing
connect_to_fd_opts? Alternatively, is it possible to test with
SOCK_DGRAM to avoid the handshake timeout issue?

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
> +	ssize_t n;

very small nit: Other functions follow reverse xmas tree order but this
one doesn't which looks kind of weird.

> +	struct sock_extended_err *sock_err;
> +	struct cmsghdr *cm;
> +	char ctrl_buf[512];
> +	struct msghdr msg = {
> +		.msg_control = ctrl_buf,
> +		.msg_controllen = sizeof(ctrl_buf),
> +	};
> +	struct pollfd pfd = {
> +		.fd = sockfd,
> +		.events = POLLERR,
> +	};
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
> +		if (cm->cmsg_level != IPPROTO_IP ||
> +		    cm->cmsg_type != IP_RECVERR)
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
> +static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel,
> +					    int code)
> +{
> +	int srv_fd = -1, client_fd = -1;
> +	struct sockaddr_in addr;
> +	socklen_t len = sizeof(addr);
> +
> +	srv_fd = start_server(AF_INET, SOCK_STREAM, "127.0.0.1", 0,
> +			      TIMEOUT_MS);
> +	if (!ASSERT_GE(srv_fd, 0, "start_server"))
> +		return;

ASSERT_OK_FD

> +
> +	if (getsockname(srv_fd, (struct sockaddr *)&addr, &len)) {
> +		close(srv_fd);
> +		return;
> +	}
> +	skel->bss->server_port = ntohs(addr.sin_port);
> +	skel->bss->unreach_code = code;
> +
> +	client_fd = connect_to_fd_nonblock(srv_fd);
> +	if (!ASSERT_GE(client_fd, 0, "client_connect_nonblock")) {

ASSERT_OK_FD

> +		close(srv_fd);
> +		return;
> +	}
> +
> +	/* Skip reading ICMP error queue if code is invalid */
> +	if (code >= 0 && code <= NR_ICMP_UNREACH)
> +		read_icmp_errqueue(client_fd, code);
> +

Consider doing all cleanup here and just adding a goto label like
cleanup in test_icmp_send_unreach?

> +	close(client_fd);
> +	close(srv_fd);
> +}
> +
> +void test_icmp_send_unreach(void)
> +{
> +	struct icmp_send *skel;
> +	int cgroup_fd = -1;
> +
> +	skel = icmp_send__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel_open"))
> +		goto cleanup;
> +
> +	cgroup_fd = test__join_cgroup("/icmp_send_unreach_cgroup");
> +	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
> +		goto cleanup;

ASSERT_OK_FD

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

if (cgroup_fd != -1)
	close(cgroup_fd);

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

No test for TC?

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

Jordan
