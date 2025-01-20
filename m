Received: from mx1.buffet.re (mx1.buffet.re [51.83.41.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6960523A9;
	Mon, 20 Jan 2025 22:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.83.41.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737412413; cv=none; b=m8xVxIP5mNk5/yHACxOY+1yk/aVNO6SN/F678mIhkRCcX/EiNtJj65ZphkcnV4Aft8aUN2KcFhEiC748VlCh7A7L4YSrJFldqyaQGBL7gIsniJIqTSr5vBPrZtZkcIvWn/SIPNFY5RITbW9Ld9woWVNKMRBDT5xAwAfsMF2OLG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737412413; c=relaxed/simple;
	bh=vfqlpWoacPY32KroqtEX+NEFPbmL4zQF705VOYAN29U=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=SgWLW7eETgQ9zKNfyI8KjWMOwMtWDsh/VuSdUT87l+d/Jlgq+gzO8CM4IGrcCCs2o2UazmkaF0gi0nssNRKz6vFpGjU+o65o3ztC6Y/rnB6iiuhyAIJ+tHo1lTvkm3egAs1qQpJvERTf9MwzZKLdRXU/+DrUSmzXgrY5Qw3cgMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=buffet.re; spf=pass smtp.mailfrom=buffet.re; dkim=pass (2048-bit key) header.d=buffet.re header.i=@buffet.re header.b=HeyQrtGC; arc=none smtp.client-ip=51.83.41.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=buffet.re
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=buffet.re
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=buffet.re header.i=@buffet.re header.b="HeyQrtGC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=buffet.re; s=mx1;
	t=1737411995; bh=vfqlpWoacPY32KroqtEX+NEFPbmL4zQF705VOYAN29U=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=HeyQrtGCYnmSxatOh/soVgJUYs0kb4bNajbUUhbDpfcdMXZZ0R+l/GaoBa6cl0Een
	 NnRs5v3zFahBqVEsnga+h5XFGvnHNQMfOhZzOxSKsvrTNvCL/Ix8cj3XlknbzIbYqu
	 DG5sOG3np81gaKgIZBpYbLv0wBJXFtRXv7MG6dbWUsTeluA1QQYP9sC5CQfWteJXbH
	 mZpsLy7ks1ChFoFxy7n9UREJ09U0sPYo8m3VJz8kGLCPKh93nFjYs+XteZunVYKWqo
	 8idar4WLbLRyOst6eQSQITXm+n/nSPw47xhynxiCuyvSRR0VmvdGBzAsF6aGmOBtL8
	 xX0tYBqUMB1MQ==
Received: from [192.168.100.2] (unknown [10.0.1.3])
	by mx1.buffet.re (Postfix) with ESMTPSA id 3D402125339;
	Mon, 20 Jan 2025 23:26:35 +0100 (CET)
Message-ID: <d77d347c-de99-42b4-a6f5-6982ed2d413f@buffet.re>
Date: Mon, 20 Jan 2025 23:30:09 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Matthieu Buffet <matthieu@buffet.re>
Subject: Re: [PATCH v2 3/6] landlock: Add UDP sendmsg access control
To: Mickael Salaun <mic@digikod.net>
Cc: Gunther Noack <gnoack@google.com>,
 Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>,
 konstantin.meskhidze@huawei.com, Paul Moore <paul@paul-moore.com>,
 linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>
References: <20241214184540.3835222-1-matthieu@buffet.re>
 <20241214184540.3835222-4-matthieu@buffet.re>
Content-Language: en-US
In-Reply-To: <20241214184540.3835222-4-matthieu@buffet.re>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

(for netfilter folks added a bit late: this should be self-contained but 
original patch is here[1], it now raises a question about netfilter hook 
execution context at the end of this email - you can just skip to it if 
not interested in the LSM part)

On 12/14/2024 7:45 PM, Matthieu Buffet wrote:
> Add support for a LANDLOCK_ACCESS_NET_SENDTO_UDP access right,
> complementing the two previous LANDLOCK_ACCESS_NET_CONNECT_UDP and
> LANDLOCK_ACCESS_NET_BIND_UDP.
> It allows denying and delegating the right to sendto() datagrams with an
> explicit destination address and port, without requiring to connect() the
> socket first.
> [...]
> +static int hook_socket_sendmsg(struct socket *const sock,
> +			       struct msghdr *const msg, const int size)
> +{
> +	const struct landlock_ruleset *const dom =
> +		landlock_get_applicable_domain(landlock_get_current_domain(),
> +					       any_net);
> +	const struct sockaddr *address = (const struct sockaddr *)msg->msg_name;
> +	const int addrlen = msg->msg_namelen;
> +	__be16 port;
> +     [...]
> +	if (!sk_is_udp(sock->sk))
> +		return 0;
> +
> +	/* Checks for minimal header length to safely read sa_family. */
> +	if (addrlen < offsetofend(typeof(*address), sa_family))
> +		return -EINVAL;
> +
> +	switch (address->sa_family) {
> +	case AF_UNSPEC:
> +		/*
> +		 * Parsed as "no address" in udpv6_sendmsg(), which means
> +		 * we fall back into the case checked earlier: policy was
> +		 * enforced at connect() time, nothing to enforce here.
> +		 */
> +		if (sock->sk->sk_prot == &udpv6_prot)
> +			return 0;
> +		/* Parsed as "AF_INET" in udp_sendmsg() */
> +		fallthrough;
> +	case AF_INET:
> +		if (addrlen < sizeof(struct sockaddr_in))
> +			return -EINVAL;
> +		port = ((struct sockaddr_in *)address)->sin_port;
> +		break;
> +
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:
> +		if (addrlen < SIN6_LEN_RFC2133)
> +			return -EINVAL;
> +		port = ((struct sockaddr_in6 *)address)->sin6_port;
> +		break;
> +#endif /* IS_ENABLED(CONFIG_IPV6) */
> +
> +	default:
> +		return -EAFNOSUPPORT;
> +	}
> +
> +	return check_access_port(dom, LANDLOCK_ACCESS_NET_SENDTO_UDP, port);
> +}
> +
>   static struct security_hook_list landlock_hooks[] __ro_after_init = {
>   	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
>   	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
> +	LSM_HOOK_INIT(socket_sendmsg, hook_socket_sendmsg),
>   };

Looking back at this part of the patch to fix the stupid #ifdef, I 
noticed sk->sk_prot can change under our feet, just like sk->sk_family 
as highlighted by Mikhail in [2] due to setsockopt(IPV6_ADDRFORM).
Replacing the check with READ_ONCE(sock->sk->sk_family) == AF_INET6 or 
even taking the socket's lock would not change anything:
setsockopt(IPV6_ADDRFORM) runs concurrently and locklessly.

So with this patch, any Landlock domain with rights to connect(port A) 
and no port allowed to be set explicitly in sendto() could actually 
sendto(arbitrary port B) :
1. create an IPv6 UDP socket
2. connect it to (any IPv4-mapped-IPv6 like ::ffff:127.0.0.1, port A)
3a. sendmsg(AF_UNSPEC + actual IPv4 target, port B)
3b. race setsockopt(IPV6_ADDRFORM) on another thread
4. retry from 1. until sendmsg() succeeds

I've put together a quick PoC, the race works. SELinux does not have 
this problem because it uses a netfilter hook, later down the packet 
path. I see three "fixes", I probably missed some others:

A: block IPV6_ADDRFORM support in a setsockopt() hook, if UDP_SENDMSG is 
handled. AFAIU, not an option since this breaks a userland API

B: remove sendmsg(AF_UNSPEC) support on IPv6 sockets. Same problem as A

C: use a netfilter NF_INET_LOCAL_OUT hook like selinux_ip_output() 
instead of an LSM hook

For C, problem is to get the sender process' credentials, and ideally to 
avoid tagging sockets (what SELinux uses to fetch its security context, 
also why it does not have this problem). Otherwise, we would add another 
case of varying semantics (like rights to truncate/ioctl) to keep in 
mind for Landlock users, this time with sockets kept after enforcing a 
new ruleset, or passed to/from another domain - not a fan.

I don't know if it is safe to assume for UDP that NF_INET_LOCAL_OUT 
executes in process context: [3] doesn't specify, and [4] mentions the 
possibility to execute in interrupt context due to e.g. retransmits, but 
that does not apply to UDP. Looking at the code, it looks like it has to 
run in process context to be able to make the syscall return EPERM if 
the verdict is NF_DROP, but I don't know if that's something that can be 
relied upon to be always true, including in future revisions. Could use 
some input from someone knowledgeable in netfilter.

What do you think?

[1] https://lore.kernel.org/all/20241214184540.3835222-1-matthieu@buffet.re/
[2] https://lore.kernel.org/netdev/20241212.zoh7Eezee9ka@digikod.net/T/
[3] 
https://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO-4.html#ss4.6
[4] 
https://netfilter-devel.vger.kernel.narkive.com/yZHiFEVh/execution-context-in-netfilter-hooks#post5
