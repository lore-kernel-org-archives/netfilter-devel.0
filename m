From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables tool v2 PATCH 2/4] src: Ensure given base chain type
 is a valid one
Date: Wed, 04 Sep 2013 14:29:38 +0300
Message-ID: <522719A2.3@linux.intel.com>
References: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1378288222-13182-3-git-send-email-tomasz.bursztyka@linux.intel.com> <20130904104550.GB8768@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757116Ab3IDL3k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 07:29:40 -0400
In-Reply-To: <20130904104550.GB8768@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> It verifies at command line parsing that given type is "filter", "nat",
>> >or "route".
> The kernel will just bail out if we pass an invalid chain type.

Sure, however I thought it would be nice to avoid one useless kernel 
call. (and the error is still possible to locate at that point)

Tomasz
