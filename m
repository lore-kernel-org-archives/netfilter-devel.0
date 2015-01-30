From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/9 WIP] nf_tables: set extensions and dynamic updates
Date: Fri, 30 Jan 2015 07:46:25 +0000
Message-ID: <1422603994-5836-1-git-send-email-kaber@trash.net>
Cc: tgraf@suug.ch, davem@davemloft.net, David.Laight@ACULAB.COM,
	ying.xue@windriver.com, paulmck@linux.vnet.ibm.com,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Herbert,

following is the nftables patchset for dynamic set updates and timeouts.
Probably the only interesting part is in patch 7/9, which adds GC to
nft_hash. Nothing special, just walking the hash and zapping entries.

Please keep in mind that this is work in progress, there are some known
bugs and problems left.

Cheers,
Patrick
