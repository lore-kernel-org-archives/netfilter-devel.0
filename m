Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418F132470A
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768843010; cv=pass; b=cQaASYHTdZmQyyF6+8pM0+567VQ0tyNnx5SMtCFdzjcOFTf8MAeZfy6hzsmrUDw7K46pjljPIcpStGOu5i6TaQ/q4f8cgBDslxZfdIMCUb2tPDeceSTSc/ZjrabdCoAGJB9yNca1j8jvBUuk/cfZFDm/UaBVrysZUQ/RTnoXzLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768843010; c=relaxed/simple;
	bh=ZsGcxa3/dujvAI4Rmb4qGNPcgAP3/YJKOOLBJnfEpuA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KJKJGDxptpPFepNe4t0UM+HHHodeSOxa9YMaGnZSDkn20Xii89lehGarJPy1K3tLGTMY7mD0xCF520/J0M9Acpc9R6gnMj0eJwNSe5RzO3umaEBjJVjKjD4KlI0s/Q9s2k3A4fwwEbyVxvEroZeDFNNh52WRHcScK3oCqyz1KwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HMFxGtQJ; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMFxGtQJ"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42fbc305552so3394065f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 09:16:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768843007; cv=none;
        d=google.com; s=arc-20240605;
        b=H0rsPK4rknuKoutVJ4lAt7NUaE7B6gdbCY0WNOtdCK1QGjKQ4fD+d5NFtCUpTpu5Td
         HzF7TctgBknPHgh1qhalQtGomdSlS2OCkexZdGOPpBnL9Hfa58u1BMlLdkyuugaNrOaT
         U3MGBt+xP6kJ5HrBv4tmeW2dRMwCxe/FZZG82dN35wfkg4kWIBr1kL1OLcJfV/1YdvJ2
         5gEVU9aV2o7kBpVmsgb06/S/ECMbaMQbB+EE6eL8Y6sp50T4rnlzSqqbdl53qhezReVe
         OeA9eFrbf7rq0tYisM4o+8pRXI0FhCetNAXTcBZsEv2k6LLMl4aPfzxJjqBVE7/0etM8
         4BMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fWkUXehTFxDxM5oaQU46NekzR5HsGH8LROOWkLyzh8s=;
        fh=3B9psspIs6WqWF6vCprWlw7eYlq2I/h8n4KV6h4Hv/M=;
        b=YCURN8ZlaWInH8ksGfi5WFQG9euk1tq4B2iLwsWLmPGUP8NWYrLj6QMoOj4iQYbuSH
         R53kAXzQjcBQQouXbNQZu3UGbxBDbHjzEw4V8SA8nbKcHTZFugyKy1Kz38ok8oTZDTPQ
         Wveuf16tM1er2WMuu08S8QhhYNxBtuIt7wKqToqKgEsVI6lwoJ/U3EOCalTJXcZ55kAx
         zHCLQlWUAKhtWLHu4zQGh+MNXBP31XuQ68kxRQLKyvDRe7a4Hf9ypC58vctGjPHXCW1l
         Xq6udkLzD+IneZDBicDkYH4J44iunrXtHTh062rS2I5jxC6jmeGuqzksFWh1MHuuqOWV
         OnuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768843007; x=1769447807; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fWkUXehTFxDxM5oaQU46NekzR5HsGH8LROOWkLyzh8s=;
        b=HMFxGtQJB8yNIu+iVcfduKq8+H3jqRLpQiFPcT2JeIgJqtgWOvjV1F8lqYWHMHDzsc
         Jrb6SODsSSIx7IcLImFT2MJpUHgtO3YcCA7+kiosGu8mS3zsCcmkN/Fl8V/M3zAM0KbS
         k4XJ6ah/+Yz4Av71A+4SJI2jj91J0fri16+gggYbliR0aRVXwQtAtv0LI+5RWDaoQg1O
         75+GfZh77gq2hQhpuTHRHe3L5ObCCWiciWE/7oXWaMitr+L2vXSVFA3i/raNZZDz7dwT
         xzBz9k+irhxfskVD+xVxSiwt7DV/3Em9ij5ppgQslSEz7xJ0czzdzptalO2dbO2sEFWO
         3yrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768843007; x=1769447807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fWkUXehTFxDxM5oaQU46NekzR5HsGH8LROOWkLyzh8s=;
        b=BSzKHT6TLqdN7JZEPpbqaFyrKB7s2sz0IKBgkb0DEmxvhY5r7zDE6meXt4uk2e6l4F
         YiqiTHgG7KYHK3Nu4Qd9wW6rZqhmpPmmOy/az9ZS5XdejSqH6F6CHf0ooiO06RgUoKXD
         RO1ZQj3g2XlM4zl/7jPWBSQEfINHbJVhpDjAIltvYENUEQ4M3wj4dST/f6tMZoaxo0T8
         5WWmR3MYRXzmTzNtGrebLTbfFNIYg1BzJY/kmSGkAvawIFFnh6dOh0TX485quA1INLcx
         Ptg7ZPTYcvqeTkVUbyhS96csM/9cL0r91usAodXZy8RUYX7fdFluB+tV8AYsfeiC81R4
         2VkA==
X-Forwarded-Encrypted: i=1; AJvYcCUy6Ja/CMUNTkvvIIlI1BAyHvCr7I5ZqqV3TKT3ly8Qq1lOwG49rU30o6wAqlMPhIWhRA2Kq3ltR+SVYJeOIMw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDE9d0KsZAz3cuxQ+7fPapOnowWymwhLtZR5ugSs+s6yLR1L6B
	jZ+rUWGb7M3CEEL51WvDozJG9eQvQK3KWtV3Wp8Ej4JcwAKclFE/gMpv1TXSJniZVkWVbmLlhtj
	qKtw+9ZAb6MFauyy2Sajz2PoEjU6H2aE=
X-Gm-Gg: AZuq6aL4bemD97thLTh3WJsfD+gIl+rRJAf/JHZL7+3GrbUDn643z8ZYd1aJ1bsKiZj
	wNUWhuOm9CofTsP7GOL14i6JTamdKB1J+uWiM0i88H4BmEYAC4/fmKvpVqvNWRzrGuW6mlBcsiv
	My2GaFKyidcNfJ8BsIhzjnfp8gooq+blwy5MVqXKMMlr04o4xphbj+g0YpvCsttDGYK3qGI9zd+
	+no7eX+nlW2Zb8HZY2bCJNaDW4Zj0DtItf/NGMJMFPaRCBDfAQzF1NDHLnnfWd2Oa2VPSu5Itwz
	nY8ppHmYoCA0YiDSYmpy/d/yyYeuDNUhaKHBSU+JhfALogPtX/BlpVg=
X-Received: by 2002:a05:6000:2282:b0:430:fc63:8d0 with SMTP id
 ffacd0b85a97d-4356a0773aemr14767256f8f.36.1768843007458; Mon, 19 Jan 2026
 09:16:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260119091615.1880992-1-sun.jian.kdev@gmail.com>
In-Reply-To: <20260119091615.1880992-1-sun.jian.kdev@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 19 Jan 2026 09:16:36 -0800
X-Gm-Features: AZwV_QhGkCpvhEfASfQzOJSn-VdxNup-v3_JeJot5VLuqsiIqW0y6hGuFkj_iBM
Message-ID: <CAADnVQ+j8Q5+2KSsaddj3nmU1EkuRAt8XwM=zcSrfQfY+A1PsA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_flow_table_bpf: add prototype for bpf_xdp_flow_lookup()
To: Sun Jian <sun.jian.kdev@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, 
	Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
	netfilter-devel <netfilter-devel@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 1:16=E2=80=AFAM Sun Jian <sun.jian.kdev@gmail.com> =
wrote:
>
> Sparse reports:
>
>   netfilter/nf_flow_table_bpf.c:58:45:
>     symbol 'bpf_xdp_flow_lookup' was not declared. Should it be static?
>
> bpf_xdp_flow_lookup() is exported as a __bpf_kfunc and must remain
> non-static. Add a forward declaration to provide an explicit prototype
> , only to silence the sparse warning.

No. Ignore the warning. Sparse is incorrect.
We have hundreds of such bogus warnings. Do NOT attempt to send
more patches to "fix" them.

pw-bot: cr
