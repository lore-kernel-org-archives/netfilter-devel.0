From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC PATCH 0/1] add insert after to nf_tables
Date: Thu, 20 Jun 2013 12:52:24 +0300
Message-ID: <51C2D0D8.1020309@linux.intel.com>
References: <1371628997-13548-1-git-send-email-eric@regit.org> <51C17E26.2020608@linux.intel.com> <20130620094243.GA5703@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27169 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab3FTJww (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:52:52 -0400
In-Reply-To: <20130620094243.GA5703@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> The user-space daemon can keep a cache of the ordered rule-set. Thus,
> it can guess the position of the rule-set from the handle.

Hum, how?
The handle it will get from the notification is the handle of the newly 
created rule, not the one used to identify the rule for insertion.

Tomasz
