From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 2/4] iptables: move manpage
Date: Mon, 26 Nov 2007 15:21:17 +0900 (JST)
Message-ID: <200711260621.lAQ6LIbG003318@toshiba.co.jp>
References: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0711250205420.25644@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:35710 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXKZGvU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 01:51:20 -0500
Received: from inet-tsb5.toshiba.co.jp (inet-tsb5 [202.33.96.24])
	by imx9.toshiba.co.jp  with ESMTP id lAQ6pIkl006207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Nov 2007 15:51:18 +0900 (JST)
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by inet-tsb5.toshiba.co.jp  with ESMTP id lAQ6LJcB026830
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Nov 2007 15:21:19 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id lAQ6LJMM009419
	for netfilter-devel@vger.kernel.org; Mon, 26 Nov 2007 15:21:19 +0900 (JST)
Received: from mx11.toshiba.co.jp (localhost [127.0.0.1])
	by ovp1.toshiba.co.jp  with ESMTP id lAQ6LI9B022714
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Nov 2007 15:21:19 +0900 (JST)
In-Reply-To: <Pine.LNX.4.64.0711250205420.25644@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Patrick,

The many manual for IPv6 extensions are still missing. But we can
move libipt_*.man to libxt_*.man for them (Great Laszlo, thanks for
introducing libxt_*man) If no objection, I will do that this weekend.
The last missing manual is NFLOG. Sorry, I'm not familiar with
the extension very much. I appreciate if anyone writes the manual for it.

Regards,

-- Yasuyuki Kozakai

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Sun, 25 Nov 2007 02:06:23 +0100 (CET)

> 
> Rename libipt_{time,u32}.man to libxt_{time,u32}.man to go
> in line with the C files.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> ---
>  extensions/lib{ip => x}t_time.man (100% similar)
>  extensions/lib{ip => x}t_u32.man (100% similar)
>  4 files changed
> 
> # This is the patch. You have to do the `svn mv`.
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
