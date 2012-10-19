From: Iain Fraser <iainkfraser@gmail.com>
Subject: Re: netfilter hooks context?
Date: Fri, 19 Oct 2012 17:38:08 +0100
Message-ID: <CA+bLfK5KpWb_AB-7F1VEvJvfOjmR-HHDd2rb=C+1L=qP+0wFXA@mail.gmail.com>
References: <CA+bLfK6x6F5g_h+0ersDHmPDCH14LEaoHQDPOmBP-uCUjBC+bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47850 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2JSQiI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:38:08 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so924816iea.19
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Oct 2012 09:38:08 -0700 (PDT)
In-Reply-To: <CA+bLfK6x6F5g_h+0ersDHmPDCH14LEaoHQDPOmBP-uCUjBC+bg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After reading [A Map of the Networking Code in Linux Kernel 2.4.20]
and thinking about it. It seems to me that packets coming from the
host will often be in process context e.g. UDP packets will be
generated for each sendto syscall. So packets in the localout and
postrouing could potentially be in run in process context.

Therefore spin locks in those hooks should disable bottom halves to be
safe from deadlock. Can anyone confirm or invalidate this please?

cheers
Iain

On Fri, Oct 19, 2012 at 5:18 PM, Iain Fraser <iainkfraser@gmail.com> wrote:
> Hello,
>
> I'm writing a LKM that uses netfilter hooks. I thought that netfilter
> hooks were run in softirq context. So when using spinlocks in the
> hooks I use plain spin_lock and in any process context code e.g. proc
> I use spin_lock_bh. However my code occasionally deadlocks with this
> single lock.
>
> If the hooks were running in softirq context this wouldn't occur
> because softirq's don't preemept each other on the same processor. So
> now I'm wondering if my original softirq assumption was incorrect. Can
> a hook be called from NON softirq context?
>
> thanks in advance
> Iain
