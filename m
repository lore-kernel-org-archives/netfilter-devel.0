From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sun, 24 Jul 2005 01:20:05 +0200
Message-ID: <42E2D0A5.7000009@trash.net>
References: <42E1ADB2.1080109@trash.net>	
	<1122119412.4484.5.camel@localhost.localdomain>	
	<42E267C8.9090005@trash.net>	
	<1122148193.3382.16.camel@localhost.localdomain>	
	<42E2A2E9.8050800@trash.net>
	<1122154479.3382.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <1122154479.3382.29.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Bart De Schuymer wrote:
> Op za, 23-07-2005 te 22:04 +0200, schreef Patrick McHardy:
> 
> What if someone wants to just get a copy sent to userspace while the
> kernel continues routing the copied packet? AFAIK this behaviour can't
> be obtained using the queue target.

Yes, sorry, I spread misinformation :) There is also a replacement
for ip_queue and I was mixing them up.

Regards
Patrick
