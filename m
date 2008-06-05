From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Thu, 5 Jun 2008 19:52:22 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806051946330.29055@fbirervta.pbzchgretzou.qr>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp> <483BB9DE.6050003@trash.net> <x6y75w3q2j@gzp> <483C088E.4020405@trash.net> <x67idfq6d8@gzp> <483CFF21.40608@trash.net> <4847F64C.2040902@trash.net> <x663snremo@gzp> <4848200A.3060600@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Gabor Z. Papp" <gzp@papp.hu>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36492 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYFERwY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:52:24 -0400
In-Reply-To: <4848200A.3060600@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-06-05 19:19, Patrick McHardy wrote:
>>   CC       libxt_dccp.oo
>> libxt_dccp.c:16:24: warning: linux/dccp.h: No such file or directory
>
>
> Mhh .. I don't really want to add that file to iptables.
> Jan, I'm not familiar with auto*, could you send a patch
> to make compilation of libxt_dccp dependand on the presence
> of linux/dccp.h? Thanks.

Is dccp.h too ugly? Either way, please pull from
	git://dev.medozas.de/xtables master
to get
commit 1ebc55e29f220082814a97e541427be7746400e0
parent 324651944e03072cde144d41896b2e207672d0f2
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jun 5 19:48:31 2008 +0200

    build: check for missing feature files

    linux/dccp.h is unlikely to be installed before 2.6.18 (which was
    when headers_install was introduced), and does not exist at all
    before 2.6.14. Add a compile-time check to skip compilation of
    libxt_dccp in case this was detected.
