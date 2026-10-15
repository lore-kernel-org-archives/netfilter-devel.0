Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B854DBD63
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 11:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792062917; cv=pass; b=m3ZsvKy7K86y4hbcMat23hviZ5RIKxy+V1EQxfrz74X8OPs19/lqlAQRNm4z5syf+/pDbAUv3kHQ8qXcLGUmpyQo5MQtNCIRKxpd2W3iWtLkJeufxQymKyCqnWkZ28cW0vU6+fGIRnptW5eJ+z58NklVoTnoVTXOpLOZIHVotlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792062917; c=relaxed/simple;
	bh=I9oPJ3YGlwxlNX6cpMBiC5ATHr477eWduZeRhnHEaoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tuYpBNor4JacAHGnqFjovOno3isvuwY4GWObIP0Uzf1DLpPg4GqIRLoZv3inrUvFUFNVPkReTe6ZjQbavpAQGRxLRzxV2DxmxGBEJXPmBn2XE2v6O2lqERRQ9lvYkyVNbgYqhkPogPlS3rACF5XwPPKDV8fWMUqKj0Ga2GguaiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=tFsok8Gu; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="tFsok8Gu"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b0a921ee46so19524977b3.2
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 04:15:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792062915; cv=none;
        d=google.com; s=arc-20260327;
        b=dWVn48B8Ft/i/a9bZ5Ygb1pKE67MMETQi26eJFzaFjFGaxHev+9OrK1qi14P3oIOFD
         6nR2K/fdOuJ5tvruHb6g+1XKu69w0TTIcEkJbO14F+4VB2DpRUSB4DJ1YIQ0w0j7X317
         BSXKOXQ3x6K2rf56Ae641eo7mnkQi2mih4yTwVOa0l+/Vn+wUY2g8gtmEq4ov10wd0KB
         9C3JKNAzqzV0eEAlhybbdXJLxS/F3KfIy8SJW5ONMpaI3QAPpv3pBRAKllWglibNbMzJ
         OUckRHeA0fxOV0jgBg5UibT1BB8Z9VUNQAFCuZjZHK1ngjRw5wSN91kAYEBSwnxs/BO2
         0FXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=I9oPJ3YGlwxlNX6cpMBiC5ATHr477eWduZeRhnHEaoM=;
        fh=pbwHlyGzchIZykqfCNjYPV8fiz2SLU0xxBAeq+Jv9IM=;
        b=fS9FbL3TwYdXEe8pPtlBW9cS7IVwx+WwgApSRyYO/SZe3BU8ZLl3mn8eE+WVqgxmpG
         tf/vvSTx5nrvRFl14+RD3SHTuzJyvpydviSzBM/w7M792XAulQyi4liQRhT8UDMf9sWL
         adHYrQKvBGzh/8riOJX3Zp6aF1am6FGT32jCNSHhY6bd7Gx+LgNbcX6VrutLoZHgUFxQ
         54c5vmNLJA04oDO84eAbI1C9L1f2Cs3M1TntfZBVUTW9+X3cbNkAq73oibnQCTtWyPQC
         F4EzmKjRdMQ1Dka0slY3/6kk03O0kzZjO/4uxUEfq6osh49TDfqVZFZyCFFM2NEzuccU
         XmTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792062915; x=1792667715; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I9oPJ3YGlwxlNX6cpMBiC5ATHr477eWduZeRhnHEaoM=;
        b=tFsok8Gu7pL10k+toUtA9U1xyWr1fKGTQGuD6siZNufYDmTlx5iGEacoYxtaO/9xuZ
         royzZQvQ6BThJfyJOQm1cjOvW32PR3hZrFJznN27ptUm1mghkbkPzgXvj2a6XHJP47TB
         bbih8OPOOMxnSjvYa3885JLpMvx+GgzIpy01s33Pr+h1OnjbITbetlHEid5It9BuxJdj
         +jtrJxAEb7mGxUwzI9gbGyCk7bauz2wHkzrmnfBsZ71s8dxlipqI21+C75FkHWcs/1y6
         QR+IKe4BLpXExBmfQlhIMoF33/KjpN4sl9hVB1ojQGf4RCv8Q7kgUbMcMuO8dLhZMhMI
         Fxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792062915; x=1792667715;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=I9oPJ3YGlwxlNX6cpMBiC5ATHr477eWduZeRhnHEaoM=;
        b=p/38UzjVHhmRTlS/6y0cumLj81d1O2m9TO4Rd7MqabWikKe2PwJwz9zr1OofzFCFHM
         0rCYi2P1z0CirUH+ybUvTJDu4fQhjWj8uA2mzpqPY6jpmTMtNZZe7y+JaFLMxWYVnKDv
         UyOoOVPK0BclYGgO5oEL+e7zEu78EbU0wsSMTLxUimYG62lB4H/eOMCMn/4tSCP/zjuz
         xY51Y+0E+iPxOt9V976VQjyK7cbOLnDFd8d1ichbg/DVLfmrxPvSy8G/IU2sAEnJwNMI
         jVgEqC2UO4HDrzii9ZvWYi4iBc9LNJIFAAcg0b1BzJlKGRHPoT/MJw3yuq+42VzoFkAA
         6f6w==
X-Gm-Message-State: AFq9FYLpmwTTTL7kJ8HPCZsalX2vS1gTb6RNWjOWO6afaWMGnV3PAjHL
	FCPTrsWDOPkPl8T3zuM+MT1FHMjzq5TNc0Y0dkAKrt4zW9CDbTvXJo/r/b3O1AQsoqrvOHyPt7a
	cEZBmHGnrRGpxt4NvOUpjpWKWds8x70FLVZnU9sYC
X-Gm-Gg: AYBFou0XHjiIJgqjRaKs/jRSISsd4gdBFb3WLBODhs2QT16kNNqpCUHLGKTEFiry1H8
	kv+roUSCCMzDt8pndgx0MUm9pEUEzymOHw/SJ8z40xCj/5EYkZYl2G6oPBEgfPihEg7fZfE0jdH
	2URzcyyeHdCENDoLk5RGGOdA8UL45oyROTx0JYNEr2ogYFwuve3K/BWpDqCKCeK6z2Ni0qYOtqZ
	JoH9mz0VUR+Jfd52N0H03s88OMhU/cFp+MquTqWv9GKincQDvXXo8it7lic1SewgyrXE4g/sKDa
	SajKF4kGjZB0NQuzgmrjMq+pAI8u2j3DurO+z9iMFW0t6KQ/DWDx0GZmXX/6ohxH3Rp5fmvsUhF
	7Q3ySHFg1PKqZudTVvgJ1NzZjsoo/fuPhTgpOwlLMMlb1sX2IuOz0wHyybqT15YaZ3sY5Z+JvyU
	PfBM1AeYviKUqYrTmcsz93mOLSd5uqIge49JZDCTVw28AwfgCP7YtJDlSl7IsiXc+6DbVXbBksy
	74WUVos1HpnUVvs0hWgu6d1p5NWtpGeNitlTeiEr5JXU8bDpb3UKHSwla5h1DNFhq/z9hBv/7Ig
	hOuKAiQcOKH49Q==
X-Received: by 2002:a05:690c:7012:b0:8b0:cf3d:7b35 with SMTP id
 00721157ae682-8b0cf3d7ea6mr10078397b3.15.1792062915195; Thu, 15 Oct 2026
 04:15:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014235628.197976-1-julius@bairaktaris.de>
 <20261014235628.197976-2-julius@bairaktaris.de> <atCsGx2IRecQNK3r@chamomile> <atCs-U_AXIyvvpKd@chamomile>
In-Reply-To: <atCs-U_AXIyvvpKd@chamomile>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Thu, 15 Oct 2026 11:14:38 +0000
X-Gm-Features: AclHuK-GCm2OH3Jid7zEvImtoqSM3gq7UTcC3JLFEhmei75CLrzAl8zOZjCyOVw
Message-ID: <CAC1t37+g_5q2NbKmCkxhZthdHYabypyDZSoshwgAUVjbGm0NsQ@mail.gmail.com>
Subject: Re: [PATCH nf-next v7 1/2] netfilter: flowtable: tear down direct
 xmit flows when the fdb entry moves
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, kadlec@netfilter.org, 
	phil@nwl.cc, horms@kernel.org, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org, razor@blackwall.org, 
	idosch@nvidia.com, ericwouds@gmail.com, dqfext@gmail.com, 
	netdev@vger.kernel.org, coreteam@netfilter.org, 
	linux-kselftest@vger.kernel.org, bridge@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Pablo,

Thanks for looking over this.

I will incorporate your feedback and send out v8 + explanations for
the questions Saturday.

Julius
