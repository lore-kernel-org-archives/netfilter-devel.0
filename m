From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ip_conntrack_tcp_be_liberal vs. large downloads?
Date: Tue, 20 Sep 2005 11:38:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0509201127490.745@blackhole.kfki.hu>
References: <20050920080825.GA6536@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matthias Andree <matthias.andree@gmx.de>
In-Reply-To: <20050920080825.GA6536@merlin.emma.line.org>
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

Hi Matthias,

On Tue, 20 Sep 2005, Matthias Andree wrote:

> I'm using a netfilter configuration that makes extensive use of
> connection tracking, on Linux 2.6.8 and Linux 2.6.11.4 (SUSE Linux 9.2
> and 9.3 kernels). Part of this configuration is to allow
> ESTABLISHED+RELATED, drop INVALID and so on - pretty standard stuff as
> found on various sites (I can dump the configuration if really needed).
>
> My observation is that larger downloads (30 MB to 150 MB) stall after
> some point, which may be sooner or later. I seldom get the download
> beyond 15 or 20 MB, at transfer rates between 80 and 300 kB/s.  tcpdump
> shows that the server (HTTP) still sends a few packages which the kernel
> doesn't ACK any more.
[...]
> I can also test newer kernels if needed - only if there'd been some bug,
> I might have assumed that SUSE rolled a patch into one of their update
> kernels.

Please try newer kernels - I smell SACKing lost packets and ACKing out of
window segments here, which is fixed (i.e. supported) in recent kernels.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
