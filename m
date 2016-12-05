From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warnings after merge of the netfilter-next tree
Date: Mon, 5 Dec 2016 12:19:38 +1100
Message-ID: <20161205121938.014bc604@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi all,

After merging the netfilter-next tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

In file included from arch/x86/include/asm/checksum.h:4:0,
                 from include/net/checksum.h:26,
                 from include/linux/skbuff.h:31,
                 from include/linux/if_ether.h:23,
                 from include/uapi/linux/ethtool.h:18,
                 from include/linux/ethtool.h:17,
                 from include/linux/netdevice.h:42,
                 from include/linux/if_vlan.h:15,
                 from net/netfilter/nft_payload.c:13:
net/netfilter/nft_payload.c: In function 'nft_payload_set_eval':
arch/x86/include/asm/checksum_64.h:184:2: warning: 'tsum' may be used uninitialized in this function [-Wmaybe-uninitialized]
  asm("addl %2,%0\n\t"
  ^
net/netfilter/nft_payload.c:261:15: note: 'tsum' was declared here
  __wsum fsum, tsum;
               ^
In file included from include/linux/skbuff.h:31:0,
                 from include/linux/if_ether.h:23,
                 from include/uapi/linux/ethtool.h:18,
                 from include/linux/ethtool.h:17,
                 from include/linux/netdevice.h:42,
                 from include/linux/if_vlan.h:15,
                 from net/netfilter/nft_payload.c:13:
include/net/checksum.h:71:9: warning: 'fsum' may be used uninitialized in this function [-Wmaybe-uninitialized]
  return csum_add(csum, ~addend);
         ^
net/netfilter/nft_payload.c:261:9: note: 'fsum' was declared here
  __wsum fsum, tsum;
         ^

Introduced by commit

  556c291b3a1b ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")

-- 
Cheers,
Stephen Rothwell
