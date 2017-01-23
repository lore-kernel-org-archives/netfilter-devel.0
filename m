From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Sun, 22 Jan 2017 23:49:19 -0500
Message-ID: <20170123044919.GK3087@madcap2.tricolour.ca>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
 <20170118151520.GY3087@madcap2.tricolour.ca>
 <CAHC9VhS_6Q=bxnzU8ni1a2fRWnXoMcELzAmy0HmwMH_xhgfRBw@mail.gmail.com>
 <21839828.eXAB1nqvpV@x2>
 <CAHC9VhT8QQ2inKgJ_ZAeiEOvmnjv-0AbHjrRf-LGfUT+WMFUeQ@mail.gmail.com>
 <e14df9b0-e6ea-c60f-f580-40b10af2392f@gmail.com>
 <CAHC9VhQK67Mi-afj90irrv6h2d1XaiLKEYD0wr+j7JD4MmRTPg@mail.gmail.com>
 <0eb840df-20d7-73ab-e7cb-aa0aa111d7b9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Paul Moore <paul@paul-moore.com>, Steve Grubb <sgrubb@redhat.com>,
        Paul Moore <pmoore@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Patrick PIGNOL <patrick.pignol@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750733AbdAWEtY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Jan 2017 23:49:24 -0500
Content-Disposition: inline
In-Reply-To: <0eb840df-20d7-73ab-e7cb-aa0aa111d7b9@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-01-21 20:12, Patrick PIGNOL wrote:
> Hi all,
> 
> I just writen that because I read
> 
> "
> 
> Determining the pid/subj of a packet is notoriously
> difficult/impossible in netfilter so let's drop that; with proper
> policy/rules you should be able to match proto/port with a given
> process so this shouldn't be that critical.  The source/destination
> addresses and proto/port (assuming IP) should be easy enough.
> 
> "
> 
> OK you explain me you talk about "Linux audit" sub-system. Cool I
> didn't read it like that ! (I'm waiting for netfilter-dev ml).
> 
> Don't tell me that windows is better than linux on that point (see
> ZoneAlarm). I know ZoneAlarm is a Firewall. But if Linux could trace
> it from netfilter you should integrate it in your audit sub system.
> 
> I think it should be good to have to know witch application ask for
> send/receive packet on witch protocol and on witch port and for
> witch IP target(from/to) at a given level of verbosity(debug) and
> how many time for a given time-unit (minute-hour).
> 
> At this level content of packet is not really useful, I think
> wire-shark is better for that.
> 
> Sorry for the noise but it still important for me as a user to can
> trace who have access to an from my computer.

As Paul points out, there are things we know about all packets that we
can put into that report.  There are things we don't know that can't be
a MUST, but can be a SHOULD if we know them to be able to record them
and would be useful.  The challenge here is that if we add a number of
fields from the SHOULD list that are unknown for some use cases
(FORWARD, userless in-kernel targets, ...) they will consume bandwidth
to report empty values, and we are trying to normalize this audit record
type so that fields don't swing in and out needlessly.

> Best regards,
> 
> Patrick PIGNOL
> 
> 
> Le 21/01/2017 à 18:37, Paul Moore a écrit :
> >On Sat, Jan 21, 2017 at 6:27 AM, Patrick PIGNOL
> ><patrick.pignol@gmail.com> wrote:
> >>Hi all,
> >>
> >>I disagree !
> >>
> >>Many people in the world would like to allow an software A to go to internet
> >>through OUTPUT TCP port 80 but disallow software B to go to the internet
> >>through this same OUTPUT TCP port 80. Don't you know about viruses on linux
> >>? Viruses ALWAYS use HTTP/HTTPS ports to get payloads on internet and OUTPUT
> >>TCP port 443 COULD NOT be CLOSED for ALL SOFTWARE if you want to access
> >>internet services (via internet browsers for example).
> >The Linux audit subsystem simply logs system events, it does not
> >enforce security policy.  I suggest you investigate the different
> >Linux firewall tools and LSMs, e.g. SELinux, as they should help you
> >accomplish what you describe.
> >
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
