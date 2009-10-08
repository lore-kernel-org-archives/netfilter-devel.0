From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack: use fscanf() instead of read() for showing
 counter
Date: Thu, 08 Oct 2009 18:07:58 +0200
Message-ID: <4ACE0E5E.5040803@netfilter.org>
References: <20091007162834.13930.14962.stgit@lb64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Hannes Eder <heder@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47928 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbZJHQIm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:08:42 -0400
In-Reply-To: <20091007162834.13930.14962.stgit@lb64>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hannes Eder wrote:
> Read an integer right away with fscanf() instead of read()-ing to a
> buffer, which was actually to small for the terminating '\0', and
> atoi()-ing.  Furthermore read() might not read enough, though unlikely
> here.

Also applied, thanks!
