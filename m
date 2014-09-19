From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables 1/3] netfilter: nf_tables: store and dump sets mechanism options
Date: Fri, 19 Sep 2014 19:20:25 +0200
Message-ID: <853b5e6a-3244-470f-9ba8-b16970404b2b@email.android.com>
References: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com> <1de321c7-7c48-4dcb-a445-b27aae8d8bcf@email.android.com> <CAOkSjBjbW+vkbLZbOmFAdRxzbPTNQ-BkPdLN2asyAcaXO50arQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43265 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbaISRUc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:20:32 -0400
In-Reply-To: <CAOkSjBjbW+vkbLZbOmFAdRxzbPTNQ-BkPdLN2asyAcaXO50arQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19. September 2014 08:51:48 MESZ, Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
>On 18 September 2014 20:34, Patrick McHardy <kaber@trash.net> wrote:
>> On 18. September 2014 20:18:18 MESZ, Arturo Borrero Gonzalez
><arturo.borrero.glez@gmail.com> wrote:
>>>The sets mechanism options was not being stored anywhere.
>>>
>>>We want to know in which cases the user explicitly set the mechanism
>>>options. In that case, we also want to dump back the info.
>>>
>>
>> I don't think this is needed. Basically we always want to dump
>options for non-constant sets, since they couldn't have been chosen
>automatically, and don't need to dump them for constant sets, since
>they can always be determined automatically based on the contents.
>>
>
>Could you please elaborate?
>
>If the set is non-constant, currently the options are by default
>NFT_SET_POL_PERFORMANCE and size 0.
>Do you want these options to be printed to the end user even when the
>user did not originally use the 'policy xx' and 'size xx' statements?
>Or in the other hand, to never print the options even when the user
>gave an explicit config?

No. When we have literal/constant sets we can automatically determine the options, and we don't need to return them from the kernel. We could, but its useless.

For named sets any options that are not the default must have been specified by the user. So we must always dump them unless they are the default.

>In the case of constant sets, what If I want to test the performance
>of different policies? I need to know which policy is applied to a
>given set, (in order to change it).

Well, the mechanism is supposed to pick the best implementation. For testing, you can unload modules, the kernel won't autoload if at least one set implementation is available.


