From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug/Problem with DNAT on OUTPUT chain (-t nat -A OUTPUT) that
 breaks routing? (fwd)
Date: Thu, 23 Oct 2003 19:16:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F980CE7.2050909@trash.net>
References: <Pine.LNX.4.44.0310231127470.29188-100000@kinison.puremagic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@lists.netfilter.org,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evan Harris <eharris@puremagic.com>
In-Reply-To: <Pine.LNX.4.44.0310231127470.29188-100000@kinison.puremagic.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I tried 2.4 and 2.6 with DNAT to 127.0.0.1. The packets were sent on the
loopback device as expected. Please send some more information about
your specific setup.

Best regards,
Patrick

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
>
