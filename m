From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH V4 1/2] netfilter: xt_connbytes: Force CT accounting to
 be enabled
Date: Fri, 25 Jun 2010 14:44:42 +0200
Message-ID: <4C24A4BA.9030402@trash.net>
References: <1277469092-6247-1-git-send-email-tim.gardner@canonical.com> <1277469092-6247-2-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57598 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0FYMov (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:44:51 -0400
In-Reply-To: <1277469092-6247-2-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Gardner wrote:
> Check at rule install time that CT accounting is enabled. Force it
> to be enabled if not while also emitting a warning since this is not
> the default state.
>
> This is in preparation for deprecating CONFIG_NF_CT_ACCT upon which
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES depended being set.
>
> Added 2 CT accounting support functions:
>
> nf_ct_acct_enabled() - Get CT accounting state.
> nf_ct_set_acct() - Enable/disable CT accountuing.
>
>   

Applied, thanks Tim.

