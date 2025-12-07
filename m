Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF741F8691;
	Sun,  7 Dec 2025 01:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765072608; cv=none; b=BAv2xtbtzgWU5Emql6fEWf10+pe6Buax0+q4gWHfOPR4XEvph9diihWQEoEt13WwW5GjsrGe6nxB/3it1/cyAC/TGq1m4bWqKpMSBzg0dI/4SwLmKYoMYCS+r1DbVAum1wqGJD+5V4e8CAO0EiGxk1H5MpvTAB8sqw0GxEWwFlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765072608; c=relaxed/simple;
	bh=mo6n/OiiadjTXvCBmA3TT6bjWqtC8ITh0SIsNjX7R+I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OjzDeaRI1VJjxO6tClg0ETmEDLzDMC28hvJO+iumbFgLlwumHf/ccCRLK89c3FK3Q7wwBoHHBMTYTNdk3GP7PAzRa971bDkPMunNay11rjVUudpWUhORZzccfKMzS7J54Uq3iMmif4a5Y2O+oDO/dB13fGUg1EvTnCpmKaF4eg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lrp3IGW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lrp3IGW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62473C4CEF5;
	Sun,  7 Dec 2025 01:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765072608;
	bh=mo6n/OiiadjTXvCBmA3TT6bjWqtC8ITh0SIsNjX7R+I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Lrp3IGW5pDJOtyaT/tGNs5xyg8eMvPzzRWvCNoh0kktUHJyrsON1yxdJAdkRIxoNO
	 XDRwEKy2He0i60qKGcRUk8B2IM/KeWWnKZ1OU8AK5aKzIYKVi1KosC0LnggfsJ/tRw
	 Jmaul1Dmo8ItZn60IDMqpZRuvC5PdZqz3Nf6AQHAIHfqKiFt6T6wkeeDuXnCkBIpT5
	 eWgBsDokZ/yDgc5wNDn8QupG5PfP9DoD2X4CoRcvMNpiIRK8Sdjd0bQILGelMs9M4G
	 pwE90wnvvXqR9jNH1H8Kpsms/6g2unUZ+grbH0ySVLNeY38nEE6lzm4rRdxRQTiYTk
	 K2elF6kFw3rXg==
Date: Sat, 6 Dec 2025 17:56:47 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [TEST] conntrack_reverse_clash.sh flakes
Message-ID: <20251206175647.5c32f419@kernel.org>
In-Reply-To: <20251206175135.4a56591b@kernel.org>
References: <20251206175135.4a56591b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 6 Dec 2025 17:51:35 -0800 Jakub Kicinski wrote:
> Hi Florian!
> 
> We have a new faster NIPA setup, and now on non-debug builds we see 
> a few (4 a week to be exact) flakes in conntrack_reverse_clash.sh

Ah, one more, the non-reverse conntrack-clash is SKIPping, occasionally:
https://netdev.bots.linux.dev/contest.html?pass=0&test=conntrack-clash-sh

If the event it's testing is probabilistic could we make it return XFAIL
when it doesn't trigger? We try to reserve SKIP for tests skipped
because tool is missing in env, something isn't built into the kernel
etc.
