From: "James King" <t.james.king@gmail.com>
Subject: Re: Targets with "mangle" table limiting (Was: Re: Troubles with MARK target in 2.6.28)
Date: Thu, 15 Jan 2009 04:08:38 -0800
Message-ID: <38bcb3ec0901150408h39390a74s6fcc9f722094715d@mail.gmail.com>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden>
	 <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net>
	 <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr>
	 <496AEEB0.3080905@trash.net>
	 <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
	 <alpine.LSU.2.00.0901150855420.23894@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Patrick McHardy" <kaber@trash.net>,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:51350 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764177AbZAOMIk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:08:40 -0500
Received: by ewy10 with SMTP id 10so1225202ewy.13
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2009 04:08:38 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0901150855420.23894@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 15, 2009 at 12:06 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
> Namely that MARK.2 is available for all tables. It looks like an error,
> given that the previous ones were all limited to the mangle table.
> But, I would have to ask - what do we gain from limiting it to mangle?
> All other *MARK targets are available for all tables too, so what was
> the original reason for the table limit?
>
> I could imagine it having to do with routing (nfmark can be used as
> a routing key, as can TOS/DSCP):
>
>>target TOS             1       mangle  IPv4    *       *            2
>>target TOS             0       mangle  IPv4    *       *            1
>>target DSCP            0       mangle  IPv4    *       *            1
>
> then again, MARK has more uses than just for routing; it can, for example,
> serve as a way to reduce the number of rules by remembering some previous
> result.
> What do others think?

The only place I can see in the mangle table where nfmark has any
special consideration is in ipt_local_hook(), in case the local output
packet needs to be rerouted, but it seems a bit heavy handed to
restrict MARK there based on that one edge case.  It might be useful
to have it available elsewhere, for example to be able to refine the
mark as it passes through the different tables, especially now that
the mark is maskable.
