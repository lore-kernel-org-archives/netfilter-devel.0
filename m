From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v2 1/2] nfnetlink: netns support
Date: Sun, 28 Feb 2010 18:27:28 +0200
Message-ID: <20100228162728.GA3332@core2>
References: <20100113144024.GA4534@x200>
 <4B4DE0AF.9040509@trash.net>
 <4B72A56F.7070503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50305 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030247Ab0B1Q1f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:27:35 -0500
Received: by fxm19 with SMTP id 19so6337fxm.21
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Feb 2010 08:27:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4B72A56F.7070503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 10, 2010 at 01:24:15PM +0100, Patrick McHardy wrote:
> While merging the nf-next tree with the changes from net-next I noticed
> that this patch allows any namespace to send configurations and verdicts
> to nfnetlink_{log,queue}. It seems you need to add a check for init_net
> to their recv functions unless I'm missing something.

netns NFLOG support is mostly ready. I'll send it once new merge window opens.
