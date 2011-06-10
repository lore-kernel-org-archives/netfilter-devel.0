From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/8] Possible problems found by static analysis of code
Date: Fri, 10 Jun 2011 18:04:35 +0200
Message-ID: <4DF24093.9090900@netfilter.org>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39794 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab1FJQEk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:04:40 -0400
In-Reply-To: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/06/11 15:25, Jiri Popelka wrote:
> We had analyzed the iptables-1.4.10 code with Coverity.
> Coverity is commercial enterprise level tool for
> static analysis (analysis based only on compiling of sources,
> not based on running of binary) of the code.

it would be cool if you pass that tool to the conntrack-tools and ipset.
