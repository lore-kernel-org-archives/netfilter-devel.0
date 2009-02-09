From: jamal <hadi@cyberus.ca>
Subject: Re: [PATCH] libxtables: Introduce xtables_afinfo
Date: Mon, 09 Feb 2009 15:45:05 -0500
Message-ID: <1234212305.20903.7.camel@dogo.mojatatu.com>
References: <1234026339.4441.24.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0902071957040.12855@fbirervta.pbzchgretzou.qr>
	 <1234035818.4441.36.camel@dogo.mojatatu.com>  <4990411F.5060509@trash.net>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:51166 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZBIUq7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:46:59 -0500
Received: by ewy14 with SMTP id 14so2775649ewy.13
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2009 12:46:57 -0800 (PST)
In-Reply-To: <4990411F.5060509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2009-02-09 at 15:43 +0100, Patrick McHardy wrote:

> Could you resend the agreed-upon patches that you
> want me to apply please?

Ok, I just synced with latest git. I will send you a few patches first.
My path to resolving tc/ipt is to start with being able to take a basic
useless program like:

----------
#include <xtables.h>
int main(int argc, char **argv) {

        return 0;
}
--------

then compile and link with "gcc useless.c -lxtables -ldl"

As it is right now i have to define in the minimal exit_error()

cheers,
jamal

