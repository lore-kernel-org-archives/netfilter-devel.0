From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH netfilter: nf_ct] Fix compilation warning if
 NF_CONNTRACK_MARK is not set
Date: Wed, 15 Jan 2014 11:35:56 +0100
Message-ID: <20140115103555.GB9928@localhost>
References: <1389386600-19012-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55665 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaAOKgA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:36:00 -0500
Content-Disposition: inline
In-Reply-To: <1389386600-19012-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 09:43:20PM +0100, Kristian Evensen wrote:
> From: Kristian Evensen <kristian.evensen@gmail.com>
> 
> net/netfilter/nft_ct.c: In function 'nft_ct_set_eval':
> net/netfilter/nft_ct.c:136:6: warning: unused variable 'value' [-Wunused-variable]

Applied, thanks.
