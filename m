From: Venkatesh Prasad Ranganath <vranganath@cox.net>
Subject: question about ipt_table_info structure
Date: Sat, 14 Dec 2002 03:01:57 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DFAF385.6040707@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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



Hi,

I am using netfilter/iptables (1.2.7a) in a project (which may end up 
contributing to netfilter/iptable branch if it succeeds).  Hence, I was 
browsing the kernel space netfilter/iptables code.  I am able to follow 
the code except for a few glitches.

1> What is the purpose of underflow field in ipt_replace?  Where is it used?
2> What is the purpose of term field in struct initial_table in 
iptables_filter.c?  Where is it used?
3> What is the purpose of ipt_replace structure?  Where is it used?
4> What is the purpose of table field in ipt_table?  It is not used at 
any time during filtering.  (or am I wrong about this?)  If it is used, 
where is it used?
5> Is it correct to say that ACCEPT, DROP, QUEUE, and RETURN are the 
builtin targets?

Also, can someone comment if my understanding of part of 
netfilter/iptable as given below is correct.
"Each rule that can be added via iptables command is represented via a 
set of data rather than a single piece of data.  Each criterion to be 
satisfied for the entire rule to be satisfied is represented as a match. 
 If all of the match/criterion are satisfied then target (linked at the 
end of the sequence of matches) associated with the rule is executed. 
 Hence, there is only one target with a rule, but may be multiple matches."

Finally, are there any documents that discuss the performance of and 
issues related (if any) to netfilter/iptables?  In particular, I am 
looking for documents which may have identified bottlenecks or have 
pointers to locations in which to look for such opportunities. Benchmark 
results and/or test run results would also be helpful.  I am just piggy 
backing this last question along with the others and I would understand 
if someone replied "google would be a good place to start" ;-)

waiting for reply,

-- 

Venkatesh Prasad Ranganath,
Dept. Computing and Information Science,
Kansas State University, US.
web: http://www.cis.ksu.edu/~rvprasad
