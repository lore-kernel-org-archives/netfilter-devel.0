Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F94E3B9937
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 12:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786624065; cv=none; b=YsTg6zG9ZJhPCGIfRh/80D2nvZczAxYTmpaBalqS50ZYF+Ae7SYmY7F6+BL3YHI0/Gk7Qak5zw8JoivaOZXjhFac3COsFPg51OpPwF9LSEY5/icUkO0J8ks12K46cWiQpwsuP4f8iYNlpfSAGowFbgiJJjWnkBq3P0yvRvsVvXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786624065; c=relaxed/simple;
	bh=954LdstcamvGYAxB0wl395OUR8a0u2TxuQLUV54Qbqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RM6gc4+gljdIx1fiSfeszYRNgpGgvZIbmh1vhWhm5KUzR72qV7B3ZOAaBsobMVmga5OGnC1ewSD00hnH0QXdSp87WO09XuYkvn/xTuIkpyOwa5oH4Q5m9jRdUTm9nYVBCANaQ8uiUaF6AGnu3KxfVhuszKbDzW45hgs5WtnHE3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 162066038C; Thu, 13 Aug 2026 14:27:35 +0200 (CEST)
Date: Thu, 13 Aug 2026 14:27:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Avinash Duduskar <avinash.duduskar@gmail.com>
Subject: Re: [nft PATCH 0/2] tests: shell: Keep dumps with numeric protocol
 values
Message-ID: <an24NqiVztbea8bH@strlen.de>
References: <20260813114556.2685869-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813114556.2685869-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Adjust the test wrapper to create dumps with --numeric-protocol option
> (patch 1) and update all dumps (patch 2).
> 
> One could also set --stateless, py test suite does that, too. Though
> there are tests (in packetpath dir) which seem to rely upon counter or
> other stateful data to be matched in dump files, so keep state for now.

Yes, there are tests that rely on dump validation to catch
non-matching/matching rules; those would have to be switched over to
test for the counter values manually.

Patch LGTM, thanks for working on this.
