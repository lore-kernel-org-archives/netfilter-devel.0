Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA91E274B26
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Nov 2025 16:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763484394; cv=none; b=q1e06R25DlNBSmoSKWG/s+G7WVOEHFx2WESUZaYA2bIzNlRpWHDkb0RsYXDL9vHzVSvGA4fAlLILwDK1iH2q0vKBWqmoBM4tTcfgg8/HInyG+QczbdjvB3be3UMgtOwlKhQc1T6XHH6NADFyWEQWo8N1skc48NTUhzSNT73ov3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763484394; c=relaxed/simple;
	bh=/n+JkSAzHpw9O3TpKGbZ/oYPiRxY5a1tCw7ESsBvYOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IRyl3S5ainTx19z40TQkUKZinZd39GnAz85l7/SoKa2Me/TOw8c39S8TzS9voSmcTyaj47Ub4lrVvmn9jVYVLpX9s5FZ/Kc3hW97Xk4V7zM3LXT73D8Wbz51w4L8SbcRCkV5heGONPRoVDFQYb3DIfeZj+Ulk+dFd+hqMemTMuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EC6EA60555; Tue, 18 Nov 2025 17:46:28 +0100 (CET)
Date: Tue, 18 Nov 2025 17:46:29 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_set_rbtree: use cloned tree
 for insertions and removal
Message-ID: <aRyi5VVq6HKTvEDm@strlen.de>
References: <20251118111657.12003-1-fw@strlen.de>
 <9a4e63da-6d36-4365-8c08-547961c9bfa7@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a4e63da-6d36-4365-8c08-547961c9bfa7@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> When adding a new element, it is inserted into the cloned copy and we 
> swap the genbit so root[1] is now live. Then, when we are sure that the 
> operation was successful, we update root[0] with the same operation. 
> Therefore, root[0] and root[1] are now identical.

I don't understand this.  The swap can't be done before ->commit().
Else, how do you deal with a rollback (failing transaction)?

Not exposing any of the new elements to the data path until
the entire transaction has moved past the point-of-no-return
is large part of the patch series.

After commit, yes, we can do a walk of the old tree, purge
old elements, then walk the new tree, add new elements to the old
tree so they are identical again.

But that doesn't sound faster than duplicating everything
on next insert/removal.

> This way we can avoid the clone operation which is quite expensive.. of 
> course, it would require to do the insert/removal operation twice.. but 
> that is cheaper if I am not wrong.

How do I know what to re-insert and to remove from the old live tree
without a walk of the new tree?

> Maybe I am asking for too much (?). Also it brings some problems.. like 
> what if the sync operation fails, should we re-do the cloning?

How can the sync op fail?  Can you elaborate?
