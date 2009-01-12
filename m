From: Patrick McHardy <kaber@trash.net>
Subject: Re: Troubles with MARK target in 2.6.28
Date: Mon, 12 Jan 2009 07:19:15 +0100
Message-ID: <496AE0E3.1030009@trash.net>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050208030106080205060300"
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: "Nikolay S. Rybalov" <nowhere@hakkenden.ath.cx>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56630 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZALGTR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:19:17 -0500
In-Reply-To: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050208030106080205060300
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Nikolay S. Rybalov wrote:
> Hi all,
> 
> I have troubles with "-j MARK --set-xmark" combination in mangle table. 
> Particulary, I want set one bit in nf mark by means, say, --set-xmark 
> 0x10/0x10, and it worked in kernels from at least 2.6.24 up to the last 
> in 2.6.27.
> 
> I use: iptables -t mangle -A POSTROUTING -o eth1 -d 192.168.37.0/24 -j 
> MARK --set-xmark 0x10/0x10
> 
> and get:
> 
> iptables v1.4.2: Unknown arg `(null)'
> Try `iptables -h' or 'iptables --help' for more information.
> 
> When I try --or-mark, iptables says that my "kernel too old for --or-mark"
> 
> Same thing happens with -j CONNMARK.
> 
> Can someone advise what to do, I really need to set only one bit without 
> altering the rest of the mark.

Does this patch fix it?


--------------050208030106080205060300
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 89837a4..36cb63b 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -289,6 +289,10 @@ static int target_revfn(u8 af, const char *name, u8 revision, int *bestp)
 				have_rev = 1;
 		}
 	}
+
+	if (af != NFPROTO_UNSPEC && !have_rev)
+		return target_revfn(NFPROTO_UNSPEC, name, revision, bestp);
+
 	return have_rev;
 }
 

--------------050208030106080205060300--
