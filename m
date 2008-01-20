From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded macros
Date: Sun, 20 Jan 2008 14:09:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
 <47934659.50303@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, bdschuym@pandora.be
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60135 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbYATNJJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:09:09 -0500
In-Reply-To: <47934659.50303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Jan 20 2008 14:02, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit a6c73fee39cedc87ef2562f84d5b1f68a315a79b
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Thu Jan 17 18:58:05 2008 +0100
>> 
>>     [NETFILTER]: ebtables: expand/remove unneeded macros
>>     
>>     The EBT_*_{MATCH,TARGET,WATCHER} macros are only used within the
>>     accompanying .c source file, so they can be moved to it. And since
>>     they are only used once, we can just as well expand them.
>>     
>>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
>
> Your patches all look fine, but please CC Bart on ebtables patches,
> I think its impolite to bypass him when he's stated as maintainer.
>
>
Sorry for the inconvenience! Links are:

[1] marc missed that one(!?)
[2] http://marc.info/?l=netfilter-devel&m=120060092423718&w=2
[3] http://marc.info/?l=netfilter-devel&m=120060092523724&w=2
[4] http://marc.info/?l=netfilter-devel&m=120060075523444&w=2
