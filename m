From: jamal <hadi@cyberus.ca>
Subject: Re: [Linux Diffserv] ANNOUNCE: tc filter extensions
Date: Sat, 4 Jan 2003 13:37:44 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030104133257.I48869__8403.42630767754$1041973791@shell.cyberus.ca>
References: <20030104125252.J48869@shell.cyberus.ca> <3E172729.2070707@promo.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: diffserv-general <diffserv-general@lists.sourceforge.net>,
	"" <lartc@mailman.ds9a.nl>, "" <netfilter@lists.samba.org>,
	"" <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ciprian Niculescu <ciprian@promo.ro>
In-Reply-To: <3E172729.2070707@promo.ro>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Yes, thats is a useful feature.
Should be able to able use the iptables LOG; I am trying to avoid
replicating things which already exist; it is very easy to replicate it.
I'll test iptables LOG sometimes today; if you beat me to it, let me know
if it works.

cheers,
jamal

On Sat, 4 Jan 2003, Ciprian Niculescu wrote:

> hello,
>
> if someone can develop a feature like -j LOG from iptables, for the tc
> filter
>
> for ex i have
>
> tc filter ...... match dport 80 0xffff flowid 1:1
>
> i want to write to syslog the headers of the packets that matched this rule.
>
> C
>
> jamal wrote:
> >
> > I guess holidays means idle time which means idle minds which leads to
> > thumb twiddling which then leads to some work (which is sometimes useful)
> >
> > Ive updated the traffic control patches i posted about six months ago.
> > Note, the current release does not break anything in tc. It is fully
> > backward compatible so you can choose not to use it and things will work
> > as they do today. Of course, it is very useful so you cant choose to
> > ignore it!
> >
> > It's now upgraded to better than "use at your own risk" category.
> > tested on both uni and SMP 2.4.18 and 2.4.20.
> >
> > http://www.cyberus.ca/~hadi/patches/action/
> >
> > Bug reports and feedback are appreaciated.
> > A lot more goodies coming up, so this is just the tip. First steps are to
> > prove sanity of the idea.
> >
> > cheers,
> > jamal
> >
> >
> > -------------------------------------------------------
> > This sf.net email is sponsored by:ThinkGeek
> > Welcome to geek heaven.
> > http://thinkgeek.com/sf
> > _______________________________________________
> > Diffserv-general mailing list
> > Diffserv-general@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/diffserv-general
>
>
>
>
> -------------------------------------------------------
> This sf.net email is sponsored by:ThinkGeek
> Welcome to geek heaven.
> http://thinkgeek.com/sf
> _______________________________________________
> Diffserv-general mailing list
> Diffserv-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/diffserv-general
>
