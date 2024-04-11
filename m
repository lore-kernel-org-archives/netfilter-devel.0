Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91D5EAF0;
	Thu, 11 Apr 2024 17:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856324; cv=none; b=Iy1uBA1TDPNmX6PiV4dPCYXRv/JMzq15p4Rcpe6hBKMcihfeujf2MiRsrBzqWhWe0RQ5d93JNgpLu7pxqGLSwquQI8WEbfpEMXGfygfYtK1LpiJKeW1em4KAj2JmMTxNX3ITsDXLpOFXD0Zr9oQJKnATOLKttjFWHQQy/qGqpTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856324; c=relaxed/simple;
	bh=Vu4l4gq+Uj6NZrcR0MxuZif/Yjg5fqlGOgpolYqt8wY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kI9uREYBzJ5CbGJ5jWEFW/DVqa1EW/93z8T81pNWquBjJ9SODzIb2oDjGIqLDtmPut6dpc3XPgq5swDL2+M0mAQ7J6ABn5+dTPOnCKKq6U7phDm2wfygOsYGkc7XiDAc/7nZ3QHDYn52LIJ6gLdyeGhmFYGLWVzilXozOva37AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aBPzxW8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aBPzxW8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB383C113CE;
	Thu, 11 Apr 2024 17:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712856323;
	bh=Vu4l4gq+Uj6NZrcR0MxuZif/Yjg5fqlGOgpolYqt8wY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aBPzxW8RYwskZAyNvRjR2NfC/vapRFujbvL/Cm8aOcVWhTUwSB7uu8kjSP7ZhnHtm
	 UqGyu7BcN8mMcHFsPAbJ67zUYLXu0+xAR3MA8S+Jbi86lkoX7LwexMt5q8Wu7wt3uZ
	 FXCtN4F6SzTNQgHeOi+nuoxA2GaZynN84sF8s0i+s/6y5yYaUXUcTKduKbJzHEtTHS
	 LfKug8TiSP88f27MQsd/WP9nm8gT44CiQZzUr4xgmUQq1DVpbFTrR0tgvS+K/dtCuv
	 nskd+48KmCMt9FO3kGglnUtkhp6ckK/4GdGI4ZbQ3m+91i96YnP8R1D4EtdSRknW3C
	 afQeEtC28xLMA==
Date: Thu, 11 Apr 2024 10:25:22 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jiri Pirko
 <jiri@resnulli.us>, Jacob Keller <jacob.e.keller@intel.com>, Pablo Neira
 Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 3/3] tools/net/ynl: Add multi message
 support to ynl
Message-ID: <20240411102522.4eceedb9@kernel.org>
In-Reply-To: <20240410221108.37414-4-donald.hunter@gmail.com>
References: <20240410221108.37414-1-donald.hunter@gmail.com>
	<20240410221108.37414-4-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Apr 2024 23:11:08 +0100 Donald Hunter wrote:
> -    def do(self, method, vals, flags=None):
> +    def _op(self, method, vals, flags):
> +        ops = [(method, vals, flags)]
> +        return self._ops(ops)[0]
> +
> +    def do(self, method, vals, flags=[]):
>          return self._op(method, vals, flags)

Commenting here instead of on my own series but there are already tests
using dump=True in net-next:

tools/testing/selftests/drivers/net/stats.py:    stats = netfam.qstats_get({}, dump=True)
tools/testing/selftests/net/nl_netdev.py:        devs = nf.dev_get({}, dump=True)

"flags=[Netlink.NLM_F_DUMP]" is going to be a lot less convenient 
to write :( Maybe we can keep support for both?
