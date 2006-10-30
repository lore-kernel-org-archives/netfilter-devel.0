From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [Fwd: Re: Networking messed up, bad checksum, incorrect length]
Date: Mon, 30 Oct 2006 09:29:24 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0610300919270.6150@blackhole.kfki.hu>
References: <454538B3.7020408@newipnet.com>
	<Pine.LNX.4.64.0610300856560.6150@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carlos Velasco <lkml@newipnet.com>
In-Reply-To: <Pine.LNX.4.64.0610300856560.6150@blackhole.kfki.hu>
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

On Mon, 30 Oct 2006, Jozsef Kadlecsik wrote:

> On Mon, 30 Oct 2006, Carlos Velasco wrote:
> 
> > I'm forwarding a mail from Linux Kernel, as it seems a bug in Netfilter
> > in 2.6.18.
> 
> The TCP session dies because a NAT device between the communicating 
> parties does not adjust the sequence numbers in the SACK fields.
> 
> Is there a NATing device, which is not identical with the machine running 
> 2.6.28, between the client and the server?

No, it's not a NATing device. It's a 'smart' box which munges the TCP 
sequence numbers and misses to do so in the SACK fields: the first packet 
from both recordings:

23:29:27.912908 IP (tos 0x0, ttl  64, id 51776, offset 0, flags [DF], 
length: 60) 192.168.128.182.45020 > 193.147.150.12.25: S [tcp sum ok] 
426197099:426197099(0) win 5840 
<mss 1460,sackOK,timestamp 46238251 0,nop,wscale 7>

23:29:28.017284 IP (tos 0x0, ttl  54, id 51776, offset 0, flags [DF], 
length: 60) 84.77.121.105.45020 > 193.147.150.12.25: S [tcp sum ok] 
888737236:888737236(0) win 5840 
<mss 1380,sackOK,timestamp 46238251 0,nop,wscale 7>

It's definitely not a 2.6.18 bug.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
