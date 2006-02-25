From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 06/6]: Restore {ipt,ip6t,ebt}_LOG compatibility
Date: Sat, 25 Feb 2006 19:48:09 +0100
Message-ID: <4400A669.2020000@trash.net>
References: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
	<20060225131707.7400.26631.sendpatchset@localhost.localdomain>
	<440065FD.5020206@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gregor Maier <gregor@net.in.tum.de>
In-Reply-To: <440065FD.5020206@net.in.tum.de>
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

Gregor Maier wrote:
> Patrick McHardy wrote:
> 
>>>Restore compatiblity by using the old log functions by default and only use
>>>the nf_log backend if the user explicitly said so.
>>>
> 
> 
> ipt_LOG still registers itfself as nf_log logger in init(). Good, so
> since conntrack can now log.
> 
> Problem: no anthoer loggers can register for PF_INET right away. They
> must unregister the ipt_LOG logger first. Then they can register
> themselves. I don't like the idea of modules and esp. userspace apps
> unregistering handlers from other modules. First Come First Serve.

Exactly, this is how it works now, if we forget about the UNBIND
operation of nf_log (which I'm not a fan of either). Ideally the
log backends should be stackable.

> When ipt_LOG doesn't register a nf_log logger, then the problem would
> not arise, although the conntrack code could not log anything until some
> other logger has been registered (since conntrack uses nf_log_packet).
> 
> 
> 
> Maybe nf_log should have two handlers for each PF:
> - One handler for loginfo.type == NF_LOG_TYPE_LOG. Which can be provided
> by ipt_LOG.
> - One handler for loginfo.type == NF_LOG_TYPE_ULOG, for which
> nfnetlink_log strongly qualifies.
> 
> 
> So, as long as ipt_LOG is loaded, conntrack et.al. can log to syslog as is.
> 
> If netlink_log is used additionally, (as handler for TYPE_ULOG),
> conntrack et.al. won't notice it.
> 
> If _everything_ should be logged to userspace, then netlink_log could
> also unregister the TYPE_LOG handler and register itself as handler for it.

I think stackable log backends are the cleanest solution for this.
