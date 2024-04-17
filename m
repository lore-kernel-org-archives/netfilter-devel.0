Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B9014037E;
	Wed, 17 Apr 2024 13:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713361827; cv=none; b=dzv52flN1G9wOqfdllWZ+xKnkCK5qDYm8adGJ3npmWbuxvlFKANQEeTi3f/fKMUV2FKOfzOOVX5w8sUpG7X1CG/liE3WR0pYM4FPrRGL1pbYRD6ZgqxMFgTHscD8Mh1DR1RWQ3Kmlh7kha4GtvQ1o5f6fKboP4tLk/Dd3Dteeh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713361827; c=relaxed/simple;
	bh=S0wKCInWk2bMmf+CEL3Qe4U9QJ44+BgpeCC/onWUcto=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C21fzte0gxeMFvPkxO7fghcdMpKTjQdYiCYLK9IIVrQO8ANCbAd9/ue4n+xt0vzNwAYo+JmLz3W/fY7cf7HiqwolSlE5HNKjCZkJdDT60TI53ATVY5MXg1H8tBgJ/mWPISMzONVMwTNu36R/uPx1K6MKnSyHLd78/YGfkNk00/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lc2lJrQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lc2lJrQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5397FC072AA;
	Wed, 17 Apr 2024 13:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713361826;
	bh=S0wKCInWk2bMmf+CEL3Qe4U9QJ44+BgpeCC/onWUcto=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Lc2lJrQAiFIls3X5Omox1lve0sdVoy22rr6PUNZteaikW3bKmjIG8i4aRPNlVfWKb
	 mOect5c/BDDVX+ua808coEzi/+lQyYJyo9xAV0Ca2Xfu7nniLlPp2aJAD8PUGxfsoF
	 s7BNBzi+gL5M5qMlqi4hPBfpmbXYh47z3b45ZN+w1LugeoyyezClnMr4KBQYJ3KcVl
	 s1BoZWJd1OJkrS+7F4IGxjqqVuEzQ4A4C63AnPoZjuS9uJn7AdfKJK7E3v0MHCZLEy
	 uTj1g/8STa3fTkNzK/k7KNPULq4z4ZtfiGabyYYpVgP69u9yWv6XKBw+hN5wyPzgPw
	 8S1DdkNWsPzTg==
Date: Wed, 17 Apr 2024 06:50:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jiri Pirko
 <jiri@resnulli.us>, Jacob Keller <jacob.e.keller@intel.com>, Pablo Neira
 Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 donald.hunter@redhat.com
Subject: Re: [PATCH net-next v3 3/4] tools/net/ynl: Handle acks that use
 req_value
Message-ID: <20240417065025.678763bb@kernel.org>
In-Reply-To: <m2mspsgnj9.fsf@gmail.com>
References: <20240416193215.8259-1-donald.hunter@gmail.com>
	<20240416193215.8259-4-donald.hunter@gmail.com>
	<20240416191016.5072e144@kernel.org>
	<m2mspsgnj9.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Apr 2024 13:51:38 +0100 Donald Hunter wrote:
> > On Tue, 16 Apr 2024 20:32:14 +0100 Donald Hunter wrote:  
> >> The nfnetlink family uses the directional op model but errors get
> >> reported using the request value instead of the reply value.  
> >
> > What's an error in this case ? "Normal" errors come via NLMSG_ERROR  
> 
> Thanks for pointing out what should have been obvious. Looking at it
> again today, I realise I missed the root cause which was a bug in the
> extack decoding for directional ops. When I fix that issue, this patch
> can be dropped.

Ha :) Feel free to post v4 as soon as ready.
