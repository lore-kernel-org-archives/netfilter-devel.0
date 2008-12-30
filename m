From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libxt_rateest: fix segfault
Date: Tue, 30 Dec 2008 12:05:32 +0100
Message-ID: <495A007C.4020605@netfilter.org>
References: <alpine.LNX.1.10.0812081818050.2016@fbirervta.pbzchgretzou.qr> <493E7B1D.7030003@trash.net> <alpine.LNX.1.10.0812242015110.8067@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49356 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752302AbYL3LFs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Dec 2008 06:05:48 -0500
In-Reply-To: <alpine.LNX.1.10.0812242015110.8067@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> parent cea9f71f5618250a38acb21c31fbbf93a752f7d4
> commit e2ac8eed9cd24bfabedb931c854ab7e0c9de5fd1
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Dec 24 20:15:44 2008 +0100
> 
> rateest: guard against segfault

Applied. Thanks Jan.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
