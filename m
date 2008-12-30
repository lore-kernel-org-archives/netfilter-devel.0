From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: build: resolve autotools suggestions
Date: Tue, 30 Dec 2008 16:18:59 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0812301611070.5671@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0812252021300.17625@fbirervta.pbzchgretzou.qr> <495A05B0.8070700@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42090 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYL3PTF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Dec 2008 10:19:05 -0500
In-Reply-To: <495A05B0.8070700@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-12-30 12:27, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> parent cea9f71f5618250a38acb21c31fbbf93a752f7d4
>> commit 6fdeb9468f1bac11698b200530cd454a167e1e39
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Thu Dec 25 20:21:36 2008 +0100
>> 
>> build: resolve autotools suggestions
>> 
>> libtool2 wants to put files into m4, so let it have it.
>
>I don't quite understand this change since I'm not a autotools guru. But
>according to the manual, there's a more portable way to do this:
>
>I'd appreciate a more detailed clarification on what you want to do. Thanks.

When run without AC_CONFIG_MACRO_DIR, autotools will suggest
(in a message printed to the screen) that it should be done so:

libtoolize: putting auxiliary files in `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: Consider adding `AC_CONFIG_MACRO_DIR([m4])' to configure.ac and
libtoolize: rerunning libtoolize, to keep the correct libtool macros in-tree.
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.

Not much more, except for adding a gitignore for m4.
