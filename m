From: Kovesdi Gyorgy <kgy@deverto.com>
Subject: Re: output device
Date: Tue, 7 Mar 2006 15:40:04 +0100
Message-ID: <200603071540.04739.kgy@deverto.com>
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
Not only the output device, but the input device handling is also missing from 
the conntrack.
So, if a packet arrives from a device, a conntrack rule is generated. If a 
packet arrives from another device with the same address and port, it is 
handled with the conntrack entry of the previous packet.

Regards
Gyorgy Kovesdi
