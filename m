From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Addrtype match: renaming functions
Date: Thu, 4 Oct 2007 08:05:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710040805230.7253@fbirervta.pbzchgretzou.qr>
References: <4703b9ed.Kwc375N0W4hwnpA7%panther@balabit.hu> <47047355.30005@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Laszlo Attila Toth <panther@balabit.hu>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42994 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbXJDGF7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 02:05:59 -0400
In-Reply-To: <47047355.30005@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 4 2007 07:00, Patrick McHardy wrote:
>Laszlo Attila Toth wrote:
>> Hello,
>> 
>> The function names in libipt_addrtype.c makes debugging hard, also I renamed them
>> prefixed by 'addrtype_'.
>
>Applied, thanks Laszlo.

I went through changing all modules in this regard, patches coming later today
when I finally woke up.
