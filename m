From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH v2 0/2] ipset: forceadd support
Date: Thu, 27 Feb 2014 19:41:23 -0800
Message-ID: <20140228034123.GA12861@home>
References: <1393542286-20955-1-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40370 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB1DlY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:41:24 -0500
Received: by mail-pd0-f174.google.com with SMTP id y13so172252pdi.33
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2014 19:41:23 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1393542286-20955-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 27, 2014 at 06:04:44PM -0500, Josh Hunt wrote:
> Forceadd is a property for hash set types and is passed in duration creation.
> When sets with this property enabled are full each subsequent 'add' operation
> will attempt to evict a random entry from the set. 

Wouldn't it be better to evict the oldest entry instead of a random one?

Phil
