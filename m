From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch] iptables and NO_SHARED_LIBS/dlfcn.h
Date: Wed, 19 Dec 2007 17:32:33 +0100
Message-ID: <476947A1.9030008@netfilter.org>
References: <200712190715.46466.vapier@gentoo.org> <47692D56.50305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mike Frysinger <vapier@gentoo.org>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49762 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751810AbXLSQpb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:45:31 -0500
In-Reply-To: <47692D56.50305@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Mike Frysinger wrote:
>> if NO_SHARED_LIBS is defined, then iptables shouldnt even include 
>> dlfcn.h.
>> otherwise you hit a build failure when using toolchains that do not 
>> provide
>> dlfcn.h because they do not support shared objects.
> 
> Applied, thanks. With some luck Pablo hasn't started preparing the 1.4.0
> release yet :)

I didn't yet, I'll probably do tomorrow or friday. I forgot that this 
week is plenty of checkpoint exams :(
