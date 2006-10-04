From: Alan Ezust <alan.ezust@presinet.com>
Subject: Re: testing installation of conntrack command line tool
Date: Wed, 4 Oct 2006 15:31:16 -0700
Message-ID: <200610041531.17209.alan.ezust@presinet.com>
References: <200610031518.10097.alan.ezust@presinet.com>
	<200610041333.19451.alan.ezust@presinet.com>
	<45242FFC.4010500@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
In-Reply-To: <45242FFC.4010500@netfilter.org>
Content-Disposition: inline
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

On Wednesday 04 October 2006 15:04, Pablo Neira Ayuso wrote:
> Alan Ezust wrote:
> > On Wednesday 04 October 2006 12:48, Pablo Neira Ayuso wrote:
> >> Alan Ezust wrote:
> >>> Hi - i'm trying out the "conntrack" program for my first time.
> >>> It compiles and runs, but when I try to do
> >>>
> >>> conntrack -L conntrack
> >>>
> >>> it shows me nothing.
> >>>
> >>> If I cat /proc/net/ip_conntrack I can see lots of log lines there.
> >>> Should the conntrack -L conntrack show me pretty much the same thing?
> >>>
> >>> What's the best way to test that conntrack is working properly?
> >>
> >> Please check that ip_conntrack_netlink is loaded, old kernel do not load
> >> it on demand.
> >
> > I'm using kernel 2.6.16.29.
> >
> > These kernel options are set:
> >
> > CONFIG_NETFILTER_NETLINK=y
> > CONFIG_NETFILTER_NETLINK_QUEUE=y
> > CONFIG_NETFILTER_NETLINK_LOG=y
> > CONFIG_IP_NF_CONNTRACK_NETLINK=y
> >
> > Are you saying I should also add a
> > CONFIG_IP_CONNTRACK_NETLINK flag in the .config  or something else?
>
> No, people usually compile ip_conntrack_netlink as module, and I wanted
> to make sure that the module was loaded (modprobe ip_conntrack_netlink)
> but since you compiled it built-in.

What's the difference between IP_NF_CONNTRACK_NETLINK and 
IP_CONNTRACK_NETLINK? Are they different modules or is one the new name for 
the other?

> Could you tell me what version of conntrack/libnetfilter_conntrac are
> you using?

conntrack 1.00beta2
libnetfilter_conntrack-0.0.31/
libnfnetlink-0.0.16/
