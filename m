From: =?ISO-8859-1?Q?C=E9dric_Tissi=E8res?= <cedric.tissieres@epfl.ch>
Subject: ip_route_input problem
Date: Thu, 25 Sep 2003 15:47:25 +0200 (MEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1064497645.3f72f1ed9b44b@imapwww.epfl.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
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

hello,

i want to route a packet before the os. i tried to do that using
ip_route_input() function like this:

ip_route_input(skb, fwdaddr, iph->saddr, iph->tos, skb->dev)

it returns -EINVAL, invalid argument. i've checked all the arguments and they
are ok.
moreover, what is the difference between ip_route_input, ip_route_input_slow and
ip_route_me_harder functions?

thanks a lot. sorry, i'm a newbie...
cedric
