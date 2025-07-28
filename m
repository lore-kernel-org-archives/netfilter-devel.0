Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2673273D6B
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 15:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753717272; cv=none; b=LUqS3V+wLpggPyscwW9Za6sTaDP6u6TxFNkFZ2Blzoj8j5So0WKENDg3wLwI+h5Af63MHIDNaY9rlduhlXJkK+j97ttZwkSyquW17xN/BONbx8e7+0bb/naSVNsboDKCS/pbiqnZnIM/j7vYujZesfBOZVy9RfZJv7OLQ+LFiEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753717272; c=relaxed/simple;
	bh=2+Yrpurr159V+PWP6gA7KCnz3U/Uvt1diPHivVM8w8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VTPsxIadAyNonNd1XxlDpjIUWWUotDt+Gpp5c6y1hsIpX2ACcAyw5m0YFxzwRqjax2pcs45PKJ0mn6QGCiM9ZWGgif9ts7smbtrfSopOymUvHoCS3J4uFQM08R1iHaZtH/qnOsA6LKA39ZDxC8bxIYF7jsiSPW51bGLR+/7RnqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EZZO6WEp; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EZZO6WEp"
Message-ID: <356fe0b5-b66e-475b-b914-919339bb441a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753717257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3P5d/fh6qV7y811Tr+D1Od6XgOnz0idhvbTB8C4epYE=;
	b=EZZO6WEpjfZHdNVXRxYJJpR23h6oploTAX0MJXz2v47dmSFJnpHYiplZ29VMjTnwkFxZxH
	eYyI2ELRx0dIRleA5/78kroc0TAM+bkb1/xj1FyqKsrU92Z2vj+CjDtC/TtRArFK0Gw7R1
	0BAQCQRkkZo0RKNlBk2Gzxkeg4d1ic0=
Date: Mon, 28 Jul 2025 08:40:49 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 4/4] selftests/bpf: add icmp_send_unreach
 kfunc tests
Content-Language: en-GB
To: Mahe Tardy <mahe.tardy@gmail.com>, lkp@intel.com
Cc: alexei.starovoitov@gmail.com, andrii@kernel.org, ast@kernel.org,
 bpf@vger.kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
 fw@strlen.de, john.fastabend@gmail.com, martin.lau@linux.dev,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev, pablo@netfilter.org
References: <202507270940.kXGmRbg5-lkp@intel.com>
 <20250728094345.46132-1-mahe.tardy@gmail.com>
 <20250728094345.46132-5-mahe.tardy@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <20250728094345.46132-5-mahe.tardy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/28/25 2:43 AM, Mahe Tardy wrote:
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
>   .../bpf/prog_tests/icmp_send_unreach_kfunc.c  | 99 +++++++++++++++++++
>   .../selftests/bpf/progs/icmp_send_unreach.c   | 36 +++++++
>   2 files changed, 135 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c
>   create mode 100644 tools/testing/selftests/bpf/progs/icmp_send_unreach.c
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

Should set client_fd = -1? See below ...

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

Otherwise if client_fd = 1, goto for_cleanup will close(1).

> +
> +		client_fd = socket(AF_INET, SOCK_STREAM, 0);
> +		ASSERT_GE(client_fd, 0, "client_socket");

The above two lines are not necessary since client_fd is
actually set in the below.

> +
> +		client_fd = connect_to_fd(srv_fd, 0);
> +		if (!ASSERT_GE(client_fd, 0, "client_connect"))
> +			goto for_cleanup;
> +
> +		read_icmp_errqueue(client_fd, *code);
> +
> +		ASSERT_EQ(skel->bss->kfunc_ret, SK_DROP, "kfunc_ret");
> +for_cleanup:
> +		close(client_fd);
> +		close(srv_fd);
> +	}
> +
> +cleanup:
> +	icmp_send_unreach__destroy(skel);
> +	close(cgroup_fd);
> +}
[...]
