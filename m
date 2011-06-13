From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnfnetlink: BAD_SIZEOF
Date: Mon, 13 Jun 2011 19:52:08 +0200
Message-ID: <4DF64E48.4060706@netfilter.org>
References: <1307697060-6572-1-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36829 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab1FMRwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:52:12 -0400
In-Reply-To: <1307697060-6572-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/06/11 11:11, Jiri Popelka wrote:
> static analysis (analysis based only on compiling of sources, not based on running of binary)
> of the code revealed the following problem:
> 
> libnfnetlink.c:481: Taking the size of pointer parameter "nlh" is suspicious.
> libnfnetlink.c:486: Taking the size of pointer parameter "nlh" is suspicious.

Applied, thanks Jiri.
