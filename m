From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables bad byte counter?!?
Date: Wed, 5 Jun 2002 21:29:54 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206052129.54254.hno@marasystems.com>
References: <1023304055.2845.69.camel@cygnus>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Torge Szczepanek <netfilter-devel@szczepanek.de>,
	netfilter-devel@lists.samba.org
In-Reply-To: <1023304055.2845.69.camel@cygnus>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Torge Szczepanek wrote:

> I am getting byte counters like this:
>
> 18446744073707058701

Very much looks like a negative number.. the above is the same as 64 bit 
integer -2492915 printed as a unsigned value.

> The byte counters differ (18446744073707 is mostly the same) so I think
> this might be an overflow of a (longint?!?) counter.

Very unlikely as it is 64 bits in size and unsigned..

Regards
Henrik
