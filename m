From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 3/6] Fix warning about unused variable if	NFLOG_GID
  is not available.
Date: Sat, 28 Jun 2008 12:45:52 +0200
Message-ID: <48661660.9030303@netfilter.org>
References: <1213878187-909-1-git-send-email-eric@inl.fr> <1213878187-909-4-git-send-email-eric@inl.fr> <485FB260.3020004@netfilter.org> <20080627194133.GA6761@bayen.regit.org> <20080627202908.GB6761@bayen.regit.org> <48660A46.8090805@netfilter.org> <20080628102559.GC6761@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org,
	chifflier@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay-av.club-internet.fr ([194.158.96.107]:57900 "EHLO
	relay-av.club-internet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbYF1Kpx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jun 2008 06:45:53 -0400
In-Reply-To: <20080628102559.GC6761@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> On Saturday, 2008 June 28 at 11:54:14 +0200, Pablo Neira Ayuso wrote:
>> The thing changes if we discuss about the userspace tools. I think that
>> they must use the latest library release. Thus, we avoid having people
>> that report problems that has been already fixed.
> 
> I really don't like this policy because it is too efficient: You will have
> any report before required version of library get into the distributions
> because people won't test it it there is too much work to build a test
> system.

Let's see it from this point: Assume that my policy consists of reducing
people homework to keep it easier to test ulogd2. Then, later on, I may
receive reports on problems that are supposed-to-be-fixed.

This report, consequently, will increase our workload since we'll have
to request in the ML: "please upgrade to lastest and confirm that it's
fixed, a similar problem is supposed to be fixed in lastest". Then, wait
for their ACK, and so on.

Moreover, since ulogd2 uses three libraries, the hypothetical reported
problem can be in any of those previous library versions. As the users
can use whatever combination of libraries, we'll have to look into the
repository and check if that library suffers from that problem or not.
As said, more work for us.

In short: I prefer reducing my workload if this only implies a sweet
push to make people do their homework - and, after all, they only have
to recompile the libraries which is not that much work.

>>>> Furthermore, I don't think a gcc warning about "unused variable" will
>>>> force a lot of people to upgrade ;)
>>> But a strict configure.in will :/
>> The gcc warning is anecdotic, it was not the main reason to bump the
>> dependencies.
> 
> I know that, I was just talking about the discussed patch. But after
> looking at the changelog and after using ulogd2 without problem with
> older libraries, I don't think the dependencies bump was needed. If a
> bug in the library was preventing ulogd2 to work correctly, I will be
> the first to ask for a dependencies bump but it is far from being the
> case here.
> 
>> Looking at the current state of the libraries, I think that it's the
>> best for now. Later on, once they get more stable and well-tested, we
>> may change this policy.
> 
> Please revert commit 3178606785161296dc5a1bd4d42d965db8b3e2cd if you
> want to apply this strict policy. This code is now useless.

Done. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
