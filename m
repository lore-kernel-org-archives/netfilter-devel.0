From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Allow MARK in other tables?
Date: Wed, 14 Nov 2007 12:01:23 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711141157310.24744@fbirervta.pbzchgretzou.qr>
References: <20071107163647.GA5874@hornet.din.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: krcmar@datinel.cz
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42707 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXKNLBZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:01:25 -0500
In-Reply-To: <20071107163647.GA5874@hornet.din.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 7 2007 17:36, krcmar@datinel.cz wrote:
>
>I am sorry for what could be a stupid question, but _why_ is the MARK
>target allowed only within the `mangle' table? It does _not_ alter the
>packet in any way (which I suppose is the reason for all the mangling
>targets to be limited to the mangle table, e. g. destroying checksums).

Yes, it's bad, and has been brought up a number of times.
http://lkml.org/lkml/2007/10/12/176 if you like to jump in.

>I need some information from tests being performed in the `raw'
>table to be reused in other tables, and the mark associated with packet
>seems to me to be the only place to note the information. Am I right?

You could (ab)use CONNMARK, or modify the MARK code so that it allows
it to set the mark from elsewhere.
