From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How does iptables redirect a packet that is not addressed to
 its local machi
Date: Thu, 8 Apr 2004 19:08:32 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404081907180.11691-100000@filer.marasystems.com>
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

On Thu, 8 Apr 2004, Grace Li wrote:

> Yes, Client and Server are in the same network!

For IPTABLES to work on the gateway both the client and server MUST send
the traffic via the gateway. You can not have iptables on the gateway
magically work on traffic which goes directly between the client<->server
not involving the gateway..

Regards
Henrik
