From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 10/27] xt_conntrack match, revision 1
Date: Fri, 4 Jan 2008 16:05:51 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801041603510.8731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
 <477E487D.8000901@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39435 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbYADPFw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:05:52 -0500
In-Reply-To: <477E487D.8000901@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 4 2008 15:53, Patrick McHardy wrote:
>
> Applied, but
>
>>  #include <linux/netfilter/nf_conntrack_tuple_common.h>
>> -#include <linux/in.h>
>> +#ifdef __KERNEL__
>> +#	include <linux/in.h>
>> +#endif
>
> Is that really necessary? I would prefer the only in-kernel user of this
> file to include it directly. Or simply include netfilter.h, which seems
> necessary for nf_inet_addr anyway.
>
With this #include, we grab the definition for 'struct in_addr'.

Yes it is necessary otherwise iptables fails to compile, because
struct in_addr is already sourced from netinet/in.h. If you have
a better idea, please share it.
Perhaps doing #include <linux/in.h> in xt_conntrack.c would resolve it.
I will see to that (if you do not already will take care of that) once I 
received your updated git tree.


thanks,
Jan
