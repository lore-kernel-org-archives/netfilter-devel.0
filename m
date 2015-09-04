From: Pravin Shelar <pshelar@nicira.com>
Subject: Re: [PATCH net] openvswitch: Remove conntrack Kconfig option.
Date: Fri, 4 Sep 2015 16:23:12 -0700
Message-ID: <CALnjE+p+UB5o-TShVbGVHMm2pO5PNwLCdZEQhiXGa_f8h5Pbeg@mail.gmail.com>
References: <1441397260-61272-1-git-send-email-joestringer@nicira.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netdev <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Joe Stringer <joestringer@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34992 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001AbbIDXXN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Sep 2015 19:23:13 -0400
Received: by igbkq10 with SMTP id kq10so22824378igb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Sep 2015 16:23:13 -0700 (PDT)
In-Reply-To: <1441397260-61272-1-git-send-email-joestringer@nicira.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 4, 2015 at 1:07 PM, Joe Stringer <joestringer@nicira.com> wrote:
> There's no particular desire to have conntrack action support in Open
> vSwitch as an independently configurable bit, rather just to ensure
> there is not a hard dependency. This exposed option doesn't accurately
> reflect the conntrack dependency when enabled, so simplify this by
> removing the option. Compile the support if NF_CONNTRACK is enabled.
>
> Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
> Signed-off-by: Joe Stringer <joestringer@nicira.com>

Acked-by: Pravin B Shelar <pshelar@nicira.com>
