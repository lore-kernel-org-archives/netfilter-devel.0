From: Andreas Schultz <aschultz@warp10.net>
Subject: Re: nft rules processed in wrong network namespace
Date: Wed, 10 Jun 2015 16:14:30 +0200
Message-ID: <CAASN2uOP76OfF9QfaRFRMyuch2o5w02spf1=u+UkEoMs3znyHw@mail.gmail.com>
References: <CAASN2uOcjOKkXamC=FkYJKCJDTcA9nQUa5=OSn6YyUJ8SGvRfg@mail.gmail.com>
	<20150610140143.GA31977@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36925 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965488AbbFJOOb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2015 10:14:31 -0400
Received: by igbsb11 with SMTP id sb11so34335439igb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2015 07:14:30 -0700 (PDT)
In-Reply-To: <20150610140143.GA31977@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 10, 2015 at 4:01 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 10, 2015 at 12:07:27PM +0200, Andreas Schultz wrote:
> [...]
>> I think I have found the root cause why this happends.
>>
>> With iptables only the hooks defined by the ipt modules can ever exist and
>> they do apply to all namespaces. Thus hooks are registered in the global list
>> nf_hooks.
>
> I have an incomplete patchset here to introduce pernet hooks. Will
> send this for review at some point.

Please, Could you share those patches? I have started on making nf_hooks
into a pernet structure, but having something to start from would make this
much simpler.

Also, in it's current form having netns and nftables support enabled at the
same time can lead to some horribly broken (insecure) setups, e.g. I could
intercept traffic for the host from within a docker container.

Shouldn't Kconfig be changed to prevent this?

Andreas
