From: "Narendra Prabhu. B" <naren@deeproot.co.in>
Subject: is this a bug or my mistake ?
Date: Fri, 3 Jan 2003 13:37:16 +0530 (IST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.43.0301031318450.957-100000@abodh.pesit.deeproot.co.in>
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


Hello,

I am using libiptc library for reading different counters. I am reading
the counters and logging them for further usage.

When repeatedly(every 120 secs) calling this function I am seeing that,
its using a lot of memory(not cpu).

First I have put the code/function that is responsible for memory leakage.
And followed by a memory debuger(ccmalloc) log.

<THE_FUNCTION>
char* read_rules ( const char *chain, iptc_handle_t *hp)
{
	const struct ipt_entry  *p_rule, *c_rule ;/*pointers to previous and current rules*/

	char *listed_counters = (char*) malloc(150) ;

	bzero ( listed_counters,150);

	for (c_rule = p_rule = iptc_first_rule (chain,hp);
					c_rule != NULL ;c_rule = iptc_next_rule(p_rule,hp) ) {
			sprintf ( listed_counters,"%s %ld ",	listed_counters, c_rule->counters.bcnt);
			p_rule = c_rule ;
	}

	return (listed_counters) ;
/*
 * In the caller function I am freeing the "listed_counters"
 * the functions "iptc_first_rule" and "iptc_next_rule" return "const struct ipt_entry *"
 */

}
</THE_FUNCTION>


<DEBUG_LOG>
.--------------------------------------------------------------------------.
|================ ccmalloc-0.3.9 (C) 1997-2001 Armin Biere ================|
+--------------------------------------------------------------------------+
| executable       = /home/naren/bridging/new-progs/libiptc/read_counters |
| startup file     = .ccmalloc                                             |
| log file         = stderr                                                |
| start time       = Fri Jan  3 13:24:06 2003                              |
| operating system = Linux 2.4.19 i686 on abodh                            |
+--------------------------------------------------------------------------+
| only-count        = 0            keep-deallocated-data = 0               |
| check-interval    = 0            check-free-space      = 0               |
| check-start       = 0            file-info             = 1               |
| chain-length      = 0            additional-line       = 1               |
| check-underwrites = 0            print-addresses       = 0               |
| check-overwrites  = 0            print-on-one-line     = 0               |
| sort-by-wasted    = 1            sort-by-size          = 1               |
| # only-log-chain  = 0            continue              = 0               |
| # dont-log-chain  = 0            statistics            = 0               |
| debug             = 0            library-chains        = 0               |
| load-dynlibs      = 0            align-8-byte          = 0               |
| only-wasting-alloc= 1                                                    |
`--------------------------------------------------------------------------'

.---------------.
|ccmalloc report|
=======================================================
| total # of|   allocated | deallocated |     garbage |
+-----------+-------------+-------------+-------------+
|      bytes|        4192 |           0 |        4192 |
+-----------+-------------+-------------+-------------+
|allocations|           8 |           0 |           8 |
+-----------------------------------------------------+
| number of checks: 1                                 |
| number of counts: 8                                 |
| retrieving function names for addresses ... done.   |
| reading file info from gdb ... done.                |
| sorting by number of not reclaimed bytes ... done.  |
| number of call chains: 2                            |
| number of ignored call chains: 0                    |
| number of reported call chains: 2                   |
| number of internal call chains: 2                   |
| number of library call chains: 0                    |
=======================================================
|
* 77.1% = 3232 Bytes of garbage allocated in 4 allocations
|       |
|       |       0x400cd9d3 in <???>
|       |
|       |       0x0804c133 in <main>
|       |                  at read_counters.c:27
|       |
|       |       0x0804c6d5 in <iptc_init>
|       |
|       |       0x0804c5b9 in <alloc_handle>
|       |
|       `-----> 0x08058e52 in <malloc>
|                          at src/ccmalloc.cc:41
|
* 22.9% = 960 Bytes of garbage allocated in 4 allocations
|       |
|       |       0x400cd9d3 in <???>
|       |
|       |       0x0804c18e in <main>
|       |                  at read_counters.c:33
|       |
|       |       0x0804cb8b in <iptc_first_chain>
|       |
|       |       0x0804c85d in <populate_cache>
|       |
|       `-----> 0x08058e52 in <malloc>
|                          at src/ccmalloc.cc:41
|
`------------------------------------------------------

</DEBUG_LOG>


Forgive me if this is my mistake and if so please let me know.

Thanks

Bye,
Narendra.



In the middle of difficulty..... lies Opportunity. (Albert Einstein)
--------------------------------------------------------------------
Narendra Prabhu. B             Free Software at its product-ive best.
DeepRoot Linux                             http://www.deeproot.co.in
                ---- Server Appliances ----
             ---- Linux Support and Services ----
-------------------------------------------------------------------
