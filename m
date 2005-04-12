From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: address translation
Date: Tue, 12 Apr 2005 14:25:35 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504121423470.16158@filer.marasystems.com>
References: <20050412104753.30017.qmail@web51401.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: mani kandan <vititmani@yahoo.com>
In-Reply-To: <20050412104753.30017.qmail@web51401.mail.yahoo.com>
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

On Tue, 12 Apr 2005, mani kandan wrote:

> now the packets destined to the first server has to be
> redirected to second server. so i thought of using
> NAT and studied LVS and found that it is not helping
> me.

NAT/Address translation won't do any good here as it destroys the original 
address information in the IP header, and as a result the packet won't 
match the socket.

You need to use "direct routing" type forwarding, explicitly routing these 
packets to the new host.

Regards
Henrik
