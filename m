From: Patrick McHardy <kaber@trash.net>
Subject: Re: Major problem with conntrack utility and kernel 2.6.14.3
Date: Mon, 05 Dec 2005 16:17:33 +0100
Message-ID: <43945A0D.8020500@trash.net>
References: <4361EAAB.1090206@fliegl.de> <436281BB.2010100@fliegl.de>
	<4392510A.3030400@eurodev.net>
	<200512041004.37192.romary@nikoon.com> <43934BC3.3090107@trash.net>
	<Pine.LNX.4.64.0512051115450.16776@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@eurodev.net>, Romary Sonrier <romary@nikoon.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0512051115450.16776@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> On Sun, 4 Dec 2005, Patrick McHardy wrote:
> 
>> Please try this patch, I hope it will fix the problems you're seeing.
>>
> 
> This patch also fixed my problem (kernel BUG at kernel/sched.c:2833).
> Thank you.
> 
> Is it possible that this patch and "Fix refcount leak
> ip_conntrack/nat_proto"
> (http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=00cb277a4a1fb76aafb2fb28aa99f30546e619c5)
> will go to next 2.6.14-stable kernel?

I'll submit them to -stable tonight.
