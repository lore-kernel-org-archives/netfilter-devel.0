From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Counter problem in a new nat target.
Date: Tue, 9 Dec 2003 11:15:04 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312091107570.24092-100000@filer.marasystems.com>
References: <3FD59D74.6050005@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <3FD59D74.6050005@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 9 Dec 2003, Emmanuel Guiton wrote:

> My problem is that I do not see which data can be accessed by any of the 
> function involved. To be precise, I need to increment a counter each 
> time I get one new conntrack. Then I decrement it each time a conntrack 
> is destroyed or set as assured (tcp connection).

Then the problem is a lot more complex.

Increasing is not a big problem, but the decreasing are as it is hard to 
find which counter to decrease from the conntrack and there is no good 
place to store such information for later without extending the 
ip_conntrack structure unless you implement this as a conntrack 
application protocol helper (can be done if no other conntrack helper is 
needed in the relevant traffic).

Do you really need to decrease the counters?

> Is the destroy function called when a conntrack is destroyed? 

The target destroy function is called when the target as such in the 
iptable is destroyed. It is not related to connection tracking.

> The hacking howto also states that the checkentry can be used to 
> dynalically allocate resources and they can be freed in the destroy 
> function. But here the same issue occurs: I do not see which common data 
> I can access from bothe the checkentry and destroy function.

Both target functions operates on the iptable, not the traffic.

When you define your target/match you define what data the target/match
uses, and you are free to use this data as you please. This data MAY
include space for counters etc but due to SMP issues it is better to have
the counters separate as each CPU operates on his own iptable copy.

Regards
Henrik
