From: Ricardo Klein <klein.rfk@gmail.com>
Subject: Re: ipset 6.16 kernel panic on bitmap:hash,ip
Date: Tue, 27 Nov 2012 12:17:01 -0200
Message-ID: <CADuigkWgP09UL7Qd=vtZU5X5mC6xugc9Rr_QWysAjPjDod7xjQ@mail.gmail.com>
References: <CADuigkVyCJVe5yKVvcKweZ=FmnTTWE1JQ55a35LrCLi2oWBHoQ@mail.gmail.com>
	<alpine.DEB.2.00.1211271352350.14623@blackhole.kfki.hu>
	<CADuigkX8Q0AJ_-PHyzn+1orKuXfqgrdPPC3yZ1aORBJrdcxBLg@mail.gmail.com>
	<alpine.DEB.2.00.1211271403550.14623@blackhole.kfki.hu>
	<CADuigkUwmj1d2PWW7wWvu12e7J9K6V9gvs+8BiM_J8QjYT5RGw@mail.gmail.com>
	<CADuigkUGcYNBYjgB+fLp4A5M-pDd779E-6WCpfVv5tqvpnfpUQ@mail.gmail.com>
	<alpine.DEB.2.00.1211271459050.15929@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42698 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab2K0ORC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:17:02 -0500
In-Reply-To: <alpine.DEB.2.00.1211271459050.15929@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So I can use bitmap:ip,mac to set a lot of mac address entryes with
fake IPs and use iptables rules only matching the MAC from the set?
So, I can workaround the lack of a mac only set and use this for now? Nice...
How should be my iptable rule to match only the mac address from the set?
--
Att...

Ricardo Felipe Klein
klein.rfk@gmail.com


On Tue, Nov 27, 2012 at 12:03 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Tue, 27 Nov 2012, Ricardo Klein wrote:
>
>> So did I foud a bug? If yes, glad to help \o/
>>
>> Well, with 6.15 it builds OK...
>
> You are trying to compile 6.16 with a kernel which lacks some
> definitions and I have to workaround that.
>
>> BUT, I cant use bitmap:ip,mac on iptables rules... check this:
>>
>> # CLEAR ALL IPTABLES RULES
>> iptables -F
>>
>> #CRIATE SET
>> ipset destroy SET_MACS_ADM
>> ipset -N SET_MACS_ADM macipmap range 10.0.0.0/16
>> sleep 1
>>
>> # POPULATE SET
>> ipset -A SET_MACS_ADM 10.0.34.32,00:1F:3B:xx:xx:xx
>> *(xx:xx:xx was intentional to hide my mac address)
>>
>> # CREATE IPTABLES RULE
>> iptables -A INPUT -m set --set SET_MACS_ADM src -j DROP
>>
>> it is not blocking traffic coming from that machine...
>
> Yes, because you specified one directional parameter only: bitmap:ip,mac
> is a two dimensional set and thus the set match/SET target require two
> directional parameters.
>
> You can't force bitmap:ip,mac to match only the MAC addresses.
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
