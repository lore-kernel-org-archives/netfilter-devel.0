From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_ecn revisited
Date: Tue, 27 Dec 2011 19:29:02 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112271927390.28894@frira.zrqbmnf.qr>
References: <1324999681-22479-1-git-send-email-jengelh@medozas.de> <20111227181858.GA28674@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41552 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab1L0S3F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:29:05 -0500
In-Reply-To: <20111227181858.GA28674@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-12-27 19:18, Pablo Neira Ayuso wrote:

>On Tue, Dec 27, 2011 at 04:27:56PM +0100, Jan Engelhardt wrote:
>> 
>> fatal: Unable to look up  (port 9418) (No address associated with hostname)
>> warn: No branch of git://dev.medozas.de is at:
>> warn:   806e172: netfilter: xtables: collapse conditions in xt_ecn
>> warn: Are you sure you pushed HEAD there?
>> 
>> The following changes since commit c5e1fd8ccae09f574d6f978c90c2b968ee29030c:
>> 
>>   Merge branch 'nf-next' of git://1984.lsi.us.es/net-next (2011-12-25 02:21:45 -0500)
>> 
>> are available in the git repository at:
>> 
>>   git://dev.medozas.de ..BRANCH.NOT.VERIFIED..
>> 
>> Jan Engelhardt (3):
>>       netfilter: xtables: move ipt_ecn to xt_ecn
>>       netfilter: xtables: give xt_ecn its own name
>>       netfilter: xtables: collapse conditions in xt_ecn
>> 
>> Patrick McHardy (1):
>>       netfilter: xtables: add an IPv6 capable version of the ECN match
>
>Is this Patrick's or you made a mistake here?

Yes, Patrick indeed crafted that patch (09 June 2011 originally).

  git://dev.medozas.de/linux xtecn
