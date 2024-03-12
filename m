Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B9C78298
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710252650; cv=none; b=JiU/EksVwcPgOKJJAU5A0RrYhB9Ve29CUwaa/eMoFkGowugc1oQ25mXZZBdaDoPw/oOHSxtc4QFMrTF6om+U7OP8K0qDMTFJMrktoAfM1TZ0HCZRqjo6rHF3jHeIP6I+FNJlpWtQ/3hCiVfKUUngIhYtHHQKMZk3TdqRffZBssc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710252650; c=relaxed/simple;
	bh=hXHmnkB4bcjRXBV7cXtv343zmbz8d8lBUrLF2JD9U3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HPl1wrxjLG0QbrXv+E+jI16dB9aVoZP9zQ9m9949ryTqMrcueBOMO7CTyE/3gx54wqPZsIFHpjmRtmz89yg3zQB6scfTYAue76ZIizgl7+8tVdlQjixGSA7lkfYhciMCDxLFh4skxU8t/tTV+L6fdiSmPPcit1ye2NfkvK2MD6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rk2q6-0001FA-F8; Tue, 12 Mar 2024 15:10:46 +0100
Date: Tue, 12 Mar 2024 15:10:46 +0100
From: Florian Westphal <fw@strlen.de>
To: Quan Tian <tianquan23@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <20240312141046.GD1529@breakpoint.cc>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240311141454.31537-2-tianquan23@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Quan Tian <tianquan23@gmail.com> wrote:
> -				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
> +				swap(trans->ctx.table->udata, nft_trans_table_udata(trans));
> +				nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);

I missed this in my review, as Pablo pointed out you can't use swap()
here, because table->udata is rcu protected.

Something like this should work as replacement:

nft_trans_table_udata(trans) = rcu_replace_pointer(trans->ctx.table->udata,
                                                   nft_trans_table_udata(trans),
						   lockdep_commit_lock_is_held(trans->ctx.net));

This will swap and ensure all stores are visible.
