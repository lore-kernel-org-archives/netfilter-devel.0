From: William Stearns <wstearns@pobox.com>
Subject: Re: Documentation for the u32 module
Date: Sat, 15 Nov 2003 17:06:38 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311151659500.22726-100000@sparrow>
References: <20031113090530.GB2301@obroa-skai.de.gnumonks.org>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ML-netfilter <netfilter@lists.netfilter.org>,
   ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
   <webmaster@netfilter.org>, Don Cohen <don-nfil@isis.cs3-inc.com>,
   William Stearns <wstearns@pobox.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
   Fabrice Marie <fabrice@netfilter.org>
In-Reply-To: <20031113090530.GB2301@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good evening, Harald, Fabrice,

On Thu, 13 Nov 2003, Harald Welte wrote:

> On Wed, Nov 12, 2003 at 11:37:39PM -0500, William Stearns wrote:
> > 	I had some initial difficulty understanding the u32 kernel module.
> > I thought I'd write up a combination tutorial and set of examples for
> > people hoping to give the module a try.
> > 	The article can be found at
> > http://www.stearns.org/doc/iptables-u32.current.html .  I'll gladly accept
> > corrections, suggestions, and submissions of additional examples of tests
> > that can be performed with u32.
> > 	Don has had a chance to review the article and has indicated that
> > he's OK with having a pointer to this article in patch-o-matic.  Is that
> > OK with the core team, and if so, what's the easiest way to add a link to
> > it?  Could this also be added to the documentation "tutorials" section?
> 
> sure, I'd be happy to add it to the homepage and patch-o-matic.
> However, I'd actually prefer if it could be added to the
> netfilter-extensions HOWTO.  This would give people a chance to learn
> about all the different targets/matches at a single location.
> 
> Bill, in case you don't know the extensions HOWTO:
> http://www.netfilter.org/documentation/HOWTO//netfilter-extensions-HOWTO.html

	Excellent!

> Would you be willing to merge your u32 documentation with that?

	Harald, I'd be honored to!
	With the help of http://www.stearns.org/html2sgml :-), I've got 
that article in sgml form, ready to go.  Fabrice, I've patched against 
your 1.30 Netfilter-extensions-HOWTO.  Here are the files of interest:

http://www.stearns.org/patches/netfilter-extensions-HOWTO.1.31.sgml

	The howto with my text merged in.

http://www.stearns.org/patches/netfilter-extensions-HOWTO.1.31.html

	The above .sgml, converted to a single file html to see how it 
looks.

http://www.stearns.org/patches/netfilter-extensions-HOWTO.1.30-1.31.patch

	The diff against 1.30.

	Please let me know if there are problems or if I should provide it 
in a different form.  Thanks again to everyone for your help.
	Cheers,
	- Bill

---------------------------------------------------------------------------
        "return(ECRAY); /* Program exited before being run */"
        -- Martin Mares <mj@ucw.cz>
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, freedups, p0f,
rsync-backup, ssh-keyinstall, dns-check, more at:   http://www.stearns.org
Linux articles at:                         http://www.opensourcedigest.com
--------------------------------------------------------------------------
