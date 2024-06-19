Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [185.125.25.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E5914388F
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 12:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718799677; cv=none; b=AMhQ+0r0YD/qfTzAKoueBmO0awXw5FWhYRPDkEuSc6GLqha2v5KrxkkavjG37WhOQk0tDP21yxebFil26GtxMsHw8vLJcERuPVBjCwzsQsVD/ZVHFaCRxiwvjIDz+nSu9VHA6Ak6n7z9Jf7/SMOu/M1uJXBK1gRLCL2xu8eulqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718799677; c=relaxed/simple;
	bh=iRzRkhC7mOr7ZJObwyEv3ES0cCDVf+Ys2poGj4OidJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPuHVG2g533uEelpxjOSCggeJpMkSF5d4G9u3g9EA6hQffWMWbX0aO6G6xCtLhig6TbgjLgejtVoUL/qeOGIBh+nQxgkrIV6BiYQnU7cX+VkH4Dw73jvEU9rGobgoOKtssjGVVoDSvUhdvnlPdJ21NASJr5PoBHAGR++raXEYRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=kse1DJd6; arc=none smtp.client-ip=185.125.25.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="kse1DJd6"
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4W42lg6hxxzTHn;
	Wed, 19 Jun 2024 14:21:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1718799663;
	bh=PQ601hDuUwdQDnx1OcRhwP3RgxnS3Y8QYve13EQlPvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kse1DJd6ezfZTW0pnaPMppMrWpDjkMH9DbGejESeOQnE0ocJfB2fDROt84meTKgmh
	 K0bJ0vQibZ5LTsqpGPqtkSbi2cN3oa3InzbrocWXq4ePopyaOYEQi6DfSym5GBeOTY
	 SUf7U96yfzBJkkuAL0QZa772Hh1E/3WT/IJl8kN0=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4W42lf6mr8zmLy;
	Wed, 19 Jun 2024 14:21:02 +0200 (CEST)
Date: Wed, 19 Jun 2024 14:20:58 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
Subject: Re: [PATCH 0/2] Forbid illegitimate binding via listen(2)
Message-ID: <20240619.wii8Chaesh7t@digikod.net>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

Could you please send a v2 for this patch? I'd like this issue to be
fixed, especially before any other Landlock feature get merged.

On Mon, Apr 08, 2024 at 05:47:45PM +0800, Ivanov Mikhail wrote:
> listen(2) can be called without explicit bind(2) call. For a TCP socket
> it would result in assigning random port(in some range) to this socket
> by the kernel. If Landlock sandbox supports LANDLOCK_ACCESS_NET_BIND_TCP,
> this may lead to implicit access to a prohibited (by Landlock sandbox)
> port. Malicious sandboxed process can accidentally impersonate a
> legitimate server process (if listen(2) assigns it a server port number).
> 
> Patch adds hook on socket_listen() that prevents such scenario by checking
> LANDLOCK_ACCESS_NET_BIND_TCP access for port 0.
> 
> Few tests were added to cover this case.
> 
> Code coverage(gcov):
> * security/landlock:
> lines......: 94.5% (745 of 788 lines)
> functions..: 97.1% (100 of 103 functions)
> 
> Ivanov Mikhail (2):
>   landlock: Add hook on socket_listen()
>   selftests/landlock: Create 'listen_zero', 'deny_listen_zero' tests
> 
>  security/landlock/net.c                     | 104 +++++++++++++++++---
>  tools/testing/selftests/landlock/net_test.c |  89 +++++++++++++++++
>  2 files changed, 177 insertions(+), 16 deletions(-)
> 
> -- 
> 2.34.1
> 
> 
