From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v0] netns NOTRACK
Date: Fri, 12 Feb 2010 14:42:51 +0200
Message-ID: <b6fcc0a1002120442q6fc275dbm3ad2d0011ec36658@mail.gmail.com>
References: <20100211173117.GD4099@x200> <4B744565.2010808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f201.google.com ([209.85.223.201]:41154 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab0BLMmw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:42:52 -0500
Received: by iwn39 with SMTP id 39so562319iwn.1
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Feb 2010 04:42:52 -0800 (PST)
In-Reply-To: <4B744565.2010808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 11, 2010 at 7:59 PM, Patrick McHardy <kaber@trash.net> wrote:
> What's missing however is clearing of nfctinfo in nf_reset().

And apparently __nf_copy() should be tweaked too. :(
