From: "Cedrix" <netfilter@cedrix.com>
Subject: conntrack: Connection close event?
Date: Wed, 22 Aug 2007 20:01:24 +0200
Message-ID: <004501c7e4e6$74509e80$1700a8c0@xcony13>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

this is my first request. I checked google, nf-faqs and conntrack-homepage 
without sufficient results for this problem:

In Short: I need to know when a connection (TCP or UDP) gets closed. I want 
to use conntrack, because I can track UDP more easily.

My thoughts so far: The /proc/net/ip_conntrack reacts very quick when a 
close happens, but it's not conveniant to check in my C/C++ application. So, 
in further reading I 've seen in the source some kind of "event-handling". 
(Listening Event for new connection, etc.)

My question: What's the best method to see if a connection gets closed. 
(Also, connection opened).

Btw: I use iptables -I FORWARD -m -state --NEW -m --LOG -log-prefix "New 
Connection established: " to log established connections, so it would be 
nice (but not necessary) if I can use the LOG for closing-connections, too - 
OR alternatively - use a conntrack-event for detecting NEW connections, too.

Any help or comment is appreciated! Thanks.


Cedrix.



[--XCN-SF--] 
