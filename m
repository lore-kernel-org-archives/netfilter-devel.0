From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Reset conntrack...
Date: Wed, 8 Dec 2004 16:32:12 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412081627080.19244@filer.marasystems.com>
References: <41AF92B1.30802@anduras.de> <20041203060819.GG4605@oknodo.bof.de>
	<41B049C5.403@anduras.de> <41B0D5AB.6050403@gmx.net>
	<41B6E379.5070909@anduras.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <41B6E379.5070909@anduras.de>
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

On Wed, 8 Dec 2004, Sven Anders wrote:

> |>Possible solutions:
> |>
> |>~ 1) Recheck all CONNTRACK entries against the new firewall rules.
> |>
> |>~ 2) Set all CONNTRACK entries with states RELATED or ESTABLISHED to
> |>~     NEW, to force the recheck.


Implemented years ago by a collegue of mine:

https://lists.netfilter.org/pipermail/netfilter-devel/2003-August/012109.html
[or alternate archive location where MIME processing actually works...]
http://marc.theaimsgroup.com/?l=netfilter-devel&m=105975103717126&w=2

Needs some trivial adjustments for current ip_conntrack versions..

Regards
Herik
