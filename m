Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E204239066;
	Mon,  3 Mar 2025 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741019820; cv=none; b=GxCJ3fWOHIaVAbc3uJLrgwVd/W99cscDKHsRNHfmeQJX+7UPLXq+A40/qHu9N/6xa/5fyvmFJDEXwz5/yswa8bG/hC4dG8i/Rvzay3ac5RKBGefYzxFsevR4PdFnFOr2qrd3I+xotwXK+Z4mYqATdI8pe5wxhF48QTXUPMS0/Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741019820; c=relaxed/simple;
	bh=9Tn6ZJxazYelS7ar0EVO4F61cExUt63mO2bhh3RodEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jZ+x18dyVWBvRY5Vh0L134Cwm7u7MWV+wOCXDf3CYIZxOBGGueXq/BCIMhPhw0u3hjKo6C22FPv5Kx1LnoGOqUPA/mcxUgzLnLPtniP++/apfpV7q/5+QcnQfqHSYDmCnto9gQI+5AM76yZRVGZ988W//R15nFQAMP9JjUxCJok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3Kc51Zy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3Kc51Zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFE4C4CED6;
	Mon,  3 Mar 2025 16:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741019819;
	bh=9Tn6ZJxazYelS7ar0EVO4F61cExUt63mO2bhh3RodEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f3Kc51ZyLI5Xo+k3ge9buTOOmAQWjATIRyW6xzVH8/eZWUOUQnRmD3W2cx7Wlrpl/
	 UnNJNEj0c9TMwhAqjhloRQnq736nOrtTnEzlhC/ylrbTcqd/4dUWv+x3lW0X+BCAAP
	 6TnVrw3sogPVjs7S603KYPGDv28uGVfh8f0S9h1Gy4gncv8hWH4rvkE5SZME6LmndQ
	 gWCeABUcfIZE0Wqxf8WF7d7hH6iOxDqVnlL72fyaGv8RMFE1lfUpXf0FoHvhEbLyEx
	 Vois01LR7lmijDy8LOV74/Ws53qqyQlMnWSo9FhS/3JOJdP2onTAl8XzT2tDYZcyej
	 G20uPoWtSmICw==
Date: Mon, 3 Mar 2025 16:36:55 +0000
From: Simon Horman <horms@kernel.org>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] [NETFILTER]: nf_conntrack_h323: Fix spelling
 mistake "authenticaton" -> "authentication"
Message-ID: <20250303163655.GV1615191@kernel.org>
References: <20250227225928.661471-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227225928.661471-1-colin.i.king@gmail.com>

On Thu, Feb 27, 2025 at 10:59:28PM +0000, Colin Ian King wrote:
> There is a spelling mistake in a literal string. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Thanks Colin,

I checked and with this patch in place codespell doesn't flag
any spelling errors in this file.

Reviewed-by: Simon Horman <horms@kernel.org>
