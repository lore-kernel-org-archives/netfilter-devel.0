From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: does ipset conflict with ipsec SuSE kernel patch?
Date: Sun, 9 Jul 2006 17:34:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0607091721160.11722@blackhole.kfki.hu>
References: <8812D8156467224C9E9739E513037EF1F3FD47@moe.nextone.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Hung Lin <hlin@nextone.com>
In-Reply-To: <8812D8156467224C9E9739E513037EF1F3FD47@moe.nextone.local>
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

On Thu, 6 Jul 2006, Hung Lin wrote:

> I tried to install ipsets (http://ipset.netfilter.org/install.html) on
> my SuSE 10.0 OS.  I could apply the kernel patches and rebuild the
> kernel (Step 1 to 4 on ipsets installation webpage.)  But when I tried
> to build iptables (Step 5,) it showed the error message:

None of the error messages you included were generated due to ipset.

> Does this mean IPsec conflicts with ipsets?  The comment of SuSE kernel
> patch said the patches are from netfilter team, and the ipsets are also
> from netfilter.org.  Since they are both belong to netfilter team, is
> there any way to resolve the conflict?

ipset is absolutely isolated from any other part of netfilter or the
kernel subsystems (set/SET match and target do not count here): at compile
time it cannot clash with any subsystem, patch, extension, whatsoever.

At running time the only known clash can happen when you want to combine
the set and recent matches in one iptables command because both have got
the '--set' argument - that'll be fixed in the next release.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
