From: William Stearns <wstearns@pobox.com>
Subject: Re: Converting patch-o-matic over to 2.6 kernel format - should be
 ready to go.
Date: Sun, 23 Nov 2003 01:43:13 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311230125100.21895-100000@sparrow>
References: <20031117080641.GA22919@sunbeam.de.gnumonks.org>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
   William Stearns <wstearns@pobox.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031117080641.GA22919@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good morning, Harald, all,

On Mon, 17 Nov 2003, Harald Welte wrote:

> On Sun, Nov 16, 2003 at 05:01:55PM -0500, William Stearns wrote:
> > 	I've written a converter that pulls in the lines from pom's
> > .config.in and .configure.help files and creates a something.patch.Kconfig
> > file, ready to be used on a 2.6 kernel.  The converter tool is at
> > http://www.stearns.org/pom26convert .  I've included a sample output; the
> > HL.patch.ipv6.config.in and HL.patch.ipv6.configure.help files were 
> > converted over to the HL.patch.ipv6.Kconfig .  The converter warned the 
> > user at run-time that it wasn't able to handle the if/fi lines in 
> > .config.in; the person running it will probably have to do some cleanup 
> > work on perhaps 20% of the files.
> 
> thanks a lot!

	I'm glad to.

> I am in the process of re-writing patch-o-matic in a more general way,
[snip]
> However, my idea was to have a higher level language where one could say
> "add the following member to struct foobar", or "create a new config
> option FOO dependent on BAR" - independent of the kernel version.

	I think I won't take you up on the project; it sounds like a fun 
one, but I, too, am jammed for time.
	My short term project is to get a 2.6 kernel going on 
patch-o-matic, so I took the easy way out and taught runme enough to work 
with 2.6 trees.  It turns out the changes are not all that large; the 
patch is only 4k.
http://www.stearns.org/patches/patch-o-matic-20031122.runme-26-patch
	For this runme to work, you need to create the Kconfig files with 
http://www.stearns.org/pom26convert/pom26convert (simply run 

pom26convert *.patch *.patch.ipv6

in each pom subdirectory (it'll tell you if any manual cleanups have to be
made).  Now runme has the .Kconfig files it needs.
	Harald, would you consider this patch as at least a temporary 
solution?  Please don't tell me I'm the only person that wants to use 
patch-o-matic on 2.6... :-)
	Cheers,
	- Bill

---------------------------------------------------------------------------
        "If you think technology can solve your security problems, then
you don't understand the problems and you don't understand the
technology."
        -- Bruce Schneier, Secrets and Lies
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, freedups, p0f,
rsync-backup, ssh-keyinstall, dns-check, more at:   http://www.stearns.org
Linux articles at:                         http://www.opensourcedigest.com
--------------------------------------------------------------------------
