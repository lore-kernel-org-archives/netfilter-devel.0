From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Wed, 08 Feb 2017 11:30:04 -0500
Message-ID: <5128842.c7Bb9yu5kt@x2>
References: <20170117052551.GQ3087@madcap2.tricolour.ca> <20170207205219.GA5864@madcap2.tricolour.ca> <CAGH-KguuAriVuLEE+mb2HwQLcq6ePeDfVyZ=acoxmomnK5R09w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Paul Moore <pmoore@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35106 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752529AbdBHQaj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 11:30:39 -0500
In-Reply-To: <CAGH-KguuAriVuLEE+mb2HwQLcq6ePeDfVyZ=acoxmomnK5R09w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday, February 7, 2017 10:56:39 PM EST Paul Moore wrote:
> On Tue, Feb 7, 2017 at 3:52 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > So while I'm not advocating this is what should be done and I'm trying
> > to establish bounds to the scope of this feature, but would it be
> > reasonable to simply not log packets that were transiting this machine
> > without a local endpoint?
> 
> I'm still waiting on more detailed requirements information from
> Steve, but based on what we've heard so far, it seems that ignoring
> forwarded traffic is a reasonable thing to do.

OK, I have done teh analysis to see where things stand on this. A long time 
ago, there was no security requirements around virtualization except OSPP v2.0 
from BSI which had a virtualization extended module. In it, it had the 
following requirements:

FDP_IFF.1.2 The TSF shall permit an information flow between a controlled 
subject and controlled information via a controlled operation if the following 
rules hold: [assignment: for each operation, the security attribute-based
relationship that must hold between subject and information security
attributes, which must allow to define the security attribute-based
relationship between two subjects such that information flow
between the compartments is not permitted].
FDP_IFF.1.3 The TSF shall enforce the [assignment: additional information flow 
control SFP rules].
FDP_IFF.1.4 The TSF shall explicitly authorise an information flow based on the
following rules: [assignment: rules, based on security attributes, that
explicitly authorise information flows].
FDP_IFF.1.5 The TSF shall explicitly deny an information flow based on the 
following rules: [assignment: rules, based on security attributes, that 
explicitly deny information flows].

So, whenever there was an allow or deny, then that needed to be auditable. The 
audit target was added and it can be configured to closely mirrored the rules. 
When auditing sufficient information needs to be recorded to make sense of why 
the flow was allowed or denied. Ultimately you really want this connected to a 
process and user if applicable.

However, in reviewing server virtualization protection profile v1.1 and 
operating system protection profile v4.1, there is no FDP_IFF.1 requirement 
which means that there are no more requirements to audit network packets. I 
did not review the network device protection profile which may or may not levy 
requirements for network auditing.

At this point, I would say there is no purpose for xt_AUDIT.c based on Common 
Criteria. It looks like its built in response to the 
CONFIG_NETFILTER_XT_TARGET_AUDIT config option. So, it can be cleanly 
deprecated.

-Steve
