From: Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCHv2] netfilter: audit target to record accepted/dropped packets
Date: Fri, 14 Jan 2011 14:24:10 -0500
Message-ID: <AANLkTik8wzag7TtvdqeZOecSeNcbWnO=fid3q0n5N4t_@mail.gmail.com>
References: <20110114152024.GA9654@canuck.infradead.org>
	<4D306FBB.8020705@trash.net>
	<20110114161937.GA22101@canuck.infradead.org>
	<20110114165937.GA5759@canuck.infradead.org>
	<4D309B4D.2010701@googlemail.com>
	<alpine.LNX.2.01.1101142017410.30008@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
	Al Viro <viro@zeniv.linux.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65484 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167Ab1ANTYL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:24:11 -0500
Received: by iyj18 with SMTP id 18so2799422iyj.19
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jan 2011 11:24:10 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1101142017410.30008@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 14, 2011 at 2:18 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
 (The reason for audit's existence still eludes me..)

audit exists because a very large number of gov't customers (Not just
USA) have special requirements about how 'relevant' information is
gathered and stored.  They require centralization and standardization
and require pretty formal documentation describing it's operation.
The gov't certification authority has recently added a requirement
that they be able to log 'illegal attempted network connections' via
the approved audit facility.  Thus, this patch.

-Eric
