From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Answers to broadcast ICMP pings
Date: Wed, 11 May 2005 09:35:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505110933130.31440@blackhole.kfki.hu>
References: <1115781511.6028.17.camel@anduril.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pascal.news@plouf.fr.eu.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
In-Reply-To: <1115781511.6028.17.camel@anduril.intranet.cartel-securite.net>
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

On Wed, 11 May 2005, Cedric Blancher wrote:

> Is there a particular reason for which answers to broadcast ICMP pings
> to local network are flaged as INVALID, as pointed out Pascal (Cced) ?

Yes.

> If I do :
>
> 	ping 192.168.1.255
>
> Where 192.168.1.0/24 is my local network, then answers sent by this
> network to me are flaged INVALID, as they don't match according entry in
> conntrack table :
>
> 	icmp     1 29 src=192.168.1.2 dst=192.168.1.255 type=8 code=0
> 	id=6448 packets=2 bytes=168 [UNREPLIED] src=192.168.1.255
> 	dst=192.168.1.2 type=0 code=0 id=6448 packets=0 bytes=0 mark=0
> 	use=1

Because the reply packets do not match the entry above while they do
not come from src=192.168.1.255. Multicast/broadcast is not supported by
conntrack.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
