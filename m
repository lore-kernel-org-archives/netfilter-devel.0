From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: secctx support for conntrack-tools [was Re: [PATCH 0/3][RFC] Relationship
 between conntrack and firewall rules]
Date: Fri, 21 Jan 2011 10:58:47 +0100
Message-ID: <4D3958D7.8010706@netfilter.org>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <4D38CD9F.1040905@googlemail.com> <201101210110.38451.richard@nod.at> <4D38CFA0.9080407@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Richard Weinberger <richard@nod.at>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51059 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab1AUJ6v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:58:51 -0500
In-Reply-To: <4D38CFA0.9080407@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21/01/11 01:13, Mr Dash Four wrote:
> 
>> SELinux is disabled on my box.
>>   
> Still, isn't it supposed to show secctx=0 (or was it secctx=-1) if
> SELinux is in permissive/disabled mode?

The support is here:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_conntrack.git;a=commit;h=fdda1474cc8654430f245b7f01c30e8ff171fa60

Please, Mr Dash Four, this thread clearly has no relationship with the
issue that you're commenting. So you're violating the mailing list rules.

Open a new thread, otherwise you confuse people (as it is happening now).
