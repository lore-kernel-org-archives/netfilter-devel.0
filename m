From: Ana Rey <ana@soleta.eu>
Subject: Re: Accounting objects support in nft
Date: Tue, 13 Jan 2015 09:25:53 +0100
Message-ID: <54B4D691.9000604@soleta.eu>
References: <cover.1421059192.git.ana@soleta.eu> <CAOkSjBi6K9t0W5Nv=mBwNUMbzT3UeFsMoadqzkBpSfDqJ3tJUQ@mail.gmail.com> <20150112123516.GA4546@salvia> <20150112123711.GL3491@acer.localdomain> <CAOkSjBikkYosr1q=T1yKMaTugLFB-b3hWyJtde5iFPjpmOhAXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:46889 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbAMIZM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:25:12 -0500
In-Reply-To: <CAOkSjBikkYosr1q=T1yKMaTugLFB-b3hWyJtde5iFPjpmOhAXg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 12/01/15 21:43, Arturo Borrero Gonzalez wrote:
> On 12 January 2015 at 13:37, Patrick McHardy <kaber@trash.net> wrote:
>> On 12.01, Pablo Neira Ayuso wrote:
>>> On Mon, Jan 12, 2015 at 12:48:35PM +0100, Arturo Borrero Gonzalez wrote:
>>>> On 12 January 2015 at 11:55,  <ana@soleta.eu> wrote:
>>>>>
>>>>> table ip filter {
>>>>>         acct http-traffic { pkts 779 bytes 99495}
>>>>>         acct https-traffic { pkts 189 bytes 37824}
>>>>>
>>>>>         chain output {
>>>>>              type filter hook output priority 0;
>>>>>              tcp dport http acct http-traffic
>>>>>              tcp dport https acct https-traffic
>>>>>         }
>>>>> }
>>>>>
>>>>
>>>> Interesting, Ana!
>>>>
>>>> I understand that acct objects are bounded to a table/family.
>>>> Why not make them globals? So we could increment same counters from
>>>> different families/tables.
>>>
>>> Indeed. The existing binding between acct and tables is superfluous.
>>> With sets, we need that to check for loops in verdict maps.
>>>
>>> So counters can become also top-level identifier as it happens with
>>> tables, ie.
>>>
>>> counters {
>>>         http-traffic { pkts 779 bytes 99495}
>>>         acct https-traffic { pkts 189 bytes 37824}
>>> }
>>>
>>> table ip filter {
>>>         chain output {
>>>              type filter hook output priority 0;
>>>              tcp dport http counter http-traffic
>>>              tcp dport https counter https-traffic
>>>         }
>>> }
>>>
>>> Patrick, any comment on that?
>>
>> I'm unsure, we don't have any global objects so far, this might open
>> another can of flushing/ordering etc problems. If it works without
>> problems, I can see both variants being useful. Given that we only
>> need a list to store them we might be able to support both by minor
>> adjustments to the lookup function.
>>
>> If we do actually want to support both, I'd suggest to start using
>> just table scope and expand it later.
> 
> Ok :-)

ok.
