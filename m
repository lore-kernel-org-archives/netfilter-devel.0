From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libxtables: prefix names and order it #2
Date: Sun, 01 Feb 2009 22:38:40 +0100
Message-ID: <49861660.1070709@netfilter.org>
References: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0901271511190.13940@fbirervta.pbzchgretzou.qr> <49860C6C.8070805@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, jamal <hadi@cyberus.ca>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57534 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752323AbZBAVit (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Feb 2009 16:38:49 -0500
In-Reply-To: <49860C6C.8070805@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Jan Engelhardt wrote:
>> diff --git a/ip6tables-restore.c b/ip6tables-restore.c
>> index a84c2e3..097711f 100644
>> --- a/ip6tables-restore.c
>> +++ b/ip6tables-restore.c
>> @@ -12,6 +12,7 @@
>>  
>>  #include <getopt.h>
>>  #include <sys/errno.h>
>> +#include <stdbool.h>
>>  #include <string.h>
>>  #include <stdio.h>
>>  #include <stdlib.h>
> 
> Aie. I was reverting this C99-specific thing but then I have noticed
> that there's already one reference to it in the tree. I'm going to
> revert it.
> 
> This break the compilation in many existing setups (like some of mine)
> that don't have the stdbool.h header. BTW, iptables is being compiled
> with gcc89 dialect, at least by now.

Forget this. gnu89 contains some c99 extensions like bool so this is
fine. I was confused by one problem spot in the compilation of iptables
in my setup. I have applied this patch. Thanks Jan.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
