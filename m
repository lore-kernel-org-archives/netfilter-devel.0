From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCHv3 2/2][RESEND] Addrtype match extension: limit addrtype
 check on the packet's interface
Date: Fri, 16 Nov 2007 18:53:46 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711161853130.21235@fbirervta.pbzchgretzou.qr>
References: <119514685071-git-send-email-panther@balabit.hu>
 <11952229272161-git-send-email-panther@balabit.hu>
 <Pine.LNX.4.64.0711161604060.3340@fbirervta.pbzchgretzou.qr>
 <473DB77B.4090206@balabit.hu> <Pine.LNX.4.64.0711161747290.31083@fbirervta.pbzchgretzou.qr>
 <473DD130.8040601@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40856 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbXKPRxr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:53:47 -0500
In-Reply-To: <473DD130.8040601@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 16 2007 18:19, Laszlo Attila Toth wrote:
> Jan Engelhardt wrote:
>> On Nov 16 2007 16:30, Laszlo Attila Toth wrote:
>> > Also it may be better if only the xt_addrtype remains and ipt_addrtype_info
>> > is
>> > used for the old one and xt_addrtype_info for the new one. But it may be
>> > confusing: ipt_* in the xt_* files...
>> 
>> Will be fixed 'one day' when all the compat code is removed :p
>
> Not 'one': 'Mon' (Monday) :P

What, there's a flag day for netfilter?
