From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: nf_queue: augment nfqa_cfg_policy
Date: Mon, 18 Jun 2018 14:13:52 +0200
Message-ID: <20180618121352.fcvsmbjq2yov4z3f@salvia>
References: <20180613161339.144919-1-edumazet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
To: Eric Dumazet <edumazet@google.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613161339.144919-1-edumazet@google.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 13, 2018 at 09:13:39AM -0700, Eric Dumazet wrote:
> Three attributes are currently not verified, thus can trigger KMSAN
> warnings such as :
> 
> BUG: KMSAN: uninit-value in __arch_swab32 arch/x86/include/uapi/asm/swab.h:10 [inline]
> BUG: KMSAN: uninit-value in __fswab32 include/uapi/linux/swab.h:59 [inline]
> BUG: KMSAN: uninit-value in nfqnl_recv_config+0x939/0x17d0 net/netfilter/nfnetlink_queue.c:1268
> CPU: 1 PID: 4521 Comm: syz-executor120 Not tainted 4.17.0+ #5
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Applied, thanks Eric.
