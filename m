From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix hang on netfilter module unload
Date: Tue, 15 Mar 2005 20:25:17 +0100
Message-ID: <4237369D.8080408@trash.net>
References: <20050315050641.GA334@linuxace.com>
	<20050315172330.GA3130@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050315172330.GA3130@linuxace.com>
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

Phil Oester wrote:
>>So we are leaking conntracks for some reason that we must diagnose.
> 
> 
> No...the app is leaking skbs.  Since the skb never goes away (at least
> until closing the app), the conntrack can thus not go away.  Isn't
> it better for us to work around stupid apps like this?  Seems preferable
> to not hang the box on iptables restart/unload, eh?

I guess by leaking you mean doesn't pull them of the receive queue.
Anyhow, the reference to the conntrack is dropped before packets
are delivered to the protocols, so this can't be the reason. Do
you have a reproducable test-case ?

>>But this is cheating, of course that the module will unload if we set 
>>all refcounts to 1 we won't spin forever in the i_see_dead_people loop 
>>but we are leaking somewhere anyway.
> 
> 
> Well, again, the admin has asked to unload iptables -- should we unload,
> or lockup the box?

Unload - after fixing the leaks :) If we cover it up this way it will
never get fixed properly.

Regards
Patrick
