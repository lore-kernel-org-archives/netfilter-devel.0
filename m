From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: don't panic on error while walking
 through the init path
Date: Thu, 23 May 2013 13:09:24 +0200
Message-ID: <20130523110924.GC22553@localhost>
References: <1369298557-5351-1-git-send-email-pablo@netfilter.org>
 <1369298557-5351-2-git-send-email-pablo@netfilter.org>
 <519DD868.1070809@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52969 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758082Ab3EWLJe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 May 2013 07:09:34 -0400
Content-Disposition: inline
In-Reply-To: <519DD868.1070809@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 23, 2013 at 04:50:48PM +0800, Gao feng wrote:
> On 05/23/2013 04:42 PM, Pablo Neira Ayuso wrote:
> > Don't panic if we hit an error while adding the nf_log or pernet
> > netfilter support, just bail out.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> 
> Acked-by: Gao feng <gaofeng@cn.fujitsu.com>

Applied.
