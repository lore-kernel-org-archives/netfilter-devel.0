From: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Subject: small buglet in iptables-save with "-m mac"
Date: Tue, 10 Dec 2002 15:26:30 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212101518580.1838-100000@pc40.e18.physik.tu-muenchen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

Please Cc: me as I'm not on the list.

This small buglet is biting me since quite a while, so I got the 1.2.7a source 
to see if it is fixed, and it isn't: if you try iptables-save on a rule with 
inverted MAC matching (e.g. "-m mac --mac-source ! xx:xx:xx:xx:xx:xx") you'll 
end up with "-m mac --mac !xx:xx:xx:xx:xx:xx", which doesn't work because of the 
missing space between the ! and the MAC. The patch below should fix it (tested 
on RH7.2, kernel 2.4.20).

--- libipt_mac.c.bak    Tue Dec 10 15:16:34 2002
+++ libipt_mac.c        Tue Dec 10 15:17:04 2002
@@ -90,7 +90,7 @@
 {
        unsigned int i;

-       printf("%s%02X", invert ? "!" : "", macaddress[0]);
+       printf("%s%02X", invert ? "! " : "", macaddress[0]);
        for (i = 1; i < ETH_ALEN; i++)
                printf(":%02X", macaddress[i]);
        printf(" ");


Ciao,
					Roland

+---------------------------+-------------------------+
|    TU Muenchen            |                         |
|    Physik-Department E18  |  Raum    3558           |
|    James-Franck-Str.      |  Telefon 089/289-12592  |
|    85747 Garching         |                         |
+---------------------------+-------------------------+

"If you think NT is the answer, you didn't understand the question."
						- Paul Stephens
