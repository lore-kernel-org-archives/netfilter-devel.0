From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 03/13] xtables.h: move non-exported parts to internal.h
Date: Sun, 13 Apr 2008 08:07:54 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804130804150.30942@fbirervta.pbzchgretzou.qr>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <d9eeb7296c3dcc442cf64e79e6c5bfd7e66ceea0.1207813085.git.jengelh@computergmbh.de> <480195AD.3000708@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46731 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYDMGH4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 02:07:56 -0400
In-Reply-To: <480195AD.3000708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-04-13 07:10, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> A number of enums, structs, functions are not used by modules, so
>> they do not need exporting.
>> ---
>>  include/xtables.h          |   61 ------------------------------------
>>  include/xtables/internal.h |   60 +++++++++++++++++++++++++++++++++++
>>  2 files changed, 60 insertions(+), 61 deletions(-)
>
> Applied.
>
> I hope you made sure that none of this is used by tc ipt action
> in iproute2. In case it is, please send a fix on top.
>
tc has its own copy of everything, so stands independent.
