From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: performance impact by increasing number of ipsets
Date: Tue, 17 Oct 2006 10:00:00 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0610170852010.17511@blackhole.kfki.hu>
References: <b322db070610162305o20d92fb7tbbd7027700b7eb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Retesh <retesh.chadha@gmail.com>
In-Reply-To: <b322db070610162305o20d92fb7tbbd7027700b7eb5@mail.gmail.com>
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

On Tue, 17 Oct 2006, Retesh wrote:

> I want to increase the number of IPsets in a system to a high number
> say 50000 (default is 255). What will be the impact on performance?

No problem - the sets are referred by index in netfilter (i.e
in the iptables rules). The set *creation* in such a high number can take
a while, however.

> Has someone tried this, or can some explain the implementation of the
> ipsets, so that I can estimate the impact on kernel?

I haven't heard about such an extreme setup. But if such a high number of
sets are really required I'd investigate other solutions like nf-hipac,
which might easily be a better solution.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
