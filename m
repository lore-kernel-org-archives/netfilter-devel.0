From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ESP spi/sequence tracking and nat
Date: Tue, 10 Aug 2004 13:01:45 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408101252340.8015@filer.marasystems.com>
References: <8FC831532CEE564AB88AC1D999C29DEBD9F148@prinsmail01.am.thmulti.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kashyap Ashwin <Ashwin.Kashyap@thomson.net>
In-Reply-To: <8FC831532CEE564AB88AC1D999C29DEBD9F148@prinsmail01.am.thmulti.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 9 Aug 2004, Kashyap Ashwin wrote:

> I want to implement a connection tracking / nat module that will track
> the SPI and SEQ parts in the ESP header. I need this functionality
> because, nat will fail for ESP if the destination IP address (the VPN
> server address) is the same for two clients. I did a packet dump for a
> popular VPN client and also noticed that the SPI can be same for two
> clients (say client -> server direction). The idea is to remember the
> last SEQ the server responded for a particular tuple and when we get the
> next tuple, we try to do a closest match, as opposed to doing an exact
> match:

To fit the Netfilter Conntrack scheme of things you then need to implement 
and ESP protocol helper which tracks the ESP connections as individual 
connections. Once this is done NAT should work at least to a limited 
degree.

To really work with NAT you should use a IPSEC implementation with NAT-T 
support. This makes IKE detect the NAT and then switch to UDP 
encapsulation which works very well with all forms of NAT, and also makes 
IKE fully aware of the NAT ip address changes.

Regards
Henrik
