Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33860BA3F;
	Wed,  3 Sep 2025 22:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937756; cv=none; b=Dk87y3D4yH9meF9m/QMWPNh61gb+1uA8HiPP15tc7JlrD2ti1OKWXmXmEQ7BJClpMoCXKcYY8Q4qI4T1LB0wX4Ossm86tymRD6cHIJUNsRffad53ZScgLeqeIJiBmBckhyiaBFk7VFEYwryKqDqmhco5Jl1j8iDVfIESBR3W4As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937756; c=relaxed/simple;
	bh=FjCxsXTO2y1dcCLjYVy+WtH9zNK8OPmf+oe47T3YX4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cDdXX4+2eMRq88N5421E1UUjamkTOK0M2GJe7FB3I8aozxX/7dhMzw0VaHWelUPYh8aFUZmIVDy3IJRv974ZQenW1LrM2uM2YNGcDiMIaic3mgIG9bpNV+jCTC1sJn9tATPlxdH6Tk4lTtbGsF3H32JPN55unJvYPkpeerHJYeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f29Eyqlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f29Eyqlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771E0C4CEE7;
	Wed,  3 Sep 2025 22:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756937755;
	bh=FjCxsXTO2y1dcCLjYVy+WtH9zNK8OPmf+oe47T3YX4Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f29EyqlqLRMXeIWuZJitiNpeH+sT89UwgxyPvp2eO7nIggZXyOzUvRmFT664V3Y+5
	 hT4Qe6gNYItnV3OsnFVhk+sKwkV9Xt30TkTk9J7wLXh+dK3V6nvNbzRe6UShvacKq7
	 1Vdn49ucvrmSBc4RdoT4+sK6MVIQQAsp0ShyTrzXFuPdQ9ZEQhvi4qtX9taKHq0MAG
	 6Hra8sQuQJGCtKJZRD8Gegr0oR3Bcau9cs9TR49LkWir54tKASsb22+aLo8/3BU/DF
	 v4zuvzEQ+P7fxHWIAsJZFBrurUDtcdGc7Ts/9tVh7PZIdd+sxhkcDZ+Lf17KY69B22
	 FaLE2GI9aB4nA==
Date: Wed, 3 Sep 2025 15:15:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH net 1/2] selftests: netfilter: fix udpclash tool hang
Message-ID: <20250903151554.5c72661e@kernel.org>
In-Reply-To: <20250902185855.25919-2-fw@strlen.de>
References: <20250902185855.25919-1-fw@strlen.de>
	<20250902185855.25919-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue,  2 Sep 2025 20:58:54 +0200 Florian Westphal wrote:
> Yi Chen reports that 'udpclash' loops forever depending on compiler
> (and optimization level used); while (x =3D=3D 1) gets optimized into
> for (;;).  Switch to stdatomic to prevent this.

gcc version 15.1.1 (F42) w/ whatever flags kselftests use appear to be
unaware of this macro:

udpclash.c:33:26: error: implicit declaration of function =E2=80=98ATOMIC_V=
AR_INIT=E2=80=99; did you mean =E2=80=98ATOMIC_FLAG_INIT=E2=80=99? [-Wimpli=
cit-function-declaration]
   33 | static atomic_int wait =3D ATOMIC_VAR_INIT(1);
      |                          ^~~~~~~~~~~~~~~
      |                          ATOMIC_FLAG_INIT
udpclash.c:33:26: error: initializer element is not constant

Could you perhaps use volatile instead?

> +#include <stdatomic.h>
>  #include <stdio.h>
>  #include <string.h>
>  #include <stdlib.h>
> @@ -29,7 +30,7 @@ struct thread_args {
>  	int sockfd;
>  };
> =20
> -static int wait =3D 1;
> +static atomic_int wait =3D ATOMIC_VAR_INIT(1);
> =20
>  static void *thread_main(void *varg)
>  {

