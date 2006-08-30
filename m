From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: ipt_LOG and friends. Question
Date: Wed, 30 Aug 2006 20:52:11 +0200
Message-ID: <20060830185211.GB8994@kriss.csbnet.se>
References: <20060824140320.GJ31235@kriss.csbnet.se>
	<20060824151923.GK31235@kriss.csbnet.se>
	<44EDD07D.1020805@trash.net>
	<20060827150456.GA9190@kriss.csbnet.se>
	<44F2CC09.4060109@trash.net>
	<20060828120334.GA8994@kriss.csbnet.se>
	<44F2ED29.8020204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44F2ED29.8020204@trash.net>
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

> >>>3. The prefix is missing a space between the prefix and IN=interface. Very
> >>>annoying to always have to use -j LOG --log-prefix "one two three ". Notice
> >>>the last space. Will this break anything if i just add a space in between of
> >>>"%sIN=%s OUT..." for the prefix?
> >>
> >>Yes, people already add the extra space and it would at least change
> >>how log files look, potentially even break parsers.
> >>
> > 
> > Hm, hard one. I guess it's not enough to only change this to revision 1 as
> > the parameter is the same and so on. And the code i wrote doesn't make any
> > difference between revision 0 and 1 during the packet dumping functions.
> > They are the same.
> > 
> > I guess the only way to solve this is to add a new flag in revision 1
> > (beside keeping old --log-prefix with the missing space. --log-text-prefix,
> > --log-text-sulfix ? I'll think of something.
> 
> That doesn't look to useful .. if I have to say --trailing-prefix-space
> I can just as well just specify it in the prefix itself.
> 

I fixed this using some smartness. If the log prefix doesn't end in an space
and isn't empty, i'll add the space. This should break a minimum of scripts
as the only this will result in is an easier space to parse between prefix
and IN=iface. Should have been there before in prefix if the log was parsed
with scripts.


Next big problem: ip6tables doesn't have revisions. So xt_LOG in userspace
has problems in libip6t_LOG.c. When i try to just ignore this and register
revision 1 (ipv6) as the one and only revision i get the following error
when using ip6tables: 
"ip6tables: Protocol wrong type for socket."
What have i missed?
Greping after the error in iptables userspace code gives me nothing. I guess
this is a libc error. Where should i look?

(I atucally created the file libip46t_LOG.c that both libipt_LOG.c (ipv4)
and libipt6t_LOG.c (ipv6) #includes after defining either LIBIPT_LOG_IPV4 or
LIBIP6T_LOG_IPV6. Since the userspace code is the very same except for some
structs in the functions headers. This might be a somewhat ugly solution,
but atleast better to have two files with more or less the same code.)

Anyway, what is the best solution here. Adding revision-control for
ip6tables? Add x_tables for userspace? Huge work. Atleast for me. Were can I
cut some corners? Is it a big deal not keeping backward compability in
ip6tables (since we don't have revisions)?

--
Joakim Axelsson
