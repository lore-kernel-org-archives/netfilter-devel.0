From: Vinod Chandran <vinod_chandran@multitech.co.in>
Subject: Re: Usage of CONNMARK
Date: Mon, 07 Feb 2005 09:46:53 +0530
Message-ID: <4206EBB5.5090001@multitech.co.in>
References: <42032EC5.4090303@multitech.co.in>
	<Pine.LNX.4.61.0502041515360.10050@filer.marasystems.com>
	<42047777.3030102@multitech.co.in>
	<Pine.LNX.4.61.0502060136540.22104@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Henrik,

In case of partail request, too I found the packets where not dropping. 
I had checked it by using nf-drill.pl, given in the FTP advisory. Modify 
the script to give a partial PORT command. The packet goes across the 
firewall and reaches the FTP server. I have connected my FTP server to 
DMZ and running the script from the LAN side.
Setting connection mark does work, but for the next packet and not the 
current one.

Thanks and Regards,
Vinod C

Henrik Nordstrom wrote:

> On Sat, 5 Feb 2005, Vinod Chandran wrote:
>
>> Currently, from the FTP helper if DROP is given, the packets are not 
>> getting dropped since the conntrack entry exists and also since from 
>> where the helper routine is called, there is no check for return 
>> value of NF_DROP. Hence when NF_DROP is returned, inside 
>> ip_conntrack_in, I set the conntrack value
>>      ct->mark = 1
>> However this CONNMARK value is getting applicable only from the next 
>> packet ownwards.
>
>
> I do not follow. Conntract helpers can return NF_DROP to drop the 
> packets, and this will cause the packet to be dropped. This is 
> actively used today by the FTP helper when an partial request is 
> received.
>
>> From ip_conntrack_in:
>
>
>         if (ret != NF_DROP && ct->helper) {
>                 ret = ct->helper->help(*pskb, ct, ctinfo);
>     [...]
>
>     return ret;
> }
>
>> If on the other hand, say I try to change the mark value, 
>> (*pskb)->nfmark ( I assume it contains the MARK indicator), and put a 
>> rule in the KEEP_STATE_FORWARD chain to drop packets with the 
>> specific mark value, the kernel is panicing , with a BUG in sched.c. 
>> I also get panic if I call nf_conntrack_put.
>
>
> Setting the nfmark like this (MARK) should work, and should not panic 
> your system.
>
> In addition, setting the connection mark from helpers called in 
> ip_conntrack_in should be available in all iptables chains.
>
>
> All three of your problems makes no sense to me. All should work 
> (return NF_DROP from helpers, setting the connection mark, setting the 
> nfmark).
>
> Regards
> Henrik
>
