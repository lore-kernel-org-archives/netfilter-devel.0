From: Patrick McHardy <kaber@trash.net>
Subject: Re: Dead loop on Virtual interface
Date: Mon, 18 Apr 2005 00:26:21 +0200
Message-ID: <4262E28D.1080900@trash.net>
References: <0b8801c54001$bb029220$5001010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Hall <temp02@bluereef.com.au>
In-Reply-To: <0b8801c54001$bb029220$5001010a@bluereef.local>
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

Andrew Hall wrote:
> Hi,
> 
> We've been using the native ipsec implementation in a routed environment 
> with no real problems. We have now tried it with a combined 
> bridging/routed setup and we see the message "dead loop on virtual 
> interface BR0'. The endpoint is configured to be the bridge interface. 
> We have tried 2.6.10 and 2.6.11.5 with the same effect. If we disable 
> the ipsec transport the message goes away. Does anyone know if this is 
> this a problem/bug with the way netfilter, the bridging code and ipsec 
> interrelate? Or could there be some other issue.

Probably a misconfiguration, this message occurs when a virtual
device's hard_start_xmit() function tries to transmit a packet using
itself as output device.

Regards
Patrick
