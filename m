From: Sven Wegener <sven.wegener@stealer.net>
Subject: [RFC] ipset: New set type iptreemap
Date: Mon, 20 Aug 2007 22:36:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708202149370.14154@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi all,

based on the feedback from Jan Engelhardt I've converted the fullipmap [1] 
set type I announced last week to manage the bitmaps with a tree 
structure, instead of a large flat single array. The code is based on 
iptree and the name of the new type is iptreemap.

Worst case memory usage has increased slightly over fullipmap, but the 
average memory usage should be lower. It also supports adding and deleting 
of ranges, so it can be used to match against lists of ranges and 
networks. Be aware that the set type doesn't store the range itself, but 
it expands the range so that the set contains all addresses within that 
range. With a pure network set type like nethash the following is not 
possible:

ipset -A foo 172.16.0.0/12
ipset -D foo 172.17.0.0/16

But iptreemap will handle it as expected and after the delete operation 
the set will only contain the ranges:

172.16.0.0-172.16.255.255
172.18.0.0-172.31.255.255

(The userspace part uses : as the range separator to not interfere with - 
in hostnames)

For ranges that start and end at octet boundaries iptreemap will not use 
any memory for the bitmaps as it manages this by reusing global allocated 
bitmaps. A garbage collector checks whether a bitmap or a complete subtree 
can be replaced by these global bitmaps.

I'm responding with two patches, one for the kernel part and one for the 
userspace part. I think the looping code for the add and delete operation 
for ranges could need some cleanup. The CHECK[1-3] macro is for checking 
whether a complete subtree can be added or deleted. And the GETVALUE[1-3] 
is for getting the start and end values for octets when we're inside of a 
range.

Sven

[1] https://lists.netfilter.org/pipermail/netfilter-devel/2007-August/029066.html
