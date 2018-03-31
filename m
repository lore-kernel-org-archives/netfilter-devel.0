From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 04/12] bridge: netfilter: Use the new global
 ether_<foo>_addr arrays
Date: Sat, 31 Mar 2018 11:40:42 -0700
Message-ID: <1522521642.11653.19.camel@perches.com>
References: <cover.1522479607.git.joe@perches.com>
         <df70bafdca663db034626f4f1525826ea263bf2c.1522479607.git.joe@perches.com>
         <20180331182810.or7attmfpjxw4sfm@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180331182810.or7attmfpjxw4sfm@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2018-03-31 at 20:28 +0200, Pablo Neira Ayuso wrote:
> Hi Joe,

Hi Pablo.

> On Sat, Mar 31, 2018 at 12:05:19AM -0700, Joe Perches wrote:
> > Remove the local consts and use the new globals.
> 
> This one is already upstream:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=9124a20d8794663a396b5d6f91f66903848a042b
> 
> I can see you're using is_broadcast_ether_addr(e->destmsk) in this new
> version, we would need an incremental version.

No worries.  I did it against next-20180329
and that other commit wasn't there.
