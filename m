From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070707 kernel
Date: Fri, 13 Jul 2007 18:09:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707131809070.25352@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707131658590.25352@fbirervta.pbzchgretzou.qr>
	<4697945A.8090806@trash.net>
	<Pine.LNX.4.64.0707131710150.25352@fbirervta.pbzchgretzou.qr>
	<200707131544.l6DFivSf011446@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707131544.l6DFivSf011446@toshiba.co.jp>
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


On Jul 14 2007 00:44, Yasuyuki KOZAKAI wrote:
>> Yes of course.
>> 
>> #define _init __attribute__((constructor)) my_init
>> 
>> That's exactly the same as before (for the NO_SHARED_LIBS=0 case).
>> For NO_SHARED_LIBS=1, _init is replaced by connlimit_init instead. Also ok.
>> Well, connlimit_init is not that far from libipt_connlimit_init,
>> and I'd prefer the latter because the former is already used for
>> 
>>   .init = connlimit_init,
>
>It's unnecessary to change it. _init is replaced by ipt_connlimit_init, not
>connlimit_init for NO_SHARED_LIBS=1. That's why I could compile connlimit
>match without error.

Very good.
Thank you for the NO_SHARED_LIBS test.



	Jan
-- 
