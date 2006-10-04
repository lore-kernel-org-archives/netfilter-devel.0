From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: testing installation of conntrack command line tool
Date: Wed, 04 Oct 2006 21:48:11 +0200
Message-ID: <45240FFB.4070606@netfilter.org>
References: <200610031518.10097.alan.ezust@presinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alan Ezust <alan.ezust@presinet.com>
In-Reply-To: <200610031518.10097.alan.ezust@presinet.com>
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

Alan Ezust wrote:
> Hi - i'm trying out the "conntrack" program for my first time. 
> It compiles and runs, but when I try to do
> 
> conntrack -L conntrack
> 
> it shows me nothing.
> 
> If I cat /proc/net/ip_conntrack I can see lots of log lines there. Should the 
> conntrack -L conntrack show me pretty much the same thing?
> 
> What's the best way to test that conntrack is working properly?

Please check that ip_conntrack_netlink is loaded, old kernel do not load
it on demand.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
