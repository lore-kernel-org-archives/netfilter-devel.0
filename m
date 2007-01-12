From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: Re: Re: dst cache overflow
Date: Fri, 12 Jan 2007 02:06:12 +0100 (CET)
Message-ID: <53037.84.123.236.132.1168563972.squirrel@www.arcoscom.com>
References: <60665.10.1.1.10.1167776653.squirrel@www.arcoscom.com>
	<55635.10.1.1.10.1167946368.squirrel@www.arcoscom.com>
	<45A492AE.2030909@trash.net>
	<54528.195.55.244.106.1168435239.squirrel@www.arcoscom.com>
	<Pine.LNX.4.61.0701101556310.28241@ask.diku.dk>
	<34737.84.123.236.132.1168444904.squirrel@www.arcoscom.com>
	<Pine.LNX.4.61.0701102023390.7998@ask.diku.dk>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <lartc-bounces@mailman.ds9a.nl>
In-Reply-To: <Pine.LNX.4.61.0701102023390.7998@ask.diku.dk>
To: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

Thanks, good tool: I'm using it to take a view into the routes table.

El Mie, 10 de Enero de 2007, 20:40, Jesper Dangaard Brouer escribi=F3:
>
> The values looks reasonable, garbage collection start (gc_thresh:32768)
> fairly early, but I often see that the GC cannot keep up.
>
> The maximum size of the route cache max_size=3D524288 is okay, but it
> depends on the usage pattern.  On my production systems I has increased
> max_size to 2 million, to keep up!
>
> Another interesting value is secret_interval:600, which is the interval
> the route cache is flushed, in seconds, that is 10 minuts.
>
>   524288/600 =3D 873 packet/sec to new destinations.
>
> You should realize that filling the route cache in 10 minuts can happen=
,
> as it only requires 873 packet/sec to new destinations.
>
>
> What to do next:
>
> Monitor the route cache, to see whats actually happening. The route cac=
he
> counters are located in /proc/net/stat/rt_cache, but is not very human
> readable.  Use the tool "rtstat" to monitor the route cache.
>
> The rtstat tool can be downloaded from Roberts site:
>   ftp://robur.slu.se/pub/Linux/net-development/rt_cache_stat
>
> Cheers,
>    Jesper Brouer
>
> --
> -------------------------------------------------------------------
> MSc. Master of Computer Science
> Dept. of Computer Science, University of Copenhagen
> Author of http://www.adsl-optimizer.dk
> -------------------------------------------------------------------
>
>
>
> On Wed, 10 Jan 2007, ArcosCom Linux User wrote:
>
>> Here are:
>>
>> # grep . /proc/sys/net/ipv4/route/*
>> /proc/sys/net/ipv4/route/error_burst:5000
>> /proc/sys/net/ipv4/route/error_cost:1000
>> grep: /proc/sys/net/ipv4/route/flush: Operaci=F3n no permitida
>> /proc/sys/net/ipv4/route/gc_elasticity:8
>> /proc/sys/net/ipv4/route/gc_interval:60
>> /proc/sys/net/ipv4/route/gc_min_interval:0
>> /proc/sys/net/ipv4/route/gc_min_interval_ms:500
>> /proc/sys/net/ipv4/route/gc_thresh:32768
>> /proc/sys/net/ipv4/route/gc_timeout:300
>> /proc/sys/net/ipv4/route/max_delay:10
>> /proc/sys/net/ipv4/route/max_size:524288
>> /proc/sys/net/ipv4/route/min_adv_mss:256
>> /proc/sys/net/ipv4/route/min_delay:2
>> /proc/sys/net/ipv4/route/min_pmtu:552
>> /proc/sys/net/ipv4/route/mtu_expires:600
>> /proc/sys/net/ipv4/route/redirect_load:20
>> /proc/sys/net/ipv4/route/redirect_number:9
>> /proc/sys/net/ipv4/route/redirect_silence:20480
>> /proc/sys/net/ipv4/route/secret_interval:600
>>
>>
>> El Mie, 10 de Enero de 2007, 16:01, Jesper Dangaard Brouer escribi=F3:
>>>
>>>
>>> On Wed, 10 Jan 2007, ArcosCom Linux User wrote:
>>>
>>>> El Mie, 10 de Enero de 2007, 8:15, Patrick McHardy escribi=F3:
>>>>> ArcosCom Linux User wrote:
>>>>>> The log says:
>>>>>> Dec 30 00:52:27 cura kernel: dst cache overflow
>>>
>>> The log message "dst cache overflow" is normally related to overflow =
of
>>> the route cache.  The max_size of the route cache can be adjusted
>>> through
>>> /proc/sys/net/ipv4/route/max_size.
>>>
>>> What is your settings in /proc/sys/net/ipv4/route/?
>>>
>>> Run command:
>>>   grep . /proc/sys/net/ipv4/route/*
>>>
>>> Hilsen
>>>    Jesper Brouer
>>>
>>> --
>>> -------------------------------------------------------------------
>>> MSc. Master of Computer Science
>>> Dept. of Computer Science, University of Copenhagen
>>> Author of http://www.adsl-optimizer.dk
>>> -------------------------------------------------------------------
>
