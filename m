Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F09402449
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 16:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775060462; cv=none; b=Pn50RCack5mcEFP8GCkfNnkPUA9gn5xn/G4j9ga7bAd4bitGIF6HvxNo7ExVFmTDmyUiZ/qhPeRVlurKjr9EcLWR5GQjyKQCjXepBN842xpheEAaV78kmx4MMXHjURAjStWjN/u1e/zfdEoUV3VxzAMDt9GBQiNZTaAYMwn8l4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775060462; c=relaxed/simple;
	bh=vqf1PiQgIrSLvLOIqCuthN86/GGCYXPRBreHnHltp80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REbcPzipV86HYS1Okxeup1fQKXMZlcXKhXwYE0PZiY0JcVFG0XEpCzyQswGX/IOZrfqC2aQWx+zOfYK3B8XGS1Nz+D5+nvDXJQpWC88Rn6HEFBdJ+kluiR0JSsBqCXu/HXswYBIfS7eUtcFM/F1RZhU3wGrHjxKJhCqSh/BnzNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BNE45O+3; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BNE45O+3"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-12a74039dc6so5818119c88.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 09:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775060460; x=1775665260; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6brUS/+KN+QlXTcwRDDuVwUelenxIPcKdQxQmBulR1c=;
        b=BNE45O+3NVsAQGgQj1RNyaCUlBChtmDeBTLHeVtYINkc/ccArh4lb3w+uEBU5yahai
         UNh+Ndpqd9XuNVjqnqwdaq0xc3owzEU237n17YEGADTta8CUXIn4orZYlC/VrSxGpAOc
         Eh7dFf533GJO+rWiGiSInXk+Rvhn0y+ff4K/agx0KF4vqXSGo69d3Ygbv4O1AWDlZsMw
         GmTCjdKykQ7jVnwmcHACAXfMCThmI0Uc2wk1chAaWtIxoOnK2+oqHf1EwEl/7LxUjKyF
         W69NDNTHjl8nO5VW2zh4JPFrs3uOmeVM3ecRgox7fv3HLKiqQ/f5YGhEG+9a53YqUjuJ
         uBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775060460; x=1775665260;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6brUS/+KN+QlXTcwRDDuVwUelenxIPcKdQxQmBulR1c=;
        b=jMvC/pu3/jOs2rlPF1yBw0B/fag4+xdOchr2ek9cxD9at2z0NQzgR3MKj/wGjW6Cfc
         M2tND/++08XN4yqpumv0qoti7QXT8Y9ERzFGB5wm3URwk9I8KRDrhZ9yEdJAAg1kpwhb
         oIz5U+nHXlWsTpWggdqiec6fzzK+DT661Q461tfMxG0WUWb4GuF9Y+p4hvdoMffc6eTR
         qjhdumqDZ6pUzAFaHgJszWp8kdtKqJXDr9AmpsXNrCFnM6c2KlP4X8JhWbPp9vlf7WSs
         0VfSDyYekJeS4O6wyMkLOLji0P4lZEkRYaE5+LeNgdRKfOyOpnDV1ETi4S4rLHRWNTHT
         /vhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgXNZ6cpRlUZPDMylx0hEH8QyOApEJ6ETWwZzrGMXHqBPpvwJ6u/MLTfXnGAUJgk18NmjZcS8itI5XpkGbOcw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw553xb2LLiJ5Oo0YWuUT3875i1/w9L9ELT5Czk743ueGpepgNM
	ys/SptfMJE1kckHPJJwH2ngVOQfeSG7IE/5/09RrQYEhBt4alPE/5dU=
X-Gm-Gg: ATEYQzy4JVV3oRt+ibz/DBw78iSfbIGx+aOchWnQSAN+pzO9sn7EqUAINGkd1sJx/Ei
	BsIc/9K60AUaml+htOoD8jCOc5WG3A3Ps0qd3/Xt0VVW8x+0cv1ZinF3IBmqoQq1ipdKv4XgkiF
	UXS87VflTT1rRavozCCF0+Zm4o0fYXog3jmXbBWqLR9PLdqM+98N7Fg7CevJ72DdTzbLpMX/Yl3
	8xk/xGq3KSMO5U17lmsjsFppwg+98oQSMPo0gOD9XXN2IRngEAbzdT1r5TG3EY0QXY5gGSh4eDK
	DMr+PZS7s+3/ZSvlPJBaRTMgjpiM4DhuI4fLbiBRaUi/nQ8CmacExVMusK8OBadeTvzxfn0RCea
	5y4h7l1/8LLrLOC/fHIdD8wb0Pi+jGoRmIWDfpGZOARf5r7FM6xw/5Oqcqq8ACv/i/PFve8SrKJ
	SaJKUG0D2rAbjs+MQyzmpHHxrvH7mACOZ7HAX2gT49N+mOsN0U5RM526j3zizwTZwXExTuh0Vfx
	Kr0jS6s+zqUmZVTkQ==
X-Received: by 2002:a05:7301:4090:b0:2c1:b26:8424 with SMTP id 5a478bee46e88-2c933d8e814mr2313816eec.33.1775060459420;
        Wed, 01 Apr 2026 09:20:59 -0700 (PDT)
Received: from localhost (c-76-102-12-149.hsd1.ca.comcast.net. [76.102.12.149])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca792f3f54sm144003eec.7.2026.04.01.09.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 09:20:59 -0700 (PDT)
Date: Wed, 1 Apr 2026 09:20:58 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Guillaume Nault <gnault@redhat.com>,
	David Woodhouse <dwmw@amazon.co.uk>, Kees Cook <kees@kernel.org>,
	Alexei Lazar <alazar@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Paul Moore <paul@paul-moore.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	oss-drivers@corigine.com, bridge@lists.linux.dev,
	bpf@vger.kernel.org, linux-wireless@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	torvalds@linux-foundation.org, jon.maddog.hall@gmail.com
Subject: Re: [PATCH 6/6] net: Warn when processes listen on AF_INET sockets
Message-ID: <ac1F6hIHcoZo-soO@mini-arch>
Mail-Followup-To: Stanislav Fomichev <stfomichev@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Guillaume Nault <gnault@redhat.com>,
	David Woodhouse <dwmw@amazon.co.uk>, Kees Cook <kees@kernel.org>,
	Alexei Lazar <alazar@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Paul Moore <paul@paul-moore.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	oss-drivers@corigine.com, bridge@lists.linux.dev,
	bpf@vger.kernel.org, linux-wireless@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	torvalds@linux-foundation.org, jon.maddog.hall@gmail.com
References: <20260401074509.1897527-1-dwmw2@infradead.org>
 <20260401074509.1897527-7-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260401074509.1897527-7-dwmw2@infradead.org>

On 04/01, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> There is no need to listen on AF_INET sockets; a modern application can
> listen on IPv6 (without IPV6_V6ONLY) and will accept connections from
> the 20th century via IPv4-mapped addresses (::ffff:x.x.x.x) on the IPv6
> socket.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  net/ipv4/af_inet.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index dc358faa1647..3838782a8437 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -240,6 +240,9 @@ int inet_listen(struct socket *sock, int backlog)
>  	struct sock *sk = sock->sk;
>  	int err = -EINVAL;
>  
> +	pr_warn_once("process '%s' (pid %d) is listening on an AF_INET socket. Consider using AF_INET6 with IPV6_V6ONLY=0 instead.\n",
> +		     current->comm, task_pid_nr(current));
> +
>  	lock_sock(sk);
>  
>  	if (sock->state != SS_UNCONNECTED || sock->type != SOCK_STREAM)
> -- 
> 2.51.0
> 

Does this also need to look at the proto? inet6_stream_ops seem to be
using inet_listen as well.

const struct proto_ops inet6_stream_ops = {
        .family            = PF_INET6,
        .owner             = THIS_MODULE,
        .release           = inet6_release,
        .bind              = inet6_bind,
        .connect           = inet_stream_connect,       /* ok           */
        .socketpair        = sock_no_socketpair,        /* a do nothing */
        .accept            = inet_accept,               /* ok           */
        .getname           = inet6_getname,
        .poll              = tcp_poll,                  /* ok           */
        .ioctl             = inet6_ioctl,               /* must change  */
        .gettstamp         = sock_gettstamp,
        .listen            = inet_listen,               /* ok           */
