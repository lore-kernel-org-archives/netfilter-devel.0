From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: IPSET: notify when deleting IPs
Date: Tue, 30 Aug 2005 09:48:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0508300937300.3462@blackhole.kfki.hu>
References: <m2u0h8hj5a.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samir Bellabes <sbellabes@mandriva.com>
In-Reply-To: <m2u0h8hj5a.fsf@cerbere.dyndns.info>
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

On Mon, 29 Aug 2005, Samir Bellabes wrote:

> what do you think about sending notification to userspace when deleting
> IPs after a timeout ?
>
> Something like:  ipset -N set_name --timeout 3600 --notify
>
> '--notify' can send messages through a specific netlink to userspace, or
> something else.
> any idea ?

That could be added easily if the kernel/userspace communication of ipset
were already been rewritten from sockopt to netlink. Harald already
suggested that, but such a process will require time. I plan to start
the rewriting somewhere around the netfilter workshop.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
