From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: dDoS attacks
Date: Mon, 27 Jan 2003 16:28:59 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15925.52939.339426.673375@isis.cs3-inc.com>
References: <20030127232648.31312.21611.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, <curious@pb194.luban.sdi.tpnet.pl>
In-Reply-To: <20030127232648.31312.21611.Mailman@kashyyyk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 > i am not very skilled in using iptables, but as far i know it is
   not possible to write following rule...
To paraphrase, I think the idea is that when the router sees a packet
from A to B complaining about traffic then it drops the next n packets
from B to A.
You may be correct that this cannot be done by iptables, but it's not
a very good solution.  For one thing, what makes you think that
packets with source address A were actually sent from A?
Your defense could be used to prevent you from communicating with the
address of the attacker's choice (unless something prevents him from
source spoofing).

Something closer to a solution is to use connection tracking and 
rate limit (now we're getting away from nefilter into lartc territory)
packets in connections that have not been replied to.
There's still the problem that if you run a public server, an 
attacker can prevent other legitimate customers from reaching you.
And all of this doesn't address the problem of packet loss due to 
link saturation.

For (much) more info on this subject see http://cs3-inc.com/ddos.html
