From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: iptables target conflict?  ROUTE and MASQUERADE
Date: Tue, 16 Dec 2003 11:04:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1071569060.28763.61.camel@descartes>
References: <BAY13-F105p0oKHV3SF000296b7@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wu Nick <chundawu@hotmail.com>
In-Reply-To: <BAY13-F105p0oKHV3SF000296b7@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le mar 16/12/2003 a 09:55, Wu Nick a ecrit :
> >From the thread "[PATCH] update for ROUTE target in Netfilter-Extension 
> HOWTO", 
> it mentioned that once the ROUTE target applies for a packet, the packet is 
> 'stolen' and no further rues are consulted.  But in this way I have no 
> chance to change my source IP address of the packet (just like MASQUERADE did) 
> with the ip address of actual outgoing ppp interface.

There is a new option (--continue) for the ROUTE target that prevents
the target from stealing the packet. Maybe this could help.

Cedric
