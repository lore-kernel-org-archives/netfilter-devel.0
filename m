From: Andreas Schultz <aschultz@warp10.net>
Subject: Re: nft rules processed in wrong network namespace
Date: Wed, 10 Jun 2015 12:07:27 +0200
Message-ID: <CAASN2uOcjOKkXamC=FkYJKCJDTcA9nQUa5=OSn6YyUJ8SGvRfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:32795 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbbFJKH1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2015 06:07:27 -0400
Received: by igbpi8 with SMTP id pi8so31782321igb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2015 03:07:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm getting the impression that my mails do not reach the list, so another
try from a different address.

To reiterate, a nft filter like this:

# ip netns exec upstream nft list table filter
table ip filter {
        chain input {
                type filter hook input priority 0; policy accept;
        }

        chain forward {
                type filter hook forward priority 0; policy accept;
        }

        chain output {
                type filter hook output priority 0; policy accept;
                nftrace set 1
                counter packets 0 bytes 0 drop
        }
}

will also apply to packets in the default/root namespace and to packets in
other namespaces.

I think I have found the root cause why this happends.

With iptables only the hooks defined by the ipt modules can ever exist and
they do apply to all namespaces. Thus hooks are registered in the global list
nf_hooks.

With nftables it is possible to instantiate different user defined hooks in
each namespace. Since this hook registration still uses the global function
nf_register_hook, all hooks from all namespace will end up in the same list.

This alone is not a problem, but when processing the nf_hooks list in
nf_iterate, it is assume that all hooks are the same in all namespaces and
no per namespace filtering is applied. So all existing hooks from all
namespaces are processed for any given packet.

Regards
Andreas
