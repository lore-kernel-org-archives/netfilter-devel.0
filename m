From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Ebtables-devel]  [PATCH 2/2] Add IPv6 support
Date: Tue, 08 Apr 2008 19:37:59 +0200
Message-ID: <47FBAD77.2050701@trash.net>
References: <mailman.53487.1201131436.6775.ebtables-devel@lists.sourceforge.net><3F25FE8C477E9E4FB3D42C2FF937C08A72D8D4@orsmsx423.amr.corp.intel.com><3F25FE8C477E9E4FB3D42C2FF937C08A767706@orsmsx423.amr.corp.intel.com><1201303354.2909.1.camel@localhost.localdomain><3F25FE8C477E9E4FB3D42C2FF937C08A82039A@orsmsx423.amr.corp.intel.com><Pine.LNX.4.64.0802070130120.23855@fbirervta.pbzchgretzou.qr> <3F25FE8C477E9E4FB3D42C2FF937C08A8D090D@orsmsx423.amr.corp.intel.com> <3F25FE8C477E9E4FB3D42C2FF937C08A8D0B6D@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>,
	ebtables-devel@lists.sourceforge.net
To: "Tseng, Kuo-Lang" <kuo-lang.tseng@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47103 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYDHRiC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 13:38:02 -0400
In-Reply-To: <3F25FE8C477E9E4FB3D42C2FF937C08A8D0B6D@orsmsx423.amr.corp.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tseng, Kuo-Lang wrote:
> Tseng, Kuo-Lang wrote on Monday, February 18, 2008 6:05 PM:
> 
>> This is the corresponding br-netfilter patch.
>>
>> It implements matching functions for IPv6 address & traffic class
>> (merged from the patch sent by Jan Engelhardt
>> [jengelh@computergmbh.de]
>> http://marc.info/?l=netfilter-devel&m=120182168424052&w=2), protocol,
>> and layer-4 port id. Corresponding watcher logging function is also
>> added for IPv6. 
>>
>> Signed-off-by: Kuo-lang Tseng <kuo-lang.tseng@intel.com>
> 
> Reposting the patch as an attachment (earlier one had line split. Sorry
> about that)


I wanted to apply this, but the patch has multiple checkpatch
errors. There are also some codingstyle errors checkpatch doesn't
complain about, like:

+       for (i = 0; i < 4; i++)
+          tmp_addr.in6_u.u6_addr32[i] = ih6->saddr.in6_u.u6_addr32[i] &
         ^^^ needs tab

It also seems the TCP/UDP/.. logging part could be shared between
IPv4 and IPv6. The protocol checks seem to be missing UDPLITE.

Please fix those up and resend, thanks.
