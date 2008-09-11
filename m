From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 2/3] Make NFLOG and NFCT build conditionnal
Date: Fri, 12 Sep 2008 00:35:10 +0200
Message-ID: <48C99D1E.3010506@netfilter.org>
References: <1221166085-23435-3-git-send-email-eric@inl.fr> <48C99429.2020406@netfilter.org> <20080911221504.GC20985@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48527 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752957AbYIKWor (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 18:44:47 -0400
In-Reply-To: <20080911221504.GC20985@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Thursday, 2008 September 11 at 23:56:57 +0200, Pablo Neira Ayuso wrote:
>> Eric Leblond wrote:
>>> This patch modifies the build system behaviour to be able to compile
>>> ulogd on system without recent release of libnetfilter library. If
>>> a library is absent or too old, it will simply not compile the concerned
>>> input module.
>> I don't see any gain from this patch. We had this sort of conditional
>> compilation in iptables - that we finally removed - and it was source of
>> user-side problems.
> 
> Hmm, even if you think autodetection is a mistake, it is useful to
> be able to compile ulogd on system where NFLOG or NFCT is not installed
> or not usable (too old kernel).

We're having this discussion over and over again :), ulogd is intended
for new systems. The ULOG target support should be legacy. You know how
limited the ULOG target is, and how many headache gives to add new
features to it ;)

> What do you think about a --without flag to be able to manually disable
> the compilation ?

Well, I'd prefer that but, sincerely, your obsession with legacy systems
go really that far.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
