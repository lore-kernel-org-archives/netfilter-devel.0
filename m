From: "Andriy T. Yanko" <wireless@wireless.org.ua>
Subject: Basic principle of enqueunig/dequeuning packets & control traffic
 flows
Date: Thu, 19 Jun 2003 12:46:20 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030619124620.7221df55.wireless@wireless.org.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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


Hi people!

Maybe this  message is offtopic but... I have no good ideas how to solve my problem.

I am writing program that must realtime control traffic flows (  control/account/bandwitdth/etc   ip traffic ).
I am using  2.4.x Netfilter queue kernel  module (ip_queue)  so  program can  get packets via libipq.
In this case I can easy control traffic (set  verdict  NF_ACCEPT or NF_DROP) and statistics traffic (via counters).
But how to shape traffic flow?
I  wrote very simple wrapper  library (just based on iproute2 sources ) for  tc command so pogram may set
qdisc, classes and filters on some device where I what  control outbox traffic.
But this is not  convenient way.

How to build own queue(s) for specific traffic flows that going via my program and setup on them some shaping 
discipline like TBF - just for shape traffic, set certain rate?

What is better for system  perfomance when use such shaping and  when using kernel QoS?

Any suggestions, ideas  are welcomed.

THANKS IN ADVANCE.

PS sorry for my poor english.
-- 
Andriy T. Yanko
wireless@wireless.org.ua

*   Avoid The Gates of Hell use Linux
**  Wenn ich sterbe, legt mir eine Birne in mein Grab ...
