From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] Per-conntrack timeout target v3
Date: Fri, 04 Jan 2008 15:23:11 +0100
Message-ID: <477E414F.9080208@trash.net>
References: <20071127190745.GA2080@linuxace.com> <474D2F88.5050707@trash.net> <20071217212010.GA23837@linuxace.com> <Pine.LNX.4.64.0712172228060.32270@fbirervta.pbzchgretzou.qr> <20071217220100.GA24118@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48059 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYADO0N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:26:13 -0500
In-Reply-To: <20071217220100.GA24118@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> On Mon, Dec 17, 2007 at 10:28:49PM +0100, Jan Engelhardt wrote:
>>> In thinking about this, it seems like a HELPER target would be
>>> useful, for instance if some random FTP server ran on a non-standard
>>> port and we wanted the FTP helper to be used.  Something like:
>>>
>>>    -s X -p 210 -j HELPER --helper ftp
>> BTW, the helper code is said to already do that (man iptables):
>>
>> 	--helper ftp-2121
> 
> Actually that's for the helper _match_, so you could for instance
> match packets which are part of a helper configured on a non-standard
> port via module parameter.  So this is different, in that it would
> allow you to specify non-standard ports at runtime.

One of the really nice things about this is that it makes helpers
explicit. I never liked the automatic tracking very much since
helpers effectively change your ruleset, and there isn't even a
way to disable them selectively besides blocking connections
completely.
