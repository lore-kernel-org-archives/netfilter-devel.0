From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/13] xtables.h: move non-exported parts to internal.h
Date: Sun, 13 Apr 2008 08:09:02 +0200
Message-ID: <4801A37E.3090504@trash.net>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <d9eeb7296c3dcc442cf64e79e6c5bfd7e66ceea0.1207813085.git.jengelh@computergmbh.de> <480195AD.3000708@trash.net> <alpine.LNX.1.10.0804130804150.30942@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34184 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYDMGJG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 02:09:06 -0400
In-Reply-To: <alpine.LNX.1.10.0804130804150.30942@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-04-13 07:10, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> A number of enums, structs, functions are not used by modules, so
>>> they do not need exporting.
>>> ---
>>>  include/xtables.h          |   61 ------------------------------------
>>>  include/xtables/internal.h |   60 +++++++++++++++++++++++++++++++++++
>>>  2 files changed, 60 insertions(+), 61 deletions(-)
>> Applied.
>>
>> I hope you made sure that none of this is used by tc ipt action
>> in iproute2. In case it is, please send a fix on top.
>>
> tc has its own copy of everything, so stands independent.
> 

Right, thanks for verifying this.
