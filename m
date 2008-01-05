From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack accounting
Date: Sat, 05 Jan 2008 13:39:15 +0100
Message-ID: <477F7A73.1090303@netfilter.org>
References: <477704CB.8030809@channing-bete.com> <477D0553.4010906@netfilter.org> <477D257B.4060901@channing-bete.com> <477DA70E.5080301@channing-bete.com> <477EA6A4.2000306@channing-bete.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ben Lentz <BLentz@channing-bete.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55073 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754024AbYAEMjm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 07:39:42 -0500
In-Reply-To: <477EA6A4.2000306@channing-bete.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Ben,

Ben Lentz wrote:
>> Syslog statistics mode still crashes... but only if I *disable*
>> LogFile, too.
>>
> I've fixed the crash when stats LogFile is off and stats Syslog is on,
> patch attached.

Applied. Thanks a lot for investigating and fixing this.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
