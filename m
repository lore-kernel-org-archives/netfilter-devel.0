From: Damon Gray <dgray@internap.com>
Subject: module access to conntrack tcp timeouts
Date: Fri, 27 May 2005 12:43:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0505271238130.2297@dgray-test.acs.internap.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


I'm new to netfilter developement so bare with me if this is a stupid 
question.

A module I'm working on needs to know what the current conntrack timeout 
for tcp established is. The variable is ip_ct_tcp_timeout_established in 
ip_conntrack_proto_tcp.c. What is the best way to go about getting access 
to this information from another kernel module? Sysctl? Proc? Can you 
access sysctl information from the kernel?

Thanks
