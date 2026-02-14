Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6259F219319
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Feb 2026 18:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771094816; cv=none; b=ZRlcACNW2faWoqmVamrwOJNFXqF56jcjusMuW3+sTbfnNKhJfMZw4e2Wgzaz/dJ/P7elJctVfc+DW+lzK/7JhkNWDPHqySfIDHA5kNIAsXor007sUMQBgimhykL+TtuwDr2WLgZqr4hJPC59WnxydXNkSuFIukQm/A+8XNQxTLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771094816; c=relaxed/simple;
	bh=E3reMOSgoiiL+m3EiONOzoel5BX/AD3aa9dfafB4nP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T9tAGPy9pKGoic5Qg8O/KrzjflOUYBCjjb0Z/0CnetF9bUhYjebLnHMasI7jbJS8Zd9Nbszy0KSPsmIqq04Xzd+bnGp5nryPxX3/lBxx3wQE+SOETqecv5zYhoZvgmRU5sPLBhd3uEP660fOhDJbAGw+wPqBWmEkN3i+we2oqCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A6A1A60601; Sat, 14 Feb 2026 19:46:46 +0100 (CET)
Date: Sat, 14 Feb 2026 19:46:42 +0100
From: Florian Westphal <fw@strlen.de>
To: Alan Ross <alan@sleuthco.ai>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH] main: refuse to run under file capabilities
Message-ID: <aZDDEpXNzcE6_lGn@strlen.de>
References: <20260213225323.5749-1-alan@sleuthco.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213225323.5749-1-alan@sleuthco.ai>

Alan Ross <alan@sleuthco.ai> wrote:
> Extend the existing setuid guard in main() to also detect
> file capabilities via getauxval(AT_SECURE).

Applied, thanks!
