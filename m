From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack extension
Date: Tue, 22 Oct 2002 16:37:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021022143726.GG3039@naboo.club.berlin.ccc.de>
References: <D7EB866AE731AA44AA546482C7BCE5F114B67B@EXCHEAST01.enterprise.cmgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Jorgensen, Jens" <jjorgensen@Tallan.com>
Content-Disposition: inline
In-Reply-To: <D7EB866AE731AA44AA546482C7BCE5F114B67B@EXCHEAST01.enterprise.cmgi.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 15, 2002 at 04:10:32PM -0400, Jorgensen, Jens wrote:
> Hello,
>  
> I'm looking into writing a Netfilter extension module and was reading
> through your source for the IRC helper so I thought I'd maybe ask you
> a question or two.

ok.

> I've read through most of the FAQs and some of the source and things
> are starting to gel but not quite yet. I'm not sure if I should be
> writing a conntrack helper, or that plus something else, or perhaps
> just a writing directly on top of netfilter. Here's what I want to do:
> I want to "multiplex" my use of port 443 on my box that sits on a
> cable modem at home. I also want to use that box as a Socks5 proxy
> from other places but from some places outbound traffic is limited to
> certain ports so I want to use the 443 port for both https and also
> Socks5. I can tell what type of connection is desired by looking and
> the first few incoming bytes on the connection. 

This is the crucial point. You are talking about TCP connections.  And
in order to see the frist couple of bytes, you have to accept the
connection and go through the full TCP handshake first.  Acceppting TCP
connections is the job of a TCP/IP stack, not of a packet filter.

> Since this is a short sequence of bytes I need to make sure that they
> are the first bytes received on 443 so it isn't enough just to look at
> each TCP packet. I have to keep track of whether incoming data has
> been received and only check the first bytes. Pretty simple in terms
> of what I need to do. Once I've checked the first few incoming bytes
> and determined the connection is for Socks5 then from there the rest
> is basically a DNAT function: just rewrite the dest port of the tcp
> packet from 443 to 1080 and you're done. Where should this fit in the
> whole netfilter wad though? Can I just write a conntrack helper? It
> isn't clear to me how a conntrack helper connects to the matching
> rules for iptable so I can pair it up to a DNAT target. Any advice or
> clarity you could bring would be most appreciated.

You need to implement this as a transparent proxy in userspace.  A
packet filter is just the wrong place for this kind of stuff.

> TIA,
> Jens B. Jorgensen
> jens.jorgensen@tallan.com

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
