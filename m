From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: How does iptables redirect a packet that is not addressed to
 its local machi
Date: Thu, 8 Apr 2004 16:01:31 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404081559410.29813-100000@chris.camcom.co.uk>
References: <BAY7-F991UjdSkleUBU00007230@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: wanghtb@legend.com.cn, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grace Li <zheyinli@hotmail.com>
In-Reply-To: <BAY7-F991UjdSkleUBU00007230@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Grace,

> Yes, Client and Server are in the same network!
> 
> I used the Ethereal tool, which is similiar to but better than tcpdump.  On 
> Client, Server and Gateway, I could all always see that packets are sending 
> back and forth from Server and Client.  There is no sign that Gateway 
> receives packets on port 1888 or 2000.

If you ping the Server from the Client, does it go through the Gateway? 
Probably not, because Client and Server are in the same subnet and on the 
same physical LAN. In this case, the packets never arrive at Gateway, so 
iptables on Gateway can't do anything to intercept or modify them.

You could try setting a route on the Client which points to the Server, 
but using Gateway as the gateway of the route.

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
