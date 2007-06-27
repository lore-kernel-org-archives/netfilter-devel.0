From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_account / iptables 1.3.8
Date: Wed, 27 Jun 2007 21:39:37 +0200
Message-ID: <4682BCF9.6040100@trash.net>
References: <1182962627.16585.6.camel@localhost>	<4682A981.3090608@plouf.fr.eu.org>
	<4682ACE2.8020606@blue-labs.org>
	<Pine.LNX.4.64.0706272059590.11120@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	David Ford <david@blue-labs.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706272059590.11120@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> Uhm, please add a reference next time; only by chance I found the thread origin
> at the netfilter@ list.
>
> No idea why TARPIT got removed. Maybe it's "unmaintained", but it did not need
> a lot of maintenance either. Though, people had to patch their kernel.
>
> There is no replacement for TARPIT - it's solid. (And xt_DELUDE does not
> replace it; it is something inbetween REJECT and TARPIT.)


Maintenance is only one aspect, but it is a problem since we can't
even compile test it without patching our kernels. A second problem
with most of these matches and targets is that they usually have a
broken non-64 bit clean ABI and if we decide to merge them someday
we need to fix that and thereby break compatibility before it was
even included in the kernel, which is ridiculous.

They should have never gotten into a release and we fixed that now.
You can still patch your kernel and iptables as you like.
