From: James King <t.james.king@gmail.com>
Subject: Re: Targets with "mangle" table limiting (Was: Re: Troubles with MARK
	target in 2.6.28)
Date: Sat, 17 Jan 2009 23:32:12 -0800
Message-ID: <38bcb3ec0901172332y55640cabx86d1200f68f11246@mail.gmail.com>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden>
	 <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr>
	 <496AEEB0.3080905@trash.net>
	 <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
	 <alpine.LSU.2.00.0901150855420.23894@fbirervta.pbzchgretzou.qr>
	 <38bcb3ec0901150408h39390a74s6fcc9f722094715d@mail.gmail.com>
	 <496F3E5A.9050607@trash.net>
	 <alpine.LSU.2.00.0901151744020.20619@fbirervta.pbzchgretzou.qr>
	 <38bcb3ec0901151438y6f688429y3d7b37e396792589@mail.gmail.com>
	 <49703F7F.8040603@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f12.google.com ([209.85.219.12]:57923 "EHLO
	mail-ew0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbZARHcO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Jan 2009 02:32:14 -0500
Received: by ewy5 with SMTP id 5so466676ewy.13
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2009 23:32:12 -0800 (PST)
In-Reply-To: <49703F7F.8040603@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 16, 2009 at 12:04 AM, Patrick McHardy <kaber@trash.net> wrote:
>>> Are there perhaps other targets besides MARK whose table restriction
>>> should be relaxed?
>>
>> Could TOS/DSCP just call ip_route_me_harder() directly when necessary
>> instead of relying on the mangle hook to do so?  This would allow it
>> to be used everywhere.
>
> That doesn't seem like a good idea. Rerouting should be an optional
> feature, available in the (misnamed) mangle table. There might be
> completely different reasons for changing DSCP. So making them available
> in other tables yes, making them responsible for rerouting no.

True, however, I was mainly thinking about the confusion that might
result if it becomes available in all tables.  For instance, someone
who relies on reroute after DSCP change (which is implicit on output)
accidentally omits the table specifier, causing the rule to default to
filter.  Or if mangle can be made entirely superfluous by
unrestricting all other targets, is there any sense in keeping it
around for a single target?  Maybe adding a new revision that allows
for explicit rerouting after the target action (such as
--set-dscp-and-reroute) might address this?
