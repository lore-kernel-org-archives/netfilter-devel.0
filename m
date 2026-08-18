Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA5047143A
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 12:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787057239; cv=none; b=sZFnR0uRx2ETnwnbxaLjVUVKR3yPJxUbugbwF5WgzXOvogLG1C2r59kUlawetVTeNXCJQrbTWkV/2T9SkG4RRlDs5RcvQZa77lTF7cPirAc+uM9aoDHz4zQ3hhOXFpZHdkoCJtvqMZl4RIMf1dxVwUM5KSxt+hAJOCNho7oIEPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787057239; c=relaxed/simple;
	bh=2tPvvyQ/V2R9N6iQU7wvbjPYmEEbbq9k/CzqWBISG6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUy/UO5Hx9/UbkW0ZFTqwq0iex0o+/STkKbhtFtTQS0rnetfi78HyDo5neKU3xcc/97u4kPNojhsk1sijQ+VD+bC6TliyQmyxGgXOrBwBAqw4zpX9qnO7JQC3nqoVn59WMNNKVoq9omUBiwTfVYgV+8+ek2HnUHh6ORldZEn5uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 165DD6051B; Tue, 18 Aug 2026 14:47:11 +0200 (CEST)
Date: Tue, 18 Aug 2026 14:47:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fmancera@suse.de
Subject: Re: [PATCH nf-next 4/4] netfilter: xt_cgroup: use
 pr_info_ratelimited()
Message-ID: <aoRUTjmwh_TC7_Rn@strlen.de>
References: <20260818122741.1329660-1-pablo@netfilter.org>
 <20260818122741.1329660-4-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818122741.1329660-4-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This seems to be the last xtables extension not using the ratelimited
> version, update it.

Makes sense, thanks Pablo.

Reviewed-by: Florian Westphal <fw@strlen.de>
