From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [RFC] matching tproxied packets
Date: Tue, 4 Jun 2002 17:14:47 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206041714.47683.hno@marasystems.com>
References: <20020604145036.GA1295@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>,
	netfilter-devel@lists.samba.org
In-Reply-To: <20020604145036.GA1295@balabit.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Balazs Scheidler wrote:

> * use a new state (called TPROXY), which would be applied to all TPROXYed
>   packets (might interact badly with nat/conntrack).

It will in no doubt interact badly with connection tracking (and therefore 
NAT).

> * have the tproxy framework mark all packets with an fwmark, and let the
>   packets in based on the value of fwmark

Will interact badly with fwmark based routing.

> * have a separate match (called tproxy), which matches tproxied sessions
>   based on some value stored in the associated conntrack entry

Defenitely my preference, but I might be biased as I make heavy use of 
connection tracking and fwmark based routing in combination.

Regards
Henrik
