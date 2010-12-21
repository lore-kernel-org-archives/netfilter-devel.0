From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnfnetlink: cast removal
Date: Tue, 21 Dec 2010 20:38:31 +0100
Message-ID: <4D110237.4080905@netfilter.org>
References: <1292703537-16532-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56073 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0LUTih (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:38:37 -0500
In-Reply-To: <1292703537-16532-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18/12/10 21:18, Jan Engelhardt wrote:
> The following changes since commit ac19c1954c3d8505c1612b219f71d7c86cc7fb13:
> 
>   Remove distro-specific parts (2010-11-05 18:31:30 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/libnfnetlink master
> 
> Jan Engelhardt (1):
>       src: remove redundant casts
> 
>  src/iftable.c      |    4 ++--
>  src/libnfnetlink.c |   27 +++++++++++++--------------
>  src/rtnl.c         |   12 ++++++------
>  3 files changed, 21 insertions(+), 22 deletions(-)

pulled and pushed out, thanks jan!
