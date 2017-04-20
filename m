From: Oleg <lego12239@yandex.ru>
Subject: Re: nfqueue buf size for recv()
Date: Thu, 20 Apr 2017 11:45:56 +0300
Message-ID: <20170420084555.GB26208@legohost>
References: <20170419165024.GA28485@legohost>
 <20170419214521.GD17294@breakpoint.cc>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward5j.cmail.yandex.net ([5.255.227.23]:55773 "EHLO
        forward5j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S943129AbdDTIw0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 04:52:26 -0400
Content-Disposition: inline
In-Reply-To: <20170419214521.GD17294@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 19, 2017 at 11:45:21PM +0200, Florian Westphal wrote:
> Oleg <lego12239@yandex.ru> wrote:
> > Can anybody tell me how can i determine a right buf size for recv()
> > in libnetfilter_queue program.
> > 
> > http://www.netfilter.org/projects/libnetfilter_queue/doxygen/group__Queue.html#gae36aee5b74d0c88d2f8530e356f68b79
> > 
> > tells nothing about this.
> 
> I'd suggest a 80k buffer to be on safe side.

  My computations give my 70k buffer, but 80k is also suitable.
  Thanks.

-- 
Олег Неманов (Oleg Nemanov)
