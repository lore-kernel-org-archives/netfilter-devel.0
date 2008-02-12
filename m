From: "Tseng, Kuo-Lang" <kuo-lang.tseng@intel.com>
Subject: RE: [Ebtables-devel] [PATCH] IPv6 dnat/snat support
Date: Mon, 11 Feb 2008 18:26:47 -0800
Message-ID: <3F25FE8C477E9E4FB3D42C2FF937C08A897BDA@orsmsx423.amr.corp.intel.com>
References: <mailman.53487.1201131436.6775.ebtables-devel@lists.sourceforge.net><3F25FE8C477E9E4FB3D42C2FF937C08A72D8D4@orsmsx423.amr.corp.intel.com><3F25FE8C477E9E4FB3D42C2FF937C08A767706@orsmsx423.amr.corp.intel.com><1201303354.2909.1.camel@localhost.localdomain><3F25FE8C477E9E4FB3D42C2FF937C08A82039A@orsmsx423.amr.corp.intel.com><Pine.LNX.4.64.0802070130120.23855@fbirervta.pbzchgretzou.qr><3F25FE8C477E9E4FB3D42C2FF937C08A85CA7F@orsmsx423.amr.corp.intel.com><Pine.LNX.4.64.0802080126020.25157@fbirervta.pbzchgretzou.qr><3F25FE8C477E9E4FB3D42C2FF937C08A85CB14@orsmsx423.amr.corp.intel.com><1202494854.2895.11.camel@localhost.localdomain><3F25FE8C477E9E4FB3D42C2FF937C08A85D069@orsmsx423.amr.corp.intel.com><1202664082.2907.5.camel@localhost.localdomain> <3F25FE8C477E9E4FB3D42C2FF937C08A85D440@o
 rsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>,
	"Bart De Schuymer" <bdschuym@pandora.be>
To: "Jan Engelhardt" <jengelh@computergmbh.de>,
	<ebtables-devel@lists.sourceforge.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55685 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbYBLC3R convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 21:29:17 -0500
Content-class: urn:content-classes:message
In-Reply-To: <3F25FE8C477E9E4FB3D42C2FF937C08A85D440@orsmsx423.amr.corp.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tseng, Kuo-Lang wrote on Monday, February 11, 2008 9:59 AM:

> Bart De Schuymer wrote on Sunday, February 10, 2008 9:21 AM:
> 
>> Op vr, 08-02-2008 te 16:01 -0800, schreef Tseng, Kuo-Lang:
>>> Bart De Schuymer wrote on Friday, February 08, 2008 10:21 AM:
>>> 
>>>> Hi Kuo,
>>>> 
>>>> Thanks for your patch. The patch looks ok. Tiny comment: the header
>>>> diffs belong in the kernel patch and the userspace patch lacks a
>>>> man page update. Seems like we'll need a merge of the two kernel
>>>> patches and extra userspace code.
>>>> 
>>>> I was gonna give my say about posting to netfilter-devel only,
>>>> without userspace code, but I guess I'm better off restraining
>>>> myself from doing that. 
>>>> 
>>>> cheers,
>>>> Bart
>>> 
>>> Thanks. I have attached an updated userspace patch that includes the
>>> missing man page update and removed the header diffs.
>> 
>> It would be better if the ipv6 address and traffic class matching
>> were implemented in the patch. So I'm going to wait for that. Is
>> there any reason why you didn't do this in the first place?
> We wanted to keep the first patch small for the review. Once the first
> patch is merged in, the v6 address and traffic class can be added
> after that.

Hi Jan, have you posted the corresponding patch to ebtables-devel for
the kernel patch you posted in here
http://marc.info/?l=netfilter-devel&m=120182168424052&w=2 ? 

If not, I can add the code and send an updated patch to ebtables-devel
to make the v6 support more complete as Bart suggested. 

We also need to merge the two kernel patches (your above one and the one
I sent last Friday). Has your kernel patch been pushed in? If not, I'll
add my part on top of yours and send an updated patch to
netfilter-devel. What do you think? 

To quickly summarize what we got: 

- You above kernel patch implements matches for TFCLASS, FLOWLBL,
NEXTHDR (w/o skipping ext. header), H- OPLIMIT, SRCADDR, and DSTADDR. 
- My kernel patch implements matches for PROTOCOL (w/ ext. header
skipped), DPORT, and SPORT and logging for v6.

- My user ebtables patch implements parsing for PROTO, SPORT, and DPORT.



