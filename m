From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Wed, 4 Nov 2009 10:45:46 +0100
Message-ID: <200911041045.46239.thomas.jarosch@intra2net.com>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <200911040942.10905.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0911041027230.10500@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:47638 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbZKDJpn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:45:43 -0500
In-Reply-To: <alpine.LSU.2.00.0911041027230.10500@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday, 4. November 2009 10:27:56 you wrote:
> >> Transfer via IPT_SO_... still uses host order.
> >
> >From the new code:
> >
> >xt_ACCOUNT.c: ipt_acc_handle_copy_data():
> >handle_ip.ip = htonl(net_ip | net_OR_mask | i);
> >
> >This really looks like network order for
> >the kernel -> userspace transfer.
> 
> Blame that on the original submission, which changed that ;-)

Would you bet on it? ;)
