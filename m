From: Null Device <nulldevice83@yahoo.com>
Subject: -m connlimit problem, sk_buff->data,user_modehelper help
Date: Wed, 5 May 2004 22:42:46 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040506054246.81482.qmail@web41903.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

First of all many thanks to this development group and
specially Henrik Nordstrom, my first phase of creating
test firewall is done.

now while going ahead a few problems are still there
which hope will b solved with the help from this
group. the first one is regarding inserting connlimit
module, when i try the following

#iptables -A INPUT -p tcp --syn --dport 80 -m
connlimit --connlimit-above 2 -j REJECT

i get the following error 
iptables: No chain/target/match by that name

connlimit as specified by Henrik Nordstrom is built in
my kernel itself. i have taken enuff care to flush the
chains before doing this.

any help?

second one i want to know is what exactly
sk_buff->data points to?

and lastly, i want to sent ICMP port unreachable for
some specific rules and want to LOG some specific
ones.

i went through REJECT code in p-o-m . it is for ipv6
and uses icmpv6_send.i thought similar function must
exists for ipv4 and located it in icmp.h after little
searching. but i am unable to get the parameters it
requires.

extern void	icmp_send(struct sk_buff *skb_in,  int
type, int code, u32 info);

what i am supposed to pass it as skb_in, will i have
to create my own sk_buff to pass it on to it. and what
is u32 info. 

and for logging i used user_modehelper to call a
userspace program to log the specific things in a diff
file not /var/log/messages. but my kernel hangs when
used this.

any help?

thx in advance.

ND 


	
		
__________________________________
Do you Yahoo!?
Win a $20,000 Career Makeover at Yahoo! HotJobs  
http://hotjobs.sweepstakes.yahoo.com/careermakeover 
