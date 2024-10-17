Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90D6146013;
	Thu, 17 Oct 2024 11:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729164915; cv=none; b=SNc31HYBHo2IJiWZX1BYcBu9fL2ClZZDSRij0W2t3n+YoXktb+YIXSQlFrLmQZwG9/4uj1M+qUknWJvHkMU1ggK+n8yu5TOMLdPq+SxxZPbZz0dw7fLilEPdBnNXKubglw4Hhbfcqdr8Vsqncn+jWwCjvTSkweqJcWf7/2NNOL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729164915; c=relaxed/simple;
	bh=hAFU5l7k4ClRGk/Sg1df0qnoBYW+9Do6OoxNSsxBaEg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=O2V9oJNcN6S2MCQcmorjN/jtAWhKQtHM7wezNXCI9LOwdgoEdO0yB115LvftO74mgvVzmRHhPQe8l2pIKo0t4QR/J3DlO5oP8AanGsj1dCyXHrBFgWVuv1B5aAacrOwfndVZTUeq1ZQjslOH/0U5AxrXZBEE4I/B5rdT7JaNIao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XTm1r1V3sz2Ddcb;
	Thu, 17 Oct 2024 19:33:52 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id B8B56180019;
	Thu, 17 Oct 2024 19:35:07 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 17 Oct 2024 19:35:03 +0800
Message-ID: <a68a9e2c-fb2c-3cd7-c076-ecf95e94606d@huawei-partners.com>
Date: Thu, 17 Oct 2024 14:34:59 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 3/8] landlock: Fix inconsistency of errors for TCP
 actions
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-4-ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241017110454.265818-4-ivanov.mikhail1@huawei-partners.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 10/17/2024 2:04 PM, Mikhail Ivanov wrote:

[...]

> +static int
> +check_tcp_connect_consistency_and_get_port(struct socket *const sock,
> +					   struct sockaddr *const address,
> +					   const int addrlen, __be16 *port)
> +{
> +	int err = 0;
> +	struct sock *const sk = sock->sk;
> +
> +	/* Cf. __inet_stream_connect(). */
> +	lock_sock(sk);
> +	switch (sock->state) {
> +	default:
> +		err = -EINVAL;
> +		break;
> +	case SS_CONNECTED:
> +		err = -EISCONN;
> +		break;
> +	case SS_CONNECTING:
> +		/*
> +		 * Calling connect(2) on nonblocking socket with SYN_SENT or SYN_RECV
> +		 * state immediately returns -EISCONN and -EALREADY (Cf. __inet_stream_connect()).
> +		 *
> +		 * This check is not tested with kselftests.
> +		 */
> +		if ((sock->file->f_flags & O_NONBLOCK) &&
> +		    ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))) {
> +			if (inet_test_bit(DEFER_CONNECT, sk))
> +				err = -EISCONN;
> +			else
> +				err = -EALREADY;
> +			break;
> +		}
> +
> +		/*
> +		 * Current state is possible in two cases:
> +		 * 1. connect(2) is called upon nonblocking socket and previous
> +		 *    connection attempt was closed by RST packet (therefore socket is
> +		 *    in TCP_CLOSE state). In this case connect(2) calls
> +		 *    sk_prot->disconnect(), changes socket state and increases number
> +		 *    of disconnects.
> +		 * 2. connect(2) is called twice upon socket with TCP_FASTOPEN_CONNECT
> +		 *    option set. If socket state is TCP_CLOSE connect(2) does the
> +		 *    same logic as in point 1 case. Otherwise connect(2) may freeze
> +		 *    after inet_wait_for_connect() call since SYN was never sent.
> +		 *
> +		 * For both this cases Landlock cannot provide error consistency since
> +		 * 1. Both cases involve executing some network stack logic and changing
> +		 *    the socket state.
> +		 * 2. It cannot omit access check and allow network stack handle error
> +		 *    consistency since socket can change its state to SS_UNCONNECTED
> +		 *    before it will be locked again in inet_stream_connect().
> +		 *
> +		 * Therefore it is only possible to return 0 and check access right with
> +		 * check_access_port() helper.
> +		 */
> +		release_sock(sk);
> +		return 0;

Returning 0 is incorrect since port was not extracted yet. Last two
lines should be replaced with a "break" to let further switch safely
extract a port.

This also requires fix in tcp_errors_consistency.connect kselftest.

> +	case SS_UNCONNECTED:
> +		if (sk->sk_state != TCP_CLOSE)
> +			err = -EISCONN;
> +		break;
> +	}
> +	release_sock(sk);
> +
> +	if (err)
> +		return err;
> +
> +	/* IPV6_ADDRFORM can change sk->sk_family under us. */
> +	switch (READ_ONCE(sk->sk_family)) {
> +	case AF_INET:
> +		/* Cf. tcp_v4_connect(). */
> +		if (addrlen < sizeof(struct sockaddr_in))
> +			return -EINVAL;
> +		if (address->sa_family != AF_INET)
> +			return -EAFNOSUPPORT;
> +
> +		*port = ((struct sockaddr_in *)address)->sin_port;
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:
> +		/* Cf. tcp_v6_connect(). */
> +		if (addrlen < SIN6_LEN_RFC2133)
> +			return -EINVAL;
> +		if (address->sa_family != AF_INET6)
> +			return -EAFNOSUPPORT;
> +
> +		*port = ((struct sockaddr_in6 *)address)->sin6_port;
> +		break;
> +#endif /* IS_ENABLED(CONFIG_IPV6) */
> +	default:
> +		WARN_ON_ONCE(0);
> +		return -EACCES;
> +	}
> +
> +	return 0;
> +}
