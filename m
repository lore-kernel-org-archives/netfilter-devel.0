Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CABF3672BA
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 07:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778571431; cv=pass; b=U1tf7pqVCmdAbywEZlUj7SfRXG0IgjHEAUUk8Nn/63mBWUqC1yI3HquduqXEvcBGsd7NR0Hut5R32hjqcyssEAS4trcnSAWgqVJgYMbphf7KeaOYqgTKDVCz7wV3wxK/q1V1Fib/how/mKsFNZy5IiQIjBxi0iU7itq5yJu6Vng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778571431; c=relaxed/simple;
	bh=bSuyYGGeEmgGvulV57SOqbxrkuecVl057GaOQUAOAak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M+4TQoeDSWQ6AUEPt95s5pMGoHyPmVkzGacspQVw2CiXyHBXrQhdi8jIf9B1FRYdj+i/1FboJOzAr2HuO7nu6uofveCiyoh/kejvq4q8Inrg6PMbnbyqrTzaMsNrBzyOsKvCyCJb4hmjjf+v1sO6nEUPZSrBQa/jdOZS7HZVLYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AOLMsxdl; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AOLMsxdl"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a86e4b950cso3776944e87.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 00:37:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778571428; cv=none;
        d=google.com; s=arc-20240605;
        b=GHJIeLgb5TPhzTtolzju8PDnVxPw4FxSaLaa19Qnh/nygZCBwEckP8U8KDvmD5y+0j
         XV0Cw2GzlJl6ApZW2nD9I0N6EOUEv/hQA4KVZ/FYEdT0c7wBKPfNHGi8QeRrQN7vIOx5
         aHwpQEIOxF1aNC7FTcWeuRoSW1ZFJlkPQyaeomTS/dYHV8/xXtk9ZEinyyIXvFzCazDj
         dIdUoYanujxuoaJHdiR3drTfyzzkN6WAaRkoYCpXYLHaDmbdSVxAAJIqWs9llfEA1QDx
         xIgouSIpDisErJ2Gq9RAA3KmKQzfkRcPak06KKO6gK/8NEsRBj9KQmstqI6tnUbn6V/H
         qQVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YiGO1DzHy3oKJw39dEBo3ubhTMAjwaktPDTRNxo6tIs=;
        fh=gA/T2XMN94BRteIAXP9Su0gJhu35UrX/6stGi74qLKI=;
        b=Y5houtwYl8gjLDLZg6o8It0YKqSGOmIUM7FyJCENArdu7IK120s/lUDH9oKkcIlKMa
         C3Qbb1LUwv25+wWl70P0zelJ+TgZRINhzBwL+gD+xuCwkRq0jpK1qsuk9X8HYbE098cQ
         /s4cU1242uuBqrxzqZQ2Ai9JnANATIMV6IPDy33zNFVBMA6GmOdqBRVXgxPd1twu3TCT
         /ePFYPcjqX7/H0oF9M3iLwqV1FLYP/MZyfL0U2XMj8Y+gF6YMPaapzuVoH7PncwvibAT
         FhJyvgb4475ruk9C57IU/6psbnaDf7FlDbzM5a+QY3hQ4qQltKPcpLxorbvxS4DnU9MB
         cMOA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778571427; x=1779176227; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YiGO1DzHy3oKJw39dEBo3ubhTMAjwaktPDTRNxo6tIs=;
        b=AOLMsxdl95RNOS40d/rtmgSLXWgPQOt8ahxDC98SXp7tJzs3Z0q33cublMzo5/5b0g
         yXX76g9PkD7gsk0pmOY7/nhW1JRZuZujU/Ov5Gg/YUQ3LpWGhv1JSjh7I8cHmfsrBaqN
         MKl30+aVCEVIfykxhfEYhqPRXrdWeMXx6gptCRU6c8Y0pjD3CcQFlwuNyBIbdi30udYR
         c/dKu8U2SLVAG2+TbuV70DpACrlVpAVoj4LU3id0oNhKWQLWIh9E3xjRCeSh+4k0ob+C
         zQalwA9xV3N6u9uRNP1T+SA9b6Sn7pergW3wonQ9up/alUvVjnm/4Tyx2jOFcNgPKyZw
         6w+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778571427; x=1779176227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YiGO1DzHy3oKJw39dEBo3ubhTMAjwaktPDTRNxo6tIs=;
        b=PW/+mB5fzChQ/bP9Vnf+CWhxxQYRtUS99eo7QCOT068/4ZobQBv4BMYY5oIj9u5NTf
         dbfdfctbILu/+8ZH8tjB1hVpuMxYcKYjbeNak9xugqEgxXkITUWDvt8LABLtSIx99EhO
         7G/PzH5jFB08+dECtibEE+t++54RvJgWT4BXsW3mum2BrUldrDmMjoVjp5BSGYccnPJk
         /h4amHvLmEMBibNw37y2O6j1xwfHDWzcVOkffWp5ezKB3PgWHOaGGXN0a0EeCT1VQmtj
         uiluaau2XmQhk6sJP8KRozkWKuqWrpuZqX/OqFfxWD1Y0cvs+HZKCDTTO4UXDgeYVt+1
         QsKQ==
X-Forwarded-Encrypted: i=1; AFNElJ8faTns44N7XfbrFQ9TgbAChQBq8L8fUcTQ3MVkPwxSg81nzJQzJ3HHNvn44TZv3AvU4Ep6ABMHih4a9sbvgYU=@vger.kernel.org
X-Gm-Message-State: AOJu0YytFeRGxNe0YXU5FUHJxsbvX6xiP2eMSseDEAtul+EHVuKPeY90
	Ss7djO31GliLJWNlowyP1Svbbh8MorrRbtbz0cSKWJqDuO1D3haD7yJ3UN1nTYU+JujWiNw72Vw
	Un0ZLYQ35HfCHYOwuafROnqC35IqS1t5e1IqSYQMA2g==
X-Gm-Gg: Acq92OFi+78ghOjko8JC33oFuUyRLI89k/+JUrIg2yURjLwyNMquIsxPpsSIFFWGas4
	sseEhr9Le99FTQf+jv/WunQ6eAW35WfksjStDfFRtM0emRq1xgldjQrUhV3UUJIHb2JbND9W3FB
	skt+sAOpWuvYzc4VvnSb0r7ckKGpsBKSEokoBevCl9/BRRurbonfbk+fAS7HIdEvx1sYFXg2gtC
	qDuDNLcdwHXDpPif3fQI/ZiA4vCB6faRcUQVvEfRzKIcDx9HFyQHFmwnfoO2iLS0VkUvw68WQ9U
	onIsxxmsLfSqKwdaM2aCgR482NALa+LHgpOk3QDu
X-Received: by 2002:ac2:4f03:0:b0:5a3:cc81:eff3 with SMTP id
 2adb3069b0e04-5a8e31e792cmr603618e87.26.1778571427561; Tue, 12 May 2026
 00:37:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260511134744.277032-1-marco.crivellari@suse.com>
 <20260511134744.277032-3-marco.crivellari@suse.com> <734b9aa0-3af4-819a-49fe-8bba7035856f@ssi.bg>
In-Reply-To: <734b9aa0-3af4-819a-49fe-8bba7035856f@ssi.bg>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Tue, 12 May 2026 09:36:56 +0200
X-Gm-Features: AVHnY4Lehk_93YiMVYGd670SPnAUadqGsUhTvlPZSmybCIwdKkGr50QbaYqby5c
Message-ID: <CAAofZF43Yee8ZutA0mR=PnsinkbHwFEafQqtVPvcACpVNhtu=Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] ipvs: Replace use of system_unbound_wq with system_dfl_wq
To: Julian Anastasov <ja@ssi.bg>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Simon Horman <horms@verge.net.au>, Eric Dumazet <edumazet@google.com>, 
	"David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 12, 2026 at 6:22=E2=80=AFAM Julian Anastasov <ja@ssi.bg> wrote:
> [...]
>         Sorry that such change was delayed but there were
> many changes in IPVS for the last month. The last that may
> delay this patch is:
>
> v3 of "ipvs: avoid possible loop in ip_vs_dst_event on resizing"
> https://lore.kernel.org/lvs-devel/20260510104605.24218-1-ja@ssi.bg/T/#u
>
>         May be we have to wait this change to reach net and
> net-next. Also, we can reconsider which queue to use, these works
> resize hash tables and call synchronize_rcu(), should we switch to
> system_dfl_long_wq if such job is considered "long" ?

Hello Julian,

Thanks for letting me know.

Yes, if it is considered long we can switch to the long unbound version.
I will prepare the v2 with this change.

Thanks!

--

Marco Crivellari

SUSE Labs
