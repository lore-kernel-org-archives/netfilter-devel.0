From: Vinod Chandran <vinod_chandran@multitech.co.in>
Subject: Re: Usage of CONNMARK
Date: Sat, 05 Feb 2005 13:06:23 +0530
Message-ID: <42047777.3030102@multitech.co.in>
References: <42032EC5.4090303@multitech.co.in>
	<Pine.LNX.4.61.0502041515360.10050@filer.marasystems.com>
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

Hi,
 
Currently, from the FTP helper if DROP is given, the packets are not 
getting dropped since the conntrack entry exists and also since from 
where the helper routine is called, there is no check for return value 
of NF_DROP. Hence when NF_DROP is returned, inside ip_conntrack_in, I 
set the conntrack value
       ct->mark = 1
 However this CONNMARK value is getting applicable only from the next 
packet ownwards.

If on the other hand, say I try to change the mark value, 
(*pskb)->nfmark ( I assume it contains the MARK indicator), and put a 
rule in the KEEP_STATE_FORWARD chain to drop packets with the specific 
mark value, the kernel is panicing , with a BUG in sched.c. I also get 
panic if I call nf_conntrack_put.

The problem in my case, is the error is detected after the conntrack 
state is changed. I am wondering whether this is the reason why its 
causing all the problems.

Thanks,
Vinod C

Henrik Nordstrom wrote:

> On Fri, 4 Feb 2005, Vinod Chandran wrote:
>
>> I am using the CONNMARK patch.
>> Inside conntrack_core, in case of special conditions, I have modified 
>> the mark value in the conntrack.
>
>
> When in conntrack is this modification done?
>
>> However this CONNMARK value is getting effective only for the next 
>> packet and not for the same packet.
>
>
> The connmark match looks at the connection mark value at the time the 
> connmark match is evaluated.
>
>> Is there some way by which, I can make the settings applicable to the 
>> same packet itself?
>
>
> It is, assuming it's done before you need to evaluate the match.
>
> Regards
> Henrik
>
