Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9601E1514F4;
	Thu, 25 Apr 2024 19:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714072380; cv=none; b=tI4vOkqvFA+lJ1vvbOR/JdYCJtghojYeD/2qnCaysUteRa83ZA6hNJXnk7b4DEoo5bcqeQWsi+KOHKD8MtiGiSvsMdNS6ZJ3+2Tg0UiI2ER0cCHPiWfX6LBminnBYO6YdS6qlmr/5HfdiOUav2AG7yXrGydpSZYl8yXECJ1lVKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714072380; c=relaxed/simple;
	bh=FuGJPh+rJqsQ0UMSARQXfXrqG1e5J7eavTHONg7vy8g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uutu6IMfvjM87aBd/j5TINb6/eiN/lNU8x4Ia4gC6Jfvg/Z3eLORFGPAKlwoQA6ECgyzYCJSPamAtP7ytu4VgQ/FnDj82P9D4MLRv02ctJ5gOKPIn2ZyuZYTVXaOAbDXhgnsAj6g3eHN/bJjZjtAAU21xIn3EoOG6vvdWB/9AOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqNTc3NI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqNTc3NI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFEAC113CC;
	Thu, 25 Apr 2024 19:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714072380;
	bh=FuGJPh+rJqsQ0UMSARQXfXrqG1e5J7eavTHONg7vy8g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kqNTc3NIbWk7oG+9oscR2aNyu49rPwgDk+KZoigBuoZZaf/I5KVll/n52vcyAPEHP
	 Mw0j6FCoGPvfp9POHri+DqTgLhm1iw9C75CzPBwFii/t9ejfL+N8J273JPchF8nYUY
	 DN02DT38FPT+ejI5C/Pup+swIlT1Awt4rqXnBv2TwagzzQVio9SdRmWMQY4B7olC2T
	 aqK+Vao+sUunpw3vtSJEZexRyWVwxh/7jInsYw5AD2u7Xw9cDf7wkVD7N1KBPiftMJ
	 8FM5Klc5IrW9g91ww9xj3x+TdkHqpyTdjeYy9QHT5Ay7KbxxDJlm3U8+g0P5DM5NpR
	 wQmdN8KkS9sww==
Date: Thu, 25 Apr 2024 12:12:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH net-next 0/7] selftest: netfilter: additional cleanups
Message-ID: <20240425121258.619c61de@kernel.org>
In-Reply-To: <20240423130604.7013-1-fw@strlen.de>
References: <20240423130604.7013-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Apr 2024 15:05:43 +0200 Florian Westphal wrote:
> I intend to route future changes, if any, via nf(-next) trees
> now that the 'massive code churn' phase is over.

I hooked the tests which reliably pass up to patchwork now.
(The PW reporting is "combined" so basically the daemon will take 
them into account for the "contest" check).

On the debug kernels we have a bunch of tests failing due to timeout.
We multiply the timeout set in ksft settings by 2 for the debug kernel,
so in netfilter we give them 1000 sec, but looks like that's not enough.

Would you be willing to bump it up? I can override it in the config of
the runner, as last resort.
