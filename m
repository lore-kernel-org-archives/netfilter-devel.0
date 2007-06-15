From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_gateway 20070605 (kernel)
Date: Fri, 15 Jun 2007 21:21:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706152112000.32724@fbirervta.pbzchgretzou.qr>
References: <200706151843.l5FIhLv18998@server1.secure-linux-server.com>
	<4672CC03.9070906@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4672CC03.9070906@trash.net>
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


On Jun 15 2007 19:27, Patrick McHardy wrote:
>> I am not certain that my anticpated crashes are actually possible.
>> 
>> Patrick, If I merely remove these unnecessary tests, will you be satisfied with the result?
>
>
>Probably, I don't have the patch handy to look at it right now.

https://dev.computergmbh.de/svn/misc_kernel/xt_gateway/trunk/
You can choose either bare files (kernel/) or patch-based (patches/),
depending on your review taste :-)

>So far I don't intend to merge it, but I'm also not very opposed
>to it (only reason against it is that its another file to take
>care of when changing say function signatures and it doesn't
>offer anything that we can't already do). Its up to you to
>convince me :)



	Jan
-- 
