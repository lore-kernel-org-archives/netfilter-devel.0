From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] make thread-safe iface resolution in libnfnetlink
Date: Wed, 29 Apr 2009 02:01:47 +0200
Message-ID: <49F798EB.3050203@netfilter.org>
References: <1240955127-13723-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42204 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbZD2AB6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Apr 2009 20:01:58 -0400
In-Reply-To: <1240955127-13723-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
> 
> I've encountered some problems with libnfnetlink iface resolution on a
> system where some interfaces are getting up and down: NuFW which uses
> this feature has crashed during a down/up of an interfaces. One of
> the reason seems that nufw uses one thread is used for iface related
> event treatment and another thread is doing iface name resolution.
> 
> As the hash can be modified or read without any lock, I think the
> problem can be linked with this issue. I thus propose a patch that
> modifies the iface resolution subsystem to make it thread-safe.

Better do the locking in your application. You can define the lock in
NuFW and protect the calls to libnfnetlink's interface API. Adding this
locking to a library does not seem to me like the right thing, see that
other non-threaded clients will have to live with the overhead of this
lock that is completely useless for them. Of course, we can document
that the interface API is not thread-safe.

I'm rewriting libnfnetlink from scratch (libnfnetlink2?) considering
this and other existing issues. I think that we can have better a
thread-safe interface API soon. Stay tuned.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
