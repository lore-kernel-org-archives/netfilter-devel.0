From: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] ipt_CLUSTERIP: Add network device notifier
Date: Wed, 11 Jun 2014 15:58:58 +0400
Message-ID: <53984482.5060309@parallels.com>
References: <1396871929.3741.6.camel@tkhai>  <20140428142306.GA28547@localhost> <1402487079.32126.54.camel@tkhai>  <20140611114957.GA23352@localhost> <1402487718.32126.63.camel@tkhai>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, <tkhai@yandex.ru>
To: Kirill Tkhai <ktkhai@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:57904 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaFKL7I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:59:08 -0400
In-Reply-To: <1402487718.32126.63.camel@tkhai>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/11/2014 03:55 PM, Kirill Tkhai wrote:

>> How it this combination being triggered there? I mean:
>>
>> # modprobe dummy
>> # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP ...
>> # rmmod dummy
>>
>> Is it something included in some scripts that automate the setup?
> 
> It's a sample of how to trigger this. The problem is not in rmmod.
> 
> Really it happens when container is stopping and device is going away.
> It's not OpenVZ related, current LXC has the same problem.

Then it should be reproducible with the help of simple 'unshare --net'
plus 'ip link add ...' commands that would create netns and populate
it with devices. Right?

Thanks,
Pavel

