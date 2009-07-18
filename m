From: Jan Engelhardt <jengelh@medozas.de>
Subject: =?UTF-8?Q?Re=3A_building_nftables=3A_=E2=80=98nfnl=5Fnft=5Fset=5Finit=E2=80=99_undeclared?=
Date: Sat, 18 Jul 2009 18:54:35 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907181853420.4742@fbirervta.pbzchgretzou.qr>
References: <4A61B7DD.9050201@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, farchanjo@gmail.com
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49192 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZGRQyh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jul 2009 12:54:37 -0400
In-Reply-To: <4A61B7DD.9050201@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-07-18 13:54, Christoph A. wrote:
>Hi!
>
>I'm building a enviroment where I can paly around with nftables.
>
>Building libnl-nft I encountered the same problem as described here:
>
>http://osdir.com/ml/general/2009-04/msg03933.html

nfnl_nftset_init was removed in 
0917b23733f46c65703545f82cc633836436f13b. nftables was not updated 
(yet).

The combination of libnl-nft--9e3c81f64856ac0068f63f4d2b8f97c5f091e2e8 + 
nftables-414fa58ae9f283c35c8510fc31f28ba77bb5fdf5
compiles through though.
