From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [libnftables PATCH 7/7] chain: handle attribute is relevant if
 only there is no name to use
Date: Wed, 15 May 2013 16:54:46 +0300
Message-ID: <519393A6.7090301@linux.intel.com>
References: <519216B6.7060701@linux.intel.com> <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1368528682-10041-8-git-send-email-tomasz.bursztyka@linux.intel.com> <20130514222051.GB10082@localhost> <5193265B.3050605@linux.intel.com> <20130515124330.GA1349@localhost> <51938852.1070705@linux.intel.com> <20130515134010.GA1577@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5628 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759013Ab3EONy5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 09:54:57 -0400
In-Reply-To: <20130515134010.GA1577@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
>> I was actually playing on my own with libnftables.
>> >It's easy: dump the chain list, then change the policy on one chain
>> >for instance, build the message to apply this change, send it...
>> >
>> >We haven't hit the bug yet anywhere, because no code does such
>> >settings change after a dump, but we - or whatever app - surely will
>> >at some point.
> We should document that. I have a patch to add the doxygen doc to
> libnftables. I prefer that user is in control of this, instead of
> adding internal workarounds to avoid tricky situations.

As you want, but it will complicate things for the user a bit.

Tomasz
