From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables return code 256
Date: Fri, 20 Feb 2009 23:10:24 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902202305340.14936@fbirervta.pbzchgretzou.qr>
References: <gnn43d$647$1@ger.gmane.org> <alpine.LSU.2.00.0902202134350.11155@fbirervta.pbzchgretzou.qr> <gnn92e$ln9$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ralf <rm@amitrader.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:32910 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZBTWK0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:10:26 -0500
In-Reply-To: <gnn92e$ln9$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-02-20 22:58, Ralf wrote:
> Jan Engelhardt wrote:
>> On Friday 2009-02-20 21:33, Ralf wrote:
>>
>>> Sometimes an insert operation (-I) fails and iptables returns 256.
>>> Under which circumstances can iptables give a return code 256 ?
>>
>> Never should this happen, because the lower 8 bits of 256 that
>> make up the exist status are 0 actually.
>> Or where do you see 256?
[I thought about $? first...]
>
> int rc = system(sz);    // sz="iptables ..."
>
> rc is sometimes definitely 256 !
>
> What does it mean?

Humph humph, this is not a C forum!

man 3 system:

RETURN VALUE
       The value returned is -1 on  error  (e.g.   fork(2)  failed),  and  the
       return  status  of the command otherwise.  This latter return status is
       in the format specified in wait(2).  Thus, the exit code of the command
       will  be  WEXITSTATUS(status).   In case /bin/sh could not be executed,
       the exit status will be that of a command that does exit(127).
