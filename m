From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Update SNMP basic for full IP address NAT
Date: Wed, 15 Nov 2006 07:45:00 +0100
Message-ID: <455AB76C.9050603@trash.net>
References: <3418F3471F1CA4409901547349FFAE2E05A05077@FTRDMEL2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: zze-Ganesh KERDONCUFF G ext RD-MAPS-REN
	<gkerdoncuff.ext@orange-ftgroup.com>
In-Reply-To: <3418F3471F1CA4409901547349FFAE2E05A05077@FTRDMEL2.rd.francetelecom.fr>
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

zze-Ganesh KERDONCUFF G ext RD-MAPS-REN wrote:
> This patch applies to the netfilter file   nat_ip_snmp_basic.c
> 
> The algorithm now applies NAT to the complete IP address (and not only
> the first byte) It also recomputes the UDP checksum accordingly.
> 
> Please apply this patch to the 2.6.18.1 official release.

What exactly is the purpose of this? My understanding of this module
(which might be wrong) is that it maps an entire /8 network, including
addresses not participating in the current connection. Your patch
changes this to only touch addresses participating in the connection
and leave the others unmapped. Is that really what you want?
In either case we can not break the old behaviour, so I suggest you
add an module option to control whether the entire network or just
a single address will be translated (ideally by just letting the user
specify a prefix length) and default to the old behaviour.
