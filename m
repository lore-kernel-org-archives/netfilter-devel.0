From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: raw patch saga continues.... kernel still panics!
Date: Tue, 14 Oct 2003 09:58:20 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310140943400.536-100000@blackhole.kfki.hu>
References: <3F88475F.4070907@wp.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: c0g <c0g@wp.pl>
In-Reply-To: <3F88475F.4070907@wp.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 11 Oct 2003, c0g wrote:

> I can force kernel to panic by using ntpdate program to synchronize
> clock or by starting ntpd server on firewall box. Of course it happens
> only when there are rules in raw table, PREROUTING chain which catch
> packets generated/received by these program and jump to NOTRACK.
> Inserting rule:
> iptables -t raw -I PREROUTING -j ACCEPT
> before NOTRACK rules makes kernel stable.

I could not reproduce the kernel panic. The raw patch/table and NOTRACK
target work fine.

> There is also one problem, don't know if correlated with raw patch,
> because unloading netfilter modules and trying to connect to my firewall
> thru PPTP causes kernel panic too. But on kernel patched with older POM
> everything works fine.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
