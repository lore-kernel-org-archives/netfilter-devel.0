Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C942BE05F
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 20:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776718361; cv=pass; b=HECSCvuotYkUmh2/Zy0Ll6IxpuMNsEvsiJo1AviahB8SKNmnSnRc70z25yQquGpZn43gXnnXbLiwvvk53Bx2O7H9uTmH/A0Ks11Xx949P16iWWKyz/KCXpoBUQmT4keUKwUysXXHnvJsJzpQMfT28hFIA3z+YAn1Ov22muKTOUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776718361; c=relaxed/simple;
	bh=Pnhnz1gyermNjSQP4+5/crpMQ9x95/YqL02Qcv52xEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dq5uhcGHMrAWOgTSLphCL0BN1AzcAa3E3pXHIzz3DjmUkZBqt+LdfdUvXvnFlh39dCye7BlgJQpCwV6hjMEFrMCUwvvFS6/i3mEI9G89pA6ep3FRuy8RSh1qX+w5CdJNCDRz6hDv1NO+Lu5Avr8XN22f5E9/DcZIm9oO7oecK4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FjIZLrLI; arc=pass smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FjIZLrLI"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82735a41920so1454309b3a.2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 13:52:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776718360; cv=none;
        d=google.com; s=arc-20240605;
        b=LI7gbX2oLX28FYVb4ED/64ZLbTEjEStHHmAuiOwzb9+000GpB6J0vT1eMGhAM/leIB
         GhvLBGuNlpNNhHCLzz0KFJi4blcvUxfuxD4y1UpjAn7QazYPLPWNQzzWB1+RLioOPiLF
         LfweLDdF9rIeyUKguVHA4LUt69sPjwMdRf/pSasCHH+cQm/dnbwDlwfmOHNxDSF9L52V
         ZCVEK2tEgii1Th0xSoqFVX/bFWEN7NLYpDSuH1NmXkfkwvp9HU78ivqOZhaG+KnZ254B
         Bt8w02slBp1/8i/O41AC06zJNnGJCVkQC/9cWJzyIyh0JfUJnEsTaDi6SyhDiWwSYQi7
         lHzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MxdD42vr//ngF98PTX13azQKwSAEPSKYCuEqwcGgkfs=;
        fh=DIRYGsnXQfUpMpK/yv+CoRGQU6Y+ZHJRpIPUwiTsPvU=;
        b=gDjshGbBa1N480Z9nurPN3Lkir7xQ72DMiHWuVO/i5sMJ1CbUyA5qnpkR/otsXEPJm
         tsxgk54BLCJXWsWDeNQxgaf4oeED89j8l8/e8zB9xQ0iepzHRlfjjTV6vWF6YgjTR1qr
         N3krvA/uY1PqvJWQ8tWEvw+E9x6p6yRvGsEeqdlEkZIKHjJWViUuunmmW2W8xEZ6zI0x
         Ebf7tO4bfTovDnH1B3rs+hL6lQR4e3jjrUmLG+jxyhD7yPdB80G0t9AkI1HMHfSuhhKM
         l/aDzxxnOaFJoAIFntJ0/62cuIiwgNEW5H5gfNFTUEyNZRIuchydgb/FPBB0exeDe2CB
         vnuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776718360; x=1777323160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MxdD42vr//ngF98PTX13azQKwSAEPSKYCuEqwcGgkfs=;
        b=FjIZLrLI3KSkP9dhCKwgfkTNIuXNaYPG/XVG89sZwWDi+Lg5mTU+TIeS7qL8fIlP5Z
         9D2UZMCzGtnxdVpbyJp1cUEWpvLOIIoyUCMvzhyNSo8yRVJL3g2ToV1cBKEDM/aXg7gT
         //LIV2svgvvzAyQR80Sp0BLBm+jwmv74bzfOKz1Uz8KB1FF8oE2PeNK8CXhCpKdm/tyR
         Ehzm2Cr60Sr86eIQg3l/2mJogk6wZTBJgg1xtcAv2NQ6ocaOjEztzaMLlQjDz5AlO/E7
         /r5We0LGgS2WTO66XnvyjgPVPEI3K4NiwoC4Mx9BOfBeR2pM5DpGdVa6wt7RLoTNS7ss
         x5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776718360; x=1777323160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MxdD42vr//ngF98PTX13azQKwSAEPSKYCuEqwcGgkfs=;
        b=jJwLqUO8YXU1sgRbrelUYQZytE5cqthd6whC/j943TY/EtOgfz3NMt0qQeQ3EtQ6K2
         M7+KXT6XxSnKfmdcj4ysGAzxsAcCt7+ixtatenycUFueqi2U6cXMGVzw/Hl03TnqjAgA
         qLOHJNu2s5qsOVIQNslL7XPlqbBHvw8wfxPQGMlJB3AMJai3eIOZ6TNRgMeEK2o17lBg
         Jbc+WBfguwpFEjbHs99sx7OQZAI0l1sXdd6yq5/1S7E3+kV1U/5a7lHlKLNHQitmeBbJ
         nO/uo8opoh6De7FMWWUvfucTPZFjq/c1qZAeyXbpQOvgJACes7uPQfvBO+nL4J9KE7vG
         Kl/w==
X-Forwarded-Encrypted: i=1; AFNElJ/TNjkA64NKEvHpctCXqrINv2RNp8NmdamSYuFrFqkv4NOgXWOSFyxE60qHF3JK5fqwpFcZFA2YQkKGXMRgIOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWAHWmjYeAdF2Xxv96XGw59+grZ8Ishwmraorgf3EKu3FfxhLt
	z+pjJDen/9hwmhGrWCkHVQlQSpylPzpCOGRP3LceFeLOKfkXPWTZjebHhcdDRFuXF+9LYbN/5kn
	7+fU+xI7vMiDC5Ka7hyzLLBcXLOsghfy8boos
X-Gm-Gg: AeBDiesK4DwUtQ5+zNCE1jml6oS+PBXfpYTRoyJSqH6JqAnKrlZzjgoORgwNxPo5pad
	sFRcJ9jcf0/FLazxDIQmA3Vke2f/jNUd7GhYwF7QeZqdHEO3pwmnm+wN8vWv4gQw6VezvWxQ7NG
	H58XvkhBZjW/Hi17+sfcpSLu88bmOCb0yNYYEruuf8sJHP7cWf1hiJ2+sZmZBBFwE5JZsKZgiXj
	xYNa5wUqlpqlOMmCWyR9Xuf4hZ5+ccgxm6kdWL1kJPknPRKnQaI6jW6YmxDIoIsPBf1Q2A/Jz8V
	2zNJL9BrbAwlHgLuP/jVNOB/TalNsvD10bpAHwTKk3jVJqZVnDVqTjvjKmDlshshUK5a0kcInhL
	by5cLpBh8TDzJfQ3LriEcl2fG8lcnE8lU9TB4aSjGPlL0WoYK
X-Received: by 2002:a05:6a00:2d1f:b0:82f:7252:38cf with SMTP id
 d2e1a72fcca58-82f8c82c396mr13602325b3a.16.1776718359711; Mon, 20 Apr 2026
 13:52:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418195843.303946-1-yiche.cy@gmail.com> <20260420082334.7db8cbf4@kernel.org>
In-Reply-To: <20260420082334.7db8cbf4@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 20 Apr 2026 16:52:27 -0400
X-Gm-Features: AQROBzDGLUKJMnGtLHblO9Fg05E_lPRg8I9KEhfXLSlLZeyIegT3XxzFdfu_aUI
Message-ID: <CADvbK_cmmdqxXJC1q-5gDTzhq_XH1ESgRZCD6pO4Ws4GoWooYQ@mail.gmail.com>
Subject: Re: [PATCH net v2] selftests: netfilter: conntrack_sctp_collision.sh:
 Introduce SCTP INIT collision test
To: Jakub Kicinski <kuba@kernel.org>
Cc: Yi Chen <yiche.cy@gmail.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, coreteam@netfilter.org, netfilter-devel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 11:23=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Sun, 19 Apr 2026 03:58:43 +0800 Yi Chen wrote:
> > The existing test covered a scenario where a delayed INIT_ACK chunk
> > updates the vtag in conntrack after the association has already been
> > established.
>
> AI says:
>
> The conntrack_sctp_collision.sh selftest is now failing in the NIPA CI on
> both the normal and debug kernel builds:
>
>   not ok 1 1 selftests: net/netfilter: conntrack_sctp_collision.sh # exit=
=3D1
>
>   # Test for SCTP INIT_ACK Collision in nf_conntrack:
>   # Invalid netns name ""
>   # Invalid netns name ""
>
> The root cause is a shell variable scoping bug introduced by this patch.
> The new test structure wraps `topo_setup` in a subshell:
>
>   (topo_setup && conf_delay $SERVER_NS link0 2) || exit $?
Better to change it to:

topo_setup || exit $?
conf_delay $SERVER_NS link0 2 || exit $?

Again, please do not post the patch until the fix gets merged into net.git:

https://lore.kernel.org/netdev/cover.1775847557.git.lucien.xin@gmail.com/

Otherwise, it will still be failing in the NIPA CI.

Thanks.

>   if ! do_test; then
>       ...
>   fi
>
> `topo_setup` calls `setup_ns CLIENT_NS SERVER_NS ROUTER_NS`, which sets
> those variables inside the subshell. Those assignments do not propagate
> back to the parent shell, so when `do_test` is called afterwards, both
> `$SERVER_NS` and `$CLIENT_NS` expand to empty strings. The `ip net exec "=
"`
> calls then fail with "Invalid netns name """.
>
> The second test case (SCTP INIT Collision) would have the same problem.
>
> The fix is to avoid the subshell or ensure the namespace variables are
> visible to `do_test`. The simplest approach is to remove the subshell
> wrapping and call `topo_setup`, `conf_delay`, and `do_test` in the same
> shell scope:
>
>   topo_setup && conf_delay "$SERVER_NS" link0 2 || exit $?
>   if ! do_test; then
>       exit $ksft_fail
>   fi
>
>   topo_setup && conf_delay "$CLIENT_NS" link3 1 || exit $?
>   if ! do_test; then
>       exit $ksft_fail
>   fi
>
> Please also note that `conf_delay` references `$ROUTER_NS` directly
> (not via a parameter), so it too requires that those variables be set
> in the same shell scope.
