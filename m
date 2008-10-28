From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: netfilter 00/03: netfilter -stable fixes
Date: Tue, 28 Oct 2008 03:13:32 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0810280311030.15543@bizon.gios.gov.pl>
References: <20081022174126.21341.38231.sendpatchset@x2.localnet> <alpine.LNX.1.10.0810240229550.4386@bizon.gios.gov.pl> <49014390.7080909@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1312516316-1225160012=:15543"
Cc: stable@kernel.org, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>
To: gregkh@suse.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:59026 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYJ1CNp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Oct 2008 22:13:45 -0400
In-Reply-To: <49014390.7080909@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1312516316-1225160012=:15543
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Fri, 24 Oct 2008, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> On Wed, 22 Oct 2008, Patrick McHardy wrote:
>> 
>>> The following three patches for -stable fix some netfilter issues:
>>> 
>>> - a regression in the iprange match, causing mismatches with inversion
>>> - a memory leak in the SNMP NAT helper
>>> - a lost #ifdef, allowing user-triggerable WARN_ONs with NETFILTER_DEBUG
>>>  (and some minor runtime misbehaviour)
>> 
>> Which kernels need above patches? Only 2.6.27 or also 2.6.25/2.6.26?
>
> I think all three patches are also needed for 2.6.25 and 2.6.26.

Thank you for the confirmation.

Greg, could you please put above patches info queue-2.6.25/queue-2.6.26?

Best regards,

 			Krzysztof Olêdzki
---1144830174-1312516316-1225160012=:15543--
