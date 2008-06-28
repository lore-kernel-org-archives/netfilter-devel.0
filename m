From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 3/6] Fix warning about unused variable if	NFLOG_GID
 is not available.
Date: Sat, 28 Jun 2008 11:54:14 +0200
Message-ID: <48660A46.8090805@netfilter.org>
References: <1213878187-909-1-git-send-email-eric@inl.fr> <1213878187-909-4-git-send-email-eric@inl.fr> <485FB260.3020004@netfilter.org> <20080627194133.GA6761@bayen.regit.org> <20080627202908.GB6761@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, chifflier@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay-dv.club-internet.fr ([194.158.96.208]:64298 "EHLO
	relay-dv.club-internet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbYF1JyS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jun 2008 05:54:18 -0400
In-Reply-To: <20080627202908.GB6761@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> On Friday, 2008 June 27 at 21:41:33 +0200, Eric Leblond wrote:
>> Hello,
>>> As I'm about to conclude a massive release of libraries and the tools, I
>>> think that forcing the use of a recent library version is better as it
>>> also contains several bugfixes.
> 
> I did not really understand the meaning of the word "forcing" till I discover
> that you've forced the use of at least libnfnetlink 0.0.39 in configure.in.
> 
> IMHO, this is too strict and not an easy step into ulogd2 acceptance:
> Instead of having a single software to compile, users will need to
> compile almost all libnf* library :(

This latest library release-set includes several fixes. Having the
lastest version installed always suppose an extra effort for the users.
Moreover, bumping the dependencies is also a way to force packagers to
upgrade.

>> Users prefer to use the library packaged in their system and it will
>> take some time before every distribution includes the required
>> libnfnetlink_log. This patch finishes to provide a clean backward
>> compatibility at a really low cost.

The libraries are backward compatible. We did not break the API nor ABI
so that users with the own applications are not forced to upgrade.

The thing changes if we discuss about the userspace tools. I think that
they must use the latest library release. Thus, we avoid having people
that report problems that has been already fixed.

>> Furthermore, I don't think a gcc warning about "unused variable" will
>> force a lot of people to upgrade ;)
> 
> But a strict configure.in will :/

The gcc warning is anecdotic, it was not the main reason to bump the
dependencies.

Looking at the current state of the libraries, I think that it's the
best for now. Later on, once they get more stable and well-tested, we
may change this policy.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
