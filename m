From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/2] extensions: restore matching any SPI id by default
Date: Wed, 15 Jul 2015 18:41:54 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1507151837110.15534@nerf40.vanv.qr>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de> <1436964819-28109-3-git-send-email-jengelh@inai.de> <20150715162442.GA22476@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:37401 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbbGOQl4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 12:41:56 -0400
In-Reply-To: <20150715162442.GA22476@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-07-15 18:24, Pablo Neira Ayuso wrote:
>On Wed, Jul 15, 2015 at 02:53:39PM +0200, Jan Engelhardt wrote:
>[...]
>> diff --git a/extensions/libxt_esp.t b/extensions/libxt_esp.t
>> index 008013b..f207def 100644
>> --- a/extensions/libxt_esp.t
>> +++ b/extensions/libxt_esp.t
>> @@ -4,6 +4,7 @@
>>  -p esp -m esp --espspi 0:4294967295;-p esp -m esp;OK
>>  -p esp -m esp ! --espspi 0:4294967294;=;OK
>>  -p esp -m esp --espspi -1;;FAIL
>> +-p esp -m esp;-p esp -m esp --espspi 0;FAIL
>>  # should fail?
>>  -p esp -m esp;=;OK
>
>This line looks very similar to the one above the comment, but it says OK.

Indeed the FAIL line is indeed mirroring the OK line, the latter of 
which should have failed the testsuite previously.
