Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [185.244.194.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12684964F;
	Wed,  4 Mar 2026 05:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.244.194.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772603446; cv=none; b=liW5CWtPnxt9yVkzTuqXxmzhpITByUXtWBkU3UrpvirmlIAHI7H9M593sB2XCF0ZUDyBx1uFX+gZZ266c51Xza8+pxe87sdl7hs8darzBzCOnOa/GG5z3zMUIbhAfLi5pCUEN3rrnwrMJOnwwd5Tb29yJnyPDA9ClufxvgxobO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772603446; c=relaxed/simple;
	bh=OxJf+Q6FbPGEAU2/QNsCB7gqvWE6MzKS94JujX5qwck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mJvjMFIjkL7EeLL60ikW+mLClepBHVzv1mq/2e7p9fHe987UTRszAiUxqlLOsw0zI6ndRH42hwD0yXkZ6KR9TWfv4Ah6xCnYpArqteGUw/rGamE9l4TfVLtC1NzqGNIjhIkl0i6rTMIUfscvlmbmDBDM2U2D/1OJV/UkXV98kjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=KmvOufNH; arc=none smtp.client-ip=185.244.194.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="KmvOufNH"
Received: from relay01-mors.netcup.net (localhost [127.0.0.1])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4fQhbc1YjRz9CZy;
	Wed,  4 Mar 2026 06:50:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1772603436;
	bh=OxJf+Q6FbPGEAU2/QNsCB7gqvWE6MzKS94JujX5qwck=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KmvOufNHVOsMecD2uoDkjoeSrmy3Mk7scIfNap8BkK2MFl8giciQAw0Csb7KxuDm+
	 hxuC0WevBAaajyjM1CC4Kj8GiZkwDg5ZZ98Acn4Q5Sl7AvD5Wui6Y4Qs1d7i4S7z7f
	 Vuw6OZ/zCjAkUxkVZ+2GarKgbTICb6jI1zWr7HOqOgInR2qE6qVMh9a3ghtlWv7g8z
	 cjGcJt5va4Uin+/s+j7Z55uUEcoXHdjlPuZgicGweE2oM2N40/m8vbmLIvZlfTMyf1
	 vg3dn0uI9ELM0moDEasETzcDaVtAfSYZraC4h8CfETdS2DLra7cz7yBS5OjdRtsqQK
	 EdqcOi+SNGT0Q==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4fQhbc0sgCz7vS1;
	Wed,  4 Mar 2026 06:50:36 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.901
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4fQhbZ2g63z8t4F;
	Wed,  4 Mar 2026 06:50:34 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 99A34617A9;
	Wed,  4 Mar 2026 06:50:33 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <75a4115f-e7f3-4316-b046-525fcd87cdef@leemhuis.info>
Date: Wed, 4 Mar 2026 06:50:32 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables [resolved]
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jindrich Makovicka <makovick@gmail.com>
Cc: Genes Lists <lists@sapience.com>, Greg KH <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, coreteam@netfilter.org,
 netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
 regressions@lists.linux.dev,
 "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
 <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
 <143e1a402ad78dd7076516a6ceb637f378310b16.camel@sapience.com>
 <10537f2b74da2b8a5cb8dc939f723291db39ff84.camel@sapience.com>
 <2026022755-quail-graveyard-93e8@gregkh>
 <b231fcdb6c66a7b24dcef3ee5c35c5f612d5c1a7.camel@sapience.com>
 <9d110d860c0c7e110d018ea53a7666eba275da20.camel@gmail.com>
 <aaday5NR-yfCkFVb@chamomile>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <aaday5NR-yfCkFVb@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <177260343399.2903715.3365136825409012734@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 99A34617A9
X-NC-CID: butrOV/u4p7Y4qNywgpMYu5RTL/Bo1fbb9jMufI/2aWhxcz+1y4=

On 3/3/26 23:03, Pablo Neira Ayuso wrote:
 
> A new userspace release with this fix is required.

But a new user space should never be required for a new kernel. Find a
few quotes from Linus on this below. And I noticed other people ran
into this, too, so it's not a corner case:
https://lore.kernel.org/all/aaeIDJigEVkDfrRg@chamomile/

So should this be reverted everywhere where this was applied? Or is
there some way to do what the commit wanted to do without breaking
userspace?

"""
* From `2018-08-03 <https://lore.kernel.org/all/CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com/>`_::

    And dammit, we upgrade the kernel ALL THE TIME without upgrading any
    other programs at all. It is absolutely required, because flag-days
    and dependencies are horribly bad.

    And it is also required simply because I as a kernel developer do not
    upgrade random other tools that I don't even care about as I develop the
    kernel, and I want any of my users to feel safe doing the same time.

* From `2017-10-26(3) <https://lore.kernel.org/lkml/CA+55aFxW7NMAMvYhkvz1UPbUTUJewRt6Yb51QAx5RtrWOwjebg@mail.gmail.com/>`_::

    But if something actually breaks, then the change must get fixed or
    reverted. And it gets fixed in the *kernel*. Not by saying "well, fix your
    user space then". It was a kernel change that exposed the problem, it needs
    to be the kernel that corrects for it, because we have a "upgrade in place"
    model. We don't have a "upgrade with new user space".

    And I seriously will refuse to take code from people who do not understand
    and honor this very simple rule.

    This rule is also not going to change.

    And yes, I realize that the kernel is "special" in this respect. I'm proud
    of it.

* From `2017-10-26(4) <https://lore.kernel.org/all/CA+55aFwiiQYJ+YoLKCXjN_beDVfu38mg=Ggg5LFOcqHE8Qi7Zw@mail.gmail.com/>`_::

    If you break existing user space setups THAT IS A REGRESSION.

    It's not ok to say "but we'll fix the user space setup".

    Really. NOT OK.
"""
 
Ciao, THorsten
