From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: "ip_tables: table screwed up!" on pom 20031023 - raw patch?
Date: Fri, 21 Nov 2003 03:59:13 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311210317290.25547-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0311202112500.21895-100000@sparrow>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, <kadlec@netfilter.org>,
   ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
In-Reply-To: <Pine.LNX.4.44.0311202112500.21895-100000@sparrow>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Nov 2003, William Stearns wrote:

> Interesting.  I hope removing that patch helps both of us.

Unfortunately my problem is still there.. and now the UML kernel config is 
very close to what we use on "real" boxes..

Time for some sleep. Maybe the problem is easier to find with a 
functional brain..

Problem description:

UML 2.4.22 kernel compiled with several POM patches and
CONFIG_NETFILTER_DEBUG

a) iptables-restore randomly fails to load a mangle+filter+nat setup in
one invocation. Calling it separately per table always seems to work.

b) Kernel often segfaults in ipt_do_table on
			                        
                        t = ipt_get_target(e);
			IP_NF_ASSERT(t->u.kernel.target);
                        /* Standard target? */
                        if (!t->u.kernel.target->target) {

sometimes the assert is printed before, sometimes it just faults.

c) Does not seem to be related to any speific targets/matches. The problem 
even manifests itself when loading a simple ruleset consisting of only the 
default policies + custom chain definitions (wihtout contents) not using 
any matches or targets.

sometimes the table gets completely corrupted to the point that running 
iptables-save fails, complaining about out of memory or a similar errror.

I am hoping this is a UML issue and not iptables.. but it is worrying.

Regards
Henrik
