From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: pom-ng include question
Date: Fri, 25 Jun 2004 13:07:49 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406251305390.11001-100000@blackhole.kfki.hu>
References: <40DBFE13.6080700@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eicke Friedrich <tady@gmx.net>
In-Reply-To: <40DBFE13.6080700@gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 25 Jun 2004, Eicke Friedrich wrote:

> I've developed an iptables/netfilter extension to detect P2P traffic
> called IPP2P.  It can be used to prohibit P2P traffic (by dropping
> matches) or combined with connection tracking, CONNMARK and a packet
> scheduler for traffic shaping of P2P traffic. I did a lot of testing
> and also got much positive feedback of users. So it can be considered
> as stable. The official homepage is located at:
> http://rnvs.informatik.uni-leipzig.de/ipp2p/index_en.html
>
> So if you believe there could be a benefit of such an extension I'll
> create a patch for pom-ng.

Yes, do it and we'll add the extension to pom-ng.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
