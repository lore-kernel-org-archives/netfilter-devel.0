From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: next iptables release
Date: Thu, 19 Mar 2009 14:10:23 +0100
Message-ID: <49C2443F.9080208@netfilter.org>
References: <49C202EA.40006@trash.net> <49C23FD6.6010503@netfilter.org> <49C240DA.2070006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59884 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752461AbZCSNKw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:10:52 -0400
In-Reply-To: <49C240DA.2070006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> I've planned to release the next iptables version sometime (late)
>>> this weekend. We've had quite a lot of changes since the last
>>> version, please test the latest version from git and report any
>>> issues.
>>>
>>> Thanks!
>>
>> Great :). BTW, I'm finishing the cluster match manpage, I'll be done
>> tonight, I'd like to see it in this iptables release (even if the
>> feature is expected to appear in 2.6.30).
> 
> I have to ask .. why? :)
>
> Besides potentially confusing people (why doesn't it work despite me
> doing everything the manpage says), what are the advantages of including
> the manpage before the actual implementation?

I planned to distribute the kernel module separately until 2.6.30
arrives, add a page to conntrack-tools.netfilter.org, document this in
the conntrack-tools manual [1] to describe the active-active setup, and
so on. Basically, my motivation is to get some feedback from people as
soon as possible without waiting the whole kernel cycle release.

I know that this seems something exceptional and it may confuse people.
Another choice is to keep it in pom-ng in the meantime, or perhaps
simply be a little bit patient :).

[1] http://conntrack-tools.netfilter.org/manual.html

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
