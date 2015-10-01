From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] libmnl: Failed to build with clang, incompatible
 EXPORT_SYMBOL(x) macro
Date: Thu, 1 Oct 2015 11:20:33 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1510011119340.22579@nerf40.vanv.qr>
References: <20150925040745.GA433@oxygen> <20150930221241.GA14943@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Neutron Soutmun <neo.neutron@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:39413 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbbJAJUe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 05:20:34 -0400
In-Reply-To: <20150930221241.GA14943@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2015-10-01 00:12, Pablo Neira Ayuso wrote:
>On Fri, Sep 25, 2015 at 11:07:45AM +0700, Neutron Soutmun wrote:
>> The EXPORT_SYMBOL(x) macro causes clang compile error and warning
>> messges:
>>   error,   "note: previous definition is here"
>>   warning, "warning: attribute declaration must precede definition
>>             [-Wignored-attributes]"
>>   See: [1]
>> 
>> This proposed patch has been prepared to fix this error which make the
>> EXPORT_SYMBOL macro define a precede definition of an attribute
>> declaration. This approach is both compatible with gcc and clang.
>
>We have more libraries using this approach, which resembles kernel
>coding. So we would need to update them all, which is a bit annoying.

If you use an export map (-Wl,--version-script=), you don't strictly
need to have any of the EXPORT_SYMBOL tags in the C source.
