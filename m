Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF45D383B9
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Feb 2024 13:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707485693; cv=none; b=tCHGmjcR7K/KB0ZYV1hvj7RARDsKg9ldTRCk4YYDl7sM8MJxKd/azreI0jC3QJflX/FgpIwt+U8azRuTHlTx6UfHtdfSyQYOU2wQe9b40QEXd/RTRDx6g7ZtFhEIV/sLuF8Zk8AaBl5NSjmJzWicowvwIfY1xcbxQBU9WPIS1j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707485693; c=relaxed/simple;
	bh=c/GSq7lChCQEXS/Moaj/5BXwSspP/3omLySXxSaATHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lz1OWe4IGti3vX2Wc2+8W5rWrmhuw2NLxEWfXJBJBMzahlq1GR6zWDd9uWjHIfWDxQIlPyrIcjqpQMXm5d62GpXUmIPeWNqJrUVZeg2O7x57TnJ8dsUhlWd8JDb2F5GDIsQVa7+8XiqwA/oEVa2cYIXBw8Di5k87KuPb7pRXruM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hRpigBAw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hRpigBAw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0oKvOg2F37GuOZrw5q9614xFR0iEsnst9qEqrv/iwdA=; b=hRpigBAws9GclvAjP3CDY3XmER
	C371mVSxY2I0mnvDDNaMoDWnNW8uZkxQ2B8thUmhvHiMOLcTmRK48uW4Bh0Oj/AM7FdUYxmEDLKuv
	UJgc29cDLOZ7khSS/MUYgUc0liZWmnR9QKwyEcPLjfOSqcSc5WLu1W1ylv9RJ6k0If5HshOJgTE+3
	LCYtqXzW4bLb/+m6HAuAKIoSMigo1Pcoy0ILiP2zUmF/PtJwxSlZSjfKt69v3UN55+T19WAYHYoAr
	6Tjtxj1HHExigR15jXjA7tMfxqbH2nizGBgfTHJsdZrCtGOaYDujkHedQWM+adZkn9zNZzLI9+dMD
	JRQEOWrQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rYR1k-0000000083m-2Bmc;
	Fri, 09 Feb 2024 14:34:48 +0100
Date: Fri, 9 Feb 2024 14:34:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: Thomas Haller <thaller@redhat.com>
Cc: NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] tests: use common shebang in "packetpath/flowtables"
 test
Message-ID: <ZcYp-McSsMiw6Wry@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Thomas Haller <thaller@redhat.com>,
	NetFilter <netfilter-devel@vger.kernel.org>
References: <20240209121603.2294742-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240209121603.2294742-1-thaller@redhat.com>

On Fri, Feb 09, 2024 at 01:13:04PM +0100, Thomas Haller wrote:
> "./tools/check-tree.sh" checks for a certain shebang. Either `/bin/bash` or
> `/bin/bash -e`. No other are currently allowed, because it makes sense to be
> strict/consistent and there is no need such flexibility.

Why be picky about extra flags to /bin/bash? If you assert the first
"word" after #! is as expected, the remaining bits are known to be
bash-compatible at least, no?

> Move the "-x" to a later command.
> 
> Note that "set -x" may not be a good choice anyway. If you want to debug
> a test and see the shell commands, you could just run
> 
>   $ ./tests/shell/run-tests.sh tests/shell/testcases/packetpath/flowtables -x

Please document such things before denying other ways to achieve the
same. ;)
Seriously, if this is the way to run the tests with tracing enabled, it
should be explained in tests/shell/README.

Cheers, Phil
