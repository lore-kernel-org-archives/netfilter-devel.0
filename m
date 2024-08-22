Received: from mail.valinux.co.jp (mail.valinux.co.jp [210.128.90.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE4914A0B8;
	Thu, 22 Aug 2024 10:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.128.90.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724323074; cv=none; b=H4fcc586NJ+NjSq8dbWfaYRT0lzrE2sjWelR8+pMuLpGlFbQXRaa1G4giRuJgCEENiM4xL9fCHIqO6s7N/fRINSku8gYh9P9a1rjjheujHo5kT+yk41rwLRgj1/Fb3kHqE4t5UT5ieO5uG0GBaml4mxtl4A8x9Zm00QZMdm94dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724323074; c=relaxed/simple;
	bh=cx9XFHnQeng5oBhBqJHtLUeRdrew3KOAWW5YS2VBHWY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RT1bsvDH8OFFggjyGp6uOI5ovWuwvoLXRgtO5Nw9MZ2zy561YBEoNcoN/I/bScCWzxbKMJMqgpwHiW1M+K+WKiBWDqET4KXG9/ju/I/oegmU/nWRhXmvAmLNvRGM32xg9w8HDYHiIghd4/q3ogHZR6ZeIPmiaSlUxD5buSMtrMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=valinux.co.jp; spf=pass smtp.mailfrom=valinux.co.jp; arc=none smtp.client-ip=210.128.90.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=valinux.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valinux.co.jp
Received: from localhost (localhost [127.0.0.1])
	by mail.valinux.co.jp (Postfix) with ESMTP id 64402A9EBF;
	Thu, 22 Aug 2024 19:37:50 +0900 (JST)
X-Virus-Scanned: Debian amavisd-new at valinux.co.jp
Received: from mail.valinux.co.jp ([127.0.0.1])
	by localhost (mail.valinux.co.jp [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bgNGmSkOoOvL; Thu, 22 Aug 2024 19:37:50 +0900 (JST)
Received: from DESKTOP-NBGHJ1C.local.valinux.co.jp (vagw.valinux.co.jp [210.128.90.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.valinux.co.jp (Postfix) with ESMTPSA id 3CB17A9B76;
	Thu, 22 Aug 2024 19:37:50 +0900 (JST)
From: takakura@valinux.co.jp
To: edumazet@google.com
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Don't track counter updates of do_add_counters()
Date: Thu, 22 Aug 2024 19:37:49 +0900
Message-Id: <20240822103749.228468-1-takakura@valinux.co.jp>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CANn89iJGUCp-4fRJWzwNzakyNZM=_mSNjX=_OUT8WJW-+isAfA@mail.gmail.com>
References: <CANn89iJGUCp-4fRJWzwNzakyNZM=_mSNjX=_OUT8WJW-+isAfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Eric,

Thanks for taking a look at the patch! And sorry that I see that I was 
missing the point of the synchronization.

On 2024-08-22 6:03 Eric Dumazet wrote:
>On Thu, Aug 22, 2024 at 6:36 AM <takakura@valinux.co.jp> wrote:
>>
>> From: Ryo Takakura <takakura@valinux.co.jp>
>>
>> While adding counters in do_add_counters(), we call
>> xt_write_recseq_begin/end to indicate that counters are being updated.
>> Updates are being tracked so that the counters retrieved by get_counters()
>> will reflect concurrent updates.
>>
>> However, there is no need to track the updates done by do_add_counters() as
>> both do_add_counters() and get_counters() acquire per ipv4,ipv6,arp mutex
>> beforehand which prevents concurrent update and retrieval between the two.
>>
>> Moreover, as the xt_write_recseq_begin/end is shared among ipv4,ipv6,arp,
>> do_add_counters() called by one of ipv4,ipv6,arp can falsely delay the
>> synchronization of concurrent get_counters() or xt_replace_table() called
>> by any other than the one calling do_add_counters().
>>
>> So remove xt_write_recseq_begin/end from do_add_counters() for ipv4,ipv6,arp.
>
>Completely wrong patch.
>
>There is no way we can update pairs of 64bit counters without any
>synchronization.

Yes, I was completely wrong about why the synchronization is required...

>This is per cpu sequence, the 'shared among ipv4,ipv6,arp' part is moot.
>
>We could use cmpxchg128 on 64bit arches, but I suspect there will be
>no improvement.

I see. And if we were to use cmpxchg128, we would also need to come up with 
the way for xt_replace_table()'s synchronization which I guess the current 
per cpu sequence is more suited.

Sincerely,
Ryo Takakura
