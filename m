From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack accounting
Date: Sat, 05 Jan 2008 17:44:24 +0100
Message-ID: <477FB3E8.9080609@netfilter.org>
References: <477704CB.8030809@channing-bete.com> <477D0553.4010906@netfilter.org> <477D257B.4060901@channing-bete.com> <477DA70E.5080301@channing-bete.com> <477DA84A.3030304@channing-bete.com> <477EAEF0.4000300@channing-bete.com> <477F7BF1.8060705@netfilter.org> <477F928A.70206@channing-bete.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ben Lentz <BLentz@channing-bete.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58864 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755568AbYAEQom (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 11:44:42 -0500
In-Reply-To: <477F928A.70206@channing-bete.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ben Lentz wrote:
> Thanks very much for considering my patches! I really appreciate the
> work you've done implementing my suggestions!

I just implemented buffer logging that guarantees that fflush is called
if the buffer is full. Have a look at LogFileBufferSize. This must
improve performance under very busy firewall. Does syslog have any
similar setting?

The logging format must be discussed before the release. It would be
fairly easy to dump the connection logging info in XML instead of plain
text and I'm not sure if current format is fine.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
