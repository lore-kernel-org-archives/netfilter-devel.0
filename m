From: Patrick PIGNOL <patrick.pignol@gmail.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Sat, 21 Jan 2017 12:27:39 +0100
Message-ID: <e14df9b0-e6ea-c60f-f580-40b10af2392f@gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
 <20170118151520.GY3087@madcap2.tricolour.ca>
 <CAHC9VhS_6Q=bxnzU8ni1a2fRWnXoMcELzAmy0HmwMH_xhgfRBw@mail.gmail.com>
 <21839828.eXAB1nqvpV@x2>
 <CAHC9VhT8QQ2inKgJ_ZAeiEOvmnjv-0AbHjrRf-LGfUT+WMFUeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <pmoore@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Paul Moore <paul@paul-moore.com>, Steve Grubb <sgrubb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33714 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdAUL1n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Jan 2017 06:27:43 -0500
Received: by mail-wm0-f67.google.com with SMTP id r144so13026647wme.0
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jan 2017 03:27:43 -0800 (PST)
In-Reply-To: <CAHC9VhT8QQ2inKgJ_ZAeiEOvmnjv-0AbHjrRf-LGfUT+WMFUeQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I disagree !

Many people in the world would like to allow an software A to go to 
internet through OUTPUT TCP port 80 but disallow software B to go to the 
internet through this same OUTPUT TCP port 80. Don't you know about 
viruses on linux ? Viruses ALWAYS use HTTP/HTTPS ports to get payloads 
on internet and OUTPUT TCP port 443 COULD NOT be CLOSED for ALL SOFTWARE 
if you want to access internet services (via internet browsers for example).

And we cannot know every dangerous IP in the world. Even because there 
are new one every time in the world. There could be a not dangerous 
server that became dangerous one because it became a hacked server.

So it's an EXCELLENT idea to make Software socket/PID accessible from 
packet netfilter API. That could prevent some malware to access opened 
standard ports and give to the users a way to make better protection 
with closest control on which software ave right to get information from 
the internet.

BE USER FRIENDLY PLEASE !!!!

Best regards,

Patrick PIGNOL

Le 20/01/2017 à 21:37, Paul Moore a écrit :
> On Fri, Jan 20, 2017 at 9:49 AM, Steve Grubb <sgrubb@redhat.com> wrote:
>> On Wednesday, January 18, 2017 6:35:29 PM EST Paul Moore wrote:
>>> At this point I think it would be good to hear what requirements exist
>>> for per-packet auditing.  Steve, are there any current Common Criteria
>>> (or other) requirements that impact per-packet auditing?
>> I don't think you want to flood your logs. That is not helpful. It asks for the
>> ability to detect information flow. Typically you want to know source and
>> destination, protocol, where on the system its coming from or going to, pid if
>> possible and the subject information if available. I know that you can be
>> acting as a proxy and forwarding outside packets into a network. That is not
>> the typical case CC is concerned about. Its more about what the user is doing.
> Determining the pid/subj of a packet is notoriously
> difficult/impossible in netfilter so let's drop that; with proper
> policy/rules you should be able to match proto/port with a given
> process so this shouldn't be that critical.  The source/destination
> addresses and proto/port (assuming IP) should be easy enough.
>
> All right, now that we've got the "must" items down, are their any
> "should" items we want?
>

