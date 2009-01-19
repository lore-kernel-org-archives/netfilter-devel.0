From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables-restore: remove unused --binary flag
Date: Mon, 19 Jan 2009 21:20:02 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901192119330.12940@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0812242031570.514@fbirervta.pbzchgretzou.qr> <495A0123.3020509@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50023 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZASUUD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:20:03 -0500
In-Reply-To: <495A0123.3020509@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-12-30 12:08, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Wed Dec 24 20:30:47 2008 +0100
>> 
>> iptables-restore: remove unused --binary flag
>> 
>
>I doubt that someone is using this option, anyhow I think that it would
>be better to output a warning message to stderr that says "-b is
>deprecated, fix your scripts". Later, we can remove it.

Requesting comments from Patrick.
