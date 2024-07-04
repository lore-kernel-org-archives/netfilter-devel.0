Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF581A2571;
	Thu,  4 Jul 2024 10:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720090471; cv=none; b=G5RBugnkjuSYnk+lvC+lAJ5GuVy8HyX6GryqWK/jTHogJweoCqJYceFY/n58CVAiDryu8C2uculG89Yd6v0TtcVlYq/1Jp8P8780wTpnrRDKOciO0ujBPqX5WB9ziZVKD2EEeS4Jv4hQYqHgqqs5FNrEJ/69LS0t+Zi7p7rbz5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720090471; c=relaxed/simple;
	bh=/UEgsCPONLf606TxctUMDbmnfBYD1aoc3d8qtpjuxLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJu+pah1ANXzIMtfZwi2JjQcgPKNZBcu+c8Nk2trahyAJS1FWBHqsWr/6fXLFaUA5lhHDHYJhrlZDrk2nhDaj9rs5NOWoQWwo9mdjCDuu0w2BX6jSY2aw0TefGSVs2Jr1A4yujMf6yMHx+v6atkxF/EYRTqzZvnGRs0EiY0kvn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sPK6U-0008GL-8q; Thu, 04 Jul 2024 12:54:18 +0200
Date: Thu, 4 Jul 2024 12:54:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Hillf Danton <hdanton@sina.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: unconditionally flush pending
 work before notifier
Message-ID: <20240704105418.GA31039@breakpoint.cc>
References: <20240703130107.GB29258@breakpoint.cc>
 <20240704103514.3035-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240704103514.3035-1-hdanton@sina.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hillf Danton <hdanton@sina.com> wrote:
> On Wed, 3 Jul 2024 15:01:07 +0200 Florian Westphal <fw@strlen.de>
> > Hillf Danton <hdanton@sina.com> wrote:
> > > On Wed, 3 Jul 2024 12:52:15 +0200 Florian Westphal <fw@strlen.de>
> > > > Hillf Danton <hdanton@sina.com> wrote:
> > > > > Given trans->table goes thru the lifespan of trans, your proposal is a bandaid
> > > > > if trans outlives table.
> > > > 
> > > > trans must never outlive table.
> > > > 
> > > What is preventing trans from being freed after closing sock, given
> > > trans is freed in workqueue?
> > > 
> > > 	close sock
> > > 	queue work
> > 
> > The notifier acquires the transaction mutex, locking out all other
> > transactions, so no further transactions requests referencing
> > the table can be queued.
> > 
> As per the syzbot report, trans->table could be instantiated before
> notifier acquires the transaction mutex. And in fact the lock helps
> trans outlive table even with your patch.
> 
> 	cpu1			cpu2
> 	---			---
> 	transB->table = A
> 				lock trans mutex
> 				flush work
> 				free A
> 				unlock trans mutex
> 
> 	queue work to free transB

Can you show a crash reproducer or explain how this assign
and queueing happens unordered wrt. cpu2?

This should look like this:

 	cpu1			cpu2
 	---			---
	lock trans mutex
  				lock trans mutex -> blocks
 	transB->table = A
  	queue work to free transB
	unlock trans mutex
				lock trans mutex returns
  				flush work
  				free A
  				unlock trans mutex
