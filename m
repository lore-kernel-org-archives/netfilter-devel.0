Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B68C1553BC;
	Tue,  2 Jul 2024 09:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719912487; cv=none; b=LA621lTDdR8lD6gsXQV0thulvq0z/3IXQjvkc8n6ByIjNJteXu78/bsWeo+KwvmfTQBp/WfQo5CqE4oR41gYjAtCtjZvARQAiZtVGL5OxlhbEEkK5wh1ujfhDfQxGw352tHrdtC/Co0WGXP/bdZAJL5h7mXpT79vT7xPzT0uPVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719912487; c=relaxed/simple;
	bh=Ioqnul1v/N72j7LyUr4QSqSPlp+8EylYPOSvswHBRLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSl1b3PUetDAnUxhd0dW8KySk0LeKoWo06n0Fay6krO/VOL5hysG+zXQBcjzhtYBPYyLyqFCBT+5eq+Wp+26EyRhbWAf5dld+YItk3e76yZJFXfYMncxmCpPcuUn0G6TPlo6/qnynInFJn9X9ktYClUjQdoeIN/NBYCNtiKPemw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJNu/viE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJNu/viE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF3DC2BD10;
	Tue,  2 Jul 2024 09:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719912486;
	bh=Ioqnul1v/N72j7LyUr4QSqSPlp+8EylYPOSvswHBRLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rJNu/viEwONCccD+uXWGkbdGtMl95NkfIm3I9CK1Buhrjlz32+o+itidYx1lRn/FY
	 bykN14CMoXZf48aloKA9p8d3XsjxmD0VZiHI6/nad6PlnZZUJCxyahx9zDpetFOs4L
	 xj11w1+xNI+LXv5mZEqycwztV3VQ0LULFeGQmKdHDH3NoPpC8ZC4dNK3XS0lhw6/t1
	 sFFUhUDegLKLAqEcXrBMFT9siFzKTgpGH1IEDso1gaWrsUqS6H5vnS4OoVIQNIgfUo
	 XSQ1kJdqf7jZNANVniRl89SpVG6WTrmD4fcGkaZL4hCy1vWAtlPh6FVcdJ9bML0uLQ
	 fbNbQeb4kylVA==
Date: Tue, 2 Jul 2024 10:28:02 +0100
From: Simon Horman <horms@kernel.org>
To: Liu Jing <liujing@cmss.chinamobile.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: remove unnecessary assignment in
 translate_table
Message-ID: <20240702092802.GC598357@kernel.org>
References: <20240701115302.7246-1-liujing@cmss.chinamobile.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701115302.7246-1-liujing@cmss.chinamobile.com>

On Mon, Jul 01, 2024 at 07:53:02PM +0800, Liu Jing wrote:
> in translate_table, the initialized value of 'ret' is unused,
> because it will be assigned in the rear. thus remove it.
> 
> Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>

Thanks,

I agree that ret is always set before it is used in translate_table(),
and thus the initialisation to 0 accompanying the variable declaration
is unnecessary.

Reviewed-by: Simon Horman <horms@kernel.org>
