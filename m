From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack DoS
Date: Tue, 25 Jun 2002 22:53:15 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206252253.15622.hno@marasystems.com>
References: <Pine.LNX.4.33.0206251119260.4927-100000@blackhole.kfki.hu> <01ff01c21c45$c90eb2a0$0489cb8a@etbx180> <20020625190125.GJ7975@naboo.ols.wavesec.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
In-Reply-To: <20020625190125.GJ7975@naboo.ols.wavesec.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

> if conntrack  doesn't see a FIN or RST packet, it won't be forwarded by
> the machine and thus never arrive at the receiver.  The sender will thus
> retransmit, and hope the packet makes it next time.

FIN will be retransmitted a couple of times, but RST won't. RST will only be 
retransmitted indirectly if data arrives from the other end.

This brings me back to the important cases where TCP closes down without 
conntrack noticing. Have tried to bring this up a couple of times before but 
I do not recall seeing much of a response..

There exists at least two real-life cenarios where conntrack won't notice that 
a TCP connection is gone:

If the RST is lost on a aborted connection where the other endpoint has 
disappeared.

when the TCP is dropped due to retransmission timeouts after one of the 
endpoints have disappeared.

The two cases above is only slight variations of the same scenario. A TCP is 
established, then one of the endpoints disappears from the network preventing 
the connection to be shut down in a normal manner.

The first very uncommon and probably not easily exploitable.

The second case is a real problem and can quite easily be used to DoS 
conntrack with a relatively small amount of packets. (total ~20 minimum size 
TCP packets per wasted conntrack entry)

The good news is that second case can be detected by detecting a long term 
uni-directional packet flow, and we probably do not need to care about the 
first..



A simple test case illustrating the second case:

Have three machines

A <-> conntrack server <-> B

On A, set up the following two simple rules to simulate connection dropout
-A OUPUT -p tcp --tcp-flags RST RST -j DROP
-A OUPUT -p tcp --tcp-flags FIN FIN -j DROP

On B, enable the chargen TCP service to have a simple TCP data source, and for 
the sake of accelerating the test, conserver resources of B and more 
obviously illustrate the point lower tcp_retries2 to something like 5.

Then run the following silly test program on A

while true; do telnet B chargen </dev/null >/dev/null; done


Note: This is only a superficial twist of the traditional TCP connection flood 
DoS. The attacker finishes the SYN handshake and then ignores the connection. 
Can be launched on conntrack via any TCP service that returns data, causing a 
TCP data queue on the connection preventing a FIN to be sent when the server 
aborts the connection.


> yes, they should.  They are TCP connections.  We shouldn't impose
> any application-protocol specific layer4 timeouts, that sounds horrible.
>
> the port versus application protocol (i.e. 80 == http) are by
> convention, not by protocol design.

I agree.

Should also note that there exists fully valid HTTP applications utilizing 
very long idle periods on a HTTP connection. How long the HTTP connection is 
kept open is a business between the user-agent and the server only, nobody 
else. The fact that most HTTP connections are short lived does not say that 
all are and that it is OK to drop idle HTTP connections.

Regards
Henrik
