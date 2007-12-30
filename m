From: Patrick McHardy <kaber@trash.net>
Subject: Re: Quota on SMP AGAIN
Date: Sun, 30 Dec 2007 19:27:15 +0100
Message-ID: <4777E303.7060601@trash.net>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net> <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr> <477520C3.8040501@trash.net> <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr> <47752958.3010601@trash.net> <Pine.LNX.4.64.0712281756580.29013@fbirervta.pbzchgretzou.qr> <47767699.2020302@trash.net> <Pine.LNX.4.64.0712291952430.8994@bizon.gios.gov.pl> <Pine.LNX.4.64.0712292052240.23321@fbirervta.pbzchgretzou.qr> <4777D734.7090405@trash.net> <Pine.LNX.4.64.0712301923210.23321@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>, gpf <gpf@simm.ru>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Eric Dumazet <dada1@cosmosbay.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53777 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbXL3S1b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:27:31 -0500
In-Reply-To: <Pine.LNX.4.64.0712301923210.23321@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hmph, how are matches supposed to work with it at all?
> Assume this:
>
> static int ...check...(...)
> {
> 	struct my_match_info *info = matchinfo;
>
> 	info->foobar = kmalloc(...);
> }
>
> ->checkentry() is only called once for each rule, but if each
> rule has its own data space (e.g. info->foobar), then that sucks.
>   

->checkentry is called before the copying, so all CPUs get the same
foobar pointer.

