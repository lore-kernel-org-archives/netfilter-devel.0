From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxtables: Replace direct exit_error() calls inside
 libxtables
Date: Wed, 11 Feb 2009 13:05:12 +0100
Message-ID: <4992BEF8.5010203@trash.net>
References: <1234236831.20903.36.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: hadi@cyberus.ca
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48036 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbZBKMFQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:05:16 -0500
In-Reply-To: <1234236831.20903.36.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

jamal wrote:
> Ok, finally - with this can compile and link xtables to:
> 
>     -----
>      #include <xtables.h>
>      int main(int argc, char **argv) {
> 
>             return 0;
>      }

Applied, thanks.
