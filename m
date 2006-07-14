From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Bi-directional packet classification with ACK prioritization
Date: Fri, 14 Jul 2006 09:29:25 +0100
Message-ID: <44B755E5.2010000@ufomechanic.net>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB255421@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org
In-Reply-To: <0633E0EDB4F25F43A2D7179CA11FAFAB255421@xavier.staff.greatlakes.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

* Eliot, Wireless and Server Administrator, Great Lakes Internet wrote,
On 02/06/06 18:06:
> Sorry for making this a cross-post, but the pressure is on for getting
> this bandwidth shaper working.
> 
> I have an interesting dilemma with bi-directional packet classification
> while doing ACK prioritization. This is an overly simplified summary of
> my setup:
> 
> Internet
>   |
> Eth0 
>   |
>   Router
>   |
> Eth1
>   |
> Intranet
> 
> 
> A client on the Intranet establishes a flow to a server on the Internet.
> Packets get classified into 3 different priority bands. Priority 1 is
> for VoIP, DNS, SSH, Telnet, and ACK packets with no data payload.
> Priority 2 is for general traffic that does not fall into band 1 or band
> 3. Priority 3 band is for P2P. 
> 
> When the flow (download) is established, it starts out with the packets
> coming in on Priority Band 2. 
> 
> The client then sends an ACK packet to the server with no data payload. 
> 
> The router then classifies that ACK packet into Priority Band 1 and
> saves the mark that was set to put it in that classification. 
> 
> A response then comes back from the server and the router restores the
> mark it previously saved. Now it is flagged for Priority Band 1. 

I got round this by editing connmark and adding 2 more marks, one for
each direction. When connmark is set, in the conntrack it sets that mark
in the usual place and also in the slot for the current direction.

When the conntrack is used to populate the skb mark, I take the current
direction.

So I get the best of both worlds.

Sam
