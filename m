From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD2] missing file Rules.make.in needed by configure.in
Date: Thu, 22 May 2008 16:12:11 +0200
Message-ID: <48357F3B.90001@trash.net>
References: <200805211055.42278.Hugo.Mildenberger@t-online.de> <4833EE9A.3010507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Hugo Mildenberger <Hugo.Mildenberger@t-online.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38565 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYEVOMN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 10:12:13 -0400
In-Reply-To: <4833EE9A.3010507@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Hugo Mildenberger wrote:
>> Running autogen.sh from current ulogd2.git  results in the following 
>> error:
>>
>> ~/git/ulogd2$ ./autogen.sh
>> configure.in: installing `./install-sh'
>> configure.in: installing `./missing'
>> filter/Makefile.am: installing `./depcomp'
>> configure.in:75: required file `Rules.make.in' not found
> 
> Yes, the repository is broken currently. We're looking
> into it.


Yasuyuki fixed the tree, it should be working now.
