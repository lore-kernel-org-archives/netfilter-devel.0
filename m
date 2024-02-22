Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA7B125D7
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Feb 2024 07:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708587906; cv=none; b=KH9yL00yX+y7kkiRnUVPevcZf2GjZUTyMCPq80jkpkCdz8xwP7+iMQEiEDMlqDLjFK9IWNYfAljJRkJxlIOCKugofzSQRf4SdUSxDp7RlWT3YeQM2dbJSHPkuDpOHgYRlrneq6B7Hch0NXgjNeE4vzVDfqVBdRvUbWD72/U6DpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708587906; c=relaxed/simple;
	bh=lhjqRGMIYENFX3qdIMaxUZbAaNfTuAWSKbvy+ajhLvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NdvDWfGv7ftDl/ti9Ikp9Cuhvw9ZK4qz4985PcNBq6WkB6d93wKFF4cmG+ZKx5y3ELkbFY+TIRQD6OcbsPyLm7uF5EUzxQ7MoNeHOjsrA8FrOmP3u1oy5aTCZY+Bikvz2ejj8CLtZoSapxTJmg/NYmAiV6T8NKSxtPfwKFgR088=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=GQRGgvaq; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="GQRGgvaq"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-295c8b795e2so4533733a91.0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Feb 2024 23:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1708587904; x=1709192704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4JOmNadOrKON30DY4+7RS7tfnRA2CiB1362+FQbBVjw=;
        b=GQRGgvaqZfyIJs8rqUC6fm5O1ezZ/tZLaUisDZxiU0sEX1Pa115Q+b+kh/DKIP6ed5
         dr3arW6fT6JwFNVP3+nNXsARfrmu+EhRczfHoqM3rfWShISTrtt5IMOXKW+pjUGyQS1c
         QrDhWSp5cutNYm5pCTDSRuFBn1wdhBgVXUJsf2VLQKXohy0dJmTie6AZEBUa5FPKmj5f
         91JHOxQy24bbLAmelB4/iOWL1n9BW8nQRJxVJA1AF5F31BKzdzi+JbH+edxZWT0pVBfJ
         ZntJA3YT5S2EICMb1ngF39iSADXmkhZJ8KyZBM9SBfSpKbJawSPBsqJV9764EDzO+cG1
         qwQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708587904; x=1709192704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JOmNadOrKON30DY4+7RS7tfnRA2CiB1362+FQbBVjw=;
        b=C7DZL9IB8C0Xa0LOY52eLGB/fIpgtcwsmr0onHII0dRNnLcxUsrohj1OYFJ8pHaQLP
         UNuChaHXuwsRPvKjPozDUKT4go4VkI3/U4r1ljm+DIiJgF83vqeWDk/eFlakEhhXy7tj
         LbgnJZnOXcpdRg3HV9J3RkBl9y+q1HRmWFquj7J6CTW//l9/XLU8u3us88X8/o3RUe+z
         0xDJdEkXnW1Dunk4zKFq2r/I2od4jECMOHw0NpsqvY+5oYe13EfKiXpGC911/C32AlPt
         vNJBtwFuzWBTWw3tL3m6/WOQ7+mS3kFMwENQ6rCXLE45KnnLkm2oa2WwzC96JmssYObP
         CySA==
X-Forwarded-Encrypted: i=1; AJvYcCWo1TzMwurZcN1ghuqel+l2KIR6a8HiCSVkWAsSaOzBNthQeI75qXeQWTZuMFN/xakmWUZThrQeTxJMxSnwY+lEVAXWvs93waqUinfGCPwc
X-Gm-Message-State: AOJu0YwR/9kOTbIMc1YQ6yLSq0JK/eLKZgWXnnw6piHyNV0W24rt45gX
	w+PskSZEX51/e4NJoN/HdUrrQM3+WMWNlDOn/0519yqcQZR6tnSMf9qNKq4SXdgbyWbhZpoPj+g
	YHY9tYPG4hN61Bqe62kJ8piRLzYWrWVyM+A+GI4UIJVaGghiV
X-Google-Smtp-Source: AGHT+IGYxWmwMxgbxfjOEpleDQvnCQ0O0UE5FzyRGh7ztk1Q0Jw/QCn6X4s6Z2Aq3U5Sz4CaKXZSHjh6+XUf8LM4r2s=
X-Received: by 2002:a17:90a:8c07:b0:299:3c73:8d2b with SMTP id
 a7-20020a17090a8c0700b002993c738d2bmr13140504pjo.14.1708587904030; Wed, 21
 Feb 2024 23:45:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240220145509.53357-1-ignat@cloudflare.com> <ZdaSIRv3HBcEUpy9@calendula>
In-Reply-To: <ZdaSIRv3HBcEUpy9@calendula>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 22 Feb 2024 07:44:52 +0000
Message-ID: <CALrw=nEQJ5thzJL1PsigCju-B=ONYcuyraxiXzCGzp+yizWmTg@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, kernel-team@cloudflare.com, jgriege@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 12:15=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter=
.org> wrote:
>
> On Tue, Feb 20, 2024 at 02:55:09PM +0000, Ignat Korchagin wrote:
> > Commit d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family")=
 added
> > some validation of NFPROTO_* families in the nft_compat module, but it =
broke
> > the ability to use legacy iptables modules in dual-stack nftables.
> >
> > While with legacy iptables one had to independently manage IPv4 and IPv=
6 tables,
> > with nftables it is possible to have dual-stack tables sharing the rule=
s.
> > Moreover, it was possible to use rules based on legacy iptables match/t=
arget
> > modules in dual-stack nftables. Consider the following program:
> >
> > ```
> >
> > /* #define TBL_FAMILY NFPROTO_IPV4 */
> >
> > /*
> >  * creates something like below
> >  * table inet testfw {
> >  *   chain input {
> >  *     type filter hook prerouting priority filter; policy accept;
> >  *     bytecode counter packets 0 bytes 0 accept
>
> Upstream nft does not provides this. Please, clarify that this the
> output with the out-of-tree patch,
>
> >  *   }
> >  * }
> >  *
> >  * compile:
> >  * cc -o nftbpf nftbpf.c -lnftnl -lmnl
> >  */
> > int main(void)
>
> Please, no program in the commit description, it makes it too long,
> I am not sure this is the good place to store this.

What if I replace the table and chain creation with nft commands and
just leave the code creating the rule? This would make the overall
program shorter, but would still illustrate the example

> > ```
> >
> > Above creates an INET dual-stack family table using xt_bpf based rule. =
After
> > d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") we get
> > EOPNOTSUPP for the above configuration.
> >
> > Fix this by allowing NFPROTO_INET for nft_(match/target)_validate(), bu=
t also
> > restrict the functions to classic iptables hooks.
> >
> > Changes in v2:
> >   * restrict nft_(match/target)_validate() to classic iptables hooks
> >   * rewrite example program to use unmodified libnftnl
>
> Thanks! Please send a v3 with updates.
