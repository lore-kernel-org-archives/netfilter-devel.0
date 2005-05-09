From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: iptables-batch 2nd try
Date: Mon, 9 May 2005 11:45:39 +0200
Message-ID: <20050509094539.GA12708@suse.de>
References: <20050421122008.GA22032@suse.de> <426BC783.3030603@trash.net>
	<20050427125808.GA16169@suse.de>
	<20050506114151.GJ30482@sunbeam.de.gnumonks.org>
	<20050509085603.GA12173@suse.de>
	<20050509090244.GD30482@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050509090244.GD30482@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Mon, May 09, 2005 at 10:56:03AM +0200, Ludwig Nussel wrote:
> > 
> > > My main objective is that the functionality between iptables-restore and
> > > iptables-batch is pretty much the same.  I think either a converter
> > > before iptables-restore, or modifications to iptables-restore would be a
> > > better way.
> > 
> > There isn't much code to share between iptables-restore and
> > iptables-batch. Although the functionality is similar they work
> > differently.
>  
> The question would then rather be: why is there no code share since the
> functionality is similar? ;)

Hmm. Both read a file line by line and split it into words.

iptables-batch then searches for -t to select the correct handle
that is passed to do_command(). Allocation of the handle is left to
do_command(). At EOF (or when reading "commit") it calls
iptc_commit() on each handle. That's it. If you want to flush tables
you have to add "iptables -F" lines yourself.

iptables-restore has a special syntax for manually creating a single
handle, creating chains and set their policy and for setting
counters. One needs to COMMIT before switching to another table. A
global setting determines whether all tables are flushed when a
handle for them is allocated.

So IMHO all that can be shared are some lines initialization
(getenv(), init_extensions()) and maybe the tokenizer. All the other
code would need to be inside a if(batch) {...} else if (restore){...}

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   SUSE LINUX Products GmbH, Development
 V_/_  http://www.suse.de/
