From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] www typo
Date: Thu, 18 Mar 2004 20:59:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1657382537.20040318205945@dns.toxicfilms.tv>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Hi,

this patch fixes a typo in the script that generates the
mirrors page.

Regards,
Maciej

Index: scripts/Netfilter_HP.pm
===================================================================
RCS file: /cvspublic/homepage/scripts/Netfilter_HP.pm,v
retrieving revision 1.7
diff -u -r1.7 Netfilter_HP.pm
--- scripts/Netfilter_HP.pm     9 Jan 2004 01:04:34 -0000       1.7
+++ scripts/Netfilter_HP.pm     18 Mar 2004 19:36:27 -0000
@@ -303,7 +303,7 @@
                        $writer->dataElement('entry', $$mhash{'thanks'});
                }
        } else {
-               $writer->dataElement('entry', 'uknnown');
+               $writer->dataElement('entry', 'unknown');
        }

        my ($name, $email) = parse_email(@{$$mhash{'contact'}}[0]);
