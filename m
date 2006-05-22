From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Iptables load balancing
Date: Mon, 22 May 2006 17:22:04 +0100
Message-ID: <4471E52C.3010600@ufomechanic.net>
References: <200605201449.56621.vladimir@sycore.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org
In-Reply-To: <200605201449.56621.vladimir@sycore.org>
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

Vladimir S. Petukhov wrote:
> Hi!
> 
> Sorry for my English...
> 
> I need to separate UDP packets  via several ports according content of these 
> packets. Each packet has fixed field  (2 bytes) - "connection" number 
> (session number), packet with the same number must be forwarded on the same 
> port. It look like NAT, but based on content of UDP packet.


Looks like you need http://l7-filter.sourceforge.net/ and write some
patterns to match your packets and then set a mark based on which packet
matched.

Then you can have NAT rules (or ipt_route) or whatever based on the
packet mark.

Sam
