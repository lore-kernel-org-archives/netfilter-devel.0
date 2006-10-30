From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [Fwd: Re: Networking messed up, bad checksum, incorrect length]
Date: Mon, 30 Oct 2006 09:10:42 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0610300856560.6150@blackhole.kfki.hu>
References: <454538B3.7020408@newipnet.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carlos Velasco <lkml@newipnet.com>
In-Reply-To: <454538B3.7020408@newipnet.com>
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

On Mon, 30 Oct 2006, Carlos Velasco wrote:

> I'm forwarding a mail from Linux Kernel, as it seems a bug in Netfilter
> in 2.6.18.

The TCP session dies because a NAT device between the communicating 
parties does not adjust the sequence numbers in the SACK fields.

Is there a NATing device, which is not identical with the machine running 
2.6.28, between the client and the server?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
