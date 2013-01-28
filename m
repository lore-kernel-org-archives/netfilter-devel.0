From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 3/8] libxtables: centralize checking for a .save
 function
Date: Mon, 28 Jan 2013 14:39:19 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301281439070.6071@nerf07.vanv.qr>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de> <1359056278-27618-4-git-send-email-jengelh@inai.de> <20130128113513.GB15781@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:37130 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268Ab3A1NjV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:39:21 -0500
In-Reply-To: <20130128113513.GB15781@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2013-01-28 12:35, Pablo Neira Ayuso wrote:
>On Thu, Jan 24, 2013 at 08:37:53PM +0100, Jan Engelhardt wrote:
>> +static void standard_save(const void *ip, const struct xt_entry_target *t)
>> +{
>> +	/* "standard" is special ... */
>
>I like this patch, but please, better add some more specific
>description, eg. Tell where the real output save of the standard
>target is done. A couple of lines won't hurt.

Yeah that certainly is a good idea.
