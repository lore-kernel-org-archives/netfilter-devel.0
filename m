From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Table duplication on smp machine
Date: Mon, 31 Mar 2003 14:06:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E882F52.1040705@hipac.org>
References: <3E881DD6.8090206@hipac.org> <20030331110709.GE7718@sunbeam.de.gnumonks.org>
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

Thanks for your quick reply.

You wrote:
> it's not only write locking.  Even if there was a locking mechanism in
> place, and we didn't care about it's performance. 
> 
> What we are really caring about is cacheline ping-pong.  If you have a
> single piece of data (like a counter) that is written by different cpu's
> all the time, you will always invalidate the cached values in the other
> cpu's cachelines.

I see. If this is the main reason it would suffice to have _one_ ruleset
for all cpu's but a block of counters for each rule like this:
                   ----------------------------------------
                   |          counter for cpu 0           |
                   |--------------------------------------|
                   |          cache-align padding         |
                   |--------------------------------------|
                   |                                      |
                  ...                                    ...
                   |--------------------------------------|
                   |          cache-align padding         |
                   |--------------------------------------|
                   |          counter for cpu n           |
                   |--------------------------------------|

Right?

> Depends on what you think of 'a lot of space'.  In all my practical
> setups, the connection tracking table is significantly larger (by orders
> of magnitude) than the iptables ruleset.

Hm, in the above scheme the padding could be up to 112 bytes on x86
which means that the netfilter scheme does not waste a byte if the
average rule is <= 112 bytes.

Anyway, I was more concerned about the reasons behind the table
duplication than waste of memory.


Thomas
