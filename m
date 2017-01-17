From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH nf] netfilter: conntrack: remove GC_MAX_EVICTS break
Date: Tue, 17 Jan 2017 10:10:23 +0100
Message-ID: <a1041af4-85ca-33da-cc4b-5eea3de3d882@6wind.com>
References: <1484587496-24177-1-git-send-email-fw@strlen.de>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36226 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdAQJK1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 04:10:27 -0500
Received: by mail-wm0-f46.google.com with SMTP id c85so191359917wmi.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2017 01:10:26 -0800 (PST)
In-Reply-To: <1484587496-24177-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 16/01/2017 à 18:24, Florian Westphal a écrit :
> Instead of breaking loop and instant resched, don't bother checking
> this in first place (the loop calls cond_resched for every bucket anyway).
> 
> Suggested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
