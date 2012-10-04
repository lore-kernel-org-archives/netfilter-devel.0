From: "Gutholm, James" <gutholmj@evergreen.edu>
Subject: Re: Conntrackd Segmentation fault due to nfexp_get_attr returning
 NULL
Date: Thu, 4 Oct 2012 02:36:47 +0000
Message-ID: <3E070A3A9446DB43B8A316366DBEABBE1F26B561@palm.evergreen.edu>
References: <20121003203338.GA10154@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from abalone.evergreen.edu ([192.211.16.10]:16022 "EHLO
	abalone.evergreen.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2JDCgt convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Oct 2012 22:36:49 -0400
In-Reply-To: <20121003203338.GA10154@1984>
Content-Language: en-US
Content-ID: <34CE9FCFC36DC043A1B7F1AA82BDFAAA@evergreen.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Thanks for the quick reply. So far, no crashes on the standby which gets a
little traffic. I'll run it on the active firewall on Friday but expect
the same

-- James



On 10/3/12 1:33 PM, "Pablo Neira Ayuso" <pablo@netfilter.org> wrote:

>On Wed, Oct 03, 2012 at 06:52:08PM +0000, Gutholm, James wrote:
>> 
>> Under heavy load conntrackd is crashing. Running under gdb I was able
>>to determine that the crashes are caused by an unchecked null pointer
>>returned by nfexp_get_attr in both exp_filter_find() in filter.c and
>>exp_build_str() in build.c
>> i
>> This only happens when expectation sync is being used. Setting
>>"ExpectationSync Off" in conntrackd.conf stops the crashes.
>> 
>> I coded in a couple of checks on the pointer returned which at least
>>stop the errors. I've included the changes as diffs and also the gdb
>>output in case it is helpful. If there's something else I can provide,
>>I'm happy to help but this might be pushing the limit of my expertise.
>> 
>> James
>> 
>> This is on RHEL6 (2.6.32-300.32.2.el6uek.x86_64) with conntrack-tool
>>built from source.
>
>I see, I forgot to document that Linux kernel >= 3.5 to get
>ExpectationSync working flawlessly is required.
>
>I have attached the following patch. It fixes the crash, and document
>this accordingly but you still will have to upgrade your kernel if you
>want expectation synchronization.
>
>BTW, thanks a lot for the report, really accurate.
>
>I'd appreciate if you give it a test, just to make sure we don't crash
>anymore, even if you will not get the expectsync feature working
>correctly in all possible scenarios.

