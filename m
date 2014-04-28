From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipt_CLUSTERIP: Add network device notifier
Date: Mon, 28 Apr 2014 16:23:06 +0200
Message-ID: <20140428142306.GA28547@localhost>
References: <1396871929.3741.6.camel@tkhai>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, tkhai@yandex.ru
To: Kirill Tkhai <ktkhai@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59123 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaD1OXQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:23:16 -0400
Content-Disposition: inline
In-Reply-To: <1396871929.3741.6.camel@tkhai>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Apr 07, 2014 at 03:58:49PM +0400, Kirill Tkhai wrote:
> Clusterip target does dev_hold() in .checkentry, while dev_put() in .destroy.
> So, unregister_netdevice catches the leak:
> 
> # modprobe dummy
> # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP --new --hashmode sourceip -i dummy0 --clustermac 01:aa:7b:47:f7:d7 --total-nodes 2 --local-node 1
> # rmmod dummy
>
>   Message from syslogd@localhost ...
>     kernel: unregister_netdevice: waiting for dummy0 to become free. Usage count = 1
>
[...]
>  1 file changed, 134 insertions(+), 12 deletions(-)

I have spinned several times on this patch, and I'm not very happy
with taking this fix:

1) It's quite large fix for a situation that seems unlikely to me.

2) We have this problem since the beginning, since the CLUSTERIP
   target was merged mainstream.

3) We have theses days the cluster match, which is more flexible as
   you can also use it not only for backend, but also in active-active
   gateway setups. It just requires a couple of arptables rules for
   mangling ARP replies to include the multicast MAC there.

Perhaps linking net_device structure with the module that have created
would simplify this, but I guess David won't take such patch just to
fix this rare iptables extension, unless this is manifesting in other
netdev code, eg. tunneling protocols.
