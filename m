From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 3/3] netfilter: Add SKPID and SKSID meta keys
Date: Thu, 19 Jun 2014 13:25:23 +0300
Message-ID: <53A2BA93.2070908@linux.intel.com>
References: <1401977956-15500-1-git-send-email-yshuiv7@gmail.com> <1401977956-15500-3-git-send-email-yshuiv7@gmail.com> <20140610110115.GA9240@localhost> <53A2B897.8080501@linux.intel.com> <20140619101959.GA4431@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yuxuan Shui <yshuiv7@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34361 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbaFSKZi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:25:38 -0400
In-Reply-To: <20140619101959.GA4431@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> To mimic xtables libxt_owner extension, would that be sufficient?
> That is already achieved through skuid and skgid.

What about:

[!] --pid-owner processid    Match local PID
[!] --sid-owner sessionid    Match local SID

Though in kernel side, I could not find any handlers for those... Unless 
I missed something.

Tomasz

