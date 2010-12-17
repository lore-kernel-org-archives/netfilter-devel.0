From: Thomas Graf <tgraf@infradead.org>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 17 Dec 2010 02:25:55 -0500
Message-ID: <20101217072555.GC23297@canuck.infradead.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
 <4D00C6A4.6090305@netfilter.org>
 <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr>
 <4D08C892.3080704@netfilter.org>
 <20101216140537.GA23297@canuck.infradead.org>
 <alpine.LNX.2.01.1012161514360.20048@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1012161514360.20048@obet.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 16, 2010 at 03:22:07PM +0100, Jan Engelhardt wrote:
> On Thursday 2010-12-16 15:05, Thomas Graf wrote:
> >
> > -> FOO_GET (seq=1, NLM_F_REQUEST)
> > <- FOO_DEL (seq=1, NLM_F_MULTI)
> > <- FOO_ADD (seq=1, NLM_F_MULTI)
> > <- NLMSG_DONE (seq=1)
> 
> Oh great, now the confusion is complete. One person says this, another 
> says something else. Best of all, the Netlink RFC leaves it unspecified, 
> so it's all hearsay, beliefs and Perl5-style ("Source acts as normative 
> reference") referencing. I guess we are doomed until the original 
> Netlink3549 authors step up and tell us their intentions.
> 
> As I see it, we need a discussion to specify what is to be done with 
> unspecified parts, with 3549 as an origin.

The RFC was not written prior to the implementation but after it has
been around for a while.

The current netlink code implementation defines the standard. It is the
standard because we have not been breaking it and will never do.

Netlink is very open minded, it does not care if individual protocols
define their own semantics. Most will never make use of the above but
it is perfectly legal to do so.

NLM_F_MULTI && NLMSG_DONE is simply a way to have the receiver
continue recieving and parsing. The flag states "Wait, be patient,
my reply consists of multiple messages" and nothing more.
