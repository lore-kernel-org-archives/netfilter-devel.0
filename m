From: Matthew Natalier <matthewn@snapgear.com>
Subject: Re: can netfilter capture internal network packet?
Date: 12 Jun 2003 13:24:22 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1055388262.3967.84.camel@matthewn1.sw.moreton.com.au>
References: <001101c32cd0$14bdf940$010aa8c0@toowoomba>
	 <20030611120439.GJ32593@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030611120439.GJ32593@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Calvin,

The ebtables project might interest you.

http://ebtables.sourceforge.net/

You can intercept packets by putting a bridge between A and B.

Cheers

Matt


> On Sat, Jun 07, 2003 at 06:37:50PM +1000, calvin wrote:
> Dear all,
>  
> I got a serious problem with my netfilter programe.
>  
> what i am trying to do is capture a packet frmo A to B in the same network
> and direct it to QUEUE.

> My setup is
>  
> A      B
>  \       /
>   \     /
>   HUB
>      | (eth0)
>    GW
>      |(eth1)
>      |
>      |

>  is that possible to: when A send a message to B port 1700 (for example) ,
>  the iptales in GW can grep the packet and put into queue for processing and
>  put it back to the line?
> 

Cheers

Matt

-- 
Matthew Natalier, Systems Programmer, SnapGear, Inc.
Ph: +61 7 3435 2805, Fx: +61 7 3891 3630
Email: matthewn@snapgear.com, Web: http://www.SnapGear.com
