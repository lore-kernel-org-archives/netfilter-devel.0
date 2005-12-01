From: Patrick McHardy <kaber@trash.net>
Subject: Re: again oops: conntrack & 2.6.14-git14
Date: Thu, 01 Dec 2005 12:09:00 +0100
Message-ID: <438ED9CC.8030908@trash.net>
References: <43760B97.9010603@fliegl.de>	<4380B5B1.9040506@trash.net>	<4384A904.4080700@fliegl.de>	<4388730A.2060003@trash.net>	<438877CE.2050305@fliegl.de>	<4388F1F7.5060402@trash.net>
	<438ED11C.4090508@fliegl.de> <438ED327.8030509@trash.net>
	<438ED4B8.90506@fliegl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <438ED4B8.90506@fliegl.de>
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

Deti Fliegl wrote:
> Patrick McHardy wrote:
> 
>> See above. It seems to trigger the softlockup watchdog for some reason,
>> which calls show_trace, which is where the crash happens.
> 
> Yes you are right - but if this kernel debugging feature is disabled, 
> then I get some "aieee killing in interrupt handler" without any call 
> trace. This is somehow really weird...

Yes, thats weird. Its also strange that it triggers the softlockup
watchdog at all, there shouldn't be delays long enough. Looking
at your other mails, you had at least one crash that looks totally
different. Are you sure your memory and other hardware is fine?
