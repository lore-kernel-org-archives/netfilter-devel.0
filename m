From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Multiple Address specification or match
Date: Fri, 1 Oct 2004 10:47:46 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0410011044390.12264@blackhole.kfki.hu>
References: <003301c4a6cc$069e3fb0$2201010a@bluereef.local>
	<Pine.LNX.4.61.0409301336380.29461@filer.marasystems.com>
	<015601c4a792$6890f250$2201010a@bluereef.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Swapnil Nagle <swapsn@rediffmail.com>,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Temp02 <temp02@bluereef.com.au>
In-Reply-To: <015601c4a792$6890f250$2201010a@bluereef.local>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 1 Oct 2004, Temp02 wrote:

> The ippool and ipset matches only support linux 2.4 not 2.6 unfortunately.

I'm working on the rewriting of ipset, together with porting to 2.6.

> The iprange match would suit my needs but it only allows a single match as
> well. What would I need to change in iptables to allow the match to be
> called more than once, as in:
>
> iptables -m iprange 10.0.0.0-10.255.255.255 -m iprange
> 172.16.0.0-172.16.255.255
>
> is this an easy to add switch somewhere?

The basic problem is that iptables matches are AND-ed. In you example you
imply OR-ed matches.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
