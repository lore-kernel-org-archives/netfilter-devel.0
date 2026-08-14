Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100053D5C1E
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2026 21:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786741815; cv=none; b=fG/nzeUBesy1U7eBIN17fMAPKjqBKrGTrVlqpjy2kryI/YiGLxqTh5wsT8cN0JH8yiEk1ifJaODZg1/OjIVFfdcROUcoBs+Mc7eqJ9n8/LcYxOq8SfapYk+8iPH3i8lvjwMVizTgabu6d+DuXf0tQm4+lZNhtXfzR9F1eExTysA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786741815; c=relaxed/simple;
	bh=EKcYi9z6xbpXnemJQFTGjOT9CvorWyrJ2muBkaIbS/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=txDQo3HAxydl7jCwaAD7Cp5yFmnfgcXZNDFygHX8Mf25pJesOTEFMxD/L8rh4xKOEQNMv4xM82gj0wRiO41PE+5Bzn3GGNuWLBDCHyYkqEW9kLPZndKOlm+FvZuMYICmxIREgPu6zvu67vyfpYdZFDjJj26GusIGAVDYT56ebg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SjqGL7PM; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjqGL7PM"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so2015614a91.0
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2026 14:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786741808; x=1787346608; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ukY1zIzuLb7bJgbrlZZkQqcy4BIL48uacwo+r+Ameik=;
        b=SjqGL7PMtpvXOdQaKWd/5xgUZkAXMOfIhs1phZTa6/lVffd6EC5/K3zYGXOBJYwH6Y
         z2O/SezYtxo7Whtb3GW7nsKpCzaxu/2z4LcqGETbz7zYEMQRzz5bMLnr2xX0bf1EWFQt
         7LB/L42FXuyhpEhRRb3QhzLJT/Ey4hbBiSRymjf5sbKezcYQvn20MWWV4/dMTK2dWLwp
         8T1biDAp69OW1FxhVw4JQts8SiSsoqfATQTHvkjbhnjJ/6daeuk42ZJb/ICVZw8l0o7t
         hIVAK4kyy5659ayZygGjqEdhSECHSGIYAehlzLeNbOeLzcL3q2YEj1VvN8K7PjMmSBfH
         m5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786741808; x=1787346608;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ukY1zIzuLb7bJgbrlZZkQqcy4BIL48uacwo+r+Ameik=;
        b=sgid+3m6/+7iLj99wsBkviEbIC6RIpJiaPxYA4Ci8MdSOzZgLMR0gXlau7+HWpgFFQ
         WEYa3G762ShMXGK1AwnUTcA80pclkDOiUlUMB52/Cibx+4MNpUwCicAgp4vipk8vPV6M
         UA1YLT+Wi7TFDqnSoSJw2Gqe1MOU7J0N943IXnA9nuI/aCHazSPEkSnzJ3kiPOfC+CnN
         X+EUcy2jyPCQ45RXLXpQO2Xa2cer8ebfRHVKCcWSz3VmtU4DQxQRcbjXGZa60H0y15uu
         CmuYsb02bDpZSTGn3ywTqz8pvYxIgMtHcDd7g5yzLsqdDJmO+T0S3zbgo5i4zhAOWLz3
         DROw==
X-Forwarded-Encrypted: i=1; AHgh+RqtZ9oHbQ5EY/icPxCVCtDa3H48GZPy5Yg9urY3F7DWA1I3QC9N+atg2Y7UxcbKKB4HoFWiT2SDz6ZgWNlLV4c=@vger.kernel.org
X-Gm-Message-State: AOJu0YznKBkcFccSoNggmJWCXDiTlQzjc7ZexrhTwMlQtmCGs/8AXBUE
	RVEXnEprWlZngiSPIvq41TUGyi0IvFOQPRourtx4VVT3tB5cld8Jt7qsa26YMA==
X-Gm-Gg: AR+sD13iXdWBtGJT+Fe0O3iBCSSXnraTkcHBe3OsyJGEYGTple6Ca10ClZc6YhXnjez
	rY1kE8+WRg4WmtmmFPFkAt9khUFfkT/PYVgoxvbwe5POcXmX9l0xMbiMFlpTSpZCCaEt0McJXln
	FhIa58usFf/k9NQ21utonbu42NYS74eJ34pQVwMoPmD+ZGL0yBcymbl3EnUHhEDdGq7PN7+DdkW
	h1p81UgrPiTeagbt19cltRDpkjv5HMs/c7HO7BrP5PQYr6tYJA4dLAA5hQT1Vdsjamv9jta1zDG
	X6RHTOnPsQko4xavOGlz3RJYxV6gXSB+aed1TkVX+M9CqRocK8t47q+sWTalQgmptCJ0IpJ8rop
	SYzjNqLir0AWQ1BqhyKZbdin8mn3EvXJOVOOS9sisaJKVycexjvH4kfZcUaYnt1oFL6Q9PjvEoq
	y/kADSH0kzkj5x6j4Tn6iEAG2ybgNQAKCx2zS0zAKaICZo5a+DJelH43x54XrBca/6ttlRdracj
	wmiIZhoo3SNXIIjonRU5+HKz6w/DTfLb0DncRM=
X-Received: by 2002:a17:90b:384b:b0:37f:e1af:df22 with SMTP id 98e67ed59e1d1-3933ba90e38mr9014933a91.17.1786741808429;
        Fri, 14 Aug 2026 14:10:08 -0700 (PDT)
Received: from r912.tailbb6e1e.ts.net ([106.216.241.121])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320e9df03e1sm7596348eec.16.2026.08.14.14.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 14:10:07 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: reject negative values for unsigned datatypes
Date: Sat, 15 Aug 2026 02:40:02 +0530
Message-ID: <20260814211002.2812806-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <an2_gW-ZhrAACQmb@chamomile>
References: <20260808013318.2766219-1-avinash.duduskar@gmail.com> <an2o0fusJ0K-_CbS@orbyte.nwl.cc> <an2_gW-ZhrAACQmb@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Thu, Aug 13, 2026 at 02:58:41PM +0200, Pablo Neira Ayuso wrote:
> Yes, I wonder if we can do this in a more generic way, like specifying
> in the datatype itself the min and maximum value expected from the
> integer.

Turns out the special case should not exist at all: it is dead code, so
neither the flag bit nor a validate callback would have a user here.

A negative priority never arrives at this check as a negative mpz. Bare
and json numeric priorities are built as raw C ints by both frontends,
priority_type_parse() throws away integer_type_parse()'s result and
rebuilds symbols from atoi(), and the name-plus-offset forms are
computed as C ints in evaluate_priority(). Instrumenting the top of
expr_evaluate_integer() agrees:

  priority -300 (text)  dtype=priority  sgn=1   val=4294966996
  prio: -300    (json)  dtype=priority  sgn=1   val=4294966996
  element "-1"          dtype=mark      sgn=-1  val=-1

On min/max: both bounds this function enforces today come from the eval
context (ectx.maxval from numgen/hash, the mask from ectx.len), not from
the datatype, so a validate hook would sit beside them with no in-tree
user.

Dropping the special case also covers a third spelling of the bug found
while testing: "elem": [-1] as a json number is accepted today and
stored as element 1, like the string forms. The plain check rejects it
too.

v2 follows with the unconditional check and test arms for all three
forms plus flowtable priority. If the validate interface is wanted for
other reasons, I would do it as a separate patch on top.

Thanks,
Avinash
