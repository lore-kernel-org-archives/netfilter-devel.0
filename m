From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Thu, 9 Dec 2004 12:29:13 +0100
Message-ID: <20041209112913.GA31497@oknodo.bof.de>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
	<20041209085249.GA22714@oknodo.bof.de>
	<Pine.LNX.4.58.0412091108420.11649@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick Schaaf <bof@bof.de>,
	Grzegorz Piotr Jaskiewicz <gj@pointblue.com.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0412091108420.11649@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

> > > - When the conntrack table is full, we search only in a single hash
> > >   bucket. We are in trouble anyway, so let's search harder for
> > >   droppable entries: the patch extends the search to at most the third of
> > >   all the buckets.
> >
> > Hmm. It's correct that we are in trouble anyway, but will it help burning
> > much more CPU to get out of trouble?
> 
> How could we lessen the trouble we are in? By refusing to add the new
> connection to the table after failing to find an unreplied connection
> in one bucket, or searching more with the price of spinning the CPU a
> little further?

Well, the way I see it, the primary task, under pressure, is still to
run ASSURED connections as good as possible. Burning more CPU in
early_drop for each new potential connection (at possibly high rate,
when under a real DoS attempt), will take significant time from routing
ASSURED connection's packets.

best regards
  Patrick
