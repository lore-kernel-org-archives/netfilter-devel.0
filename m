From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Wed, 4 Nov 2009 09:42:10 +0100
Message-ID: <200911040942.10905.thomas.jarosch@intra2net.com>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <200910301707.05490.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0910301737320.8401@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:36189 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZKDImJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:42:09 -0500
In-Reply-To: <alpine.LSU.2.00.0910301737320.8401@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Jan,

On Friday, 30. October 2009 18:49:21 you wrote:
> >What do you think?
> 
> I think it is a non-issue, because all three of libxt_ACCOUNT,
> xt_ACCOUNT.ko and iptaccount are updated at the same time.
> Especially so if you are an Xtables-addons user!

Yes, though this would break external applications that use
libxt_ACCOUNT as they expect the data to be in host order.
Not everyone is just using the command line "iptaccount" tool.

> I will bump the .revision too so that the chance of accidental
> collisions is lowered.

Ok

> Transfer via IPT_SO_... still uses host order.

>From the new code:

xt_ACCOUNT.c: ipt_acc_handle_copy_data():
handle_ip.ip = htonl(net_ip | net_OR_mask | i);

This really looks like network order for
the kernel -> userspace transfer.

-> Breakage for libxt_ACCOUNT library users.

> And I went through the source and annotated it with appropriate __be
> markers plus a htonl->ntohl fix.

Thanks!

Cheers,
Thomas
