From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Valgrind warnings in libnetfilter_queue about pointers to uninitialsed
 bytes
Date: Wed, 13 Feb 2008 13:44:55 +0100
Message-ID: <47B2E647.9000908@netfilter.org>
References: <14627619.43021202851931588.JavaMail.root@zimbra.untangle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Arthur Ulfeldt <arthur@untangle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55858 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756873AbYBMMpD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:45:03 -0500
In-Reply-To: <14627619.43021202851931588.JavaMail.root@zimbra.untangle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arthur Ulfeldt wrote:
> Valgrind is reporting uninitialised bytes at the pointer returned by nfq_open().
> libnetfilter_queue version 1.1.0.

I'd appreciate a patch for this since I won't be able to fix it along
this week.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
