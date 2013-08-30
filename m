From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] [RFC] xt_owner: enable xt_owner on INPUT chain
Date: Fri, 30 Aug 2013 07:54:37 -0700
Message-ID: <20130830145437.GA7648@linuxace.com>
References: <1377866623-25948-1-git-send-email-valentina.giusti@bmw-carit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: valentina.giusti@bmw-carit.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52792 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab3H3Oyz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:54:55 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so2418511pad.5
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Aug 2013 07:54:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1377866623-25948-1-git-send-email-valentina.giusti@bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 30, 2013 at 02:43:42PM +0200, valentina.giusti@bmw-carit.de wrote:
> I'm working on getting the owner extension also on the INPUT chain.
> 
> In the meanwhile, could anybody please give feedback and tell me if this is the
> right direction?

What about the (common) case of no local socket?  I think that's why the owner
match was restricted to output|postrouting in the first place, no?

Phil
