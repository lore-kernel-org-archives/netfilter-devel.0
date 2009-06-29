From: Nishit Shah <nsshah.82@gmail.com>
Subject: Re: arptables ruleset not working when compiling on
	fedora6,7,8/centos 5/redhat 5
Date: Mon, 29 Jun 2009 21:48:20 +0530
Message-ID: <b2d58cb80906290918q2da5af1ap87772755b3363032@mail.gmail.com>
References: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>
	 <56378e320906290721i63f969edm90aed19619decf71@mail.gmail.com>
	 <b2d58cb80906290751j7fb3976bx9d04fed852c8b451@mail.gmail.com>
	 <4A48D6AD.4010005@trash.net>
	 <b2d58cb80906290818t66616f70k2fe7596b906a8a4e@mail.gmail.com>
	 <4A48E14A.3060708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Richard Horton <arimus.uk@googlemail.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4A48E14A.3060708@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 29, 2009 at 9:14 PM, Patrick McHardy<kaber@trash.net> wrote=
:
> Nishit Shah wrote:
>>
>> On Mon, Jun 29, 2009 at 8:28 PM, Patrick McHardy<kaber@trash.net> wr=
ote:
>>>
>>> Nishit Shah wrote:
>>>>
>>>> On Mon, Jun 29, 2009 at 7:51 PM, Richard
>>>> Horton<arimus.uk@googlemail.com>
>>>> wrote:
>>>>>
>>>>> 2009/6/29 Nishit Shah <nsshah.82@gmail.com>:
>>>>>>
>>>>>> Hi,
>>>>>> =A0 =A0 =A0 I am compiling arptables-v0.0.3-3/arptables-v0.0.3-2=
 on
>>>>>> fedora6,7,8/centos 5/redhat 5. Module is compiled successfully.
>>>>>> Following are the simple steps.
>>>
>>> Which kernel versions (the lowest) are these running?
>>>
>>
>> lowest is 2.6.18.
>
> Ah, I remember, we had some breakage with of the ARPT codes with the
> introduction of x_tables in 2.6.16. Please try to figure out the
> difference of those values between working and non-working state
> (ARPT_CONTINUE, ARPT_RETURN etc.)
>

Bingo !!!

It is due to the value of ARPT_RETURN. ARPT_RETURN defined in
arptables-v0.0.3-3 is

=2E/include/linux/netfilter_arp/arp_tables.h:#define ARPT_RETURN
(-NF_MAX_VERDICT - 1)

and value of NF_MAX_VERDICT is different on machine running with gcc
2.96/glibc 2.2.4 and above all machines.

value of NF_MAX_VERDICT on machine running gcc 2.96 and glibc 2.2.4,

        /usr/include/linux/netfilter.h:#define NF_MAX_VERDICT NF_REPEAT

and same file on all above machines,

        /usr/include/linux/netfilter.h:#define NF_MAX_VERDICT NF_STOP

Thanks Patrick :)

Rgds,
Nishit Shah.
