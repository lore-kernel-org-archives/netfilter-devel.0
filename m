From: David Miller <davem@davemloft.net>
Subject: Re: fedora plans to replace iptables with firewalld
Date: Thu, 15 Nov 2012 15:45:15 -0500 (EST)
Message-ID: <20121115.154515.1601270379989323660.davem@davemloft.net>
References: <50A542CD.7030604@earthlink.net>
	<20121115.143737.1667162595710068997.davem@davemloft.net>
	<50A5530A.9000509@earthlink.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: sclark46@earthlink.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:48512 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab2KOVkb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:40:31 -0500
In-Reply-To: <50A5530A.9000509@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Stephen Clark <sclark46@earthlink.net>
Date: Thu, 15 Nov 2012 15:39:38 -0500

> On 11/15/2012 02:37 PM, David Miller wrote:
>> From: Stephen Clark<sclark46@earthlink.net>
>> Date: Thu, 15 Nov 2012 14:30:21 -0500
>>
>>> Is anyone here aware that fedora is planning on replacing iptables
>>> with something called firewalld?
>> It's an abstraction layer built on top of iptables and ebtables,
>> not a replacement.
>>
>> A simple read of the project web site would have told you this,
>> and I encourage you to do some research in the future instead
>> of spreading misinformation.
>>
>> Thanks.
>>
> This is not what it says in the feature page at
> https://fedoraproject.org/wiki/Features/firewalld-default#Detailed_Description

The "service" as in the user level scripts, not the kernel level
components.

Read the project page, for real:

https://fedoraproject.org/wiki/FirewallD

Where it explicitly says:

====================
Adding an abstraction layer on top of ip*tables and ebtables firewall
rules makes adding rules simple and more intuitive. The abstraction
layer needs to be powerful, but also simple, which makes this not an
easy task. A firewall language has to gen invented for this. Firewall
rules have a fixed position and querying generic information about
access state, access policies for ports and other firewall features is
possible.
====================

Please stop wasting everyone's time.
