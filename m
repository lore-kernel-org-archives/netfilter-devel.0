From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [[PATCH v3]] netfilter: nfnetlink_acct: add filter support to
 nfacct counter list/reset
Date: Tue, 26 Aug 2014 21:38:19 +0200
Message-ID: <20140826193819.GA4757@salvia>
References: <20140820133401.GA7422@salvia>
 <1408557798-6455-1-git-send-email-a.perevalov@samsung.com>
 <20140824131537.GA8144@salvia>
 <BLU436-SMTP8877E9030BB0C55BBF4CC28DDC0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	mathieu.poirier@linaro.org, netfilter-devel@vger.kernel.org,
	kyungmin.park@samsung.com, hs81.go@samsung.com
To: Alexey Perevalov <alexey.perevalov@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55774 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbaHZThk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:37:40 -0400
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP8877E9030BB0C55BBF4CC28DDC0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 26, 2014 at 11:15:04PM +0400, Alexey Perevalov wrote:
> Hi
> On 08/24/2014 05:15 PM, Pablo Neira Ayuso wrote:
> >Hi,
> >
> >On Wed, Aug 20, 2014 at 10:03:18PM +0400, Alexey Perevalov wrote:
> >>+static struct nfacct_filter *
> >>+nfacct_filter_alloc(struct nlattr *attrs[NFACCT_FILTER_MAX + 1])
> >>+{
> >>+	struct nfacct_filter *filter = kzalloc(sizeof(struct nfacct_filter),
> >>+					       GFP_KERNEL);
> >>+	if (!filter)
> >>+		return ERR_PTR(-ENOMEM);
> >>+
> >>+	filter->mask = nla_get_be32(attrs[NFACCT_FILTER_MASK]);
> >>+	filter->value = nla_get_be32(attrs[NFACCT_FILTER_VALUE]);
> >We have to use ntohl() here, it's the convention for nfnetlink.
> >
> >I'm attaching a patch that resolves this plus some cleanups.
> >
> >Please, let me know if you're OK with it. Thanks.
>
> Yes, I'm ok with it.

Applied, thanks.
