Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792572801;
	b=slprfSoStKXM07RPdHcBrlDyMeIty1kDO4GWKXS5leFEafspJVrjap0WDMt1ZVER/Q+s
	 xSV4LA6DZ5UQRMVWDVt0JtbJVk207SKVrQRTQ/SBdaJJj4FBblQwGnRPtGnOA0w+uwKij
	 PL75FQVN6wehQh+kPCAFAXQAW/Bj/ETfaYjfAnLC62DAB/zFFNM9cO0jah12eOQMwHdl5
	 GWZitpaFUJszFJsUNVEvls5cHI8AHIRkZAeT80vMbS8woN68dTi2LWmFNYp1HtCbVSqVh
	 0g8FtVpDo9EYpgt0n/FIRwGlawPlnkCaaMAjXJ6JMMLgjGluypG8p00HEZskII3LsRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792572801;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=wa2jhPxRyIFcLvS9sFW7VQPzgY1oXyeSja3fw5aXHoc=;
	b=wO136Q6n23MAfQOYNHic5e3a9uclRkfB4g0qKYqjy3v1PacY0/B9JrKbTsscjOSgMNUW
	 WPGCpKT8c0ndf0QTfUS95BQjOuDzxNqLRG+GyonXYGYy455M9r2Mt6DurTUGKw+4ZN/+z
	 lkfGD2duE1kwFc6txbe90V1T2FPoRA+tAWqfkpbWQSI+sJCgcd/S2TCU6nvItHg5ek9Va
	 c+wbxiVQpataTfr6+tkvojHajLF9sDWtUYm00XmfWc1vfpGPBzaqDtoDqB1xor4T30gCD
	 Tj27lTeDc0yJM2CfeiAnnP0RV1vb4tdUNoYn10RIpfChPSCwvQqFOX4/8ZD2uujv3Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=myjYfE7g;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6C7EA606A319
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 08:53:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C7EA606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=myjYfE7g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792572798;
	bh=wa2jhPxRyIFcLvS9sFW7VQPzgY1oXyeSja3fw5aXHoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=myjYfE7gjb+CRz6HuxSBDyoPfzWazxrEI2uqTkIr6Uwj/bM1oEy2qT3bZ0AQ3IQvD
	 7cptyohf4M/vmAoHWuHB55NfyahR/ngvAkKMAJlasFM38fc2OABzbXbioBDK10PPmd
	 PZLuJFl2jw884Ep+QO1fZ/Hrqr0OUjPagT90CWpBUEOJcgy4jcetZSmLwCsBCrbAiP
	 VEYhtFJIvGUVJUr2njPiTC8xhYsDoCbeq/N0m8VJGDkWB+xUZDskaFjKqsNl3AF8Ce
	 WoQW+6oXtR8BCSJjNdYOdJe9DyjJxiuv+NzW0QIZos6ODwqcf8SQNg7Sy3KvgX6LFV
	 0KvFlA7NlY74w==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8EDC760055;
	Wed, 21 Oct 2026 10:53:18 +0200 (CEST)
Date: Wed, 21 Oct 2026 10:53:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Pulse Zy <zypulsecore@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] conntrack: apply the receive buffer size
 to the event socket
Message-ID: <ath9exRvU55IyGAc@chamomile>
References: <CAC9WPdyPZNTHOMmm+C2shvJntRytoD6Zj17Q3MWFmjZQTv5+QA@mail.gmail.com>
 <atf2bRP7z2j8gogm@chamomile>
 <atf25JhLxwTY8kha@chamomile>
 <CAC9WPdzTfkn+-XyJ+_9n8Y03KHhaATQYnegt6nPQ5rcFHx=+qA@mail.gmail.com>
 <ath4KREFLT3z0cR9@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ath4KREFLT3z0cR9@chamomile>

On Wed, Oct 21, 2026 at 10:30:33AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 20, 2026 at 07:55:43PM -0400, Pulse Zy wrote:
> > Thanks for applying the patch!
> > 
> > I checked the commit and noticed that both the author and committer
> > are set to you. Would it be possible to correct the author to Yuen Su
> > <zypulsecore@gmail.com>?
> 
> Too late, sorry :-)

Oh, actually I mean to use this emoticon :-(
