Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4981E877;
	Mon, 15 Apr 2024 17:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713203188; cv=none; b=I2EIsMs0izYrvqpmU8/rma8txsMwL1+J3qZbwljYHuUko2kZCa6PCDBfwrs/o2nOcGuHd7rA2WUuQLHbDSyGtTesSqrB4swBw3itmV8TaY/+ew9l3sd0wU8E1xdlyngpMAI6syRZcUylQCHuKBm1YZN9uY4/NZkxsbNF15mIcdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713203188; c=relaxed/simple;
	bh=m8GGov/pwkd9DiB/jsPNMMdHvIl9JLyjEqpFvD8mT3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fk5MVbe5H3ldR4y6ljLNmHFRv6Bf7uCDRFV0Yf15lr/USJgljkjbOhnRdIXZaPfjGYxEtEkxoBz/Rc+U2VChIh46g2BFYAJOORaAHveisZw/VT6F0lzFft2aP6RMERzZ+Z4y0XjPhdDKF4ayOl7xvF5WcgHAxP3XQV8SjdxeU9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+W91PH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+W91PH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B944C113CC;
	Mon, 15 Apr 2024 17:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713203187;
	bh=m8GGov/pwkd9DiB/jsPNMMdHvIl9JLyjEqpFvD8mT3Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a+W91PH0rJbR34rVIb7i4ZG92oLj8k+4w0usTtj1xmw4ZbA73Zek/eXLKIHKYApl1
	 +HfbjjVJhWRI5T4jUCjJBgsBl41atVlS3KE2RMKnkbzmrm3dzJc2vGcw/yR97tWP56
	 9fOuRHqUxvxUAVRkMIQXl/9G5TiGa6MUp/LKsa7gN1S0KpnnXLi0CagQUP/uneFoxg
	 9u93KFknrdZEAHKkjRwp7jbxgnONldjl78B0KLdk+kP0/4klKPjt0SOa/FWzBcAmlY
	 BVaAQMqzZ7ZlilMEvssvIlxQPiDL1asPv4k1dvm9cIwrQ7woV5Mo/pdTFpMxQDkrhX
	 tYQq3qfv09urg==
Date: Mon, 15 Apr 2024 10:46:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next 12/12] selftests: netfilter: update makefiles
 and kernel config
Message-ID: <20240415104626.2b1ad88f@kernel.org>
In-Reply-To: <20240415143054.GA27869@breakpoint.cc>
References: <20240414225729.18451-1-fw@strlen.de>
	<20240414225729.18451-13-fw@strlen.de>
	<20240415070240.3d4b63c2@kernel.org>
	<20240415143054.GA27869@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Apr 2024 16:30:54 +0200 Florian Westphal wrote:
> If you prefer you can apply the series without the last patch
> and then wait for v2 of that last one.

Sounds good, let me do that (in a few hours)!
