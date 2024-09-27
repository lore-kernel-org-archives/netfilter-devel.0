Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9518061FCE;
	Fri, 27 Sep 2024 11:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727438311; cv=none; b=kToyKCoesaohX0uqZSI01mx4kFKdWIiheWrS2XPma22EsBZvi/bcCaNPNIUSJ59JfBUIx2QS8Dt0WYa7Q1etPdSn/+irm9XiEfBfA9V4SBy4GCBDWB4fPKAUs3VUh7TkRnQaEebgq0hn3T5VLqR1IUlpyUbVIgv6uiEin0UfSJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727438311; c=relaxed/simple;
	bh=dE5Uuzs+YR4hrSapIWu5h0+X9vtdQxYvVFnUFXghG7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=komEyc3sGRiHT1WVRQ6Vt2no/uXcOOuKUt/SFcrNr7u/TVuA9se056s1hTfOn3qwuhZHdd+/QlcQujg8WuYMe10g1TlvQVOjvJD7q0EKxc+QIzqr319AwQVLrZlWnEyhGxyrP2qIwFD/oMqLEW4En1zolz4JHk40rcGKWWeB1PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=59648 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1su9c7-002w5N-VH; Fri, 27 Sep 2024 13:58:25 +0200
Date: Fri, 27 Sep 2024 13:58:23 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] selftests: netfilter: Add missing resturn value.
Message-ID: <Zvad32EvxZ5oHiuJ@calendula>
References: <20240927032205.7264-1-zhangjiao2@cmss.chinamobile.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240927032205.7264-1-zhangjiao2@cmss.chinamobile.com>
X-Spam-Score: -0.9 (/)

On Fri, Sep 27, 2024 at 11:22:05AM +0800, zhangjiao2 wrote:
> From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> 
> There is no return value in count_entries, just add it.

Applied, thanks
