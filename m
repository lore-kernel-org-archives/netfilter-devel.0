From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: H.323 progress.
Date: Wed, 19 May 2004 10:57:33 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405191053140.2202-100000@blackhole.kfki.hu>
References: <40AA6C1D.2000105@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Richard Scobie <richard@sauce.co.nz>
In-Reply-To: <40AA6C1D.2000105@sauce.co.nz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 19 May 2004, Richard Scobie wrote:

> Thank you very much for your reply. I have spent some time experimenting
> with gnuGK as a proxy in the following test setup:
>
> Tandberg(192.168.3.0/24)->IptablesNAT-VPN(10.0.0.0/24)->IptablesNAT-VPN->
>
> ----->Tandberg(192.168.4.0/24)
> |---->gnuGK in H.323 proxy mode (192.168.4.0/24)
>
> Again, this does not complete all connections.

Yes, you'd need a gnuGK at 192.168.3.0/24 too and let the gatekeepers
communicate. Think of it as building proxy firewalls. You need the given
functionality at both sides.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
