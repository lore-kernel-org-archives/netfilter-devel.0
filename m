From: Patrick McHardy <kaber@trash.net>
Subject: Re: again oops: conntrack & 2.6.14-git14
Date: Sun, 27 Nov 2005 00:38:31 +0100
Message-ID: <4388F1F7.5060402@trash.net>
References: <43760B97.9010603@fliegl.de>	<4380B5B1.9040506@trash.net>	<4384A904.4080700@fliegl.de>	<4388730A.2060003@trash.net>
	<438877CE.2050305@fliegl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <438877CE.2050305@fliegl.de>
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
> Well sorry for having a 64bit system. This is my stresstest script:

The crashes seem to be unrelated to conntrack. They all happen in
show_trace+489 because of accesses to 0xffffffff82800000, which
is the end of the kernel text mapping on x86_64. Your stress test
seems to trigger the softlockup watchdog, which is why you are
seeing these. I suggest you resend your report to lkml.
