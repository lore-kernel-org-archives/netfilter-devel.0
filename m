From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxtables:  simple aliasing macro for exit_error
Date: Wed, 11 Feb 2009 13:06:18 +0100
Message-ID: <4992BF3A.5000400@trash.net>
References: <1234277013.20903.44.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: hadi@cyberus.ca
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48057 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbZBKMGV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:06:21 -0500
In-Reply-To: <1234277013.20903.44.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

jamal wrote:
> I think this is it for exit_error(). I didnt want to convert all the
> calls to exit_error(), so i introduced a simple macro to point to
> the xtables_globals
> 
> Next, after you look at these changes i would like to create a
> xtables_merge_options and convert apps defining their own
> merge_options to use it.

Applied, thanks.
