From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded macros
Date: Sun, 20 Jan 2008 14:17:07 +0100
Message-ID: <479349D3.6050103@trash.net>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr> <47934659.50303@trash.net> <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, bdschuym@pandora.be
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57683 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYATNSI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:18:08 -0500
In-Reply-To: <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 20 2008 14:02, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> commit a6c73fee39cedc87ef2562f84d5b1f68a315a79b
>>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>>> Date:   Thu Jan 17 18:58:05 2008 +0100
>>>
>>>     [NETFILTER]: ebtables: expand/remove unneeded macros
>>>     
>>>     The EBT_*_{MATCH,TARGET,WATCHER} macros are only used within the
>>>     accompanying .c source file, so they can be moved to it. And since
>>>     they are only used once, we can just as well expand them.
>>>     
>>>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>>
>> Your patches all look fine, but please CC Bart on ebtables patches,
>> I think its impolite to bypass him when he's stated as maintainer.
>>
>>
> Sorry for the inconvenience! Links are:
> 
> [1] marc missed that one(!?)
> [2] http://marc.info/?l=netfilter-devel&m=120060092423718&w=2
> [3] http://marc.info/?l=netfilter-devel&m=120060092523724&w=2
> [4] http://marc.info/?l=netfilter-devel&m=120060075523444&w=2


Thanks. Bart, please let me know if you have any objections or
want to add a Signed-off-by: line.


