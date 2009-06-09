From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Notification of new BZ entries
Date: Tue, 09 Jun 2009 16:23:26 +0200
Message-ID: <4A2E705E.3090106@netfilter.org>
References: <alpine.LSU.2.00.0906082341230.3946@fbirervta.pbzchgretzou.qr> <4A2E4123.7030608@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41565 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbZFIOXh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:23:37 -0400
In-Reply-To: <4A2E4123.7030608@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Dear co-developers,
>>
>> the netfilter bugzilla currently by default still assigns new
>> entries to laforge.
>>
>> Unfortunately this means there will be no notification to
>> $current_developer_set, and entries be missed. I try to regularly
>> sweep along to catch new entries, but sometimes I forget.
>> Since the amount of new entries in BZ is really low, could not BZ be
>> set up to throw a mail to nf-dev whenever a new item gets created?
> 
> We do have a bugzilla list for that already. The default should
> be changed anyways of course, but I thought Pablo already did that?

I'll fix this to assign all the bugs to the nf-bugzilla mailing list.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
