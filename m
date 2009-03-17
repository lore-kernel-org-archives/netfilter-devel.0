From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 15:36:31 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0903171532230.14581@bizon.gios.gov.pl>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org> <49BF9F7E.3090208@trash.net> <alpine.LNX.1.10.0903171411560.17354@bizon.gios.gov.pl> <49BFA633.4010306@trash.net>
 <alpine.LNX.1.10.0903171444060.14581@bizon.gios.gov.pl> <49BFAADF.9000008@trash.net> <alpine.LNX.1.10.0903171452570.14581@bizon.gios.gov.pl> <49BFAC57.1060702@trash.net> <alpine.LNX.1.10.0903171505320.14581@bizon.gios.gov.pl> <49BFB217.9050001@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1678644367-1237300592=:14581"
Cc: Jan Engelhardt <jengelh@medozas.de>, pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:59556 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZCQOgn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:36:43 -0400
In-Reply-To: <49BFB217.9050001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1678644367-1237300592=:14581
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Tue, 17 Mar 2009, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> 
>> 
>> On Tue, 17 Mar 2009, Patrick McHardy wrote:
>> 
>>> Krzysztof Oledzki wrote:
>>>> 
>>>> 
>>>> On Tue, 17 Mar 2009, Patrick McHardy wrote:
>>>> 
>>>>> Krzysztof Oledzki wrote:
>>>>>>> I'd say it has been long enough, but Jan raised a valid point.
>>>>>>> We can't use the Kconfig selection anymore once we remove that
>>>>>>> option, so we need a replacement to automatically enable counters.
>>>>>> 
>>>>>> So loading connbytes should enable accounting automatically. Fine, it 
>>>>>> is doable. But how we want to handle it WRT to NS? Should it be enabled 
>>>>>> in all NameSpaces or...?
>>>>> 
>>>>> Just the ones it is actually used in I'd say (i.e. in the checkentry
>>>>> function for the current namespace).
>>>> 
>>>> OK, but AFAIK modules are not namespace dependly, so why only in actually 
>>>> used one? This bugs me a little.
>>> 
>>> But using them is namespace dependant.
>> 
>> How?
>
> The "connbytes" rules exist only in a specific namespace.

True, but it migh be too late to enable accounting at that point. What if 
there are already acitive flows?

>> Anyway, how about this:
>>  sysctl net.netfilter.nf_conntrack_acct=0 -> disable accounting in this NS
>>  sysctl net.netfilter.nf_conntrack_acct=1 -> enable accounting in this NS
>>  sysctl net.netfilter.nf_conntrack_acct=-1 -> (default) use global value in 
>> this NS
>> 
>> Global value: by default 0 if connbytes is not loaded, 1 if it is.
>> Global value could be set with nf_conntrack.acct=0/1 (kernel) acct=0/1 
>> (module) or sysctl (??? how global, NS independent sysctls are named???).
>> 
>> Doubts:
>>  - should we set global value to 0 when unloading connbytes?
>
> Why do anything global at all? Its not needed unless connbytes is used
> (or something in userspace, which we can't detect), and that affects
> only a single namespace.

To enable it before the first packet?

Best regards,

 				Krzysztof Olêdzki
---1144830174-1678644367-1237300592=:14581--
