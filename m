From: Phil Oester <kernel@linuxace.com>
Subject: Re: UNWANTED state
Date: Wed, 29 Dec 2004 15:56:57 -0800
Message-ID: <20041229235657.GA11573@linuxace.com>
References: <200412300042.18561.rootkit85@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matteo Croce <rootkit85@yahoo.it>
Content-Disposition: inline
In-Reply-To: <200412300042.18561.rootkit85@yahoo.it>
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

On Thu, Dec 30, 2004 at 12:42:17AM +0100, Matteo Croce wrote:
> Hi,
> time ago i wanted to stealth may gateway, so i start dropping outgoing 
> icmp-port-unreachable packets, to avoid UDP scans.
> But i had also a '--dport 113 -j REJECT' target to allow faster irc logins,
> that stopped working since those ICMP were rejected by the new rule.
> So i hacked the kernel with a patch i also attach, to prevent those packets 
> being generated.

Perhaps you should consider using:

--dport 113 -j REJECT --reject-with tcp-reset

instead of hacking the kernel to disable icmp rejects?

As far as the rest of your message goes, I suppose it is a matter of personal
preference, but if you have a firewall open to the world for a particular
service, people on the outside will be able to find it if that service is
running.  Why do you care if people get an icmp unreachable when the service
is down?  You aren't making the box more secure IMO by not allowing the
icmp error outbound.

Anyhow...this discussion likely belongs over on the general netfilter list.

Phil
