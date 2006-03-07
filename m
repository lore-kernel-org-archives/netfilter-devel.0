From: Kovesdi Gyorgy <kgy@deverto.com>
Subject: Re: output device
Date: Tue, 7 Mar 2006 10:19:47 +0100
Message-ID: <200603071019.47411.kgy@deverto.com>
References: <200603030944.11858.kgy@deverto.com>
	<440845B4.3000208@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <440845B4.3000208@ufomechanic.net>
Content-Disposition: inline
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

> > I would like to set the output device in a rule (it is needed due to
> > overlapping addresses). AFAIK, it cannot be done directly in a rule...
> why can't you use ipt_route ?
If I use such a rule:
iptables -t mangle -A PREROUTING -p udp -d xxxx --dport yyyy -j ROUTE \
      --oif eth0.2000 --continue
then nothing happens. If the "--continue" is missing, the given packets are 
lost.
What can be the problem here? I use kernel 2.6.15.5, iptables 1.2.11 and patch 
for the ipt_route.

Other question: AFAIK the conntrack does not del with the target device. To be 
as fast as possible the target device would be handled in the conntrack, and 
it would be given together with the address in the DNAT rule, because the 
device is part of the address in a schyzophrenic network.

Regards
Gyorgy Kovesdi
