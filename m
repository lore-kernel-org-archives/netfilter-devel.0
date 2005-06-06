From: Phani Kumar <pkumar@students.iiit.net>
Subject: redirect unauthenticated traffic to a registration portal (fwd)
Date: Mon, 6 Jun 2005 15:19:39 +0530 (IST)
Message-ID: <Pine.LNX.4.61.0506061518280.26578@students.iiit.ac.in>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,
    I had implemented a linux router with 4 interfaces.

eth0 -- outside net
eth1 --
eth2 --    diff Internal n/ws
eth3 --

Now I had to allow only authenticated traffic to pass through the router(i.e 
through interface eth0).
I have a list of all authenticated Mac-addresses in a file.

All unauthenticated traffic (i.e non-authenticated mac-address traffic) had to 
be redirected to default registration site.


Pls can anyone suggest me how to do above task.
I am able to allow only authenticated traffic by using

iptables -t filter -A FORWARD -m --mac-source xx.xx.xx... -i eth0 -j ACCEPT

and so on for all authenticated users

iptables -t filter -A FORWARD -i eth0 -j DROP

How do I redirect the unathenticated traffic to a registration portal rather 
than dropping it??


Phani
IIIT-Hyd
