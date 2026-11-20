Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168805;
	b=0gkx4D1oRyuLzGX/LSRuDvawAhjqB6jKKBDLcuJkMeOCSaCzfdOfgB9qqq8K4izNLD6Z
	 +y0oE2fvCYuCgjQcZEmP7le9dg7ARJkI2dAaLEs3yYbpN1ILsNm0EyAKB4F8Q4luFVEcF
	 7t50GMlubQjyYCU7cN2T2YNbz8mYAwxTMuB4j//FBSo5B43UY8xFdy1TFsJGNtTvgF5pH
	 aa3fJSSlyDYhQ1kvmHEZ23xMgO2tzt8OHoteyNocLdartKOhaOSep5QMTnWLkhWVv6TvR
	 z4aMBIMqcXuJLxkUG5NHL9UmIrvx6jIB99WFtlh6h9kxMqcW2N6qOdPmsxaVUtT606g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168805;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=B7X/qXWT3OY5wBn46qAFt/jPdQNoq2Ryqy9ODRp8mC4=;
	b=xTWrz7/ManbtiOWdWgSOVbAiz4H/gGdq0BlIn/RM1lCxgr5KV9zKZbyknDIF3QWRjMhP
	 JWkcOrroueGludVaA7sGyQkWro15kMYKRqRnQmqf/26IR8MH3hdr2odOE2/0yeIiLyVGq
	 zlsOdda7UqNvGPnrzWSDQTn3xSSywMQBP2cEHjPPXQm7kCyRfydM9L1fCZhe/2Jyoy5Qr
	 fcGEUKKgzIHSg9DQPA5E2fVA102ocL4qSHso45ccp+oBGsurhAGuZHvqXRL7kJa+C1i/x
	 8zCuzS0WQXEOlyIuy/JcmKwAl7aDUbmCo7+Rez+qzAGG/fqf+XZKj08i6TFkbK61cQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="dJjDihw/";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 46958606A332;
	Fri, 20 Nov 2026 10:00:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46958606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dJjDihw/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795168801;
	bh=B7X/qXWT3OY5wBn46qAFt/jPdQNoq2Ryqy9ODRp8mC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dJjDihw/3iwh/wjy+Uf9CP5hjCBJ4URkzvpXhg8Mx+zfUlj1V/oz4G1IxKbhVOsj4
	 thNHRG6JBFg7spfr81hKg37MqdMuqhY0jTIVABZeOcQcGRa6jLX3nDUYtSofp5DgT+
	 PmtBHU497vWvppLplF+sZFfpSSLEJ4n8K4lnKborpAF/lycOYYVhVkb8S/l3exHWTb
	 VwY49Z+kXbR/jBlqjlsXMJribCWwF6Q6pBrLnuBNH0uV+iQr8uyUK1Jyy6e0pDbV6V
	 b58MSL9QcEQIGm3VaSlyMG5Zbt4DctRobgqP5k/Wf1+4qxoJ2icI8bDs0johEDWGTy
	 G6Za2jmxukQzQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B85A760057;
	Fri, 20 Nov 2026 11:00:01 +0100 (CET)
Date: Fri, 20 Nov 2026 10:59:58 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Willy Tarreau <w@1wt.eu>, n3rd <18670333770@163.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>,
	"security@kernel.org" <security@kernel.org>
Subject: Re: [SECURITY] netfilter: ipset: double free in hash resize vs
 inline gc
Message-ID: <awAaHlAKHEMyiVi8@chamomile>
References: <3a7a0984.dc22e.1a1f6bb0630.Coremail.18670333770@163.com>
 <av_cqPmvrh5iT8Tw@1wt.eu>
 <3a321704-59ad-7756-102c-a5c6ae77be88@blackhole.kfki.hu>
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
In-Reply-To: <3a321704-59ad-7756-102c-a5c6ae77be88@blackhole.kfki.hu>

Hi,

On Fri, Nov 20, 2026 at 09:28:02AM +0100, Jozsef Kadlecsik wrote:
> Hi,
> 
> On Fri, 20 Nov 2026, Willy Tarreau wrote:
[..]
> > Can you please propose patches for your different reports ? This is generally
> > trivial to do for LLMs after they find a bug because they have a complete
> > view of the problem.
> 
> The current custom hash implementation backend suffers major internal issues
> which cannot properly be solved without a complete redesign.
> 
> Florian worked really hard and rewroted the custom hash implementation with
> an rhashtable based one which fixes the issue in question and other issues
> lurking in the current ipset code as well, without loosing any
> functionality.
> 
> It is heading into nf-next and at the end going to be backported to the
> stable branches too. Thus all known/reported ipset related issues will be
> fixed in "one step".

This is all coming in the next nf-next.git PR for this week, I'm
working on this.
