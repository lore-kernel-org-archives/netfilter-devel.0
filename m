Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A5F372B56
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 09:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775034707; cv=pass; b=hba8ehAQeTC9toAyiu20jLStvD99Bf3ELiNuJA1Psj+CXJZvQmv1zl8xxOSKZjl4Ety2pgnz4ttg88Mpkm/bcoHWGV5RJ/Br2Xeq6tK2IjVAQwJ6O88NvaEMb7JPmWZ8Pbq4quPylUG0x/yQewaimcYN1yp7duAfcdP7Kwocx7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775034707; c=relaxed/simple;
	bh=dmaTcuAy6jfJ+bmzS1Jm/uyBrkTWgyDnScrFaQ2/nas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kjq+JQmd7npsoyOsfajEAtMc0SqjcZNTpWyczVSG2ge+qzNEUPNJoRbH0BjBmO55pPTbsqp1BmCKLReRcxPmzWsQoWiCuqRvwMa8tBn6KSNoartKn8yRWz0TJT8fUFGfInV+jU3NzZoasoIqoLYO69SZv1wU3QfB3ShWqEU7Rrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=twFnRIT8; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="twFnRIT8"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-509134ab2d2so52358971cf.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 02:11:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775034703; cv=none;
        d=google.com; s=arc-20240605;
        b=OA2uYTv9Tv6wCu/xz7b4mG+m1n7zBu8SHTAYqoQpWeJYdkxJca9uYltyAUGGn1bCC+
         JAULSGcbL/XHkc67BQSEOGhPmHhm6EvXT8adgBH3dZejwx46T1coLxkKfNjD6SlFJTFg
         UMSkhJ6zw6kF0EADcgyCUV3mOYn3HMsGDYR+V0X1IGzvo9ERM++M9i6/U11gLg0GefVF
         r4W+hQt52Q5uhXu5MidOhmN8d/wfj371+B2R1XwPa/lDgKRSp7PktK+KzWN8IOvipcit
         JickobDt3YDDmrObcFrWv4k7zcvy6wYVkUleJAmr1zJhVqxB+fWzvx7QRoBRPTEUzJLM
         onMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lctUVgmnSzTUnScobr+jAtLkB/onmBi35F0YaMEt+UE=;
        fh=asOpHGslSGOzRReTLIJCQKyf/jP4XgBQZJXWOlhg9pw=;
        b=OKrRydFhOPl11a2Q8T5p7bl/e87SKXi184tqyMAnhRKzCs5qhh2/bXqphM4WUMJqqb
         B50tbytWH5Ju2/NfTMCV5BUzF/W3EZ4TVE7VrPXD7B5AmpbGVdhJc9NEIRrp4s+Ln8mq
         AbJV9IGq4dfIN6SFUNwAt/pBCFTN+UOa3xHgVLiismANXauLBkzj5teV3DkVtCZIzHQY
         4khvdZCqPUHomt9DFM5Zxt/rSPeZLLDEvZBXRrcOF2vCAJLk4tXeZUjQF+TsLGfbJ+WD
         wNo2XfqcTpkNqHfJuCOBxEsau4KMxZETgtzgWHu7S+YCSiDPjaR5l0ddfoFz+LAyikEh
         2IzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775034703; x=1775639503; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lctUVgmnSzTUnScobr+jAtLkB/onmBi35F0YaMEt+UE=;
        b=twFnRIT8SirtW12uUCHs6hTeF/J2DOg5PKAmKI/mwRCncAk4AIvZwUq8xR7yTK0iJ+
         4ImgI8xWhYvzAYMKo33ksmbew7TAwPlXPwRplqecw+NYSPwHcYD8NcIFmA0v/FzgmIrA
         GlgznlRQinWJpsA4qp4IlnNYa4zu4LMzYJu3khv64uuDL3+ybWpc3gfaIp1N30uXymnh
         o/KWJm7bZFr+X8f9bK2b9IBUwDPo2JrcV4mBBOIg3fqCL5h118wWZzw/mlpOg5YazSse
         2pJzkr32Nm/rqUXZUcHdfdBBA5R+Rztx/u8eIHbmmnYHi26nHKuFO8CqGzwdfgZfHKXJ
         VrAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775034703; x=1775639503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lctUVgmnSzTUnScobr+jAtLkB/onmBi35F0YaMEt+UE=;
        b=KRbenAC4mlcXwsqnSOzcvMZrOS9MqDTOXJv3a0BWsSNIw1QlKdFLqUz7bcq7Pkz6jo
         KCayHmERUauHE6WI9TYRkQGjj4+judQilCJpe2IC+YOnHDx3zeNP50KTOJGdNt7+eStc
         pEy0ME6cGGMBmepWwbtMrwXSDX6yVeHodzgZ5TQEZtSOuB08oC5+IYeanKEnTV2zoJ+Y
         5+A86O6he4QsxxhpwVhPkxqpdI7wB6SBFxAs1nFfPQbwGpaMS/vgyLK8SOxReW30Iubr
         gfVqkYVN6xUqkG4AYYhcOF8mBIKV+x27jGM92EJiwPFDUGlqiHCXamKA+kjQ+MFQ4Frt
         zfKw==
X-Forwarded-Encrypted: i=1; AJvYcCW3b7F8ULZp3ISW9jfg3SRj9guFR1P4yQKto05FXm79s9YRm/r5gEVmIvFz6T2Bc+Tn3h+XhzHZgGkV0bpiM70=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/sXdmOQjEFxwlSfiWDur4BONUrrGecqlj00MVMCTlDj72Twmg
	f4bSxi7c15Y7EnLeoTkt6rHorpit2iWowncn98EKm47MF1lPnGsSNiqEL+0xdCNQyKpn9Y/X2Ho
	cM1hXKu+OSlFwRl0WZFfdEd8NkiljpqcBesrNqqqf
X-Gm-Gg: ATEYQzwy6QvZp6ZkRH1BSmvv0DS9CDuu7k3TO5U96J2X9bUk45KtIpVkDZgX55085q2
	hG5TcLeNp3RTuA8M7vM1QCpsZQifqmge5DrOktnNQQXVwxfk7AZW3MlFWCJUkvZIhQex7gHjj8/
	HE6khwBQQfgqnQ6SxTlJfC69iCqeu2WTo1dzz98YMeeCC4XtBBengZRrVF0JapveChEMBemaxmZ
	xBapK903ccVtKoCrnl4v4TfjlS13i/qY7lz/P97dVneh7FwAicZX/PXTMbPZndYGV5q4G+XaToZ
	a+9OhAeRxX86cVRM
X-Received: by 2002:a05:622a:5909:b0:4ed:b2da:966f with SMTP id
 d75a77b69052e-50d3bd84b29mr44808651cf.31.1775034702251; Wed, 01 Apr 2026
 02:11:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260401074509.1897527-1-dwmw2@infradead.org> <20260401074509.1897527-7-dwmw2@infradead.org>
In-Reply-To: <20260401074509.1897527-7-dwmw2@infradead.org>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 1 Apr 2026 02:11:31 -0700
X-Gm-Features: AQROBzDMpjzScINQf3v40GgXHFr7zNRIwe6Qb5aBvyyAycV5Up8H_bwJXHOzd_8
Message-ID: <CANn89i+GHkkubJp3MTKZ_r4tde1qLejfsxUh+w0gPZ3ec+YdjQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] net: Warn when processes listen on AF_INET sockets
To: David Woodhouse <dwmw2@infradead.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	Guillaume Nault <gnault@redhat.com>, David Woodhouse <dwmw@amazon.co.uk>, Kees Cook <kees@kernel.org>, 
	Alexei Lazar <alazar@nvidia.com>, Gal Pressman <gal@nvidia.com>, Paul Moore <paul@paul-moore.com>, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, oss-drivers@corigine.com, 
	bridge@lists.linux.dev, bpf@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	torvalds@linux-foundation.org, jon.maddog.hall@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 1, 2026 at 12:45=E2=80=AFAM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
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
>         struct sock *sk =3D sock->sk;
>         int err =3D -EINVAL;
>
> +       pr_warn_once("process '%s' (pid %d) is listening on an AF_INET so=
cket. Consider using AF_INET6 with IPV6_V6ONLY=3D0 instead.\n",
> +                    current->comm, task_pid_nr(current));
> +

Some kernels are built without CONFIG_IPV6, so this warning would be
quite misleading.
