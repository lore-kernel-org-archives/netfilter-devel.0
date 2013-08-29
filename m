From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] netfilter: SYNPROXY core: fix warning in
 __nf_ct_ext_add_length()
Date: Thu, 29 Aug 2013 12:38:52 +0200
Message-ID: <20130829123852.7b1c0093@redhat.com>
References: <1377765129-8490-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, mph@one.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab3H2KjG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:39:06 -0400
In-Reply-To: <1377765129-8490-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 29 Aug 2013 10:32:09 +0200
Patrick McHardy <kaber@trash.net> wrote:

> With CONFIG_NETFILTER_DEBUG we get the following warning during SYNPROXY init:
> 
> [   80.558906] WARNING: CPU: 1 PID: 4833 at net/netfilter/nf_conntrack_extend.c:80 __nf_ct_ext_add_length+0x217/0x220 [nf_conntrack]()
> 
> The reason is that the conntrack template is set to confirmed before adding
> the extension and it is invalid to add extensions to already confirmed
> conntracks. Fix by adding the extensions before setting the conntrack to
> confirmed.
> 
> Reported-by: Jesper Dangaard Brouer <jesper.brouer@gmail.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

I have verified that the warning is gone after this patch, thanks!

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
