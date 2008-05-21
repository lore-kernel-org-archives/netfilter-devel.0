From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD2] missing file Rules.make.in needed by configure.in
Date: Wed, 21 May 2008 11:42:50 +0200
Message-ID: <4833EE9A.3010507@trash.net>
References: <200805211055.42278.Hugo.Mildenberger@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Hugo Mildenberger <Hugo.Mildenberger@t-online.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34889 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677AbYEUJmv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 05:42:51 -0400
In-Reply-To: <200805211055.42278.Hugo.Mildenberger@t-online.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hugo Mildenberger wrote:
> Running autogen.sh from current ulogd2.git  results in the following error:
> 
> ~/git/ulogd2$ ./autogen.sh
> configure.in: installing `./install-sh'
> configure.in: installing `./missing'
> filter/Makefile.am: installing `./depcomp'
> configure.in:75: required file `Rules.make.in' not found

Yes, the repository is broken currently. We're looking
into it.
