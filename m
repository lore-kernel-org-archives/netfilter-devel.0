From: Just another UFO mechanic <oscar@ufomechanic.net>
Subject: Re: building libctnetlink
Date: 24 Mar 2005 12:35:56 +0000
Message-ID: <1111667756.2526.19.camel@lap-ufomechanic>
References: <423BF227.8030502@outerspace.dyndns.org>
	<423BF4DC.2070902@outerspace.dyndns.org>
	<1111335091.2523.46.camel@lap-ufomechanic>
	<1111335425.2523.49.camel@lap-ufomechanic> <423DF940.100@eurodev.net>
	<1111412190.2716.55.camel@lap-ufomechanic>
	<423F007F.2060102@eurodev.net>
Reply-To: oscar@ufomechanic.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <423F007F.2060102@eurodev.net>
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


On Mon, 2005-03-21 at 17:12, Pablo Neira wrote:
> Just another UFO mechanic wrote:
> > Hi 
> >     Thanks but when I run autoconf it creates the configure script then
> > when I run configure it says 
> > 
> > creating libtool
> > configure: creating ./config.status
> > config.status: creating Makefile
> > config.status: error: cannot find input file: Makefile.in
> 
> yes, type automake before.
> 
> --
> Pablo
I am still trying to compile libctnetlink and libnfnetlink I cannot find
a whole lot of info on it. I have 2 questions

When I try compile
I get the error
libctnetlink.c:32:39 linux/nfnetlink_conntrack.h: No such file or
directory

Is there a second lib I am missing ? I have looked around and see only a
reference to old-nfnetlink

Secondly
Because this should be in linux/* this tells me that it may belong to an
older kernel or something that is now deprecated, is that so ? I am
trying to compile on 2.6.10

Thanks
