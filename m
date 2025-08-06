Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAE5292B3F;
	Wed,  6 Aug 2025 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754495238; cv=none; b=Lg1NUHAnN4hevvTqqAQOyLerF1n6JhpPGNkVqkjYciKz9HH3aveNJ9clTA5o3lL7G9/nSjlaqYZRrJC3JHzLPfgOFWQHLdZQkEEbPnOUCb6t1ZVS0xjx6XBmfvRMy9UauGuyoh67S96zaDdY66wEldcrE1T5SjZsMd/AQjmwxcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754495238; c=relaxed/simple;
	bh=E9EJHvseRYR8Cnkzf6lNhYNZ8pZf+RU11YQTW/20uQs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NwDTbKkl9VASbdU4gV2GdcZwA+p6On6D8vWzIuXww3OoWjwGCRQpSCX1IAdJOKY7uxp5FHCxkB6PRsVWXepDsn3yNhfw8ikwF5aUl0TPAqGhrtbJWYcOxq0ZMCOd3Wsq1qDOGP8FO+TS6U+8BbTQkbBSVWouI2oKqUzxZmKQ4v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 219E51003C0C49; Wed,  6 Aug 2025 17:47:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 1F9C2110098430;
	Wed,  6 Aug 2025 17:47:07 +0200 (CEST)
Date: Wed, 6 Aug 2025 17:47:07 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org, 
    netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: Re: [ANNOUNCE] libnftnl 1.3.0 release
In-Reply-To: <aJM8ZPySLNObX5r8@calendula>
Message-ID: <54r4586n-9q20-2np0-rs68-4p5444sr78sr@vanv.qr>
References: <aJM8ZPySLNObX5r8@calendula>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2025-08-06 13:28, Pablo Neira Ayuso wrote:
>
>https://www.netfilter.org/projects/libnftnl/downloads.html

Signature missing from http://ftp.netfilter.org/pub/libnftnl/

I guess one of those download locations should be retired.
