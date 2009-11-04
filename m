From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Wed, 4 Nov 2009 10:27:56 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911041027230.10500@obet.zrqbmnf.qr>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <200910301707.05490.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0910301737320.8401@obet.zrqbmnf.qr> <200911040942.10905.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33983 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbZKDJ1w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:27:52 -0500
In-Reply-To: <200911040942.10905.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-11-04 09:42, Thomas Jarosch wrote:
>On Friday, 30. October 2009 18:49:21 you wrote:
>
>> Transfer via IPT_SO_... still uses host order.
>
>From the new code:
>
>xt_ACCOUNT.c: ipt_acc_handle_copy_data():
>handle_ip.ip = htonl(net_ip | net_OR_mask | i);
>
>This really looks like network order for
>the kernel -> userspace transfer.

Blame that on the original submission, which changed that ;-)
