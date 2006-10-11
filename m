From: robert <rbscott@cadvium.net>
Subject: Re: ipq and nf_queue compatibility
Date: Wed, 11 Oct 2006 11:56:34 -0700
Message-ID: <C15F0529-23F1-4953-BF4D-0CEEC3309473@cadvium.net>
References: <A204A2FA-BD7D-410F-B6AB-EB61B894DB28@cadvium.net>
	<452C8828.6000005@trash.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <452C8828.6000005@trash.net>
To: Patrick McHardy <kaber@trash.net>
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

is there any sequence that will insure both ipq and nfqueue work?   
should it just never unbind then?  I am a little unclear what the  
difference is between unregister and unbind?

--robert

On Oct 10, 2006, at 10:59 PM, Patrick McHardy wrote:

> robert wrote:
>> Hello,
>>
>> I am porting a program that uses IPQ to NF_QUEUE, and the port went
>> very smoothly, but I noticed that if I run the nfqueue version once,
>> the ipq version stops working.  The NF_QUEUE version always  
>> works,  but
>> the other one simple stops functioning.  Is there a known
>> incompatibility between the two?  Or perhaps is there some global   
>> state
>> that I need to cleanup inside of the NFQUEUE version before I   
>> execute
>> the IPQ version.  The kernel has both IPQ and NFQUEUE support.
>>
>> This happens regardless of whether or not I call the function
>> nfq_unbind_pf on exit.  Not really sure what that function does,  
>> but  it
>> was inside of nfqnl_test.c, so I tried it out.
>
> ip_queue only registeres itself when the module is loaded,
> nfnetlink_queue registeres when NFQNL_CFG_CMD_PF_BIND is
> received. So once ip_queue has been unregistered it never
> registeres again and doesn't receive any packets anymore.
>
