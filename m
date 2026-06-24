Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AD9254B1F
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 07:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782286289; cv=none; b=H2mKFOxCMEEQKSHdy7G9sqvri2czXg5NzlV9Ah64EO97bblPHd6NsYnD0cKxXhe+k7KYOWV5p3rk0pUEHfKW8dieQUdruef7XrFFgtfKDMKlvz1hawvPNRhWgQRGA59E1tTDnupIZ/sqJ5hiQ9TCsKzKfMOeO+5Bg2HRNifs2EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782286289; c=relaxed/simple;
	bh=Zp0NmGUu3v2qQp+kbHyfOeFP8Tnp5EOY/oK5Sas0i4w=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=n2PfdmsSfDBHPKEBHfok/6sNfgs3fy4ekXzOQlz+VYXf6sfF4+VLi3fVZop5MH8nP2i4JUtuF6mINHs4pboUnKvXyyDE1E0wp53qSQZ5ATtMHSGtbaOjemrXiGOsQ4TEBZvfuehx1RD9dDzTTmNDMWMnGmlq6tx7NHYUNvNM0w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com; spf=pass smtp.mailfrom=etsalapatis.com; dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b=HM58Dxy8; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b="HM58Dxy8"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c85822059d8so444919a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 00:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1782286287; x=1782891087; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BAJJH/ybZpPMvXsT28V1SA6Kd2qO7VgQ4QZr4Jxcy2Q=;
        b=HM58Dxy8Fm1ptL0+efcnmO+YEUUoFKTCcUxvIbNOQ3XQ5QdMr3jvQMIoFZCl6CF4Hc
         QabDUdENY4WFbkwYLY861Yk2a7F6Hj1TcUlidT444AnLEicjsVmlmjrHrBYBFTzPiI0H
         pMAo9GOAFplDgrNg8KwA3pTAKSwB/Ej4cBOwFWscMbH6QPuwvvGqjxxklrPfIme4GjEs
         IEB4+T98NG1cQmm50803zx6gAS8q7w5fl3GJlVYQRTsqjtbD+OklKA1llrYzA+5cL9aN
         Dj71cuXOrv7kfpmo+V3h1kXD/544QvfemMlTW73aLuhjVvdapw7wyVOsX33bgg5aIRzP
         87GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782286287; x=1782891087;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BAJJH/ybZpPMvXsT28V1SA6Kd2qO7VgQ4QZr4Jxcy2Q=;
        b=p1zf5K6mQXy71rP8HQtOzfVX2TIPapP7XbauvvKANQMaCQjY6oNODkaqmngMSphYsd
         ppWf9JJfRe5p3G98nxfm4r8GI9QcHR55gshKTpc+z7DXjZubQajL5JtgrANJ9LilWO5L
         YZm5bKxvsmYIZqajtQs/HpzjAPLriW9nqm72yT/AFA6tGRY0Xz0QosEAFrFsyC/nuaq+
         uwKM0xRUPZnl4UXAS4U/PiLff0RKQrYFkjApBf+iIoJuyLpgA0cJyzw+d5OleufyDbso
         Jrq40s+MvIxOZxEOtFFNhoxAwg+3MJadVZM58p+U/59UuVt1oBNuZbB4e/u3sO+eNPV+
         9cCA==
X-Forwarded-Encrypted: i=1; AFNElJ+cGdAutpQN5dsAdvTFE5U6N4URBtjG3DuwbtkvgFQ1ffS2vAM+DJ1Bf2jHJb4/oAUaiq/zAu+KTCZHGimDHy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgMto8i2CoQIU7lRVJRHp0jsrJbNI4iMIRYESvv21w0AMADWXq
	vUMshoLMRFdPlVR2qDWfMbFwQG5YrCQF702hykIjDx0rxHRrR/n/ZGo2Aflx442FdRY=
X-Gm-Gg: AfdE7clNqSBw0pXWxOWinI1lce9zg1fwFLwmnG2vMJvA7kwpfzzHaHx3LEZtErftd0c
	QB4PvnhR/jnkKNvT2rklXt9jbRhgm08nzOQqNu7Fvk8VXkfE4RV5lRLnIt8JaSTa6HE7cufZYC2
	/vZJw0bmkCIlRYGxUXq4ZwQtzNc+ebKfjDYIYtShz54A9wWW9tVsvj2Tqzh5zswlgu8rjHSLrMO
	d9/TyIl7f2E4qmXPZwv0AZ6xuVKArT9cCu/3n3Mm6CcBIViirvOqVUtRaDshDxLjG6suNSErPF8
	hUuYdowJy2/fr6bTim74tTfxfZO2r6jAFA7+RZYWCwhYiLiQGUgO+PwIvFLIZtPmqWcC/niOGbK
	X8ym1/yGl1SRiUI58veveXkRjEdZSj58uUPLV6NiMJBwsCMyMJ9openVMFexipZtwzpIPPSAZX1
	vnGuI3qD4NwI7aNA==
X-Received: by 2002:a05:6a21:3399:b0:3bb:2200:f680 with SMTP id adf61e73a8af0-3bd2d21fac8mr2742500637.25.1782286286990;
        Wed, 24 Jun 2026 00:31:26 -0700 (PDT)
Received: from localhost ([2605:8d80:5c40:7b14:89ba:fd93:9852:c9eb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8bc2c8d8a9sm12022117a12.5.2026.06.24.00.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 00:31:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 24 Jun 2026 03:31:25 -0400
Message-Id: <DJH3RC5R8W8E.2T8JRUAQDPT23@etsalapatis.com>
To: "Mahe Tardy" <mahe.tardy@gmail.com>, <bpf@vger.kernel.org>
Cc: <andrii@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
 <edumazet@google.com>, <john.fastabend@gmail.com>, <jordan@jrife.io>,
 <kuba@kernel.org>, <martin.lau@linux.dev>, <netdev@vger.kernel.org>,
 <netfilter-devel@vger.kernel.org>, <pabeni@redhat.com>,
 <yonghong.song@linux.dev>
Subject: Re: [PATCH bpf-next v8 7/7] selftests/bpf: add bpf_icmp_send
 recursion test
From: "Emil Tsalapatis" <emil@etsalapatis.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260622120515.137082-1-mahe.tardy@gmail.com>
 <20260622120515.137082-8-mahe.tardy@gmail.com>
In-Reply-To: <20260622120515.137082-8-mahe.tardy@gmail.com>

On Mon Jun 22, 2026 at 8:05 AM EDT, Mahe Tardy wrote:
> This test is similar to test_icmp_send_unreach_cgroup but checks that,
> in case of recursion, meaning that the BPF program calling the kfunc was
> re-triggered by the icmp_send done by the kfunc, the kfunc will stop
> early and return -EBUSY.
>
> The test attaches to the root cgroup to ensure the ICMP packet generated
> by the kfunc re-triggers the BPF program. Since it's attached only for
> this recursion test, it should not disrupt the whole network.
>
> Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

> ---
>  .../bpf/prog_tests/icmp_send_kfunc.c          | 45 +++++++++++++++
>  tools/testing/selftests/bpf/progs/icmp_send.c | 56 +++++++++++++++++++
>  2 files changed, 101 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/t=
ools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> index 66447681f72d..fd4b8fa78a01 100644
> --- a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> +++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
> @@ -1,8 +1,10 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <test_progs.h>
>  #include <network_helpers.h>
> +#include <cgroup_helpers.h>
>  #include <linux/errqueue.h>
>  #include <poll.h>
> +#include <unistd.h>
>  #include "icmp_send.skel.h"
>
>  #define TIMEOUT_MS 1000
> @@ -10,6 +12,7 @@
>  #define ICMP_DEST_UNREACH 3
>  #define ICMPV6_DEST_UNREACH 1
>
> +#define ICMP_HOST_UNREACH 1
>  #define ICMP_FRAG_NEEDED 4
>  #define NR_ICMP_UNREACH 15
>  #define ICMPV6_REJECT_ROUTE 6
> @@ -203,3 +206,45 @@ void test_icmp_send_unreach_tc(void)
>  	bpf_link__destroy(link);
>  	icmp_send__destroy(skel);
>  }
> +
> +void test_icmp_send_unreach_recursion(void)
> +{
> +	struct icmp_send *skel;
> +	int cgroup_fd =3D -1;
> +
> +	skel =3D icmp_send__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel_open"))
> +		goto cleanup;
> +
> +	if (setup_cgroup_environment()) {
> +		fprintf(stderr, "Failed to setup cgroup environment\n");
> +		goto cleanup;
> +	}
> +
> +	cgroup_fd =3D get_root_cgroup();
> +	if (!ASSERT_OK_FD(cgroup_fd, "get_root_cgroup"))
> +		goto cleanup;
> +
> +	skel->data->target_pid =3D getpid();
> +	skel->links.recursion =3D
> +		bpf_program__attach_cgroup(skel->progs.recursion, cgroup_fd);
> +	if (!ASSERT_OK_PTR(skel->links.recursion, "prog_attach_cgroup"))
> +		goto cleanup;
> +
> +	trigger_prog_read_icmp_errqueue(skel, ICMP_HOST_UNREACH, AF_INET,
> +					"127.0.0.1");
> +
> +	/*
> +	 * Because there's recursion involved, the first call will return at
> +	 * index 1 since it will return the second, and the second call will
> +	 * return at index 0 since it will return the first.
> +	 */
> +	ASSERT_EQ(skel->data->rec_kfunc_rets[0], -EBUSY, "kfunc_rets[0]");
> +	ASSERT_EQ(skel->data->rec_kfunc_rets[1], 0, "kfunc_rets[1]");
> +
> +cleanup:
> +	cleanup_cgroup_environment();
> +	icmp_send__destroy(skel);
> +	if (cgroup_fd >=3D 0)
> +		close(cgroup_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/icmp_send.c b/tools/testin=
g/selftests/bpf/progs/icmp_send.c
> index 5fa5467bdb70..fd9c7684797b 100644
> --- a/tools/testing/selftests/bpf/progs/icmp_send.c
> +++ b/tools/testing/selftests/bpf/progs/icmp_send.c
> @@ -13,6 +13,10 @@ __u16 server_port =3D 0;
>  int unreach_type =3D 0;
>  int unreach_code =3D 0;
>  int kfunc_ret =3D -1;
> +int target_pid =3D -1;
> +
> +unsigned int rec_count =3D 0;
> +int rec_kfunc_rets[] =3D { -1, -1 };
>
>  SEC("cgroup_skb/egress")
>  int egress(struct __sk_buff *skb)
> @@ -125,4 +129,56 @@ int tc_egress(struct __sk_buff *skb)
>  	return TCX_DROP;
>  }
>
> +SEC("cgroup_skb/egress")
> +int recursion(struct __sk_buff *skb)
> +{
> +	void *data =3D (void *)(long)skb->data;
> +	void *data_end =3D (void *)(long)skb->data_end;
> +	struct icmphdr *icmph;
> +	struct tcphdr *tcph;
> +	struct iphdr *iph;
> +	int ret;
> +
> +	if ((bpf_get_current_pid_tgid() >> 32) !=3D target_pid)
> +		return SK_PASS;
> +
> +	iph =3D data;
> +	if ((void *)(iph + 1) > data_end || iph->version !=3D 4)
> +		return SK_PASS;
> +
> +	if (iph->daddr !=3D bpf_htonl(SERVER_IP))
> +		return SK_PASS;
> +
> +	if (iph->protocol =3D=3D IPPROTO_TCP) {
> +		tcph =3D (void *)iph + iph->ihl * 4;
> +		if ((void *)(tcph + 1) > data_end ||
> +		    tcph->dest !=3D bpf_htons(server_port))
> +			return SK_PASS;
> +	} else if (iph->protocol =3D=3D IPPROTO_ICMP) {
> +		icmph =3D (void *)iph + iph->ihl * 4;
> +		if ((void *)(icmph + 1) > data_end ||
> +		    icmph->type !=3D unreach_type ||
> +		    icmph->code !=3D unreach_code)
> +			return SK_PASS;
> +	} else {
> +		return SK_PASS;
> +	}
> +
> +	/*
> +	 * This call will provoke a recursion: the ICMP packet generated by the
> +	 * kfunc will re-trigger this program since we are in the root cgroup i=
n
> +	 * which the kernel ICMP socket belongs. However when re-entering the
> +	 * kfunc, it should return EBUSY.
> +	 */
> +	ret =3D bpf_icmp_send(skb, unreach_type, unreach_code);
> +	rec_kfunc_rets[rec_count & 1] =3D ret;
> +	__sync_fetch_and_add(&rec_count, 1);
> +
> +	/* Let the first ICMP error message pass */
> +	if (iph->protocol =3D=3D IPPROTO_ICMP)
> +		return SK_PASS;
> +
> +	return SK_DROP;
> +}
> +
>  char LICENSE[] SEC("license") =3D "Dual BSD/GPL";
> --
> 2.34.1

