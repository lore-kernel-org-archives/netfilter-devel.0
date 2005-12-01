From: Deti Fliegl <deti@fliegl.de>
Subject: Re: again oops: conntrack & 2.6.14-git14
Date: Thu, 01 Dec 2005 11:31:56 +0100
Message-ID: <438ED11C.4090508@fliegl.de>
References: <43760B97.9010603@fliegl.de>	<4380B5B1.9040506@trash.net>	<4384A904.4080700@fliegl.de>	<4388730A.2060003@trash.net>	<438877CE.2050305@fliegl.de>
	<4388F1F7.5060402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4388F1F7.5060402@trash.net>
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
> The crashes seem to be unrelated to conntrack. They all happen in
> show_trace+489 because of accesses to 0xffffffff82800000, which
> is the end of the kernel text mapping on x86_64. Your stress test
> seems to trigger the softlockup watchdog, which is why you are
> seeing these. I suggest you resend your report to lkml.
Then please explain to me why it does only happen when calling
'conntrack -L'. The system is 100% stable, there is no defective
hardware and no weird configuration. Under same conditions I can run 
kernel compilation jobs in a row...

Deti
