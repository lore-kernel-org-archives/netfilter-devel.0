From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Bugzilla mails not working
Date: Mon, 01 Sep 2008 18:05:07 +0200
Message-ID: <48BC12B3.7050902@netfilter.org>
References: <20080901150950.GA24543@linuxace.com> <48BC07E4.4010102@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56058 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360AbYIAQqL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:46:11 -0400
In-Reply-To: <48BC07E4.4010102@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Phil Oester wrote:
>> Email out of bugzilla doesn't seem to be working.  Can someone
>> take a look?
> 
> There are no mails visible in the mailman interface. Pablo, you seem
> to be familiar with the bugzilla setup, could you have a look please?

exim was rejecting emails for user bugzilla-daemon as unroutable, I have
added it to /etc/aliases. It should work now.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
