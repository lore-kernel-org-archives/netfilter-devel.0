From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [netfilter-core] Re: [ANNOUNCE] Release of iptables-1.2.9
Date: Fri, 7 Nov 2003 19:09:38 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311071901580.12681-100000@filer.marasystems.com>
References: <20031107135520.GM5741@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <coreteam@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031107135520.GM5741@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 7 Nov 2003, Harald Welte wrote:

> > I was wondering why this file was nearly 50kB bigger than rc1. In fact, the
> > archive contains some old files, totalizing about 160 kB :
> > 
> >   extensions/.#libipt_ECN.c.1.7
> >   extensions/.#libipt_recent.c.1.6
> >   .#iptables.c.1.54
> >   .#iptables.c.1.55
> >   libiptc2/.libiptc.c.1.40
> 
> oh, I wonder how they get there... .# looks like emacs, but I never use
> emacs...

These are CVS backup files, generated when cvs update patches modified
files in your working directory or when you use the -j flag for 
replaying/undoing committed edits (such as when moving changes between 
branches)

> thanks for pointing this out, I'll try to avoid that for the next
> release.

It is always a good idea to use "cvs export" when making releases. This 
makes sure there is no crap left over in the directory, and also 
automatically gets rid of those CVS directories..

The procedure we use for Squid is something like this once the release is 
decided by the core team:

1. cvs -Q update to make sure there is nothing forgotten in the working 
directory. If this says anything at all, correct the issue before 
continuing unless it is obvious the message can be ignored.

2. cvs tag to mark the release in CVS

3. cvs export to make the release

4. build the release tarballs from the cvs export directory

Regards
Henrik
