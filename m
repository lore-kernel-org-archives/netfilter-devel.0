From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] ulog: add protection when remove ipt_ULOG
Date: Tue, 19 Feb 2013 09:09:02 +0800
Message-ID: <5122D0AE.7060405@cn.fujitsu.com>
References: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com> <20130207182708.GA18328@localhost> <5121A6B0.9090809@cn.fujitsu.com> <20130218165230.GA19791@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47769 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757003Ab3BSBIW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:08:22 -0500
In-Reply-To: <20130218165230.GA19791@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2013/02/19 00:52, Pablo Neira Ayuso wrote:
> On Mon, Feb 18, 2013 at 11:57:36AM +0800, Gao feng wrote:
> [...]
>>> I think this is very unlikely to happen. The removal of the module
>>> happens in user-context and the entire path to build and deliver the
>>> skb to user-space is protected is under spin_lock_bh, so scheduling
>>> is not possible.
>>
>> Doesn't spin_lock_bh only disable local cpu's bottom-half?
>> the task that remove the modules can run on other cpus at the same time.
>> I'm wrong?
> 
> That's right. But that will not happen since the removal of ipt_ULOG
> is protected by the module refcount, which is bumped for each iptables
> rule. So, you have to remove all rules using the ULOG target first to
> be able to rmmod that module, but then there is no chance to race with
> packets.

this calltrack doesn't add the refcount of moudule.
trace_packet->nf_log_packet->logger->logfn(ipt_logfn).
But when removing module,we call nf_log_unregister and
we can make sure only ulog_tg_exit uses ulog_buffer->skb,
So it's safe to don't add spin lock protect here.

I will send a v2 patchset to remove the spin lock protect
in ebt_ulog module.

Thanks!
