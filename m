From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
Date: Wed, 15 Apr 2009 17:10:19 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>
References: <49E5BDF7.8090502@trash.net> <20090415135526.2afc4d18@nehalam> <49E64C91.5020708@cosmosbay.com> <20090415.164811.19905145.davem@davemloft.net> <20090415170111.6e1ca264@nehalam>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>, dada1@cosmosbay.com,
	kaber@trash.net, jeff.chua.linux@gmail.com,
	paulmck@linux.vnet.ibm.com, paulus@samba.org, mingo@elte.hu,
	laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, benh@kernel.crashing.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090415170111.6e1ca264@nehalam>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On Wed, 15 Apr 2009, Stephen Hemminger wrote:
> 
> The counters are the bigger problem, otherwise we could just free table
> info via rcu.  Do we really have to support: replace where the counter
> values coming out to user space are always exactly accurate, or is it
> allowed to replace a rule and maybe lose some counter ticks (worst case
> NCPU-1).

Why not just read the counters fromt he old one at RCU free time (they are 
guaranteed to be stable at that point, since we're all done with those 
entries), and apply them at that point to the current setup?

			Linus
