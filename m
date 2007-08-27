From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: new target: -j TEE
Date: Mon, 27 Aug 2007 16:21:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708271539140.11442@fbirervta.pbzchgretzou.qr>
References: <1188216512.6900.24.camel@basti79.freenet-ag.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Sebastian Classen <sebastian.classen@freenet.ag>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1188216512.6900.24.camel@basti79.freenet-ag.de>
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


On Aug 27 2007 14:08, Sebastian Classen wrote:
>
>The ROUTE targe seems to be finaly gone from pom-ng and we need a
>solution for the --tee function. So I deciced to use some parts from the
>ROUTE target, adaped the code to the current kernel and implmemented a
>new taget called TEE. The only function is packet duplication and those
>duplicate packets are routed the the given gateway (--gw option).
>
>We use this as a replacement for netwrk traffic taps, the syntax is:
>itpables -t mangle -A PREROUTING -p tcp --sport <some-port> -j TEE --gw
><IP.of.mirror.box>
>
>Is there any chance getting this into pom-ng?

Here is an updated version first that uses xt:

	http://dev.computergmbh.de/wsvn/misc_kernel/xt_TEE/

it's not entirely POM-conformant, since, well, if a module is good 
enough to go to POM, it is likely good enough to go into mainline too.


A few questions:

* Is --gw 0.0.0.0 even supported/meaningful? It seems not, so some 
  checks could be removed.
* Your route_gw() function returns something, but you do not really use the
  result. Is this intended?




	Jan
-- 
