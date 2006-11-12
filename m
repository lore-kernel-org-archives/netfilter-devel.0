From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4][CONNTRACK] Introduce flag facilities to take over
 TCP connections
Date: Sun, 12 Nov 2006 20:03:59 +0100
Message-ID: <4557701F.4020904@netfilter.org>
References: <4553D2F2.1020107@netfilter.org>
	<Pine.LNX.4.64.0611102122130.26087@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0611102122130.26087@blackhole.kfki.hu>
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

Hi Jozsef,

Jozsef Kadlecsik wrote:
> On Fri, 10 Nov 2006, Pablo Neira Ayuso wrote:
> 
>> This patch introduces two new flags called IPS_PICKUP that forces the
>> protocol handler to pick up the window of valid TCP packets and
>> IPS_IN_WINDOW to by pass window checkings.
> 
> Who can set and by what these flags? 
> 
> I suppose IPS_IN_WINDOW could be set by the conntrack tool. But what 
> about IPS_PICKUP - is it planned to set by conntrackd when switching from 
> slave to master?

Indeed, conntrackd requires tcp window tracking disabled at the moment
and I want to get rid of this limitation. The idea is to inject as much
TCP connection state information in the conntrack as possible and force
a pickup for the sequence tracking since I think that it is not feasible
to replicate every window state change because of performance issues:
generation of tons of messages, therefore the idea is to introduce a
tradeoff between security and availability.

About IPS_IN_WINDOW, it could be used by the conntrack tool/iptables
target to workaround possible problems related to broken boxes. We've
been discussed lately in netfilter-failover about session sharing
scenarios like the one described here where the connection can bounce
between nodes in an unpredictible manner:

http://lists.netfilter.org/pipermail/netfilter-failover/2006-October/000648.html

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
