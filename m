From: Torsten Luettgert <ml-netfilter@enda.eu>
Subject: Re: TEE broken in 3.6
Date: Wed, 17 Oct 2012 09:45:43 +0200
Message-ID: <20121017094543.2ddb0397@goldlack.enda.eu>
References: <20121016211319.3f07a7e3@goldlack.enda.eu>
	<1350417618.3954.1494.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.cbxnet.de ([212.87.33.16]:58872 "EHLO mail1.cbxnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab2JQHpq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:45:46 -0400
In-Reply-To: <1350417618.3954.1494.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 16 Oct 2012 22:00:18 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Could you try latest tree, with the following patch ?

Yeah, that works.

I'm still a bit sad, though, since I'll have to wait for 3.7 now (no
FLOWI_FLAG_KNOWN_NH in 3.6.*), or is there any solution for those "old"
kernels, too?

Regards,
Torsten
