From: netfilter@westboro.org
Subject: Memory Leaks in the iptc libs
Date: Wed, 18 Jun 2003 21:48:44 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.2.0.9.0.20030618212603.00a813e8@wheresmymailserver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
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

I have written a program - loosely based on iptables that maintains rules 
under RedHat 9.0.  I am seeing a memory leak - presumably in the kernel and 
am looking to see if anyone can point me in the right direction.  I can run 
67,000 iterations of the program and my memory space is not increasing - 
but the overall memory usage of the machine seams to have gone up 60-70 
megabytes.  IE even after I kill my process the memory is up.  For this 
test I was not increasing the number of rules but deleting one then adding 
one. This program is meant to be a long running daemon but if the 
underlying libs leak leak memory that is not part of my process I have issues.

I have gone back through the archives and have seen several messages about 
leaks but they seamed to be with people who were calling do-command from 
their own program.

I will try to get a patch together if I can find where the problem is but 
wanted to see if anyone could get me started.

Bob M

PS

The application is used for access control to a group of gaming 
servers.  There is a tree of rules that isolate the high octet of an IP 
address.  This tree makes up 256+128+64 ... +1 chains with 2 rules per 
chain.  I add a users IP to the appropriate leaf chain and pass off to a 
chain for that user that checks the traffic to see if it is 
acceptable.  the expectation is 3000 - 4000 users.  The program 
(editrules.c) has 5 functions - which it recieves from ipc via a non-priv 
account that gets its data via a network connection form the user 
authetication server.

These functions are define, delete, assign, ban and unban.

The define function create the chain for the user and adds a jump rule to 
do standard traffic checking.

The delete rule deletes the user chain and any rules that refer to it.

The assign function searches through the table and removes and rule that 
jumps to the user chain and then adds a rule at the appropriate leaf chain 
to jump to the user rule.

The ban function inserts a rule to the user chain that bans a user from a 
particular game.

The unban function searches the user chain for a matching jump to ban the 
user and deletes it.

The program also saves the current state of the rules and restores them 
when it starts.

The infrastructure chains and rules are set up by various scripts

PPS - yes there was a lot of copying and I kept the IPTables copyright 
intact ;-) not so loose after all.
