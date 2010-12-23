From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Thu, 23 Dec 2010 18:00:38 +0000
Message-ID: <4D138E46.7090207@googlemail.com>
References: <4D11F384.3070908@googlemail.com>	<alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu>	<4D138C02.3050905@googlemail.com> <20101223.095545.183057798.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, dennisml@conversis.de,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20101223.095545.183057798.davem@davemloft.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


>>> If you need to match the same port both with TCP and UDP, then add it
>>> to the set twice, with the proper protocols.
>>>   
>>>       
>> I've already dealt with this - I do not see the need to add 2x as many
>> elements to a set when, in reality, I am not interested in matching
>> the protocol part.
>>     
>
> You must, every protocol puts the ports in a different location.
>   
What do you mean by 'puts the ports in a different location'? Clarify 
please.

