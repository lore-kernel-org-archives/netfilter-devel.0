From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 6/6] netfilter: xtables: add const qualifiers
Date: Thu, 11 Feb 2010 14:27:51 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002111427490.32310@obet.zrqbmnf.qr>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de> <1265823547-10358-7-git-send-email-jengelh@medozas.de> <4B73C740.5020003@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50619 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab0BKN1w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:27:52 -0500
In-Reply-To: <4B73C740.5020003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-11 10:00, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> +static inline const struct ip6t_entry_target *
>> +ip6t_get_target_c(const struct ip6t_entry *e)
>> +{
>> +	return ip6t_get_target((struct ip6t_entry *)e);
>> +}
>> +
>
>I would prefer a macro over these get_target_c functions.

Why so?
