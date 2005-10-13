From: seb@frankengul.org
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Thu, 13 Oct 2005 09:18:51 +0200
Message-ID: <20051013071851.GA2526@frankengul.org>
References: <20051010.141518.60492651.davem@davemloft.net>
	<20051011104446.GJ4290@rama>
	<20051011175457.GC13415@rama.de.gnumonks.org>
	<20051012.155419.36023860.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, bdschuym@pandora.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051012.155419.36023860.davem@davemloft.net>
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

On Wed, Oct 12, 2005 at 03:54:19PM -0700, David S. Miller wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Tue, 11 Oct 2005 19:54:57 +0200
> 
> I think I found the bug in your patch Harald.
> 
> > @@ -716,8 +716,8 @@ static int translate_table(const char *n
> >  	}
> >  
> >  	/* And one copy for every other CPU */
> > -	for (i = 1; i < num_possible_cpus(); i++) {
> > -		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
> > +	for_each_cpu_mask(i, cpu_possible_map) {
> > +		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*(1+i),
> >  		       newinfo->entries,
> >  		       SMP_ALIGN(newinfo->size));
> >  	}
> 
> This isn't correct I think.  It assumes cpu numbers are
> linear :-)
> 
> In the two cpu case of cpu "0" and cpu "2" what this loop
> will do is:
> 
> 1) copy entry 0 to entry 1
> 2) copy entry 0 to entry 3
> 
> which fails to initialize entry 2 and that's how we crash.
> 
> Maybe the loop is better constructed like this (btw, for_each_cpu()
> walks over cpu_possible_map, no need to expand that by hand):
> 
> 	for_each_cpu(i) {
> 		if (i == 0)
> 			continue;
> 
> 		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size) * i,
> 		       newinfo->entries,
> 		       SMP_ALIGN(newinfo->size));
> 	}
> 
> Here is an updated patch, and it takes care of all of the platforms
> that don't export the necessary cpumask symbols.
> 
> Sebastian can you test this one out please?
> 
> Thanks a lot.

You're welcome :).

I'm pleased to announce that the mail i'm writing is on the machine with
your patch applied, and nothing bad happenned in the 5 first minutes.

So I can reasonnably assert that the patch is correct and fix the
problem.

Just one little point: Should the cpu_possible_map be an exported symbol
for all smp arch or not ?

	Seb
