From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Bugzilla mails not working
Date: Tue, 02 Sep 2008 10:34:16 +0200
Message-ID: <48BCFA88.5020102@netfilter.org>
References: <20080901150950.GA24543@linuxace.com> <48BC07E4.4010102@trash.net> <48BC12B3.7050902@netfilter.org> <20080901175013.GA27500@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40435 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751319AbYIBIeW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2008 04:34:22 -0400
In-Reply-To: <20080901175013.GA27500@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> On Mon, Sep 01, 2008 at 06:05:07PM +0200, Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> Phil Oester wrote:
>>>> Email out of bugzilla doesn't seem to be working.  Can someone
>>>> take a look?
>>> There are no mails visible in the mailman interface. Pablo, you seem
>>> to be familiar with the bugzilla setup, could you have a look please?
>> exim was rejecting emails for user bugzilla-daemon as unroutable, I have
>> added it to /etc/aliases. It should work now.
> 
> Sorry, still doesn't seem to be working.

Hm, weird. I'm receiving the bug reports via email. Probably I'm not
understanding the problem that you're reporting.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
