From: Paolo Rossi <paolo_76@inwind.it>
Subject: SNAT multicast traffic
Date: Tue, 08 Feb 2005 10:13:29 +0100
Message-ID: <420882B9.3050108@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hi all,


I have a trouble with netfilter. I need to perform a SNAT to outgoing multicast packet. Multicast packet come from 
private network and i can't annunce this private network in my routing domain. Becauseour routers manage multicast 
traffic with PIM-SM protocol and PIM perform RPF (reverse path forwarding), the clients can't see the multicast traffic. 
I've read that netfilter don't support multicast SNAT, why?

Is there someone can hel me?


Thanks


Best wishes


Paolo
