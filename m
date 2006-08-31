From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_LOG and friends. Question
Date: Thu, 31 Aug 2006 04:16:15 +0200
Message-ID: <44F6466F.2090002@trash.net>
References: <20060824140320.GJ31235@kriss.csbnet.se>
	<20060824151923.GK31235@kriss.csbnet.se>
	<44EDD07D.1020805@trash.net>
	<20060827150456.GA9190@kriss.csbnet.se>
	<44F2CC09.4060109@trash.net>
	<20060828120334.GA8994@kriss.csbnet.se>
	<44F2ED29.8020204@trash.net>
	<20060830185211.GB8994@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060830185211.GB8994@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> I fixed this using some smartness. If the log prefix doesn't end in an space
> and isn't empty, i'll add the space. This should break a minimum of scripts
> as the only this will result in is an easier space to parse between prefix
> and IN=iface. Should have been there before in prefix if the log was parsed
> with scripts.


That sounds like a good idea, but people might just as well expect not
to see any spaces. The LOG target has behaved this way for many years
now, and this minor annoyance is not worth breaking things. I consider
changing the default output format as not possible. Adding an option
for this doesn't make much sense either.

> Next big problem: ip6tables doesn't have revisions. So xt_LOG in userspace
> has problems in libip6t_LOG.c. When i try to just ignore this and register
> revision 1 (ipv6) as the one and only revision i get the following error
> when using ip6tables: 
> "ip6tables: Protocol wrong type for socket."
> What have i missed?
> Greping after the error in iptables userspace code gives me nothing. I guess
> this is a libc error. Where should i look?
> 
> (I atucally created the file libip46t_LOG.c that both libipt_LOG.c (ipv4)
> and libipt6t_LOG.c (ipv6) #includes after defining either LIBIPT_LOG_IPV4 or
> LIBIP6T_LOG_IPV6. Since the userspace code is the very same except for some
> structs in the functions headers. This might be a somewhat ugly solution,
> but atleast better to have two files with more or less the same code.)
> 
> Anyway, what is the best solution here. Adding revision-control for
> ip6tables? Add x_tables for userspace? Huge work. Atleast for me. Were can I
> cut some corners? Is it a big deal not keeping backward compability in
> ip6tables (since we don't have revisions)?


Same here, userspace needs to be kept compatible. ip6tables doesn't have
revision support currently, so the only way would be to add it. I know
Harald had some unfinished work for adding x_tables support (probably
including revision support for ip6tables) for userspace. I've CCed him,
maybe you can pick up on his work.

He's quite busy these days though, so it might take some time. If you
want to split of the printk logbuffer patch I would already submit it
for 2.6.18, its a good idea for netconsole independant of any xtables
unification.
