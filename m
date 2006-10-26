From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: How many rules were supported iptables?
Date: Thu, 26 Oct 2006 14:12:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0610261314390.20975@ask.diku.dk>
References: <003e01c6f410$f70baf30$1319939c@LGE.NET> <45387015.40305@ufh.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: =?UTF-8?B?7J206re87IiY?= <kslee109@gmail.com>,
	netfilter-devel@lists.netfilter.org, Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Peter <pme@ufh.se>
In-Reply-To: <45387015.40305@ufh.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org



On Fri, 20 Oct 2006, Peter wrote:

> ??? <kslee109@gmail.com> wrote:
>
<cut>
>> ...
>> Do 10,000 rules operate safely?? Or Some rules dont operate normally??
>> If some rules dont operate normally, how many rules iptables does 
>> support??
>> 
> It's the 4 MB in total size of rules. (This is the maximum size of a 
> chunc of data copy from userspace to kernel space in one syscall)


It is NOT true, that there exist a 4 MB size limit of rules.

Its quite easy to disprove. I have made some tests where I can transfer a 
ruleset of 13 Mb, between userspace and kernel (howto see ruleset size 
see note#1).

The ruleset consists of 12256 chains and 59239 rules.  Regarding 
performance issues: I have constructed the ruleset as a subnet-tree, where 
a worst-case match result in touching max 45 rules.  Throughput wise with 
this ruleset, I can route 94Mbit/s through the Linux box on a 100Mbit/s 
netcard.

Problem: The execution time of iptables take around 14 seconds.  This is 
caused by the way iptables/libiptc parse the ruleset blob, in libiptc.c 
function iptcc_find_chain_by_offset.  We should actually fix this... I 
have raised this issue before on the list, but the discussion died...

The real limit:

To test the limits of iptables, I also tried to load a ruleset with 24878 
chains and 120250 rules, with a ruleset blob size around 30Mb. (Iptables 
init function now takes 70 seconds!!!). With a ruleset that large iptables 
actually gave up and reported:

  "Memory allocation problem" (errno:12)

And the kernel syslog reported:

  "kernel: allocation failed: out of vmalloc space - use vmalloc=<size> to increase size."

This error, is caused by, that the kernel cannot allocate enough vmalloc 
memory.  Propably just before it swaps the rulesets. (This can be 
increased at boot time vmalloc=xxx and the available vmalloc memory can 
be seen in /proc/meminfo).


Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------

Notes:

Note#1:
  The easies way to see the size of the ruleset blob is to compile libiptc
  with -DIPTC_DEBUG2 and look at the filesize of
  /tmp/libiptc-so_get_entries.blob and /tmp/libiptc-so_set_replace.blob).
