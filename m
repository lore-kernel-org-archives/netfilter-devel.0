From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Feature suggestion: internal logdrop table
Date: Wed, 17 Dec 2003 20:45:25 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312172036520.18802-100000@filer.marasystems.com>
References: <3FE0706A.9000308@pp3.inet.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Markus Saarinen <markus.saarinen@pp3.inet.fi>
In-Reply-To: <3FE0706A.9000308@pp3.inet.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Dec 2003, Markus Saarinen wrote:

> Would it be possible to have a 'logdrop' target coded into iptables?

Jost copy LOG and make a terminal version of LOG, or extend the LOG target 
with options to indicate that the rule is terminal.

But I guess that the reason why this is not done is because "terminal" log 
is just as often used with other actions such as ACCEPT/REJECT making the 
number of combinations very large.

What have been discussed before is making a log match instead of a target. 
This would allow log to be used within any other rule in a clean manner. 
But unfortunately this discussion got sidetracked on other issues and 
apparently no such match was made.

This would make the example rules look like:

  -A INPUT -s subnet1 -d somewhere -m log --log-prefix "fromsubnet1" -J DROP
  -A INPUT -s subnet2 -d somewhere -m log --log-prefix "fromsubnet2" -J DROP

> From a bit of Googling, i've seen that quite many people actually
> create these log-drop chains by hand (myself included).

Yes, this is the common solution to the problem. However when using 
--log-prefix is creates very many chains (one per --log-prefix).

> so think it would actually be a quite useful feature. Not to mention the few
> clockticks my firewall would save when it could just drop the packet
> from the same rule without traversing back to the original chain and
> parsing a new rule ;-)

For now use custom chains making the target of the packet. This saves you
from duplicating all the matches. So your main chains matches the packet
to your rules, and target chains decides on what should be done with the 
packet including log/nolog etc.. The CPU difference is not large between 
using custom chains and using a combined rule like discussed above, the 
main difference is in how easy the ruleset is to maintain.

Regards
Henrik
