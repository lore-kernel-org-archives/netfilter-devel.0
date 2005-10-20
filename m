From: David Coulson <david@davidcoulson.net>
Subject: Re: mark value as routing key
Date: Thu, 20 Oct 2005 08:09:55 -0400
Message-ID: <43578913.2090103@davidcoulson.net>
References: <BAY103-F12CBD5D305A6953CA1C2EEB2730@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F12CBD5D305A6953CA1C2EEB2730@phx.gbl>
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



Marco Berizzi wrote:

> Locally generated packet with destination port 80
> are going through the adsl table but the packet
> source ip is 1.1.1.254. Why source ip packet is
> 1.1.1.254? Should't it be 10.10.10.6?

No - You will have to create a NAT rule to NAT anything marked with 0x1
onto 10.10.10.6.

David

-- 
David J. Coulson
email: david@davidcoulson.net
web: http://www.davidcoulson.net/
