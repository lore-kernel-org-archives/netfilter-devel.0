From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Table duplication on smp machine
Date: Mon, 31 Mar 2003 14:50:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E8839B2.6080607@hipac.org>
References: <3E881DD6.8090206@hipac.org> <20030331110709.GE7718@sunbeam.de.gnumonks.org> <3E882F52.1040705@hipac.org> <20030331123326.GO7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald

You wrote:
> then you start having cacheline ping-pong problems when match/target
> private data is written to (like in the limit match, ...)

Hm, I don't understand. The limit match performs the write operations
on the same private data block for all cpu's so the cacheline ping-pong
occurs in the current scheme too [in addition to the locking overhead].

Of course this would be true if a match/target uses its per-cpu
data block to store information but I cannot imagine a scenario
where this makes sense or whatsoever.

> apart from that, ther is no reason why we shouldn't do what you are
> proposing.  In fact, this is exactly what my initial pkttables/iptables2
> design does ;)

Ok :)


Thomas
