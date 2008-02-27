From: Philip Craig <philipc@snapgear.com>
Subject: Re: TC interface
Date: Wed, 27 Feb 2008 18:56:08 +1000
Message-ID: <47C525A8.1040502@snapgear.com>
References: <200802251358.12898.anton.vazir@gmail.com> <200802271337.31505.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:34818 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752432AbYB0I4M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 03:56:12 -0500
In-Reply-To: <200802271337.31505.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton wrote:
> Looks like everyone is too proud to answer a simple newbee 
> question...

More likely busy...

>> I'm trying to figure out how to interface with the
>> kernel's qos structires. I've found libiptc HOWTO - but
>> it's very outdated and provides only IPTABLES
>> manipulation, not traffic scheduler. Could anyone please
>> advice, if there is a C library, which provides an
>> abstraction for easier manipulation with kernel internals
>> to not use "tc" and "iptables"?

This should cover tc:
http://people.suug.ch/~tgr/libnl/

There isn't a C api for iptables other than libiptc, and
it isn't meant to be used outside of iptables anyway.

Also google showed me http://www.coverfire.com/lql/
but I know nothing about it.

