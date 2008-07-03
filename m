From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH,RFC] Route match, user
Date: Thu, 3 Jul 2008 18:55:24 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807031851120.23294@fbirervta.pbzchgretzou.qr>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030922040.20393@fbirervta.pbzchgretzou.qr> <20080703162946.GB19256@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53161 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbYGCQz0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:55:26 -0400
In-Reply-To: <20080703162946.GB19256@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-07-03 18:29, Phil Oester wrote:
> 
>> >+static int route_parse(int c, char **argv, int invert, unsigned int *flags,
>> >+                       const void *entry, struct xt_entry_match **match)
>> >+{
>> >+	struct xt_route_info *info = (struct xt_route_info *) (*match)->data;
>> >+	unsigned int value;
>> >+
>> >+	check_inverse(optarg, &invert, &optind, 0);
>> 
>> I would not bother supporting intraplaced ! at all. Just remove that line.
>
>Sorry..."intraplaced"?

intra = within/inside

There is

	iptables ! -s 192.168.1.5	(normal)
and
	iptables -s ! 192.168.1.5	(intraplaced)

Considering that most extensions only support the normal form,
I would not add any more intraplace support to new modules
to reduce the number of supported styles. Real robustness can
only be achieved when one is strict.
