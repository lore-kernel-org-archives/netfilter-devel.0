From: "David S. Miller" <davem@davemloft.net>
Subject: Fw: Re: 2.6.11-rc2 TCP ignores PMTU ICMP (Re: Linux 2.6.11-rc2)
Date: Thu, 27 Jan 2005 15:41:18 -0800
Message-ID: <20050127154118.45e59991.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


Hey guys, please try to take a look at this one.

There are multiple confirmations that merely having ipt_MASQUERADE
loaded or built into the kernel causes PMTU ICMP messages to be
ignored in the current kernel.

I suspect this is more fallout from Rusty's recent conntrack/nat
stuff.  Maybe it'll result in some more nfsim testcases being
added, so perhaps not such a bad thing afterall :-)

Begin forwarded message:

Date: Thu, 27 Jan 2005 15:11:57 -0800
From: David Brownell <david-b@pacbell.net>
To: Janos Farkas <jf-ml-k1-1087813225@lk8rp.mail.xeon.eu.org>
Cc: David Ford <david+challenge-response@blue-labs.org>, linux-kernel@vger.kernel.org, netdev@oss.sgi.com, Art Haas <ahaas@airmail.net>
Subject: Re: 2.6.11-rc2 TCP ignores PMTU ICMP (Re: Linux 2.6.11-rc2)


I just got an interesting "I see these problems too" report.  It
may provide a useful clue.  According to "Art Haas" <ahaas@airmail.net>:

> I'm running the current BK kernel now, and I'm not seeing the problems
> right now because, I found, I do not have some of the IP masquerading
> modules installed on my machine. When these modules get installed then
> the cvs/rsync problems appear. 
 
I do have CONFIG_IP_NF_TARGET_MASQUERADE=y on the system where I'm
seeing this, though it's not doing anything just now.  Haven't yet
made time to see if disabling it improves things ... but if that's
a factor, it could explain why more people aren't suffering with
this problem.

- Dave
