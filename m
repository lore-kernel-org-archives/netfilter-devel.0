From: Atle Solbakken <atle@goliathdns.no>
Subject: Re: netfilter hooks context?
Date: Fri, 19 Oct 2012 19:54:17 +0200
Message-ID: <508193C9.5070704@goliathdns.no>
References: <CA+bLfK6x6F5g_h+0ersDHmPDCH14LEaoHQDPOmBP-uCUjBC+bg@mail.gmail.com> <CA+bLfK5KpWb_AB-7F1VEvJvfOjmR-HHDd2rb=C+1L=qP+0wFXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Iain Fraser <iainkfraser@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail47.e.nsc.no ([193.213.115.47]:44468 "EHLO mail47.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758409Ab2JSSL2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:11:28 -0400
In-Reply-To: <CA+bLfK5KpWb_AB-7F1VEvJvfOjmR-HHDd2rb=C+1L=qP+0wFXA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Den 19. okt. 2012 18:38, skrev Iain Fraser:
> After reading [A Map of the Networking Code in Linux Kernel 2.4.20]
> and thinking about it. It seems to me that packets coming from the
> host will often be in process context e.g. UDP packets will be
> generated for each sendto syscall. So packets in the localout and
> postrouing could potentially be in run in process context.
>
> Therefore spin locks in those hooks should disable bottom halves to be
> safe from deadlock. Can anyone confirm or invalidate this please?
>
> cheers
> Iain
>
> On Fri, Oct 19, 2012 at 5:18 PM, Iain Fraser<iainkfraser@gmail.com>  wrote:
>> Hello,
>>
>> I'm writing a LKM that uses netfilter hooks. I thought that netfilter
>> hooks were run in softirq context. So when using spinlocks in the
>> hooks I use plain spin_lock and in any process context code e.g. proc
>> I use spin_lock_bh. However my code occasionally deadlocks with this
>> single lock.
>>
>> If the hooks were running in softirq context this wouldn't occur
>> because softirq's don't preemept each other on the same processor. So
>> now I'm wondering if my original softirq assumption was incorrect. Can
>> a hook be called from NON softirq context?
>>
>> thanks in advance
>> Iain
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hva you considered using RCU instead of locking?

Read about it here:

http://www.kernel.org/doc/Documentation/RCU/

Atle-
