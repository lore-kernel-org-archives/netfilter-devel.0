From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: About matching
Date: Fri, 8 Apr 2005 09:18:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0504080901080.21705@blackhole.kfki.hu>
References: <20050407000158.02AA.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050407000158.02AA.LARK@linux.net.cn>
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

Hello,

On Thu, 7 Apr 2005, Wang Jian wrote:

> iptables <match rule 1> -j CONNMARK --set-mark value/mask
> iptables <match rule 1> -j RETURN
>
> How many times the match rule 1 is evaluated when matched? If two, then
> the second time is waste of CPU cycle.
>
> Then think these three
>
> iptables <match rule 1> -j CONNMARK --set-mark value/mask
> iptables <match rule 1> -j CONNMARK --restore --mask mask
> iptables <match rule 1> -j RETURN
>
> Are there any optimization for such case?

No, but what's wrong with a natural subchain called with the condition
<match rule 1>? If the return position should be the chain according to
the original rules above, one could dust off Henrik's goto patch from
pom-ng.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
