From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: netfilter hooks context?
Date: Sat, 20 Oct 2012 09:54:54 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1210200949520.28376@nerf07.vanv.qr>
References: <CA+bLfK6x6F5g_h+0ersDHmPDCH14LEaoHQDPOmBP-uCUjBC+bg@mail.gmail.com> <CA+bLfK5KpWb_AB-7F1VEvJvfOjmR-HHDd2rb=C+1L=qP+0wFXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Iain Fraser <iainkfraser@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:58523 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab2JTHy4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2012 03:54:56 -0400
In-Reply-To: <CA+bLfK5KpWb_AB-7F1VEvJvfOjmR-HHDd2rb=C+1L=qP+0wFXA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-10-19 18:38, Iain Fraser wrote:

>After reading [A Map of the Networking Code in Linux Kernel 2.4.20]
>and thinking about it. It seems to me that packets coming from the
>host will often be in process context e.g. UDP packets will be
>generated for each sendto syscall. So packets in the localout and
>postrouing could potentially be in run in process context.

Indeed.

>Therefore spin locks in those hooks should disable bottom halves to be
>safe from deadlock. Can anyone confirm or invalidate this please?

According to Rusty's Unrealiable Guide To Locking, spin_lock_bh type 
locking is appropriate in your case.

http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/c214.html#AEN235
[note this is old, and for example does not contain the "mutex" type 
lock]
