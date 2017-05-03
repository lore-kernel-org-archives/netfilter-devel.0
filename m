From: Florian Westphal <fw@strlen.de>
Subject: Re: .nf_ct_iterate_cleanup panic
Date: Wed, 3 May 2017 13:19:34 +0200
Message-ID: <20170503111934.GA27809@breakpoint.cc>
References: <CAHp8Fza4+-yF=FXtz6srQPggjvxrgexY-LgzmC9mUeyu2sZnHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: dalin liu <kendodada@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51468 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751274AbdECLTw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2017 07:19:52 -0400
Content-Disposition: inline
In-Reply-To: <CAHp8Fza4+-yF=FXtz6srQPggjvxrgexY-LgzmC9mUeyu2sZnHw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

dalin liu <kendodada@gmail.com> wrote:
> kernel version: 4.4.56
> 
> In my linux box,when some PPPoE link are disconnected,
> nf_ct_iterate_cleanup will be called.nf_ct_iterate_cleanup may have
> access to the wrong conntrack address:

Is this a new bug?  If so, what kernel version did not have this problem?
