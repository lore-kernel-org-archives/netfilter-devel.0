Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFB024A076
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 23:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777935892; cv=none; b=cvXZ4Y4uo3OnALS8NcOQAI3x3rzeMBIzUPoP91NiIgZvApSfNvEwYHMDyPV9CWHpMGiTmnGwCinEhOI2MeN4d0wHsmrKcPQaOQ1fp/TVtNri+n0LK1TMgq2A93HFvDGdfJgJHku6fnSA1/NhKwWI4A2vNnJBd5AFrYCji3LxK7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777935892; c=relaxed/simple;
	bh=Q4TTG9VqmUDlZhDAvRa5mJ8ooKYANcrgx3zAFKxrWWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGQt0ROlvdGACSQnXjEK52oqhl1Ya2NuYK7k1nBxk6Tzb8IT+6FSAntqNZe5BsqyZYZX5rAWJwQtOWUHjIgeUslWNszCKTiBoV1hPuG8CybbfrHzRikBDnxNa8SxeVmiGHMVx23MaLAmeNZJ4jqKGWs1pjhPKI2dPg3243acOEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AAC00605F3; Tue, 05 May 2026 01:04:47 +0200 (CEST)
Date: Tue, 5 May 2026 01:04:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Tristan Madani <tristmd@gmail.com>
Cc: netfilter-devel@vger.kernel.org, tristan@talencesecurity.com
Subject: Re: [PATCH nf 3/5] netfilter: x_tables: unregister the templates
 first
Message-ID: <afkmDq1bDlQag9ec@strlen.de>
References: <20260502075639.7440-1-fw@strlen.de>
 <20260502075639.7440-4-fw@strlen.de>
 <177792044028.2307140.8003648539483235646@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177792044028.2307140.8003648539483235646@gmail.com>

Tristan Madani <tristmd@gmail.com> wrote:
> For the series:
> Reviewed-by: Tristan Madani <tristan@talencesecurity.com>

Thanks.  I've fixed this up in my local copy, I will need to send
a v3 (only minor changes needed, so I will keep your RvB tags).
