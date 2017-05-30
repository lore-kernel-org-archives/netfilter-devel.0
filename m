From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH conntrack-tools] ipv6: remove use of HAVE_INET_PTON_IPV6
Date: Tue, 30 May 2017 09:54:55 +0200
Message-ID: <023cbfd9-3d9a-24b7-442d-1c16347fca9e@6wind.com>
References: <1496072655-26752-1-git-send-email-nicolas.dichtel@6wind.com>
 <20170529162523.GA22681@salvia>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35381 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbdE3Hy6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2017 03:54:58 -0400
Received: by mail-wm0-f48.google.com with SMTP id b84so80877021wmh.0
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 00:54:57 -0700 (PDT)
In-Reply-To: <20170529162523.GA22681@salvia>
Content-Language: fr
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 29/05/2017 à 18:25, Pablo Neira Ayuso a écrit :
[snip]
>> -#ifdef HAVE_INET_PTON_IPV6
>> -	if (inet_pton(AF_INET6, $2,
>> -		      &conf.channel[conf.channel_num].u.mcast.in) <= 0) {
>> +	err = inet_pton(AF_INET6, $2,
>> +			&conf.channel[conf.channel_num].u.mcast.in);
>> +	if (err == 0) {
>>  		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
>>  		break;
>> +	} else if (err < 0) {
>> +		dlog(LOG_WARNING, "inet_pton(): IPv6 unsupported!");
>> +		break;
> 
> Probably better to exit() here and to use LOG_ERR instead?
Sure, I kept the previous behavior, but indeed, it's better to exit. I will send
a new version.
