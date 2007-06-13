From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: would it be hard to add /32 pseudo-nets to nethash?
Date: Wed, 13 Jun 2007 22:48:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706132244180.7458@blackhole.kfki.hu>
References: <1181765976.3720.14.camel@murdegern.cbxnet.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1181765976.3720.14.camel@murdegern.cbxnet.de>
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

On Wed, 13 Jun 2007, Torsten Luettgert wrote:

> I'm using ipset in some script-generated setup of mine. It's really 
> cool. Now, I found that the "nethash" type really expects networks, i.e. 
> /31 up to /1 networks. I'd love to have support for single addresses 
> (/32 "networks") in there, too.

That won't go: in "nethash" type of sets the network address (32 bit 
itself) plus the netmask size encoded in 32 bits, which naturally clashes 
with pure IP addresses. In order to store just IP addresses, use "iphash" 
type of sets.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
