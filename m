From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: IP SET target iptables fix
Date: Fri, 18 Mar 2005 09:14:43 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0503180907470.14190@blackhole.kfki.hu>
References: <200503171840.01301.mpokrywka@hoga.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Michal Pokrywka <mpokrywka@hoga.pl>
In-Reply-To: <200503171840.01301.mpokrywka@hoga.pl>
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

Hi,

On Thu, 17 Mar 2005, Michal Pokrywka wrote:

> Current iptables target needs to test for IP_SET_INVALID_ID when
> printing or saving rules from kernel, currently it errors "iptables v1.3.1:
> Set id 65535 in kernel doesn't exist."
>
> Patch below fixes this problem:

Yes, good catch: patch is applied in svn, iptables shapshot updated on
webpage.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
