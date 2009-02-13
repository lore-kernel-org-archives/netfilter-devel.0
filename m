From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH] libxtables: Dont initialize global xt_params
Date: Fri, 13 Feb 2009 19:11:30 +0100
Message-ID: <4995B7D2.1030007@intra2net.com>
References: <1234448162.3271.1.camel@dogo.mojatatu.com>	 <200902121609.43664.thomas.jarosch@intra2net.com>	 <alpine.LSU.2.00.0902121612200.5658@fbirervta.pbzchgretzou.qr>	 <200902121641.54430.thomas.jarosch@intra2net.com> <1234532958.4078.10.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: hadi@cyberus.ca
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:60627 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbZBMSh6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:37:58 -0500
In-Reply-To: <1234532958.4078.10.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

jamal wrote:
> I have no objection with junking the patch i sent. My initial intent of
> NULLing was to use it as a check when first initializing - but now i
> realize it actually didnt matter; and the readability arguement sounds
> fair.

Thanks and have a nice weekend :-)

Thomas
