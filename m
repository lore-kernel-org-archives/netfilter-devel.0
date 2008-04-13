From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/13] xtables.h: move non-exported parts to internal.h
Date: Sun, 13 Apr 2008 07:10:05 +0200
Message-ID: <480195AD.3000708@trash.net>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <d9eeb7296c3dcc442cf64e79e6c5bfd7e66ceea0.1207813085.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33185 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYDMFKJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 01:10:09 -0400
In-Reply-To: <d9eeb7296c3dcc442cf64e79e6c5bfd7e66ceea0.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> A number of enums, structs, functions are not used by modules, so
> they do not need exporting.
> ---
>  include/xtables.h          |   61 ------------------------------------
>  include/xtables/internal.h |   60 +++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+), 61 deletions(-)

Applied.

I hope you made sure that none of this is used by tc ipt action
in iproute2. In case it is, please send a fix on top.

