From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH 2/4] netfilter: ipset: generalize netmask to support cidr
 and mask values
Date: Tue, 28 Mar 2017 15:01:54 -0500
Message-ID: <c9e1322d-4436-cf3d-0780-e37c18228e2f@akamai.com>
References: <1490120944-1770-1-git-send-email-johunt@akamai.com>
 <1490120944-1770-3-git-send-email-johunt@akamai.com>
 <alpine.DEB.2.11.1703272110580.16553@blackhole.kfki.hu>
 <e813c815-6803-6268-2bc0-cfe28f128093@akamai.com>
 <alpine.DEB.2.11.1703282010360.20521@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:25916 "EHLO
        prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753487AbdC1UCC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 16:02:02 -0400
In-Reply-To: <alpine.DEB.2.11.1703282010360.20521@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/28/2017 01:28 PM, Jozsef Kadlecsik wrote:
> Hi Josh,
>
> On Tue, 28 Mar 2017, Josh Hunt wrote:
>
>>> Overall, I like the feature and the patches. After reviewing I comment
>>> only the parts where I believe some modifications are needed.
>>
>> Thanks for the review. I'll go through this and send a v2 in the next
>> few days.
>
> Thinking over it I understand better your approach: replace
> IPSET_ATTR_NETMASK with IPSET_ATTR_NETMASK_MASK completely and keeping the
> former for backward compatibility reasons only. What I propose is able to
> maintain syntax-compatibility in the sense that what is passed to the
> kernel as cidr/netmask can be saved from there in the same syntax.

I have not gone through all of your comments yet, but my intention was 
to make sure that if cidrs are used they are presented the same way they 
are today (prior to my patches.) If a user uses the new full netmask 
support then that is what is shown. This way we stay consistent with 
whatever the user inputs at create time.

Examples of both:

# ipset create foo hash:ip netmask 24
# ipset list -t foo
Name: foo
Type: hash:ip
Revision: 5
Header: family inet hashsize 1024 maxelem 65536 netmask 24
Size in memory: 104
References: 0
Number of entries: 0

# ipset create foo hash:ip netmask 255.255.255.0
# ipset list -t foo
Name: foo
Type: hash:ip
Revision: 5
Header: family inet hashsize 1024 maxelem 65536 netmask 255.255.255.0
Size in memory: 104
References: 0
Number of entries: 0

Internally they both resolve to the same mask, but we present them 
consistently based on how they were input at create time.

This way if a user uses cidrs today nothing changes from their perspective.

>
> The exemption from adding multiple entries from a range in the case of
> non-cidr value netmask must also be documented in the manpage. Maybe it'd
> be even better additionally to return an explicit error in such cases:
> thus it cannot lead to a misunderstanding from user point of view.

I haven't gone through this yet, but will take a look and let you know 
if I have any questions.

Josh
