From: Peteris Krumins <newsgroups@lf.lv>
Subject: Re[2]: ip_queue, is this safe:
Date: Sun, 3 Aug 2003 00:33:58 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <8229894986.20030803003358@lf.lv>
References: <Mutt.LNX.4.44.0308020114120.29556-100000@excalibur.intercode.com.au>
Reply-To: Peteris Krumins <newsgroups@lf.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Mutt.LNX.4.44.0308020114120.29556-100000@excalibur.intercode.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Friday, August 1, 2003, 6:25:18 PM, you wrote:

JM> On Fri, 1 Aug 2003, Peteris Krumins wrote:

>>   i am doubting:
>>   tcp = (struct tcphdr *)(packet->payload + ip->ihl*4);

JM> To start with, this pointer arithmetic is incorrect, you need something 
JM> like:

JM>         tcph = (void *) iph + iph->ihl * 4;

>> 
>>   because ip->ihl could be faked, couldnt it? The packet would get queued
>>   and if ip->ihl is something faked, using the tcp pointer i'd get a
>>   segfault, wouldn't i?

JM> The kernel drops received packets with a too-large ihl before the
JM> prerouting hook.  For locally generated packets of this type (e.g. root is
JM> playing games with raw sockets), iptables 'accepts' them without 
JM> traversing any more rules on the chain -- they won't make it to the 
JM> QUEUE target.

JM> You will however need to validate any transport+ header lengths against 
JM> the length of the packet.


Thanks for the answer!


P.Krumins
