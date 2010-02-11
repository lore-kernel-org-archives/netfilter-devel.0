From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] netfilter: fix mangle tables back
Date: Thu, 11 Feb 2010 19:27:15 +0200
Message-ID: <20100211172715.GC4099@x200>
References: <20100211161235.GA4099@x200>
 <alpine.LSU.2.01.1002111724250.11348@obet.zrqbmnf.qr>
 <4B743196.6020005@trash.net>
 <20100211171553.GB4099@x200>
 <4B743D60.1070407@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:39774 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab0BKR1T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:27:19 -0500
Received: by fxm7 with SMTP id 7so1482559fxm.28
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 09:27:17 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4B743D60.1070407@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 11, 2010 at 06:24:48PM +0100, Patrick McHardy wrote:
> It looks correct to me. Will try to reproduce the crash
> just to make sure.

Just CONFIG_NET_NS=y and it will crash.
Arrgh!
