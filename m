From: Kishore Dharmavaram <kishored@servgate.com>
Subject: RE: Memory leaks in ip_conntrack?
Date: Tue, 11 Nov 2003 15:25:01 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <EFBADA8C200C2B418DA39734FD15475B0B205F@skat.sky.com>
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

Hell Jozsef & All,
I verified & I find my 2.4.20 is already patched with UNCONFIRMED
connections fix: http://www.netfilter.org/security/2003-08-01-listadd.html
Thanks,
Kishore

-----Original Message-----
From: Jozsef Kadlecsik [mailto:kadlec@blackhole.kfki.hu]
Sent: Monday, November 10, 2003 11:51 PM
To: Kishore Dharmavaram
Cc: netfilter@lists.netfilter.org; 'netfilter-devel@lists.netfilter.org'
Subject: RE: Memory leaks in ip_conntrack?


On Mon, 10 Nov 2003, Kishore Dharmavaram wrote:

> Earlier when I checked, /proc/net/ip_conntrack  and /proc/slabinfo were
both
> showing a number around 34000 to 36000, when I checked again after
sometime,
> number of connections in /proc/slabinfo hit the maximum 131072 and number
of
> connections went down to 20 to 30 in /proc/net/ip_conntrack andbox is
> rejecting new connections.

Did you apply any patches from patch-o-matic? If yes, which one?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
