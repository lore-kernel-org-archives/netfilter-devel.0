From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RE: Memory leaks in ip_conntrack?
Date: Wed, 12 Nov 2003 00:34:54 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0311120028560.26051-100000@blackhole.kfki.hu>
References: <EFBADA8C200C2B418DA39734FD15475B0B205F@skat.sky.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter@lists.netfilter.org>,
	"'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kishore Dharmavaram <kishored@servgate.com>
In-Reply-To: <EFBADA8C200C2B418DA39734FD15475B0B205F@skat.sky.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 11 Nov 2003, Kishore Dharmavaram wrote:

> I verified & I find my 2.4.20 is already patched with UNCONFIRMED
> connections fix: http://www.netfilter.org/security/2003-08-01-listadd.html
>
> > Did you apply any patches from patch-o-matic? If yes, which one?

There are other patches in p-o-m. Didn't you apply anything else?
Say the nfnetlink/ctnetlink patch? It is known that there was a buggy
version of that which screwed up the internal conntrack counter.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
