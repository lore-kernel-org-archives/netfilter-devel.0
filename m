From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 3/3] netfilter: Add SKPID and SKSID meta keys
Date: Thu, 19 Jun 2014 13:16:55 +0300
Message-ID: <53A2B897.8080501@linux.intel.com>
References: <1401977956-15500-1-git-send-email-yshuiv7@gmail.com> <1401977956-15500-3-git-send-email-yshuiv7@gmail.com> <20140610110115.GA9240@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Yuxuan Shui <yshuiv7@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6783 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaFSKQ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:16:57 -0400
In-Reply-To: <20140610110115.GA9240@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> Add SKPID and SKSID meta keys so we can implement PID and SID matching
>> >rules in userspace nft tool.
> I would like to have some use case in the patch description that
> justifies how this can be useful to everyone.
>
> I don't want add more selectors just because we can make it, they
> should allow to perform some useful action.

To mimic xtables libxt_owner extension, would that be sufficient?

Tomasz
