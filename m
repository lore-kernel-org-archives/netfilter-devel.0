From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack info for a packet
Date: Tue, 2 Mar 2004 18:34:33 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403021833220.27205-100000@filer.marasystems.com>
References: <20040302164018.47436.qmail@web13905.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040302164018.47436.qmail@web13905.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2 Mar 2004, Scott MacKay wrote:

> Is there an info doc on how to get conn track
> information for a packet?

See the conntrack match in iptables for one example.

In principle you use ip_conntrack_get to retreive the conntrack of the skb 
and then grab whatever values you need from there.

Regards
Henrik
