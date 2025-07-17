Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51822E49B8;
	Thu, 17 Jul 2025 13:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752758542; cv=none; b=kSDnw43emm2+8i8lavmNTCnkbJDEgnHIBFwCdmq978wRweI5anQQBypiit5n/vRgs98cm+4MOEQvFtnozx+oKKuxSQ0PXDF7NWainP2G5yeKpX1pEzFh84CP8YV5uqqoC8gXAE6Ra7TK1YpHOdIKF06Wy0Xa+Bbu6CBrfqVu85I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752758542; c=relaxed/simple;
	bh=bGCKICSm9hIpX67LG0SsjdII2iCrFx6470CW9qFKN2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1y3u2LqxRciOuyTa6hYl6EUKnhap+i3WKPe3P/VV6YPW5Ad4TgKN6nYhwEnzeXlrRkMyybydmOKHq/3By5t9MWduGiuZlwrhJtXLl2lwrTOyzrWC1rO/+BhAhqSgJp1Uz3EmFRcU0lzTBIARqja32oFgHFwVC8p2eeYyb96QIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=de4YT8Fe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="de4YT8Fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08625C4CEE3;
	Thu, 17 Jul 2025 13:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752758542;
	bh=bGCKICSm9hIpX67LG0SsjdII2iCrFx6470CW9qFKN2Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=de4YT8FeAtu/EG97mpXuRZ1keOmLc61sTI+Ej+3o/9JKzRwH4vWjT8nPCcxp2gEdc
	 nccx9YwDxqNOdH8pYQaeUpZ2BJ/LkxWtKDYx67x8qxnVu8cU+o+aisTuFkCOPpfRGO
	 Bk4ljMdW4jvI4X9kMRPTdx3i8D5asa/5qy/xemxffmjIkyqvGIC8Z3icmCQn29kPIZ
	 SqKwRHgXE3krgXff3HY0Bb+h7WkdMVTQdBC4HaIZq2WYpOPWH7ab2UpHfB/5NzyQDn
	 59w3oLBv/tmr/lVFGnrwSb+tTaMQ5PU/p7zLo5kRkagJfWeDEPxmtWTaHFxszt2p7Z
	 91AwsGSjkazVg==
Date: Thu, 17 Jul 2025 06:22:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: fw@strlen.de
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org
Subject: Re: [PATCH net 2/7] selftests: netfilter: add conntrack clash
 resolution test case
Message-ID: <20250717062218.380dab89@kernel.org>
In-Reply-To: <20250717095122.32086-3-pablo@netfilter.org>
References: <20250717095122.32086-1-pablo@netfilter.org>
	<20250717095122.32086-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Jul 2025 11:51:17 +0200 Pablo Neira Ayuso wrote:
> Add a dedicated test to exercise conntrack clash resolution path.
> Test program emits 128 identical udp packets in parallel, then reads
> back replies from socat echo server.
> 
> Also check (via conntrack -S) that the clash path was hit at least once.
> Due to the racy nature of the test its possible that despite the
> threaded program all packets were processed in-order or on same cpu,
> emit a SKIP warning in this case.
> 
> Two tests are added:
>  - one to test the simpler, non-nat case
>  - one to exercise clash resolution where packets
>    might have different nat transformations attached to them.

This appears to fail for us:

TAP version 13
1..1
# timeout set to 1800
# selftests: net/netfilter: conntrack_clash.sh
# got 128 of 128 replies
# timed out while waiting for reply from thread
# got 127 of 128 replies
# FAIL: did not receive expected number of replies for 10.0.1.99:22111
# FAIL: clash resolution test for 10.0.1.99:22111 on attempt 2
# got 128 of 128 replies
# timed out while waiting for reply from thread
# got 0 of 128 replies
# FAIL: did not receive expected number of replies for 127.0.0.1:9001
# FAIL: clash resolution test for 127.0.0.1:9001 on attempt 2
# SKIP: Clash resolution did not trigger
not ok 1 selftests: net/netfilter: conntrack_clash.sh # exit=1
make[1]: Leaving directory '/home/virtme/testing-15/tools/testing/selftests/net/netfilter'
make: Leaving directory '/home/virtme/testing-15/tools/testing/selftests'
