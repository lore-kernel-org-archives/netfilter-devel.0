From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 08/24] [NETFILTER]: rename NF_ARP to AF_ARP and assign
 a non-clashing value
Date: Thu, 3 Apr 2008 15:07:30 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804031444200.1301@fbirervta.pbzchgretzou.qr>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <846a3697441043b20a99abac8046aad205938256.1207134547.git.jengelh@computergmbh.de> <47F4C686.2000700@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60654 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYDCNHb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:07:31 -0400
In-Reply-To: <47F4C686.2000700@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-04-03 13:59, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>>  For coming Xtables patches, we want to use AF_UNSPEC, but NF_ARP
>>  currently evaluates to the same value so it gets changed.
>>
>>  --- a/include/linux/socket.h
>>  +++ b/include/linux/socket.h
>>  @@ -179,6 +179,7 @@ struct ucred {
>>   #define AF_ASH		18	/* Ash				*/
>>   #define AF_ECONET	19	/* Acorn Econet			*/
>>   #define AF_ATMSVC	20	/* ATM SVCs			*/
>>  +#define AF_ARP		21	/* Address Resolution for IPv4	*/
>
> Did you make sure this value wasn't ever used by something else?

There are no traces of 21 in the entire history [/nico/archive.git,
/tglx/history.git].

> Is this used by userspace? If not, why change it?

Change, because NF_ARP is used to wrongly index into xt_afinfo -- it
overlaps with PF_UNSPEC. Since NF_ARP is only used very internally in
the kernel, it can be changed. To avoid problems, PF_ARP gets a
proper slot.
