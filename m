From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Netfilter based application : any advice ?
Date: Mon, 15 Mar 2004 09:51:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40556E79.50608@eurodev.net>
References: <200403141930.29602.alchemyx@uznam.net.pl> <1079300670.3068.182659007@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Saber zrelli <saber_z@fastmail.fm>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <1079300670.3068.182659007@webmail.messagingengine.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Saber zrelli wrote:

>- Is it possible to send packets with Netfilter or not? ( if not i guess
>using libnet will resolve the pb but better to have  
>  every thing based on the same infrastructure)
>  
>

If you can do that in user space, have a look at libnet.You can forge
packets in inject them.


>- I would like to have the tool work with wireless protocol , does
>Netfilter support non Ethernet proto and 802.11 particulary?
>  
>

This is transparent to netfilter since it's in OSI layer 3/4.

regards,
Pablo
