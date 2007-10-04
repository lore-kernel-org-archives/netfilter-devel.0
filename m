From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] TCPOPTSTRIP target (netfilter)
Date: Thu, 04 Oct 2007 07:04:13 +0200
Message-ID: <4704744D.1070706@trash.net>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr> <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de> <87lkal1ucz.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0710021612590.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Sven Schnelle <sschnelle@astaro.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39895 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbXJDFEz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:04:55 -0400
In-Reply-To: <Pine.LNX.4.64.0710021612590.7130@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Oct 2 2007 16:09, Sven Schnelle wrote:
> 
>>Sven Schnelle <svens@bitebene.org> writes:
>>
>>
>>Ok, i've cleaned up the code and followed the suggestions here. I've
>>also added the possibility to strip more than one option from the Headers.
> 
> 
> Would be great if we could work on one patch :) [see below]


Indeed, that would be less confusing :) Please send the final
patch under new cover so I don't mix it up (its too late for
2.6.24 anyway, so no need to hurry).
