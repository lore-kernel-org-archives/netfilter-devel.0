From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 2/3] netfilter: Rework xt_TEE netdevice notifier
Date: Fri, 30 Mar 2018 11:47:45 +0200
Message-ID: <20180330094745.stx5hq5qx2qi3l7u@salvia>
References: <152233127015.1654.2122693690388452589.stgit@localhost.localdomain>
 <152233221526.1654.14062155454284081692.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, kadlec@blackhole.kfki.hu,
        fw@strlen.de, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        ast@kernel.org, brouer@redhat.com, linux@rasmusvillemoes.dk,
        john.fastabend@gmail.com, dsahern@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152233221526.1654.14062155454284081692.stgit@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Mar 29, 2018 at 05:03:35PM +0300, Kirill Tkhai wrote:
> Register netdevice notifier for every iptable entry
> is not good, since this breaks modularity, and
> the hidden synchronization is based on rtnl_lock().
> 
> This patch reworks the synchronization via new lock,
> while the rest of logic remains as it was before.
> This is required for the next patch.
> 
> Tested via:
> 
> while :; do
> 	unshare -n iptables -t mangle -A OUTPUT -j TEE --gateway 1.1.1.2 --oif lo;
> done
> 
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
