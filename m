From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Sat, 22 May 2004 14:38:20 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405211416341.8045-100000@blackhole.kfki.hu>
References: <40AD659B.7090107@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Philip Craig <philipc@snapgear.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40AD659B.7090107@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 May 2004, Patrick McHardy wrote:

> Instead of modifying the nf_mark value (which I don't think we should
> do), we could just let the mark target perform the same operations that
> NOTRACK/TRACE perform, namely attaching a dummy-conntrack (NOTRACK)
> and setting a bit in nfcache (TRACE). For the tcp-window-tracking
> spoofed-rst protection we could set a bit in the conntrack structure.
> I suppose this feature need to be enabled on a per-connection base
> anyway. Unfortunately adding NOTRACK functionality to MARK in this
> way would create a dependency on ip_conntrack. Maybe we should add
> it to CONNMARK ?

Hm. Actually, as we already use a bit in nfcache for TRACE, we could
reserve bits generally:

#define NFC_HOOKS_MASK			0x0000FFFF
#define NFC_FLAGS_MASK			0xFFFF0000

/* Special netfilter flags */

#define NFC_PKT_FLAGS_MASK		0x00FF0000
#define NFC_CT_FLAGS_MASK		0xFF000000

#define NFC_FLAG_TRACE			0x00010000
#define NFC_FLAG_NOTRACK		0x00020000
#define NFC_FLAG_CT_TCP_SYNRST		0x01000000

The lower half could be manipulated by MARK while the upper half by
CONNMARK. But the latter would require a new element in ip_conntrack
itself and I wouldn' really like to make it bigger.
Do we really need an unsigned long to store the status? :-)

> PS: Joszef, I changed your address to @netfilter.org, your mailserver
> doesn't like me.

I whitelisted you, sorry for the inconvenience.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
