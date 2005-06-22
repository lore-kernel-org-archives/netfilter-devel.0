From: Unknown <netfilter-devel@demultiplexer.de>
Subject: auto ip configuration
Date: Wed, 22 Jun 2005 22:53:00 +0200
Message-ID: <1119473580.7825.25.camel@notbock>
Reply-To: netfilter-devel@demultiplexer.de
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: nf-devel <netfilter-devel@lists.netfilter.org>
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

dear list,

you know about people, which have some static ip configuration on their
notebooks. they would like to connect to a smart gateway
without the need to change anything. 

I would ask you whether this is possible to implement such a gateway
using netfilter.

I alredy build a working example with some tools and scripting
but it isn't really performant and it have a lot of "design errors".
Simple speaking it is a farpd running box, where all incoming requests
are logged through the bridging code. The Syslog output is piped
into a script and the requested ip is assigned to the lan interface.
Evil thing ;-)

I would preffer something like inverse SNAT/MASQUERADE.
The difference would be, that:
	it applys to PREROUTING
	it does mapping from a big subnet (maybe 0/0) to a singe address or a
range of addresses.

The farpd would point all clients to the gateway.
Having rp_filter disabled all misconfigured packets incoming on a lan
interface would be translated into a valid ip address.
Then the usual routing would take place.
The response packets would be back-natted into the clients idea of the
gateway address.

Would please someone give me a pointer.
Am I completly wrong with this?

regards
jaroslaw
