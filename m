From: Biermann-Roemke@t-online.de (=?ISO-8859-1?Q?Karsten_R=F6mke?=)
Subject: Re: libiptc - frustrating
Date: Sat, 04 Oct 2003 10:39:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F7E872F.5070304@hhb.bonn.de>
References: <3F7C4919.8060800@hhb.bonn.de> <20031002201344.GF5758@sunbeam.de.gnumonks.org>
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


Hello again!
Im looking for the following way of adding rules to the tables.
>>3) linking iptables.o to my application. I remember, that I've not done that
>>   because iptables never frees any memory - only allocates - not 
>>useful for a
>>   long time running program.
> 
> 
> this should be fixed now.
> 
> You have to consider a fourth option:
> 4) running iptables-restore --noflash and piping commands to stdin.
After looking to the code - iptables-restore calls do_command - same
what iptables-standalone does.

But again back to memory problems, I modified libiptc and iptables.c so that
I just print every allocation and deallocation of memory. The output at the
end of this mail is one example which shows 11 times malloc/calloc and 6 
times free.

I have never done programming on such a kernel-near level, so in the moment
I'm just counting :-). There are 5 allocations of memory remaining, so 
my question:

Is there some memory allocated which is used by the kernel (or somebody 
else, maybe
rustys hamster)? I hope this question isn't to stupid - hmm probably it 
is. If
iptables allocates some memory and is terminated then the memory should 
be free'd again
by the kernel?

Slightly off-topic: does somebody know what happens with the memory, if 
I do a
system call like system("iptables ....")? If some memory is allocated 
from iptables
and not deallocated again - does the linux kernel cares about 
deallocating this
memory.

ok it's enough up to now, wishing a nice weekend and thank you

Karsten


ah, here's the example:
stopping access of one host
(redirecting to own web-server on port 5042 which sends only ascii-art)

kspace9:/usr/local/iptables-1.2.7aMod # ./iptables -t nat -p tcp -I iAccess
-s 10.4.1.1 -j REDIRECT --to-port 5042

leads to the output of modified iptables:

In do_command case j calling fw_calloc
Calling malloc in merge_options
Calling alloc for addr in parse_hostnetwork
Calling alloc for addr in parse_hostnetwork
malloc in alloc_handle
malloc in populate_cace for h->cache_chain_heads
Calling fw_malloc in generate_entry
malloc in alloc_handle

free on (*handle)->cache_chain_heads in insert_rule
free on *handle in insert_rule

malloc in commit for repl
malloc in commit for repl->counters
malloc in commit for newcounters

3xfree on repl->counters, repl, newcounters in commit

free on *handle in commit, set *handle to NULL
