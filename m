From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/3] iptables: accept multiple IP address specifications
 for -s, -d
Date: Fri, 17 Jul 2009 17:55:44 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907171737410.11904@fbirervta.pbzchgretzou.qr>
References: <1244229955-27642-1-git-send-email-jengelh@medozas.de> <1244229955-27642-2-git-send-email-jengelh@medozas.de> <4A2A1260.7050207@netfilter.org> <4A2D171E.9060401@trash.net> <alpine.LSU.2.00.0906101405590.30984@fbirervta.pbzchgretzou.qr>
 <alpine.LSU.2.00.0906251903520.26556@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0907161624140.22115@fbirervta.pbzchgretzou.qr> <4A608B3B.20702@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55043 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831AbZGQPzq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2009 11:55:46 -0400
In-Reply-To: <4A608B3B.20702@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-07-17 16:31, Patrick McHardy wrote:
>>> Yeah but in general? The - judging from their version numbers -
>>> x.y.z.S stable versions like 1.4.3.1 used to receive lots of new
>>> features because there is just master, in which case it should
>>> have been the new 1.4.4 already.
>>> So either z is bumped more often and S-versions will not
>>> be released, or S only receives fixes, necessiting a separate branch.
>>> Objections?
>> 
>> It would be cool to get an answer here so I know how to twingle 
>> patchbranches that I'd like to submit.
>
>Well, I don't object to having a stable branch when we actually do
>need to release pure bug-fix versions. But I'd say those can be
>created on demand.
>
Yes, but it requires that any bugfix commit does not have master as a
descendent (otherwise it would be perturbed by dev commits). The core
essential of a (de facto) stable branch is that solely the most
recent tag, (or stable commits), are a parent.

That is what I want to be sure of, esp. when others send commits.
Below's patches respect this.


"Please pull from..."
	git://dev.medozas.de/iptables stable

the two (2) things that Jan Engelhardt piled up:
      xt_conntrack: revision 2 for enlarged state_mask member
      libxt_helper: fix invalid passed option to check_inverse

 extensions/libxt_conntrack.c           |  175 +++++++++++++++++++++++++++-----
 extensions/libxt_helper.c              |    2 +-
 include/linux/netfilter/xt_conntrack.h |   13 +++
 3 files changed, 162 insertions(+), 28 deletions(-)
