From: Jeffrey Laramie <JALaramie@Loudoun-Fairfax.com>
Subject: Re: Bug/Problem with DNAT on OUTPUT chain (-t nat -A OUTPUT) that
 breaks routing? (fwd)
Date: Thu, 23 Oct 2003 13:29:09 -0400
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <3F980FE5.1000108@Loudoun-Fairfax.com>
References: <Pine.LNX.4.44.0310231127470.29188-100000@kinison.puremagic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org,  netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0310231127470.29188-100000@kinison.puremagic.com>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

Evan Harris wrote:

>Ok, I've upgraded to kernel 2.4.22, and the same behaviour is being
>exhibited.
>
>To recap the problem:
>
>Packets being nat'd on the OUTPUT chain of a machine are still being sent on
>the same interface they would have without the nat, and ignoring the route
>that aims them to the right iface for that dest addr.
>
>Evan
>
>  
>

I haven't seen the rest of this thread, so I may have missed something, 
but why are you doing DNAT on the nat OUTPUT chain? DNAT is usually done 
on the nat PREROUTING chain and SNAT on the POSTROUTING chain. Anything 
done in filter OUTPUT, mangle POSTROUTING, or nat POSTROUTING could 
change the direction of your packets before they leave your host.

Jeff
