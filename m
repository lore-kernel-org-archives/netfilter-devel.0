From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack accounting
Date: Sat, 05 Jan 2008 13:45:37 +0100
Message-ID: <477F7BF1.8060705@netfilter.org>
References: <477704CB.8030809@channing-bete.com> <477D0553.4010906@netfilter.org> <477D257B.4060901@channing-bete.com> <477DA70E.5080301@channing-bete.com> <477DA84A.3030304@channing-bete.com> <477EAEF0.4000300@channing-bete.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ben Lentz <BLentz@channing-bete.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35752 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753909AbYAEMpx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 07:45:53 -0500
In-Reply-To: <477EAEF0.4000300@channing-bete.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ben Lentz wrote:
>> One more thing... it looks like daemon mode doesn't detach from it's
>> controlling terminal, still shows "pts/1", and hangs upon logout:
> 
> Added setsid(), patch attached.

Applied. Thanks again.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
