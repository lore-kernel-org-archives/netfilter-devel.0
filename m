From: Eddy Kvetny <eddy.linux@yahoo.com>
Subject: RE: Huge impact of the conntrack mechanism on routing performance
	(30% with a single conntrack entry)
Date: Sun, 9 Apr 2006 14:10:31 -0700 (PDT)
Message-ID: <20060409211031.97319.qmail@web38408.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

> From: David S. Miller davem at davemloft.net
> Date: Fri Apr 7 23:28:29 CEST 2006

>> From: Eddy Kvetny <eddy_kvetny at yahoo.com>
>> Date: Wed, 5 Apr 2006 07:03:05 -0700 (PDT)

>> Right after "insmod ip_conntrack.ko" the throughput
>> drastically falls to 28 kpps (-12 kpps or -30%
!!!).

> Yes, this is pretty much what the cost of netfilter 
> is for a router.

> This has been known and well understood for a long 
> time, and solutions
> to this problem are not easy which is why there 
> hasn't been any progress in this area to date.

Thanks for the response

I would appreciate if someone could explain this "well
understood" :-) thing to me. How come such an overhead
for a single entry in the conntrack table ? After
putting it to the table this entry is hashed and later
is supposed to be find very quickly. What am I missing
here ?

Thanks in advance

Best regards, Eddy



__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
