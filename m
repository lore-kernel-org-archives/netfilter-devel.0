From: Patrick McHardy <kaber@trash.net>
Subject: Re: Update: Patch-o-matic cleanup
Date: Fri, 12 May 2006 07:55:35 +0200
Message-ID: <44642357.3000308@trash.net>
References: <443165AA.4030509@trash.net> <4433CA75.9040607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Grzegorz@Janoszka.pl
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4433CA75.9040607@trash.net>
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

Patrick McHardy wrote:
> This is the full list of patches to be removed. Instructions how to set
> up a pomng repository are at the end of this mail, I'll commit the code
> soon.
> 
> - ACCOUNT
> - IPMARK
> - NETLINK
> - NETMAP
> - TARPIT
> - TCPLAG
> - TRACE
> - XOR
> - account
> - comment
> - connlimit
> - connrate
> - conntrack_locking
> - cuseeme-nat
> - dropped-table
> - expire
> - fuzzy
> - geoip
> - goto
> - ip_queue_vwmark
> - ipp2p
> - mport
> - nat-reservations
> - netfilter-docbook
> - osf
> - owner-socketlookup
> - pool
> - pptp-conntrack-nat
> - psd
> - time
> - tproxy
> 
> The patches will be removed in 30 days, authors or other people that
> want to maintain them in an external repository are welcome to send
> the URL to be included in the distrubuted sources.list.

I've now removed all patches that didn't find a new maintainer or
which already have an external repository. I'll keep the ones where
people are still setting up the repository for a couple more days,
these are:

IPMARK                  Grzegorz Janoszka <Grzegorz@Janoszka.pl>
TARPIT                  Krzysztof Oldzki <olenf@ans.pl>
connlimit               Krzysztof Oldzki <olenf@ans.pl>
ipp2p                   Krzysztof Oldzki <olenf@ans.pl>
time                    Krzysztof Oldzki <olenf@ans.pl>

Please send me the URLs of the repositories when they are up. Anyone
wanting to take care of an already removed patchlet is of course also
invited to send me a URL.
