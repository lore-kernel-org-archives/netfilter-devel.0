From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 2/3] locking: Annotate spin_unlock_wait() users
Date: Tue, 24 May 2016 12:22:07 -0400
Message-ID: <20160524162207.GB3354@mtj.duckdns.org>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.608476390@infradead.org>
 <CA+55aFyyHbPVMx8cZbKONy5cevxsYA0qbwapboA0dD8hPSwPWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Will Deacon <will.deacon@arm.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <Waiman.Long@hpe.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	Oleg Nesterov <oleg@redhat.com>,
	netfilter-devel@vger.kernel.org,
	Sasha Levin <sasha.levin@oracle.com>, hofrat@osadl.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:34665 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbcEXQWK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 12:22:10 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFyyHbPVMx8cZbKONy5cevxsYA0qbwapboA0dD8hPSwPWg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Tue, May 24, 2016 at 09:17:13AM -0700, Linus Torvalds wrote:
> So don't talk about "acquire". And most certainly don't talk about
> "control dependencies". Not if we end up having things like *drivers*
> using this like in this example libata.

A delta but that particular libata usage is probably not needed now.
The path was used while libata was gradually adding error handlers to
the low level drivers.  I don't think we don't have any left w/o one
at this point.  I'll verify and get rid of that usage.

Thanks.

-- 
tejun
