From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: Re: [PATCH] libxt_multiport: Add translation to nft
Date: Wed, 9 Mar 2016 20:07:10 +0530
Message-ID: <56E03516.6080309@gmail.com>
References: <20160307212141.GA10594@sonyv> <20160308105346.GB4008@salvia>
 <56DFC995.7090009@gmail.com> <20160309123238.GA30363@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34276 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcCIOgy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 09:36:54 -0500
Received: by mail-pf0-f181.google.com with SMTP id 129so42043391pfw.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Mar 2016 06:36:53 -0800 (PST)
In-Reply-To: <20160309123238.GA30363@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 09 March 2016 06:02 PM, Pablo Neira Ayuso wrote:
> On Wed, Mar 09, 2016 at 12:28:29PM +0530, FaTe wrote:
>> Added translation for the match multiport.
>>
>> Example :
>> $ iptables-translate -A INPUT -p tcp -m multiport --ports 3:4  -j ACCEPT
>> nft add rule ip filter INPUT ip protocol tcp dport { 3-4 } tcp sport { 3-4 }
>> counter accept
>>
>> $ iptables-translate -A INPUT -p tcp -m multiport --sports http,ssh,ftp  -j
>> ACCEPT
>> nft add rule ip filter INPUT ip protocol tcp sport { 80,22,21 } counter accept
>>
>> $ iptables-translate -A INPUT -p tcp -m multiport --dports 1024:2048  -j ACCEPT
>> nft add rule ip filter INPUT ip protocol tcp dport { 1024-2048 } counter accept
>>
>> $  iptables-translate -A input -p tcp -m multiport --dports 1024:2048,2049:3333
>> -j ACCEPT
>> nft add rule ip filter input ip protocol tcp dport { 1024-2048,2049-3333 }
>> counter accept
> 
> This translation is not correct as it's been discussed in a different
> thread.
> 
I am unable to find that thread :( .
BTW i'm sending v2 for multiport translation which works correctly.
