Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656A43B7B7C;
	Wed,  4 Mar 2026 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636363; cv=none; b=ewdY8tGWzEaaUx2592qp3paWhW9HToluQlJqsI/a08Yk+RKUmoasAXPFn6F44J42Rvn7/4R13QJEApEfoXhr2jw7GCqsV74n6LpIlDGzLXd+W3SRMmHQEGLdLvzLr8igizGoJ2qw+zKv5V+nVOEXTPyeyofVtYwdWFMUVSSajy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636363; c=relaxed/simple;
	bh=/lNwR+ZYE4Pp0j2tZP/j9awuxcDAzLdyRMP+40EdGrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ngf5JPkzeE1XZz06aWHRYF8jCDE+xawvnqr+D5TWKPxxLb9mdEfHT4XN3NqtnlLTTpKHof12RQtimCCJENJP8mFgH0RYJgWI3wDwZdLwJY1F3R0nXKBQ6DXqZLAK1io2Gj41GVYTzly0P/8r2yo3sl1LVTis6C1ykiZZ6JcqVLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=KJ7vsDvn; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="KJ7vsDvn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sUIfRa+g8fpmxFfqp2XG0bd5OP0+/q3uVgqVEbYGmPA=; b=KJ7vsDvn/Oknk0T9J4ShzV/hkt
	EhjXH1u565mXeKNI40Hiq/ld2F8vOGUMqaUEiJqOH+46feMARlLXq/FjJpgfwGEdMKEN+TDlvGgys
	9lc+lQHi0qlSDtKQSXX5jLivT9pCzF5mW/YKHZ6YIyGXMGOq8WDPi3XeuBVdcLxMqX7vr2PUXQQRn
	SvjG4aaTjzBEMeK18o0s1m3PlPk5u0+IadndvJz9AwzWLHfBBDYkJb+uABSR4A4hUnoIFHX/8SSMM
	2tJlVNrOu+5TgTQKkffGTZdLv9TJR4KW9XSUhlA92WwnyRbanA4fXdMOzb+f1ZRUFoX21Te7EnphF
	webg1muw==;
Received: from [179.221.50.217] (helo=[192.168.0.108])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1vxngv-008y27-95; Wed, 04 Mar 2026 15:59:13 +0100
Message-ID: <279c7a14-2b8a-410e-85d5-ee11b0e5371e@igalia.com>
Date: Wed, 4 Mar 2026 11:59:05 -0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: nf_tables: fix use-after-free on ops->dev
To: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com
References: <20260302212605.689909-1-koike@igalia.com>
 <aaYYiPTO5JYOlhhY@chamomile>
 <17499d82-ad03-44a9-ab3a-429d2ebea02f@igalia.com>
 <aafD369eE31dh1VP@strlen.de> <aaglAU8E48EF1m-_@orbyte.nwl.cc>
 <aag18YM3g0sS7wXW@strlen.de>
Content-Language: en-US
From: Helen Koike <koike@igalia.com>
In-Reply-To: <aag18YM3g0sS7wXW@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/4/26 10:38 AM, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
>>> And *THIS* looks buggy.
>>> Shouldn't that simply be:
>>> 			if (!match || ops)
>>> 				continue;
> 

I tested this change locally (with syz reproducer) and I'm unable to 
trigger the issue anymore. Without this change I always reproduce it.

If you are to send this patch, please add:

Tested-by: Helen Koike <koike@igalia.com>



> FWIW I can't get the reproducer to trigger a splat with this change.
> I've fed this to syzbot to double-check.
> 
>> You're right, the 'changename' check in NETDEV_REGISTER is not needed
>> because even if not changing names one should skip if already
>> registered. Actually, this indicates a bug unless handling
>> NETDEV_CHANGENAME. Maybe add a WARN_ON_ONCE()?
> 
> Well, it does trigger, afaics.


Thanks,
Helen
