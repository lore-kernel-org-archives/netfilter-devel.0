From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nlif_open() - nlif_close() - memory leak?
Date: Thu, 22 May 2008 15:08:12 +0200
Message-ID: <4835703C.7070801@netfilter.org>
References: <200805221500.35587.anton.vazir@gmail.com> <20080522124801.GK7436@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, Anton <anton.vazir@gmail.com>,
	Netfilter Mailinglist <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60244 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935697AbYEVNIW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 09:08:22 -0400
In-Reply-To: <20080522124801.GK7436@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Thursday, 2008 May 22 at 15:00:35 +0500, Anton wrote:
>>> The attached patch should fix the memory leak issue.
>>> Could you test it ?
>> Accordingly to "top", it's still leaking.
> 
> Yes, I should not code during conferences ;)
> 
> I attach a patch which is working for me.

Oh, I didn't notice this patch. I think that my patch results in a
cleaner code. The current list handling is a bit error prone. What do
you think?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
