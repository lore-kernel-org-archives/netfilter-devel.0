From: Oskar Andreasson <blueflux@koffein.net>
Subject: tcp-window-tracking.patch question
Date: Thu, 19 Sep 2002 16:07:29 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0209191558570.15133-100000@laptop1.agatha>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

Quick question, do you know if the tcp-window-tracking patch will enter 
the main kernel tree, or if it is considered at all?

Reason I am wondering is since I've pretty much based my ipsysctl 
documentation on your code, and I would hate to "put it down" just because 
this is not even close to how the final implementation will look:). My 
mistake if so, but still annoying.

As a sidenote, I would really like to see this in the main kernel since it 
is a really really good feature. Sure, 99% of the time there's no need to 
change these variables, but it gives the flexibility to actually do it the 
other times (without editing kernel source that is).

Thoughts?
 
----
Oskar Andreasson
http://www.frozentux.net
http://iptables-tutorial.frozentux.net
http://ipsysctl-tutorial.frozentux.net
mailto:blueflux@koffein.net
