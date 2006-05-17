From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Wed, 17 May 2006 09:19:03 +0200
Message-ID: <446ACE67.4030700@trash.net>
References: <20060515204142.GO7774@kenobi.snowman.net>	<20060515210342.GP7774@kenobi.snowman.net>	<446AC1FB.5070406@trash.net>
	<20060516.235910.71774114.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: sfrost@snowman.net, gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, marcelo@kvack.org, willy@w.ods.org,
	azez@ufomechanic.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060516.235910.71774114.davem@davemloft.net>
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
> From: Patrick McHardy <kaber@trash.net>
> Date: Wed, 17 May 2006 08:26:03 +0200
> 
>>OK, updated patch attached. The TTL is now always kept up-to-date.
> 
> 
> Looks nice.
> 
> Is there any reasonable reason to allow ip_pkt_list_tot to ever be
> larger than say 255?  If we can accept that limit, we can shrink
> the recent_entry considerably by packing the index and nstamps
> into a single word next to ttl.


My primary goal was full compatibility, I have no idea about real-life
usage though. Maybe Stephen can answer this.
