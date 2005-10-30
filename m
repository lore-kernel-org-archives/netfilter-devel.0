From: Deti Fliegl <deti@fliegl.de>
Subject: Re: iptables & new CONNMARK 32bit marks
Date: Sun, 30 Oct 2005 11:27:07 +0100
Message-ID: <43649FFB.6070200@fliegl.de>
References: <435D0456.60405@fliegl.de>
	<20051030094349.GZ4479@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051030094349.GZ4479@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
>>when using kernel 2.6.14rc5 the mark values have become 32bit but
>>latest iptables code still uses 64bit values. 
> 
> 
> It sends a 64bit value to the kernel, there's nothing wrong with that.
> The kernel is able to parse that.
> 
> 
>>This causes the kernel module to say "CONNMARK: Only supports 32bit
>>mark" 
> 
> 
> This should only happen if you actually specify a mark that is bigger
> than 0xffffffff.  
Yes you are right but if you are on a 64bit platform you might run into 
trouble with these initializations in libipt_connmark.c:

markinfo->mask = ~0UL or if(mask != ~0UL)

This will evaluate to 0xffffffffffffffff on a long variable. You should 
netter should use 0xffffffff than the hack above.

Further a #ifdef KERNEL_64_USERSPACE_32 version of the code does not 
make sense to me as 32bit will always be 32bit even on 64bit platforms :)

> Please post the specific rules in case of any doubt.
iptables -t mangle -A PREROUTING --proto tcp -j CONNMARK --restore-mark

Deti
