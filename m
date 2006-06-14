From: Sven Anders <anders@anduras.de>
Subject: Re: [PATCH] entry_data
Date: Wed, 14 Jun 2006 11:03:50 +0200
Message-ID: <448FD0F6.3010506@anduras.de>
References: <200606050029.08602.max@nucleus.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060700090304080206010505"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <200606050029.08602.max@nucleus.it>
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

This is a multi-part message in MIME format.
--------------060700090304080206010505
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Massimiliano Hofer schrieb:
> Hi,
> here is my proposed patch for an API change that supports entry specific data.
> 
> As explained in my previous posts the purpose of this patch is to give matches 
> the opportunity to store entry specific data. Several matches already achieve 
> this reserving some space in the data fields, but these come from userspace 
> and I don't think it is the Right Way(TM) to do it.

Does this mean we can reuse these fields for other puroposes without breaking
compatibility with iptables?


I'm particularly interested in adding a negation to the "limit" match and I
think the match is using one of these special data fields...

 > /* Ugly, ugly fucker. */
 >  struct xt_rateinfo *master;

If this gives us the possibility to add the negation, who do we distinguish
between the old and new limit version. In other words: Who do we reach a maximum
compatibility?

Gruß
 Sven

-- 
 Sven Anders <anders@anduras.de>                 () Ascii Ribbon Campaign
                                                 /\ Support plain text e-mail
 ANDURAS service solutions AG
 Innstraße 71 - 94036 Passau - Germany
 Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 6032
Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Schön
Vorsitzender des Aufsichtsrats: Dipl. Kfm. Thomas Träger

--------------060700090304080206010505--
