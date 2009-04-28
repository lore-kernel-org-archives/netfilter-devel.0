From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: use per-CPU r**ursive lock {XV}
Date: Tue, 28 Apr 2009 06:43:40 -0700 (PDT)
Message-ID: <20090428.064340.193569214.davem@davemloft.net>
References: <49F6A8FD.3010804@cosmosbay.com>
	<20090428.045342.206106171.davem@davemloft.net>
	<20090428124033.GA1655@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: dada1@cosmosbay.com, torvalds@linux-foundation.org,
	shemminger@vyatta.com, zbr@ioremap.net, peterz@infradead.org,
	mathieu.desnoyers@polymtl.ca, jarkao2@gmail.com, paulus@samba.org,
	paulmck@linux.vnet.ibm.com, kaber@trash.net,
	jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
	jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	benh@kernel.crashing.org
To: mingo@elte.hu
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090428124033.GA1655@elte.hu>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 28 Apr 2009 14:40:33 +0200

> IMHO this locking construct should be considered for 
> linux/local_lock.h and kernel/local_lock.c. Even if the netfilter 
> code drops its use soon afterwards ;-)

If you can show me have to pass a per-cpu variable (the variable,
not a dereference of it) as an argument to an inline function,
I'll implement this :-)

It has to be dereferenced after local_bh_disable() for the
read side acquisition.
