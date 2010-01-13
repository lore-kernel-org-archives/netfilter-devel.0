From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/2] ctnetlink: add netns support
Date: Wed, 13 Jan 2010 15:28:57 +0200
Message-ID: <20100113132857.GB16975@x200>
References: <20100113122637.GB5790@x200>
 <4B4DC35A.9000600@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:56931 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0AMN3F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:29:05 -0500
Received: by fxm25 with SMTP id 25so150624fxm.21
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2010 05:29:02 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4B4DC35A.9000600@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2010 at 01:58:02PM +0100, Patrick McHardy wrote:
> Alexey Dobriyan wrote:
> > Allow conntrack program to operate correctly in netns.
> > Note: passing events is not done in this patch.
> 
> Why not? It seems like a small change and without this the netns
> support will still be incomplete.

For some reason, I thought this code associated with nfnetlink_log code et al,
but yes, it will be easy.
