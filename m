From: Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: Update pf.os with newer OS fingerprints
Date: Fri, 8 Feb 2019 17:25:38 +0100
Message-ID: <26083325-457a-1a4d-6aff-935d887d6478@riseup.net>
References: <7d39a0dc-d7bd-7934-1d86-7268bf7c51b9@riseup.net>
 <20190208160725.aen3uil2jmfnp6zc@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: tech@openbsd.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <owner-tech+M68996=goot+2Dtech=gmane.org@openbsd.org>
In-Reply-To: <20190208160725.aen3uil2jmfnp6zc@salvia>
Content-Language: en-US-large
List-Help: <mailto:majordomo@openbsd.org?body=help>
List-Owner: <mailto:owner-tech@openbsd.org>
List-Post: <mailto:tech@openbsd.org>
List-Subscribe: <mailto:majordomo@openbsd.org?body=sub%20tech>
List-Unsubscribe: <mailto:majordomo@openbsd.org?body=unsub%20tech>
Sender: owner-tech@openbsd.org
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On 2/8/19 5:07 PM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Fri, Feb 08, 2019 at 03:06:00PM +0100, Fernando Fernandez Mancera wrote:
>> Hi,
>>
>> I have been updating the pf.os signatures with more recent OS
>> fingerprints. I have checked out new Linux, FreeBSD and OpenBSD but only
>> Linux and FreeBSD needed new ones. I have been doing this because it is
>> related with my work during the last Google Summer of Code. In addition,
>> Michal Zalewski is aware of the new fingerprints too.
>>
>> Thanks.
>>
>> P.S: Keep me on Cc. I'm not subscribed to the list.
>>
>> diff --git etc/pf.os etc/pf.os
>> index 41c1bc6a482..8f235876799 100644
>> --- etc/pf.os
>> +++ etc/pf.os
>> @@ -232,6 +232,11 @@ S4:64:1:60:M*,S,T,N,W7:		Linux:2.6::Linux 2.6
>> (newer, 3)
>>  T4:64:1:60:M*,S,T,N,W7:		Linux:2.6::Linux 2.6 (newer, 4)
>>
>>  S10:64:1:60:M*,S,T,N,W4:	Linux:3.0::Linux 3.0
>> +S10:64:1:60:M*,S,T,N,W6:	Linux:3.1::Linux 3.1
>> +S10:64:1:60:M*,S,T,N,W7:	Linux:3.4-3.10::Linux 3.4 - 3.10
>> +S20:64:1:60:M*,S,T,N,W7:	Linux:3.11-3.19::Linux 3.11 - 3.19
>> +S20:64:1:60:M*,S,T,N,W7:	Linux:4.0-4.19::Linux 4.0 - 4.19
> 
> Probably merge these two lines above? ie.
> > S20:64:1:60:M*,S,T,N,W7:	Linux:3.11-4.19::Linux 3.11 - 4.19
> 

I split this one by following the pattern of similar situations for
other fingerprints. eg.

16384:64:1:44:M*:		FreeBSD:2.0-2.2::FreeBSD 2.0-4.2
16384:64:1:44:M*:		FreeBSD:3.0-3.5::FreeBSD 2.0-4.2
16384:64:1:44:M*:		FreeBSD:4.0-4.2::FreeBSD 2.0-4.2

65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:4.7-4.11::FreeBSD 4.7-5.2
65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:5.0-5.2::FreeBSD 4.7-5.2

In my opinion I would make no changes to these two lines. Do you agree?

>> +S44:64:1:60:M*,S,T,N,W7:	Linux:4.20::Linux 4.20
>>
>>  S3:64:1:60:M*,S,T,N,W1:		Linux:2.5::Linux 2.5 (sometimes 2.4)
>>  S4:64:1:60:M*,S,T,N,W1:		Linux:2.5-2.6::Linux 2.5/2.6
>> @@ -283,6 +288,8 @@ S22:64:1:52:M*,N,N,S,N,W0:	Linux:2.2:ts:Linux 2.2
>> w/o timestamps
>>  65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:4.7-4.11::FreeBSD 4.7-5.2
>>  65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:5.0-5.2::FreeBSD 4.7-5.2
>>
>> +65535:64:1:60:M*,N,W6,S,T:	FreeBSD:9.0-12.0::FreeBSD 9.0 - 12.0
>> +
>>  # XXX need quirks support
>>  # 65535:64:1:60:M*,N,W0,N,N,T:Z:FreeBSD:5.1-5.4::5.1-current (1)
>>  # 65535:64:1:60:M*,N,W1,N,N,T:Z:FreeBSD:5.1-5.4::5.1-current (2)
