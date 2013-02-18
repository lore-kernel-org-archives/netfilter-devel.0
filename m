From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] ulog: add protection when remove ipt_ULOG
Date: Mon, 18 Feb 2013 11:57:36 +0800
Message-ID: <5121A6B0.9090809@cn.fujitsu.com>
References: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com> <20130207182708.GA18328@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45777 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab3BREMw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Feb 2013 23:12:52 -0500
In-Reply-To: <20130207182708.GA18328@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 2013/02/08 02:27, Pablo Neira Ayuso wrote:
> Hi Gao,
> 
> On Tue, Feb 05, 2013 at 09:57:30AM +0800, Gao feng wrote:
>> We should add a lock protection when we free the skb,
>> because it maybe used by ipt_ulog_packet right now.
> 
> Did you hit a reproducible crash?
> 

I didn't.
I looked at the ebt_ulog.c and found ebt_ulog_fini
uses the spin lock to protect the ulog_buff's skb.


> I think this is very unlikely to happen. The removal of the module
> happens in user-context and the entire path to build and deliver the
> skb to user-space is protected is under spin_lock_bh, so scheduling
> is not possible.
>

Doesn't spin_lock_bh only disable local cpu's bottom-half?
the task that remove the modules can run on other cpus at the same time.
I'm wrong?
