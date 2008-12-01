From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] More secure SYSRQ for xtables-addons
Date: Mon, 1 Dec 2008 23:37:58 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812012329140.22349@fbirervta.pbzchgretzou.qr>
References: <492E926D.5020807@oracle.com> <alpine.LNX.1.10.0812011952520.17726@fbirervta.pbzchgretzou.qr> <49345EE4.3070409@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58294 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYLAWiB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:38:01 -0500
In-Reply-To: <49345EE4.3070409@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-12-01 23:02, John Haxby wrote:
>>   
>> > +	for (i = 0; sysrq_password[i]; i++)
>> > +		if (sysrq_password[i] == '\n')
>> >     
>> +|| sysrq_password[i] == '\0'
>>
>> (assuming that echoing into string module parameters at least adds a \0)
>>   
> I think it does this anyway doesn't it?  The "sysrq_password[i]" loop test
> stops at the '\0'

Oh drats, I did not see that. That's why I prefer explicit zero tests
everywhere (except bools, because they are bools, and not
integers/pointers), e.g.

	for (i = 0; sysrq_password[i] != '\0'; ++i)

Also, \n could be simply tested for by adding it to the for condition:

	for (i = 0; sysrq_password[i] != '\0' &&
	     sysrq_password[i] != '\n'; ++i)
		/* loop */;

Turns out doing so saves 7 bytes on i586 ;-)
