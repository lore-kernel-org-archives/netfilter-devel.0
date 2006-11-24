From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_nat tree updated
Date: Fri, 24 Nov 2006 23:27:34 +0900 (JST)
Message-ID: <200611241427.kAOERags021181@toshiba.co.jp>
References: <Pine.LNX.4.64.0611240036380.21966@blackhole.kfki.hu>
	<45669021.8060109@trash.net> <4566AA49.5020706@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4566AA49.5020706@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 24 Nov 2006 09:16:09 +0100

> Patrick McHardy wrote:
> > Jozsef Kadlecsik wrote:
> > 
> >>>- /proc-compatibility: since the plan is to get rid of the
> >>> old IPv4-only connection tracking ASAP, we need to think
> >>> of something to keep old scripts fiddling with /proc-files
> >>> working. So we probably need to do some symlinking (is that
> >>> possible?) of the old net/ipv4/netfilter files or just keep
> >>> the around as normal files. 
> >>
> >>
> >>As I see symlinking is not possible, so we have to keep the old files.
> >>
> >>
> >>> And we need a /proc/net/ip_conntrack that only shows IPv4 entries I 
> >>> suppose.
> >>
> >>
> >>Yes! Missing /proc/net/ip_conntrack could break a lot of scripts.
> > 
> > 
> > I'll take care of the proc files.
> 
> This is a first attempt - its quite ugly because of all the
> new exports it needs. But even worse - what should we do about
> proc entries added by modules, like the SCTP protocol module?
> Should we just put this in nf_conntrack_standalone or in case
> of SCTP in the module itself?

I like later one from the point of view of modularity. BTW, in the first
place, why sysctl entries for tcp/udp/icmp are registered by
nf_conntrack_standalone, not each module ?

-- Yasuyuki Kozakai
