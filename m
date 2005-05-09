From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: iptables-batch 2nd try
Date: Mon, 9 May 2005 10:56:03 +0200
Message-ID: <20050509085603.GA12173@suse.de>
References: <20050421122008.GA22032@suse.de> <426BC783.3030603@trash.net>
	<20050427125808.GA16169@suse.de>
	<20050506114151.GJ30482@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050506114151.GJ30482@sunbeam.de.gnumonks.org>
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
> On Wed, Apr 27, 2005 at 02:58:08PM +0200, Ludwig Nussel wrote:
> ...
> > +	fprintf(stderr, "Usage: %s [FILE]\n\n", program_name);
> > +	puts("Read iptables commands from FILE, commit them at EOF\n");
> > +	puts("In addition to normal iptables calls the commands");
> > +	puts("'commit' and 'exit' are understood.");
> > +	exit(0);
> 
> So why don't you put some simple parser/converter in front of
> iptables-restore?  I mean, iptables-restore does pretty much the same,
> just that it expects the input format to be something different than a
> shell script.
> 
> Those differences should be quite easy to convert (probably even in some
> shell or perl script).  Basically all you need to do is to remove the
> "iptables" from the beginning of the command, and add the COMMIT line at
> the end.  Even though "-P" and "-N" are not used.

That was my first approach but the startup costs for perl are too
high. So you'd need to write the converter in e.g. C. But then it
doesn't make much sense to print text that is parsed by
iptables-restore again when you can just do the appropriate calls
yourself. The disadvantage is that you need to build iptables-batch
inside iptables since there doesn't seem to be an external library.

> My main objective is that the functionality between iptables-restore and
> iptables-batch is pretty much the same.  I think either a converter
> before iptables-restore, or modifications to iptables-restore would be a
> better way.

There isn't much code to share between iptables-restore and
iptables-batch. Although the functionality is similar they work
differently.

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   SUSE LINUX Products GmbH, Development
 V_/_  http://www.suse.de/
