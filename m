From: Unit Zero <onyx@zero.fdns.net>
Subject: using ip_queue in kernel space
Date: Thu, 4 Mar 2004 17:21:23 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.56L0.0403041712040.12794@zero.fdns.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've been curious for a while about the viability of using ip_queue from 
a kernel module, without any userland side. It seems that ip_queue is 
really only used for deferring the verdict on packets to a userspace 
program, but if I simply install a queue handler in the module init 
entrypoint and then install a netfilter hook that returns a QUEUE verdict 
on packets I want, and then do whatever in my queue handler, (kick off 
timer tasks to issue verdicts or some other such thing) will this work? 

I've been meaning to just throw together a quickie test module, strap on 
my kernel-panic helmet and give it a spin, but haven't gotten around to 
it, since I've been busy developing alot of traffic/bandwidth stuff 
(hashing dest-host/port pairs in a netfilter hook and counting total 
incoming/outgoing traffic per port on a server is fun!)

- Vic M. Condino
