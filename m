From: Tom Eastep <teastep@shorewall.net>
Subject: Re: NAT before IPsec with 2.6
Date: Fri, 23 Jan 2004 07:51:40 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401230751.40618.teastep@shorewall.net>
References: <Pine.LNX.4.44.0401231521350.13626-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>,
	Michal Ludvig <mludvig@suse.cz>
In-Reply-To: <Pine.LNX.4.44.0401231521350.13626-100000@filer.marasystems.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Friday 23 January 2004 06:24 am, Henrik Nordstrom wrote:
> On Fri, 23 Jan 2004, Michal Ludvig wrote:
> > I.e. the postrouting on the unencrypted packet is really called right
> > before it gets encrypted. And the encrypted packet then hits the
> > POSTROUTING again, but it's already a different packet, actually.
>
> My issue is with packets not destinated for an IPSec tunnel.. from what I
> read your patch these will hit POSTROUTING twice. But maybe I misread your
> patch?

I'm concerned that passing the unencrypted packet through POSTROUTING 
apparently makes it impossible for firewall rules to enforce encryption to a 
remote host or network.

It's my opinion that when the ipsec<n> devices where eliminated, the baby got 
thrown out with the bath water.

My $.02...

-Tom
-- 
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
