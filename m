From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix out-of-bounds accesses in
 clusterip_tg_check()
Date: Wed, 31 Jan 2018 15:00:19 +0100
Message-ID: <20180131140019.tvsoyc3ihs3l44eb@salvia>
References: <20180130142134.131750-1-dvyukov@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        willemb@google.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180130142134.131750-1-dvyukov@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 30, 2018 at 03:21:34PM +0100, Dmitry Vyukov wrote:
> Commit 136e92bbec0a switched local_nodes from an array to a bitmask
> but did not add proper bounds checks. As the result
> clusterip_config_init_nodelist() can both over-read
> ipt_clusterip_tgt_info.local_nodes and over-write
> clusterip_config.local_nodes.
> 
> Add bounds checks for both.

Applied, thanks Dmitry.
