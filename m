From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Thu, 5 Nov 2009 17:06:46 +0100
Message-ID: <200911051706.46071.thomas.jarosch@intra2net.com>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <200911041045.46239.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0911042337570.19869@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:58575 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbZKEQGn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:06:43 -0500
In-Reply-To: <alpine.LSU.2.00.0911042337570.19869@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday, 4. November 2009 23:38:03 Jan Engelhardt wrote:
> >> >This really looks like network order for
> >> >the kernel -> userspace transfer.
> >>
> >> Blame that on the original submission, which changed that ;-)
> >
> >Would you bet on it? ;)
> 
> No, but I can fix it anyway.

Thanks for fixing it! I'll port your changes to my tree (including proper 
credits) the next days and will give the new code a test run.
Leonardo Secci will also test the changes on a big endian box.

Cheers,
Thomas
