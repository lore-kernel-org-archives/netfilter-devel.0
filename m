From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxtables: define xtables_free_opts()
Date: Wed, 11 Feb 2009 13:00:37 +0100
Message-ID: <4992BDE5.1030500@trash.net>
References: <1234213287.20903.19.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: hadi@cyberus.ca
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47919 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZBKMAl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:00:41 -0500
In-Reply-To: <1234213287.20903.19.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

jamal wrote:
> A user of the structure xtables_globals. Next goal is to attack
> exit_error() so i can compile that basic program..

Also applied, thanks.
