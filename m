From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RE: Memory leaks in ip_conntrack?
Date: Tue, 11 Nov 2003 08:51:22 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0311110849430.24817-100000@blackhole.kfki.hu>
References: <EFBADA8C200C2B418DA39734FD15475B0B2057@skat.sky.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter@lists.netfilter.org>,
	"'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kishore Dharmavaram <kishored@servgate.com>
In-Reply-To: <EFBADA8C200C2B418DA39734FD15475B0B2057@skat.sky.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 10 Nov 2003, Kishore Dharmavaram wrote:

> Earlier when I checked, /proc/net/ip_conntrack  and /proc/slabinfo were both
> showing a number around 34000 to 36000, when I checked again after sometime,
> number of connections in /proc/slabinfo hit the maximum 131072 and number of
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
