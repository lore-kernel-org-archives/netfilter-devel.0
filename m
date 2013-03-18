From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] netfilter: ipt_ULOG: make spinlock per nlgroup
Date: Mon, 18 Mar 2013 17:11:13 +0800
Message-ID: <5146DA31.9000105@cn.fujitsu.com>
References: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com> <1360032517-3785-1-git-send-email-gaofeng@cn.fujitsu.com> <20130315115129.GB9530@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2476 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab3CRJK2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:10:28 -0400
In-Reply-To: <20130315115129.GB9530@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2013/03/15 19:51, Pablo Neira Ayuso wrote:
> On Tue, Feb 05, 2013 at 10:48:37AM +0800, Gao feng wrote:
>> This patch uses the spin lock per group instead of
>> global spin lock,just like ebt_ulog.
> 
> I'd prefer if we focus on NFLOG, that has been around since quite for
> a while. ULOG should be scheduled for removal, we can add some printk
> in the checkentry path to let people know.
> 

Ok,let's just drop this patch. :)

Thanks!
