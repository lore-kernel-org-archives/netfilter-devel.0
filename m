From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/4][CONNTRACK] Introduce flag facilities to take over
 TCP connections
Date: Fri, 10 Nov 2006 21:49:13 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611102122130.26087@blackhole.kfki.hu>
References: <4553D2F2.1020107@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4553D2F2.1020107@netfilter.org>
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

Hi Pablo,

On Fri, 10 Nov 2006, Pablo Neira Ayuso wrote:

> This patch introduces two new flags called IPS_PICKUP that forces the
> protocol handler to pick up the window of valid TCP packets and
> IPS_IN_WINDOW to by pass window checkings.

Who can set and by what these flags? 

I suppose IPS_IN_WINDOW could be set by the conntrack tool. But what 
about IPS_PICKUP - is it planned to set by conntrackd when switching from 
slave to master?
 
> Moreover, four new attributes to inject the window scale factor and
> enable SACK are introduced. These new facilities provide the appropiate
> mechanisms to take over TCP connections in failover settings with TCP
> tracking enabled.

Great!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
