From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Sun, 15 Jan 2012 18:05:05 +0000
Message-ID: <4F131551.2090608@googlemail.com>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu> <4F130A03.7080208@googlemail.com> <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


>> Any chance of fixing this bug soon:
>>
>> ~# ipset n test hash:net family inet timeout 0
>> ~# ipset a test 10.1.0.0/16
>> ~# ipset t test 10.1.12.12
>> 10.1.12.12 is in set test.
>> ~# ipset t test 10.1.12.0/24
>> 10.1.12.0/24 is NOT in test.
>>     
>
> It's a feature which I'm not going to fix in any near future.
>   
It isn't a "feature", it is a bug: 10.1.12.0/24 is within the 
10.1.0.0/16 range, so the above test should return true, not false. 
Either that, or ip range values should be restricted/excluded from the 
"test" command in the ipset userspace binary.

