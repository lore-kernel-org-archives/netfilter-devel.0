From: Daniel <daniel@dev-zone.org>
Subject: MAC address matching. Or other ideas.
Date: Mon, 05 May 2003 11:34:36 +1200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EB5A38C.4090606@dev-zone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Quick version:

Is it possible to get the MAC match module to match on dst MAC address 
rather than just src MAC?

Longer Version:

My network is peered to an internet exchange. I am running Debian stable 
with Zebra to handle all of the routing. I only want to measure traffic 
that is going through our ISP. So I want to be able to say only gimme 
traffic that is coming in and out via gateway X, the only way I can 
figure to do that is by matching the MAC address of the gateway, but the 
match only works on incoming traffic. Is it even technically possible to 
match on out going? Or if someone has a better way of doing it I would 
be happy to hear that as well.

I am not subscribed to the list so if it is possible to reply to me and 
the list that would be great, but I will read the list archive for the 
next couple of days anyway.

Thanks
Daniel Griggs
