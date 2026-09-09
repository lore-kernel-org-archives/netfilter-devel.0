Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE815695;
	Wed,  9 Sep 2026 00:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788915148; cv=none; b=VZcqHDxa/hQ4LWSIPL/6NQXWEBGHekgCCanq2W+sFqLjChwyCErnt3GVigEYwbwpGFhCh5dQxL7Gog4hg6jS/dwLVx9eDp8Gcf6qGSCn410+qH2n2OmuPl6egGuMRxHV+4b8R/JmrigLWeF8v+E3ZSx/1+5CQHLvsSuC2LmwKbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788915148; c=relaxed/simple;
	bh=Drg/l6eNiJdS6WrlfQrpnPJ76x1G5CGd7qHtm5jtorQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bCSYCD3yqXXzbUuBdoemde6r9ps8JB7Uihb1Ecq+O/bWwbtW09f4dn/oAJrAkxNpLAKaD5o1Fvo92HxTv1LzefXoxxk4vdDDhegUGVd2UaDqC5RcIXd2emXxVEoQmxRoVOP7UwGQOguao2upxhuxTzK7TCQkafph86VeQ4v+FIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JyPVbB8s; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JyPVbB8s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788915144;
	bh=PdGrfA7zAJp8SMGp43M+kuZoPzHGQOyKC+mFwVh5MdE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JyPVbB8sokRxp9wH5rtHPwiP5BmZGjxP4vvpGtrxjWYPSXDJMdBGwcvgvtua7g3w1
	 fpHSFbq4X473mFXMC8BRQugNouEwQ0pTo+BlwdQsaJCBph5qKMk8awXinvVgoZAzRm
	 MQnIJ96RUHRjz+XLfW+MtDt1Saf2g0A8wJgG7I9pO7mUBaRt1JXLip1T0SNHMYv9GE
	 3H6f+gV7MPAheRxGENC+/u9NEBM3GWRTZDLhuU2M8OrXUiTPnhoj7mDr8J32LM+tUY
	 UJkVOo8L0ayfZQsBzckOUMkC3o/sNrR7XOnmHIZcG7hU2s8flBvS4pGMFFmQAsKKoS
	 gEnATSwN37UQQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 770C16017D;
	Wed,  9 Sep 2026 02:52:24 +0200 (CEST)
Date: Wed, 9 Sep 2026 02:52:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf 0/1] netfilter: x_tables: avoid holding mutex over
 faultable user copies
Message-ID: <aqCtxhu5Av_RLtY8@chamomile>
References: <cover.1788244146.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1788244146.git.zihanx@nebusec.ai>

On Tue, Sep 01, 2026 at 01:47:53PM +0000, Zihan Xi wrote:
[...]
> Reproducer:
> 
> The following files must be saved with these exact names in one directory.
> The commands below build all helpers and run the FUSE/user-namespace path.
> The FUSE helper binary is named poc-userns-trig so the hung-task comm
> matches the crash log. The captured panic is hung_task after that task
> blocked for more than 10 seconds, and then khungtaskd panics because
> hung_task_panic=1. A 10-second timeout alone only warns; it does not
> panic. The tested guest enabled panic on the kernel command line with
> hung_task_panic=1 hung_task_timeout_secs=10
> hung_task_check_interval_secs=10 panic=-1. poc.sh, poc-userns-trig and
> poc.c also write these sysctls when they are writable:
> 
>     echo 10 > /proc/sys/kernel/hung_task_timeout_secs
>     echo 10 > /proc/sys/kernel/hung_task_check_interval_secs
>     echo 10 > /proc/sys/kernel/hung_task_warnings
>     echo 1 > /proc/sys/kernel/hung_task_panic

This configuration does not look sensible to me.
