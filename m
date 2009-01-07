From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: build: resolve autotools suggestions
Date: Wed, 07 Jan 2009 15:15:18 +0100
Message-ID: <4964B8F6.8080605@netfilter.org>
References: <alpine.LNX.1.10.0812252021300.17625@fbirervta.pbzchgretzou.qr> <495A05B0.8070700@netfilter.org> <alpine.LSU.2.00.0812301611070.5671@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45457 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752844AbZAGOPe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:15:34 -0500
In-Reply-To: <alpine.LSU.2.00.0812301611070.5671@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-12-30 12:27, Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>> parent cea9f71f5618250a38acb21c31fbbf93a752f7d4
>>> commit 6fdeb9468f1bac11698b200530cd454a167e1e39
>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>> Date:   Thu Dec 25 20:21:36 2008 +0100
>>>
>>> build: resolve autotools suggestions
>>>
>>> libtool2 wants to put files into m4, so let it have it.
>> I don't quite understand this change since I'm not a autotools guru. But
>> according to the manual, there's a more portable way to do this:
>>
>> I'd appreciate a more detailed clarification on what you want to do. Thanks.
> 
> When run without AC_CONFIG_MACRO_DIR, autotools will suggest
> (in a message printed to the screen) that it should be done so:
> 
> libtoolize: putting auxiliary files in `.'.
> libtoolize: copying file `./ltmain.sh'
> libtoolize: Consider adding `AC_CONFIG_MACRO_DIR([m4])' to configure.ac and
> libtoolize: rerunning libtoolize, to keep the correct libtool macros in-tree.
> libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
> 
> Not much more, except for adding a gitignore for m4.

Applied. Thanks. Any other missing patch to apply to iptables from your
side? I remember those to deprecate -b for iptables-save/restore but I
prefer to add a warning before removing them as I suggested.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
