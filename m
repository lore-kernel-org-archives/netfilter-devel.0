From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: iptables denial of services
Date: Sat, 17 Apr 2004 13:13:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4081114A.40808@fl.priv.at>
References: <Pine.LNX.4.44.0404161149300.1981-100000@filer.marasystems.com>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0404161149300.1981-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote on 16.04.2004 12:03 MET:
> On Thu, 15 Apr 2004, Jorge Garcia wrote:
> 
>>Is this a problem in iptables firewall??i mean does iptables stop filtering after handling a lot of traffic?
> 
> No, but it may start dropping packets if overloaded.
> 
> If you are doing connection tracking then there is also an analogy to the
> connection flooding, where conntrack will not accept new sessions when a
> huge number of connetions is already established and this will most likely
> result in those new sessions to dropped by your firewall. But it is not a
> risk that filtering stops, only that new connections may not be accepted 
> for a while. The number of sessions involved is considerably higher than 
> on a server so your servers will most likely be dead long before the limit 
> in conntrack can be reached.

What if the server you are talking about is a server farm? Then an iptables 
gateway that does connection track on the way may as well "die" before the 
servers "die" because of overload.

Can you give some details about those limits? Are there any numbers 
availabe that relate that to memory/cpu/....?

-- 
MfG / Regards
Friedrich Lobenstock
