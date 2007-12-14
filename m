From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Fri, 14 Dec 2007 10:22:46 +0100
Message-ID: <47624B66.5060205@trash.net>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>	 <beb91d720712040832p71981f85yd097f86614e680af@mail.gmail.com>	 <47565BB3.9030500@trash.net>	 <beb91d720712050339w7daeb392me3e3e3cc44bad0d@mail.gmail.com>	 <4757C632.60503@trash.net>	 <beb91d720712060325l22f4b609kdc481a64d36768e9@mail.gmail.com>	 <beb91d720712090534i4df4513bk22b840d75e2ff543@mail.gmail.com>	 <beb91d720712090611va682efcn80db6efb1efbaf0e@mail.gmail.com>	 <475E6696.50805@trash.net>	 <cd6061db0712131341h166734ecjcdfd518cb8dfb5f8@mail.gmail.com> <beb91d720712131414g4daff4e7ic03dd29ed503f197@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Laurence J. Lane" <ljlane@debian.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35440 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXLNJWv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:22:51 -0500
In-Reply-To: <beb91d720712131414g4daff4e7ic03dd29ed503f197@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Salatiel Filho wrote:
> On 12/13/07, Laurence J. Lane <ljlane@debian.org> wrote:
>> On Dec 11, 2007 5:29 AM, Patrick McHardy <kaber@trash.net> wrote:
>>
>>> It shouldn't, but I haven't seen any other complaints about this
>>> yet, so please try to either compile the kernel natively or also
>>> cross-compile iptables.
>> [ I'm jumping in on the end of the thread with comments not directed
>> at anyone specific.]
>>
>> I just saw an additional comment to #446685. A search for "EABI iptables"
>> shows a known arm iptables' problem and at least one workaround is the chroot
>> method mentioned in the report.
>>
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=446685


The bad fd bug visible in the strace attached to that report is the
one I fixed in SVN.

> I have not test the solution cause i have to download 116MB to chroot :)
> But i`m curious , if i compile both source kernel and source iptables
> , should`t they be compatible ?


They should, unless something is causing different structure layout.
