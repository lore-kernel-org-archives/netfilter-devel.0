From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: TEE broken in 3.6
Date: Wed, 17 Oct 2012 09:48:51 +0200
Message-ID: <1350460131.26103.68.camel@edumazet-glaptop>
References: <20121016211319.3f07a7e3@goldlack.enda.eu>
	 <1350417618.3954.1494.camel@edumazet-glaptop>
	 <20121017094543.2ddb0397@goldlack.enda.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Torsten Luettgert <ml-netfilter@enda.eu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51875 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2JQHs4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:48:56 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so3385593bkc.19
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Oct 2012 00:48:55 -0700 (PDT)
In-Reply-To: <20121017094543.2ddb0397@goldlack.enda.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2012-10-17 at 09:45 +0200, Torsten Luettgert wrote:
> On Tue, 16 Oct 2012 22:00:18 +0200
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Could you try latest tree, with the following patch ?
> 
> Yeah, that works.
> 
> I'm still a bit sad, though, since I'll have to wait for 3.7 now (no
> FLOWI_FLAG_KNOWN_NH in 3.6.*), or is there any solution for those "old"
> kernels, too?
> 
> Regards,
> Torsten

I believe its stable material, it will reach 3.6.3 or 3.6.4 dont worry.

Thanks


