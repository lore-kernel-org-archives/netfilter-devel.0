From: Patrick McHardy <kaber@trash.net>
Subject: Re: arptables ruleset not working when compiling on 	fedora6,7,8/centos
 5/redhat 5
Date: Mon, 29 Jun 2009 17:44:10 +0200
Message-ID: <4A48E14A.3060708@trash.net>
References: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>	 <56378e320906290721i63f969edm90aed19619decf71@mail.gmail.com>	 <b2d58cb80906290751j7fb3976bx9d04fed852c8b451@mail.gmail.com>	 <4A48D6AD.4010005@trash.net> <b2d58cb80906290818t66616f70k2fe7596b906a8a4e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Richard Horton <arimus.uk@googlemail.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Nishit Shah <nsshah.82@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <b2d58cb80906290818t66616f70k2fe7596b906a8a4e@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Nishit Shah wrote:
> On Mon, Jun 29, 2009 at 8:28 PM, Patrick McHardy<kaber@trash.net> wrote:
>> Nishit Shah wrote:
>>> On Mon, Jun 29, 2009 at 7:51 PM, Richard Horton<arimus.uk@googlemail.com>
>>> wrote:
>>>> 2009/6/29 Nishit Shah <nsshah.82@gmail.com>:
>>>>> Hi,
>>>>>        I am compiling arptables-v0.0.3-3/arptables-v0.0.3-2 on
>>>>> fedora6,7,8/centos 5/redhat 5. Module is compiled successfully.
>>>>> Following are the simple steps.
>> Which kernel versions (the lowest) are these running?
>>
> 
> lowest is 2.6.18.

Ah, I remember, we had some breakage with of the ARPT codes with the
introduction of x_tables in 2.6.16. Please try to figure out the
difference of those values between working and non-working state
(ARPT_CONTINUE, ARPT_RETURN etc.)
