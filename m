From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables 32bit compat layer
Date: Thu, 30 Mar 2006 01:01:15 +0200
Message-ID: <442B11BB.3060806@trash.net>
References: <200603291638.02842.dim@openvz.org>	<442A81DB.7060608@trash.net>	<1143659085.4015.77.camel@localhost.localdomain>
	<20060329.135351.71293324.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, arnd@arndb.de, dim@openvz.org,
	rusty@rustcorp.com.au, gandalf@wlug.westbo.se, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060329.135351.71293324.davem@davemloft.net>
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

David S. Miller wrote:
> From: Martin Josefsson <gandalf@wlug.westbo.se>
> Date: Wed, 29 Mar 2006 21:04:45 +0200
> 
> 
>>That machine (an old ultra1) hasn't seen electricity in a long time,
>>I'll see if I can dig it out this weekend unless someone else (dave?)
>>beats me to testing the patch.
> 
> 
> I think such userland hacks should not be worried about
> and we should put the new correct kernel compat netfilter
> stuff in.
> 
> If anything explodes on sparc64 for whatever reason, I will take care
> of it. :-)

Fine with me :) I've added it to my tree, I'll pass it on a couple of
hours.
