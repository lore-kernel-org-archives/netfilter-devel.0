From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_queue 0/4] misc code cleaning and documentation
Date: Mon, 22 Dec 2008 11:48:06 +0100
Message-ID: <494F7066.8050401@netfilter.org>
References: <1229722591-7836-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44403 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084AbYLVKsO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:48:14 -0500
In-Reply-To: <1229722591-7836-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
> 
> This small patchset fixes two inconsistencies:
>  * Change variable name to have an homogeneous naming
>  * Use nfq_fd function instead of call to nfnetlink function.
> It also fixes a potential problem in nfq_close() where a ressource was freed twice:
>  * Suppress double call of nfnl_subsys_close()
> Last patch is a documentation update:
>  * Switch documentation style to doxygen.
> I've switched the documentation style to doxygen format. It is standard, easy
> to use and very powerful. An html output example is available here:
> 	http://www.nufw.org/doc/libnetfilter_queue/
> 
> Patchset statistics:
>  src/libnetfilter_queue.c |  437 ++++++++++++++++++++++++++++++++--------------
>  utils/nfqnl_test.c       |    3 +-
>  2 files changed, 310 insertions(+), 130 deletions(-)

They all look fine, please feel free to push them yourself to
netfilter's git.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
