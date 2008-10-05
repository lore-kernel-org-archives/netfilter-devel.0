From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [NETFILTER]: Move extensions' arguments into compound structure
 (1/2)
Date: Sun, 5 Oct 2008 10:55:24 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051054460.21891@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr> <48E8CF70.9090309@trash.net> <alpine.LNX.1.10.0810051036170.21891@fbirervta.pbzchgretzou.qr> <48E8D493.5@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46944 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbYJEOzZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:55:25 -0400
In-Reply-To: <48E8D493.5@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 10:52, Patrick McHardy wrote:
>
> Reducing the overhead before merging will make me a lot more
> comfortable accepting this patch without seeing any numbers
> since its adding overhead to one of the hottest spots of ruleset
> evaluation.
>
Ok just let me rebase all the stuff, and I'll send you something
that goes on top of 8d51a66159a6fbc27342ee80e5b69910a679735e .

>> Yup. When space is tight (and we only have like 74 chars to make it
>> fit onto a screen, accounting for the git-log indent and one extra
>> byte), it will have to do without the subsystem.
>
> No, I'm adding it anyways and exceeding the limit is fine for
> changelogs if it aids in readability. So please just add it so
> I don't have to edit the descriptions every time.

Aye, sir!
