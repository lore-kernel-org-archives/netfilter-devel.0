From: Jesper Dangaard Brouer <netdev@brouer.com>
Subject: Re: [PATCH] netfilter: conntrack: adjust nf_conntrack_buckets
 default value
Date: Thu, 4 Dec 2014 14:26:13 +0100
Message-ID: <20141204142613.1558e172@brouer.com>
References: <7537ac022aea771d7af0aef2bd3bb30e5fa0a008.1417634768.git.mleitner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36587 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaLDN0R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:26:17 -0500
Received: by mail-lb0-f182.google.com with SMTP id f15so15305060lbj.27
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Dec 2014 05:26:15 -0800 (PST)
In-Reply-To: <7537ac022aea771d7af0aef2bd3bb30e5fa0a008.1417634768.git.mleitner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed,  3 Dec 2014 17:30:19 -0200
Marcelo Ricardo Leitner <mleitner@redhat.com> wrote:

> Manually bumping either nf_conntrack_buckets or nf_conntrack_max has
> become a common task as our Linux servers tend to serve more and more
> clients/applications, so let's adjust nf_conntrack_buckets this to a
> more updated value.
> 
> Now for systems with more than 4GB of memory, nf_conntrack_buckets
> becomes 65536 instead of 16384, resulting in nf_conntrack_max=256k
> entries.
> 
> Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
> ---

It have been needed for a long time that we bumped this, e.g. TCP hash
is bigger than our current ceil.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
