Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00604C13D;
	Wed, 24 Apr 2024 02:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713924971; cv=none; b=sVSCLyN7JvWOeUsoReBqlP3tAkRboBIYpGZ29FzA16QAJ7lA8FoMeqPLaCyZzATIC3dRoIWTw2l+d63aFZvfDgKhFRFISB1aYCN527a7u1/4YQBVHXRfUzID7oNL4lsN9tGZP2+LssrEVkGPEjsLrP28KxeYr5NIQ995GtVoRAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713924971; c=relaxed/simple;
	bh=0vw9tPgrcUPrC3NfHnBNGyHFrlvNxn8ExXOVsKP7kK8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rWrhAQH7S0GTawVWWdYU+Gh5HxSSMDk1NYPteFR9b4AeT8RNubHbuwbTUx5PQhyeVrnjI5jEZ6ilp0JUURxtAgw68sbYP2S9YTAB50mNf9lVn5ncnORLe9bETvMMIdXT+jIqHAMc2g10rvKaQSTIfV9/IZnF2vi6qNceJJ9yFno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gvj9VckZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gvj9VckZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2C6C116B1;
	Wed, 24 Apr 2024 02:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713924970;
	bh=0vw9tPgrcUPrC3NfHnBNGyHFrlvNxn8ExXOVsKP7kK8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Gvj9VckZTAHuse4EnKfxJcq3+Zoo+Z8P0JPwej2HEZH4vTKa+LZ+V1w1ppHNDdMxy
	 8daL6e3CMWiK/1vxuVF8A0ATK6bGXBoPKXNlUnlvTUWG/OXV3LSHUiEvXnmZAPMlcp
	 0A69AqjkffLwkRwyM/Mskt1Qy1QQiI5rXW+oLnVJ+GrjAjIKqBpPuwDQ27MoqzbOt6
	 XriwwEQTZozcsUeuZVfrnOlMWsRQNUkpgmqLqeRw8kh1JM43DuV1ltiILOHhwmNBG9
	 uyM2ADZVO6Fv8PrreHQYQXLTtb4nj14MdzhTHFYtZY8Lq2WONGCEE+JQ79trIh8g0d
	 Hfp66BGLJfM4g==
Date: Tue, 23 Apr 2024 19:16:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH net-next] tools: testing: selftests: switch
 conntrack_dump_flush to TEST_PROGS
Message-ID: <20240423191609.70c14c42@kernel.org>
In-Reply-To: <20240422152701.13518-1-fw@strlen.de>
References: <20240422152701.13518-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Apr 2024 17:26:59 +0200 Florian Westphal wrote:
> Currently conntrack_dump_flush test program always runs when passing
> TEST_PROGS argument:
> 
> % make -C tools/testing/selftests TARGETS=net/netfilter TEST_PROGS=conntrack_ipip_mtu.sh run_tests
> make: Entering [..]
> TAP version 13
> 1..2 [..]
>   selftests: net/netfilter: conntrack_dump_flush [..]
> 
> Move away from TEST_CUSTOM_PROGS to avoid this.  After this,
> above command will only run the program specified in TEST_PROGS.

Hm, but why TEST_CUSTOM_PROGS in the first place?
What's special about it? I think TEST_GEN_PROGS would work
