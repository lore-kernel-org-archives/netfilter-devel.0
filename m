From: Kishore Dharmavaram <kishored@servgate.com>
Subject: RE: Memory leaks in ip_conntrack?
Date: Tue, 11 Nov 2003 16:49:12 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <EFBADA8C200C2B418DA39734FD15475B0B2061@skat.sky.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: netfilter@lists.netfilter.org, "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: 'Jozsef Kadlecsik' <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef & All,
It seems some patches were already applied on base 2.4.20 kernel netfilter
sources that iam working with, is there a way to findout what patches were
applied on netfilter code? and are some must-apply patches for 2.4.20?, if
so can you please give me a list or pointout few?
Thanks,
Kishore

-----Original Message-----
From: Jozsef Kadlecsik [mailto:kadlec@blackhole.kfki.hu]
Sent: Tuesday, November 11, 2003 3:35 PM
To: Kishore Dharmavaram
Cc: netfilter@lists.netfilter.org; 'netfilter-devel@lists.netfilter.org'
Subject: RE: Memory leaks in ip_conntrack?


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
