From: Deti Fliegl <deti@fliegl.de>
Subject: Re: again oops: conntrack & 2.6.14-git14
Date: Thu, 01 Dec 2005 11:47:20 +0100
Message-ID: <438ED4B8.90506@fliegl.de>
References: <43760B97.9010603@fliegl.de>	<4380B5B1.9040506@trash.net>	<4384A904.4080700@fliegl.de>	<4388730A.2060003@trash.net>	<438877CE.2050305@fliegl.de>	<4388F1F7.5060402@trash.net>
	<438ED11C.4090508@fliegl.de> <438ED327.8030509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <438ED327.8030509@trash.net>
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

Patrick McHardy wrote:
> See above. It seems to trigger the softlockup watchdog for some reason,
> which calls show_trace, which is where the crash happens.
Yes you are right - but if this kernel debugging feature is disabled, 
then I get some "aieee killing in interrupt handler" without any call 
trace. This is somehow really weird...

Deti
