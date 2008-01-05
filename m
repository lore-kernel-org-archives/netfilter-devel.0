From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: conntrack accounting
Date: Sat, 5 Jan 2008 17:24:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801051724320.14194@fbirervta.pbzchgretzou.qr>
References: <477704CB.8030809@channing-bete.com> <477D0553.4010906@netfilter.org>
 <477D257B.4060901@channing-bete.com> <477DA70E.5080301@channing-bete.com>
 <477DA84A.3030304@channing-bete.com> <477EAEF0.4000300@channing-bete.com>
 <477F7BF1.8060705@netfilter.org> <477F928A.70206@channing-bete.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ben Lentz <BLentz@channing-bete.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40678 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbYAEQYm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 11:24:42 -0500
In-Reply-To: <477F928A.70206@channing-bete.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 5 2008 09:22, Ben Lentz wrote:
>> Ben Lentz wrote:
>>   
>> > > One more thing... it looks like daemon mode doesn't detach from it's
>> > > controlling terminal, still shows "pts/1", and hangs upon logout:
>> > >       
>> > Added setsid(), patch attached.
>> >     
>>
>> Applied. Thanks again.
>>   
> Hmmm... file descriptors for STDIN, STDOUT, and STDERR should be closed, too...
> the setsid() detaches the controlling terminal but a terminal still hangs at
> logout after starting the daemon. A quick-and-dirty patch is attached, but
> there's probably a "better" way to do this.
>
> Thanks very much for considering my patches! I really appreciate the work
> you've done implementing my suggestions!
>
>

close(STDIN_FILENO);
close(STDOUT_FILENO);
close(STDERR_FILENO);
