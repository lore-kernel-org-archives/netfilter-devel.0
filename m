From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: kernel-source required?
Date: Thu, 10 Jan 2008 18:22:31 +0900 (JST)
Message-ID: <200801100922.m0A9MW1f023688@toshiba.co.jp>
References: <Pine.LNX.4.64.0801091826410.29244@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:63978 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYAJJwp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:52:45 -0500
Received: from inet-tsb5.toshiba.co.jp (inet-tsb5 [202.33.96.24])
	by imx9.toshiba.co.jp  with ESMTP id m0A9qXsv003532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Jan 2008 18:52:33 +0900 (JST)
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by inet-tsb5.toshiba.co.jp  with ESMTP id m0A9MYg4007581
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Jan 2008 18:22:34 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id m0A9MYal016915
	for netfilter-devel@vger.kernel.org; Thu, 10 Jan 2008 18:22:34 +0900 (JST)
Received: from mx2.toshiba.co.jp (localhost [127.0.0.1])
	by ovp2.toshiba.co.jp  with ESMTP id m0A9MX0p018553
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Jan 2008 18:22:33 +0900 (JST)
In-Reply-To: <Pine.LNX.4.64.0801091826410.29244@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Wed, 9 Jan 2008 18:30:36 +0100 (CET)

> just now as an IRC user posted about a compilation error, the only 
> situation that I could think of to load to this error was a missing 
> kernel source tree.
> Since many Xtables header files are copied to the iptables source tree, 
> yet `make KERNEL_DIR=somethinginvalid` gives a compiler error because it 
> cannot find <linux/compiler.h> (required by ip_tables.h).

I wonder why recent (at least, Fedora Core 7) distributed kernel header
package for user programs does not include /usr/include/linux/compiler.h .

> So I wonder, do we actually support building iptables without a 
> kernel source tree?

I prefer to keep people easy to try newer iptables as possible.
We can add include/linux/compiler.h to iptables or remove __user, etc. from
headers of iptables.

-- Yasuyuki Kozakai
