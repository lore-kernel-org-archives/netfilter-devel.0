From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: TCP window tracking patch status query for further design considerations
Date: Wed, 09 Oct 2002 00:22:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA35A8C.6040201@drugphish.ch>
References: <Pine.LNX.4.33.0210090012060.24530-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Roberto Nibali <ratz@tac.ch>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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

> It has nothing to do with the tcp-window-tracking patch. Without the patch
> you would get the same results.

Yes, you're right, I found it out too just a few hours ago.

> You send too big packets with the DF bit set, but you block the
> correspondig ICMP error messages (see the kernel log above) as well.

D'oh, apologies to the netfilter-devel list for this embarrassing posting.

>>Another problem is that I can work on the new session as long as the
>>things I do don't generate a certain size of packets.
>  
> Exactly.

I will crawl back to my corner and try it again.

Sorry for wasting your time,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq'|dc
