From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft 3/3] src: add set optimization options
Date: Fri, 19 Sep 2014 19:24:12 +0200
Message-ID: <359d0a48-619a-47d9-93f6-5f77dc117d39@email.android.com>
References: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com> <1411064300-4433-3-git-send-email-arturo.borrero.glez@gmail.com> <49a03ccd-ddb8-47dc-b455-885ddf607e6a@email.android.com> <CAOkSjBheru+aESGEuqLABAsEJvciBBo_ZqFvoVx0fU7vrpk4UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43294 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbaISRYT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:24:19 -0400
In-Reply-To: <CAOkSjBheru+aESGEuqLABAsEJvciBBo_ZqFvoVx0fU7vrpk4UQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19. September 2014 09:04:17 MESZ, Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
>On 18 September 2014 20:39, Patrick McHardy <kaber@trash.net> wrote:
>> On 18. September 2014 20:18:20 MESZ, Arturo Borrero Gonzalez
><arturo.borrero.glez@gmail.com> wrote:
>>>This patch adds options to choose set optimization mechanisms.
>>>
>>>Two new statements are added to the set syntax, and they can be
>mixed:
>>>
>>> nft add set filter set1 { type ipv4_addr ; size 1024 ; }
>>> nft add set filter set1 { type ipv4_addr ; policy memory ; }
>>> nft add set filter set1 { type ipv4_addr ; policy performance ; }
>>>nft add set filter set1 { type ipv4_addr ; policy memory ; size 1024
>;
>>>}
>>>nft add set filter set1 { type ipv4_addr ; size 1024 ; policy memory
>;
>>>}
>>>nft add set filter set1 { type ipv4_addr ; policy performance ; size
>>>1024 ; }
>>>nft add set filter set1 { type ipv4_addr ; size 1024 ; policy
>>>performance ; }
>>>
>>>Also valid for maps:
>>>
>>>nft add map filter map1 { type ipv4_addr : verdict ; policy
>performace
>>>; }
>>> [...]
>>>
>>>
>>>This is the output format, which can be imported later with `nft -f':
>>>
>>>table filter {
>>>       set set1 {
>>>               type ipv4_addr
>>>               policy memory
>>>               size 1024
>>>       }
>>>}
>>
>> Conceptually this looks good, I'll have a look at the implementation
>after dinner.

Sorry, late nicht after dinner, but I'll get to it tommorrow :)

>> What my patch did was only handle the case where limits can be
>determined automatically, IOW literal sets. Both is needed.
>>
>
>Do you mean to give the size parameter a value when we know the set
>has a concrete number of elements?
>For example:
>add rule tcp dport {1 , 2 , 3} counter --> then add a set with fixed
>size 3.

Yes, this is what my patch is doing, and some further analysis of common prefixes etc for an unfinished feature.

>I realize now the patch includes some newlines included by mistake. So
>a v2 is likely to be needed.

Yeah. I've only read it on my mobile so far, but I also noticed some changes which aren't needed, so please hold off with a V2 until tommorrow.

