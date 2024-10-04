Received: from smtp-8fad.mail.infomaniak.ch (smtp-8fad.mail.infomaniak.ch [83.166.143.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C934013E02E
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Oct 2024 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728036870; cv=none; b=jrpEf9U2K/pePlXRxUAl8joBpRboWUa2/YTk8eVi9+4Z61+9zZITh6BA20yW/c6w1deUphRqnNmDOw+GBseuTJwlAJfmK7jglX+TpaKaD1x8zdMd1dmQ0J8j/8ZTRkRmM45q1hUegV7Ji8uiKbCrQwrFM7touGU1A7Vv1zWIC7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728036870; c=relaxed/simple;
	bh=9jWiIpX05LSSZp8Ogukw1p0Wz4ZMz/wTpU5oVh8C7m8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=tNViWtkLyLzjXZl6/Lra8PLQs7tvit4wT2LVM1IM9r3pZuAS9dnaSIb2Fn3wq2chrqUmpPkFPgCfBnMrfuUkdfplKE9b8fLFX6Py7Vm+BhAVAaIQT5Vf1dorLD9WrtzPeT3U5u4fb4BA37Trz/QJ3KNzJXG8qmtAA9jmGjJY80g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=NgrFkqx6; arc=none smtp.client-ip=83.166.143.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="NgrFkqx6"
Received: from smtp-4-0001.mail.infomaniak.ch (unknown [IPv6:2001:1600:7:10:40ca:feff:fe05:1])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4XKkt16YbNzPHt;
	Fri,  4 Oct 2024 12:14:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1728036857;
	bh=WdKCD0/gPr8kNHaTWIOqAKe3foWfd3Ja4b9zE52EEf8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=NgrFkqx6jckHZNTzcPDgMB8JX9sz3zoh5K0kyuO93NYdchU1/9OOO0os7TF8N+Xee
	 1ZiEksrjkx8FZpMkXM/H8uHHFz2oQ+gvsMjKYWjdw6weS+sBVYubyv/vpJDiwTg/7G
	 zuo2CT2AH6/Y45kU89miABa76ocX21pfM+B+nGv0=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4XKkt053xYzJ2T;
	Fri,  4 Oct 2024 12:14:16 +0200 (CEST)
Date: Fri, 4 Oct 2024 12:14:14 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>, 
	Eric Dumazet <edumazet@google.com>, Vlad Yasevich <vyasevich@gmail.com>, 
	Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>
Cc: gnoack@google.com, willemdebruijn.kernel@gmail.com, 
	Paul Moore <paul@paul-moore.com>, Alexey Kodanev <alexey.kodanev@oracle.com>, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	Matthieu Buffet <matthieu@buffet.re>
Subject: Re: [RFC PATCH v1 2/2] selftests/landlock: Test non-TCP INET
 connection-based protocols
Message-ID: <20241004.Hohpheipieh2@digikod.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b58680ca-81b2-7222-7287-0ac7f4227c3c@huawei-partners.com>
X-Infomaniak-Routing: alpha

Eric, Vlad, Neil, and David, there might be a bug in the SCTP
implementation:

Paul, Alexey, there is a bug in the SELinux hooks for SCTP:

On Fri, Oct 04, 2024 at 12:22:42AM +0300, Mikhail Ivanov wrote:
> 
> 
> On 10/3/2024 8:45 PM, Mickaël Salaün wrote:
> > On Thu, Oct 03, 2024 at 10:39:32PM +0800, Mikhail Ivanov wrote:
> > > Extend protocol fixture with test suits for MPTCP, SCTP and SMC protocols.
> > > Add all options required by this protocols in config.
> > 
> > Great coverage!  It's nice to check against SCTP and MPTCP, but as you
> > were wondering, I think you can remove the SMC protocol to simplify
> > tests. MPTCP seems to work similarly as TCP wrt AF_UNSPEC, so it might
> > be worth keeping it, and we might want to control these protocols too
> > one day.
> 
> Thanks! I'll remove SMC then.
> 
> > 
> > > 
> > > Extend protocol_variant structure with protocol field (Cf. socket(2)).
> > > 
> > > Refactor is_restricted() helper and add few helpers to check struct
> > > protocol_variant on specific protocols.
> > 
> > > 
> > > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> > > ---
> > >   tools/testing/selftests/landlock/common.h   |   1 +
> > >   tools/testing/selftests/landlock/config     |   5 +
> > >   tools/testing/selftests/landlock/net_test.c | 212 ++++++++++++++++++--
> > >   3 files changed, 198 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
> > > index 61056fa074bb..40a2def50b83 100644
> > > --- a/tools/testing/selftests/landlock/common.h
> > > +++ b/tools/testing/selftests/landlock/common.h
> > > @@ -234,6 +234,7 @@ enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
> > >   struct protocol_variant {
> > >   	int domain;
> > >   	int type;
> > > +	int protocol;
> > >   };
> > >   struct service_fixture {
> > > diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
> > > index 29af19c4e9f9..73b01d7d0881 100644
> > > --- a/tools/testing/selftests/landlock/config
> > > +++ b/tools/testing/selftests/landlock/config
> > > @@ -1,8 +1,12 @@
> > >   CONFIG_CGROUPS=y
> > >   CONFIG_CGROUP_SCHED=y
> > >   CONFIG_INET=y
> > > +CONFIG_INFINIBAND=y
> > 
> > Without SMC this infiniband should not be required.
> 
> yeap
> 
> > 
> > > +CONFIG_IP_SCTP=y
> > >   CONFIG_IPV6=y
> > >   CONFIG_KEYS=y
> > > +CONFIG_MPTCP=y
> > > +CONFIG_MPTCP_IPV6=y
> > >   CONFIG_NET=y
> > >   CONFIG_NET_NS=y
> > >   CONFIG_OVERLAY_FS=y
> > > @@ -10,6 +14,7 @@ CONFIG_PROC_FS=y
> > >   CONFIG_SECURITY=y
> > >   CONFIG_SECURITY_LANDLOCK=y
> > >   CONFIG_SHMEM=y
> > > +CONFIG_SMC=y
> > >   CONFIG_SYSFS=y
> > >   CONFIG_TMPFS=y
> > >   CONFIG_TMPFS_XATTR=y
> > > diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> > > index 4e0aeb53b225..dbe77d436281 100644
> > > --- a/tools/testing/selftests/landlock/net_test.c
> > > +++ b/tools/testing/selftests/landlock/net_test.c
> > > @@ -36,6 +36,17 @@ enum sandbox_type {
> > >   	TCP_SANDBOX,
> > >   };
> > > +/* Checks if IPPROTO_SMC is present for compatibility reasons. */
> > > +#if !defined(__alpha__) && defined(IPPROTO_SMC)
> > > +#define SMC_SUPPORTED 1
> > > +#else
> > > +#define SMC_SUPPORTED 0
> > > +#endif
> > > +
> > > +#ifndef IPPROTO_SMC
> > > +#define IPPROTO_SMC 256
> > > +#endif
> > > +
> > >   static int set_service(struct service_fixture *const srv,
> > >   		       const struct protocol_variant prot,
> > >   		       const unsigned short index)
> > > @@ -85,19 +96,37 @@ static void setup_loopback(struct __test_metadata *const _metadata)
> > >   	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
> > >   }
> > > +static bool prot_is_inet_stream(const struct protocol_variant *const prot)
> > > +{
> > > +	return (prot->domain == AF_INET || prot->domain == AF_INET6) &&
> > > +	       prot->type == SOCK_STREAM;
> > > +}
> > > +
> > > +static bool prot_is_tcp(const struct protocol_variant *const prot)
> > > +{
> > > +	return prot_is_inet_stream(prot) &&
> > > +	       (prot->protocol == IPPROTO_TCP || prot->protocol == IPPROTO_IP);
> > 
> > Why do we need to check against IPPROTO_IP?
> 
> IPPROTO_IP = 0 and can be used as an alias for IPPROTO_TCP (=6) in
> socket(2) (also for IPPROTO_UDP(=17), Cf. inet_create).
> 
> Since we create TCP sockets in a common way here (with protocol = 0),
> checking against IPPROTO_TCP is not necessary, but I decided to leave it
> for completeness.

Sound good, but we should then also add variants with IPPROTO_TCP for
sandboxed and not-sandboxed tests:

/* clang-format off */
FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp1) {
	/* clang-format on */
	.sandbox = NO_SANDBOX,
	.prot = {
		.domain = AF_INET,
		.type = SOCK_STREAM,
		/* IPPROTO_IP == 0 */
		.protocol = IPPROTO_IP,
	},
};


/* clang-format off */
FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp2) {
	/* clang-format on */
	.sandbox = NO_SANDBOX,
	.prot = {
		.domain = AF_INET,
		.type = SOCK_STREAM,
		.protocol = IPPROTO_TCP,
	},
};

> 
> > 
> > > +}
> > > +
> > > +static bool prot_is_sctp(const struct protocol_variant *const prot)
> > > +{
> > > +	return prot_is_inet_stream(prot) && prot->protocol == IPPROTO_SCTP;
> > > +}
> > > +
> > > +static bool prot_is_smc(const struct protocol_variant *const prot)
> > > +{
> > > +	return prot_is_inet_stream(prot) && prot->protocol == IPPROTO_SMC;
> > > +}
> > > +
> > > +static bool prot_is_unix_stream(const struct protocol_variant *const prot)
> > > +{
> > > +	return prot->domain == AF_UNIX && prot->type == SOCK_STREAM;
> > > +}
> > > +
> > >   static bool is_restricted(const struct protocol_variant *const prot,
> > >   			  const enum sandbox_type sandbox)
> > >   {
> > > -	switch (prot->domain) {
> > > -	case AF_INET:
> > > -	case AF_INET6:
> > > -		switch (prot->type) {
> > > -		case SOCK_STREAM:
> > > -			return sandbox == TCP_SANDBOX;
> > > -		}
> > > -		break;
> > > -	}
> > > -	return false;
> > > +	return prot_is_tcp(prot) && sandbox == TCP_SANDBOX;
> > >   }
> > >   static int socket_variant(const struct service_fixture *const srv)
> > > @@ -105,7 +134,7 @@ static int socket_variant(const struct service_fixture *const srv)
> > >   	int ret;
> > >   	ret = socket(srv->protocol.domain, srv->protocol.type | SOCK_CLOEXEC,
> > > -		     0);
> > > +		     srv->protocol.protocol);
> > >   	if (ret < 0)
> > >   		return -errno;
> > >   	return ret;
> > > @@ -124,7 +153,7 @@ static socklen_t get_addrlen(const struct service_fixture *const srv,
> > >   		return sizeof(srv->ipv4_addr);
> > >   	case AF_INET6:
> > > -		if (minimal)
> > > +		if (minimal && !prot_is_sctp(&srv->protocol))
> > 
> > Why SCTP requires this exception?
> 
> SCTP implementation (possibly incorrectly) checks that address length is
> at least sizeof(struct sockaddr_in6) (Cf. sctp_sockaddr_af() for bind(2)
> and in sctp_connect() for connect(2)).

sctp_sockaddr_af() checks for len < SIN6_LEN_RFC2133, but also for
len < af->sockaddr_len, which refers to sctp_af_inet6.sockaddr_len =
sizeof(struct sockaddr_in6).

I think this is a bug in the SCTP implementation and it would be a fix
of 81e98370293a ("sctp: sctp_sockaddr_af must check minimal addr length
for AF_INET6"), which fixes all versions of Linux.

> 
> > 
> > >   			return SIN6_LEN_RFC2133;
> > >   		return sizeof(srv->ipv6_addr);
> > > @@ -271,6 +300,11 @@ FIXTURE_SETUP(protocol)
> > >   		.type = SOCK_STREAM,
> > >   	};
> > > +#if !SMC_SUPPORTED
> > > +	if (prot_is_smc(&variant->prot))
> > > +		SKIP(return, "SMC protocol is not supported.");
> > > +#endif
> > > +
> > >   	disable_caps(_metadata);
> > >   	ASSERT_EQ(0, set_service(&self->srv0, variant->prot, 0));
> > > @@ -299,6 +333,39 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp) {
> > >   	},
> > >   };
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_mptcp) {
> > > +	/* clang-format on */
> > > +	.sandbox = NO_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_MPTCP,
> > > +	},
> > > +};
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_sctp) {
> > > +	/* clang-format on */
> > > +	.sandbox = NO_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_SCTP,
> > > +	},
> > > +};
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_smc) {
> > > +	/* clang-format on */
> > > +	.sandbox = NO_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_SMC,
> > > +	},
> > > +};
> > > +
> > >   /* clang-format off */
> > >   FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp) {
> > >   	/* clang-format on */
> > > @@ -309,6 +376,39 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp) {
> > >   	},
> > >   };
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_mptcp) {
> > > +	/* clang-format on */
> > > +	.sandbox = NO_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET6,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_MPTCP,
> > > +	},
> > > +};
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_sctp) {
> > > +	/* clang-format on */
> > > +	.sandbox = NO_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET6,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_SCTP,
> > > +	},
> > > +};
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_smc) {
> > > +	/* clang-format on */
> > > +	.sandbox = NO_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET6,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_SMC,
> > > +	},
> > > +};
> > > +
> > >   /* clang-format off */
> > >   FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_udp) {
> > >   	/* clang-format on */
> > > @@ -359,6 +459,39 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp) {
> > >   	},
> > >   };
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_mptcp) {
> > > +	/* clang-format on */
> > > +	.sandbox = TCP_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_MPTCP,
> > > +	},
> > > +};
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_sctp) {
> > > +	/* clang-format on */
> > > +	.sandbox = TCP_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_SCTP,
> > > +	},
> > > +};
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_smc) {
> > > +	/* clang-format on */
> > > +	.sandbox = TCP_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_SMC,
> > > +	},
> > > +};
> > > +
> > >   /* clang-format off */
> > >   FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp) {
> > >   	/* clang-format on */
> > > @@ -369,6 +502,39 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp) {
> > >   	},
> > >   };
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_mptcp) {
> > > +	/* clang-format on */
> > > +	.sandbox = TCP_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET6,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_MPTCP,
> > > +	},
> > > +};
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_sctp) {
> > > +	/* clang-format on */
> > > +	.sandbox = TCP_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET6,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_SCTP,
> > > +	},
> > > +};
> > > +
> > > +/* clang-format off */
> > > +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_smc) {
> > > +	/* clang-format on */
> > > +	.sandbox = TCP_SANDBOX,
> > > +	.prot = {
> > > +		.domain = AF_INET6,
> > > +		.type = SOCK_STREAM,
> > > +		.protocol = IPPROTO_SMC,
> > > +	},
> > > +};
> > > +
> > >   /* clang-format off */
> > >   FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_udp) {
> > >   	/* clang-format on */
> > > @@ -663,7 +829,7 @@ TEST_F(protocol, bind_unspec)
> > >   	/* Allowed bind on AF_UNSPEC/INADDR_ANY. */
> > >   	ret = bind_variant(bind_fd, &self->unspec_any0);
> > > -	if (variant->prot.domain == AF_INET) {
> > > +	if (variant->prot.domain == AF_INET && !prot_is_sctp(&variant->prot)) {
> > >   		EXPECT_EQ(0, ret)
> > >   		{
> > >   			TH_LOG("Failed to bind to unspec/any socket: %s",
> > > @@ -689,7 +855,7 @@ TEST_F(protocol, bind_unspec)
> > >   	/* Denied bind on AF_UNSPEC/INADDR_ANY. */
> > >   	ret = bind_variant(bind_fd, &self->unspec_any0);
> > > -	if (variant->prot.domain == AF_INET) {
> > > +	if (variant->prot.domain == AF_INET && !prot_is_sctp(&variant->prot)) {
> > 
> > It looks like we need the same exception for the next bind_variant()
> > call.
> 
> I ran these tests with active selinux (and few other LSMs) (selinux is set
> by default for x86_64) and it seems that this check was passed
> correctly due to SCTP errno inconsistency in selinux_socket_bind().
> 
> With selinux_socket_bind() disabled, bind_variant() returns -EINVAL as
> it should (Cf. sctp_do_bind).
> 
> Such inconsistency happens because sksec->sclass security field can be
> initialized with SECCLASS_SOCKET (Cf. socket_type_to_security_class)
> in SCTP case, and selinux_socket_bind() provides following check:
> 
> 	/* Note that SCTP services expect -EINVAL, others -EAFNOSUPPORT. */
> 	if (sksec->sclass == SECCLASS_SCTP_SOCKET)
> 		return -EINVAL;
> 	return -EAFNOSUPPORT;
> 
> I'll possibly send a fix for this to selinux.

Yes please, and it would be handy to split this patch with the first
providing MPTCP coverage and the second SCTP coverage.  This way I'll
quickly merge the MPTCP tests and wait for the SCTP fixes.

The SELinux issue might have been introduced with commit 0f8db8cc73df
("selinux: add AF_UNSPEC and INADDR_ANY checks to
selinux_socket_bind()").

> 
> > 
> > >   		if (is_restricted(&variant->prot, variant->sandbox)) {
> > >   			EXPECT_EQ(-EACCES, ret);
> > >   		} else {
> > > @@ -727,6 +893,10 @@ TEST_F(protocol, connect_unspec)
> > >   	int bind_fd, client_fd, status;
> > >   	pid_t child;
> > > +	if (prot_is_smc(&variant->prot))
> > > +		SKIP(return, "SMC does not properly handles disconnect "
> > > +			     "in the case of fallback to TCP");
> > > +
> > >   	/* Specific connection tests. */
> > >   	bind_fd = socket_variant(&self->srv0);
> > >   	ASSERT_LE(0, bind_fd);
> > > @@ -769,17 +939,18 @@ TEST_F(protocol, connect_unspec)
> > >   		/* Disconnects already connected socket, or set peer. */
> > >   		ret = connect_variant(connect_fd, &self->unspec_any0);
> > > -		if (self->srv0.protocol.domain == AF_UNIX &&
> > > -		    self->srv0.protocol.type == SOCK_STREAM) {
> > > +		if (prot_is_unix_stream(&variant->prot)) {
> > >   			EXPECT_EQ(-EINVAL, ret);
> > > +		} else if (prot_is_sctp(&variant->prot)) {
> > > +			EXPECT_EQ(-EOPNOTSUPP, ret);
> > >   		} else {
> > >   			EXPECT_EQ(0, ret);
> > >   		}
> > >   		/* Tries to reconnect, or set peer. */
> > >   		ret = connect_variant(connect_fd, &self->srv0);
> > > -		if (self->srv0.protocol.domain == AF_UNIX &&
> > > -		    self->srv0.protocol.type == SOCK_STREAM) {
> > > +		if (prot_is_unix_stream(&variant->prot) ||
> > > +		    prot_is_sctp(&variant->prot)) {
> > >   			EXPECT_EQ(-EISCONN, ret);
> > >   		} else {
> > >   			EXPECT_EQ(0, ret);
> > > @@ -796,9 +967,10 @@ TEST_F(protocol, connect_unspec)
> > >   		}
> > >   		ret = connect_variant(connect_fd, &self->unspec_any0);
> > > -		if (self->srv0.protocol.domain == AF_UNIX &&
> > > -		    self->srv0.protocol.type == SOCK_STREAM) {
> > > +		if (prot_is_unix_stream(&variant->prot)) {
> > >   			EXPECT_EQ(-EINVAL, ret);
> > > +		} else if (prot_is_sctp(&variant->prot)) {
> > > +			EXPECT_EQ(-EOPNOTSUPP, ret);
> > >   		} else {
> > >   			/* Always allowed to disconnect. */
> > >   			EXPECT_EQ(0, ret);
> > > -- 
> > > 2.34.1
> > > 
> > > 
> 
