From: James MacLean <macleajb@ednet.ns.ca>
Subject: String match then SNAT from find
Date: Fri, 12 Mar 2004 22:43:08 -0400 (AST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403122223210.16818-100000@Trademart-1.ednet.ns.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Folks,

Have not done any _real_ programming for some time, but thought this might
be dooable...

Goal is to have Squid send out requests with a source of the originating 
client address (SNAT) and then DNAT them as they return through this PC 
acting as a router. I realize there are some other options like tproxy, 
but I saw nothing available for the 2.6 kernel that is current.

Method was to use Squid to add the X-Forwarded-For: <ip> header, then in 
POSTROUTING, use it to set the SNAT address. Would this even work?

Sounded almost easy enough for even me to try and implement :). Went
looking for an overview of how to make a new filter from a programmers
point of view, but have not found it.

So I started to take ipt_NETMAP.c and string.c to see if I could blend the 
two. Now I can not figure out how to take a match() function and return a 
target() result, or if that's even the way I should be thinking.

Is there a sample filter that changes the destination IP like SNAT, but 
does it because of a match it made?

Or maybe there is already a filter that does this that I passed over in 
POM, or somewhere I missed looking?

Sorry if this appears too simple a query, but I would appreciate any 
pointers to help prod me along ;).

thanks,
JES
-- 
James B. MacLean        macleajb@ednet.ns.ca
Department of Education 
Nova Scotia, Canada
     
