From: "Timothy Webster" <timothyw@outblaze.com>
Subject: over a 1,000,000,000 individual ips to block
Date: Thu, 24 Jun 2004 22:57:32 +0800
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <20040624145732.25300.qmail@team.outblaze.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-admin@lists.netfilter.org>
Content-Disposition: inline
To: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

I have a need to block 1 -> 2 million ips. 
This edge firewall will be blocking dos attackers, spammers
from hitting our proxys, and mail/web servers.
I also need to be able to reload the 1 -> 2 million blocked 
ips from time to time as they change. 
But this list is not changing continuously.

Thoughts how to do this?
What would you recommend for a hardware?
The iptables set patch, what else?


I need to come of with a plan so I can begin testing for
deployment.

Thanks,

-Tim
