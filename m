From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: nf_conntrack allocation issue
Date: Fri, 1 Dec 2006 16:07:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612011602330.3907@blackhole.kfki.hu>
References: <456EFC8F.2000507@trash.net>
	<Pine.LNX.4.64.0612010847390.3907@blackhole.kfki.hu>
	<45702A1B.20608@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45702A1B.20608@trash.net>
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

On Fri, 1 Dec 2006, Patrick McHardy wrote:

[...]  
> The reason why I didn't want to add it is that IMO the allocation
> scheme needs to be redesigned anyway, so when we do it we might end
> up with a module parameter we had for two months and need to carry
> around forever. We can still add it any time we want, but for now
> my priority is to get it right (i.e. working properly, not
> optimized) without doing anything we might regret later. Module
> parameters for rather obscure internal stuff tend not to get used
> anyway, so most users don't loose anything.

You're right. And that double lookup is truly horrid, we'll have to find a 
way to eliminate.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
