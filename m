Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17DE12D76E;
	Wed,  3 Jul 2024 13:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720011677; cv=none; b=W4yVcnMf6kICs34UPY/iJ4d6Xi7kpRPPRENluEOZUHxcuv0HxRfBOk35DLEsOfIwtSvb0UMhqzVxZGkzX4rWXMPWh87x+VlZ7u0scG/3T4t/39D+sDlcVNB/xbpd+0GZfTxhUddiXl7/P2Zdq92uH6+McZOwPNrdeqWRYR2avjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720011677; c=relaxed/simple;
	bh=FlsCaFSg5VHWt2OU13H8/f4LqzE6kXlYNYbP0vddRVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/SUyALy+Rfj4+jB5Zm2Zl4RjxUBbYUPj3jeXL01Qbzj+O6Yi/BdsY6K3aRQdFFGJS6IjsU0hF83P2YV0+94pBYsy28t0f7eJComjEVZyt/DvzE1RJr985j9oUfSGlUyqRs4Ni416/FsAMPhbRUxIZdEb9jlixz4lzpP3yhtZRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sOzbf-0008Ka-Ft; Wed, 03 Jul 2024 15:01:07 +0200
Date: Wed, 3 Jul 2024 15:01:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Hillf Danton <hdanton@sina.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: unconditionally flush pending
 work before notifier
Message-ID: <20240703130107.GB29258@breakpoint.cc>
References: <20240702140841.3337-1-fw@strlen.de>
 <20240703103544.2872-1-hdanton@sina.com>
 <20240703120913.2981-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703120913.2981-1-hdanton@sina.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hillf Danton <hdanton@sina.com> wrote:
> On Wed, 3 Jul 2024 12:52:15 +0200 Florian Westphal <fw@strlen.de>
> > Hillf Danton <hdanton@sina.com> wrote:
> > > Given trans->table goes thru the lifespan of trans, your proposal is a bandaid
> > > if trans outlives table.
> > 
> > trans must never outlive table.
> > 
> What is preventing trans from being freed after closing sock, given
> trans is freed in workqueue?
> 
> 	close sock
> 	queue work

The notifier acquires the transaction mutex, locking out all other
transactions, so no further transactions requests referencing
the table can be queued.

The work queue is flushed before potentially ripping the table
out.  After this, no transactions referencing the table can exist
anymore; the only transactions than can still be queued are those
coming from a different netns, and tables are scoped per netns.

Table is torn down.  Transaction mutex is released.

Next transaction from userspace can't find the table anymore (its gone),
so no more transactions can be queued for this table.

As I wrote in the commit message, the flush is dumb, this should first
walk to see if there is a matching table to be torn down, and then flush
work queue once before tearing the table down.

But its better to clearly split bug fix and such a change.
