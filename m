From: Patrick McHardy <kaber@trash.net>
Subject: Re: #263154: iptables: segfault with multiple ip hostnames
Date: Wed, 04 Aug 2004 00:26:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4110110E.40904@trash.net>
References: <20040803220350.GA5223@ljlane.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Laurence J. Lane" <ljlane@nontoxic.org>
In-Reply-To: <20040803220350.GA5223@ljlane.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Laurence J. Lane wrote:

>http://bugs.debian.org/263154
>
>iptables 1.2.11 segfaults when given a domain name that resolves 
>to multiple ip addresses. The situation is the same for kernel 
>versions 2.4.26 and 2.6.7.
>
>As an example:
>
>  # iptables -I INPUT -s google.com -j DROP
>  free(): invalid pointer 0x8055a4c!
>  Segmentation fault
>  
>
Already fixed in CVS:

http://cvs.netfilter.org/iptables/iptables.c?r1=1.68&r2=1.69

But seems to be missing this:

diff -u -r1.69 iptables.c
--- iptables.c  4 Jul 2004 15:20:53 -0000       1.69
+++ iptables.c  3 Aug 2004 22:22:25 -0000
@@ -551,7 +551,7 @@
                                                                                                                              

                while (host->h_addr_list[*naddr] != (char *) NULL)
                        (*naddr)++;
-               addr = fw_calloc(*naddr, sizeof(struct in_addr));
+               addr = fw_calloc(*naddr, sizeof(struct in_addr) * *naddr);
                for (i = 0; i < *naddr; i++)
                        inaddrcpy(&(addr[i]),
                                  (struct in_addr *) host->h_addr_list[i]);

Regards
Patrick
