From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: NF [PATCH 3/4] xt_TCPOPTSTRIP
Date: Tue, 27 Nov 2007 15:50:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711271549260.20371@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252006330.9477@fbirervta.pbzchgretzou.qr>
 <474A74C5.8050609@trash.net> <Pine.LNX.4.64.0711261718440.22369@fbirervta.pbzchgretzou.qr>
 <474AF214.4090301@trash.net> <Pine.LNX.4.64.0711261724100.22369@fbirervta.pbzchgretzou.qr>
 <474C0F79.6050105@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sven Schnelle <svens@bitebene.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47885 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbXK0Oue (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 09:50:34 -0500
In-Reply-To: <474C0F79.6050105@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 27 2007 13:37, Patrick McHardy wrote:
>> >     
>> > > If you quilt/stgit, just replace the patch.
>> > >       
>> > What are the changes?
>> >     
>> The name unification thing is one thing for sure. A diff would tell.
>
> I merged the parts that make sense. This is the patch I have queued now.
>
Looks fine, thanks.
BTW, what are the criteria that cause the tcpoptstrip_tg6 to be wrapped
into a #ifdef CONFIG_IP6_NF_TABLES?
