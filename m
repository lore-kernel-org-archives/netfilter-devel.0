From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Owner match misnaming
Date: Mon, 11 Jul 2005 20:44:32 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507112044190.17095@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0507111401170.14796@yvahk01.tjqt.qr>
	<datno8$gft$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <datno8$gft$1@sea.gmane.org>
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


>> BTW,
>>           /* files->file_lock can not be used in a BH */
>> a BH is a buffer head, at least in the linux kernel...
>
>I think BH means bottom-half, referring to the work-side of an
>interrupt. I read
>http://library.n0i.net/linux-unix/administration/unreliable-guides/kernel-locking/lklockingguide.html
>or http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/

Any way to fix it?



Jan Engelhardt
-- 
