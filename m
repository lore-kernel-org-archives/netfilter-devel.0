From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4] Fix expectaction mask dumping, take #3
Date: Tue, 21 Feb 2006 14:03:54 +0100
Message-ID: <43FB0FBA.4060609@netfilter.org>
References: <43EFF176.3070505@netfilter.org> <43F44794.1080203@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43F44794.1080203@trash.net>
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

Hi Patrick,

Patrick McHardy wrote:
>>Besides, this modification introduces the attribute CTA_IP_L3NUM.
>>Although the layer 3 protocol information is sent in the nfnetlink
>>header, if the message contains information about an expectation, it
>>will contain information about the master conntrack (just one of the
>>tuples), the expectation tuple and the expectation mask. In this case,
>>the value of l3num in the expectation mask is not the same that is set
>>in the nfnetlink message. That is why we need another field that contain
>>the value of l3num.
> 
> I'm not sure I understand. The new attribute still contains the same
> value as the netlink header, doesn't it? So userspace should currently
> have at least two possibilities to get the correct value:
> 
> - use the value from the netlink header
> - use the value from the tuple that comes with the mask, as the first
>   part of your patch does. This seems most logically to me since the
>   mask and the tuple belong together.

The problem is that currently the expectation mask is not dumped.
find_l3proto returns the generic protocol handler for 0xFF, and that
doesn't dump any layer 3 information. Moreover, the expectation mask has
l3num value that is different from the l3num in the nfnetlink header,
that's why I introduced this field.

I can send a patch to remove the expectation mask dumping but I'm not
sure if this information could be useful for userspace helpers. Harald?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
