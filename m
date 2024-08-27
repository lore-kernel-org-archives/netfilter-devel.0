Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C64C8BEA;
	Tue, 27 Aug 2024 02:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724725502; cv=none; b=Bm64Hh9pvvinnG4gXuW1s1bFCTporlqRhweJAdI2zUYxa38BCWUf2AT4Ew5PH0+FL1jRXnjp1EZ15rRd3887hkB1D0lVGPWhIJS0GipNMRzoh3WrYvJVJSjZdCCW3tyvhax+iY5NVcNRd0j5vi/7WYG/LWc/FKSX7HlSfk4cPLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724725502; c=relaxed/simple;
	bh=5obBFAgk49d6SfmCWkhvVk8SCMkmqHl7tmdg64UCpjs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mox/YLSJF+eFliidvAc5HKVIPL9ll5AQKRZowck5hEld47o4zpFsk3h4N+IkW/ugcPPHVplNEULWjbjRbM3QweEMKWWihiGEEGJG1OVH1vTbaMJJWJEep2HqSj2lWeXSlh5db7PeeqPRXE+CIuhbcJ1HErPTAqH5KQ8HRS9sEUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dW0qNSud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dW0qNSud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE7C4FF0C;
	Tue, 27 Aug 2024 02:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724725501;
	bh=5obBFAgk49d6SfmCWkhvVk8SCMkmqHl7tmdg64UCpjs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dW0qNSudjZtDXdmqiCp1I6Dh28SKCWCEnsMjb+3BDLmJ9XZ92MhHy6Bo2WQ3/IH3C
	 E+sqs9GXpM21NaCiWs+R42Y0Rmt3iA75W6Qdh3frlzoJyG5SD5wSz9Gw3SCHnK+EE4
	 Pp5/QQeGat5HAqvoaieIZnIn6GW5CyUDlbidrMnuR7n7P6Nx1rTySv30Ylg/QWpDF9
	 RDyOIRkqF7NHD4L6XBrWc+AY5UxCfdKZortF1p8VcH3tBnG7u9a9xFVNnWanQd7Hj7
	 EgVx8vlLSw3SQtFjJ5kOFIKn9G47lfHDo83az8krI3Y51jKjK7m7JvJncKXScDILh+
	 RBjBaTDQNlRLA==
Date: Mon, 26 Aug 2024 19:25:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de, Antonio Ojea <aojea@google.com>
Subject: Re: [PATCH net-next 2/9] selftests: netfilter: nft_queue.sh: sctp
 coverage
Message-ID: <20240826192500.32efa22c@kernel.org>
In-Reply-To: <20240822221939.157858-3-pablo@netfilter.org>
References: <20240822221939.157858-1-pablo@netfilter.org>
	<20240822221939.157858-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 Aug 2024 00:19:32 +0200 Pablo Neira Ayuso wrote:
> From: Antonio Ojea <aojea@google.com>
> 
> Test that nfqueue with and without GSO process SCTP packets correctly.
> 
> Joint work with Florian and Pablo.

This is unhappy on a debug kernel in netdev CI:

# 2024/08/26 17:38:31 socat[12451] E write(7, 0x563837a56000, 8192): Cannot send after transport endpoint shutdown
# Binary files /tmp/tmp.ZZAJtF9z9R and /tmp/tmp.hS8W1Te84V differ
# FAIL: lost packets?!

https://netdev-3.bots.linux.dev/vmksft-nf-dbg/results/745281/2-nft-queue-sh/stdout

Works fine on a non-debug kernel tho:

https://netdev-3.bots.linux.dev/vmksft-nf/results/745282/5-nft-queue-sh/stdout

so gotta be some race.

Please follow up soon, I'll disable this test case for now.
