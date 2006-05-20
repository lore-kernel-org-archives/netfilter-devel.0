From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: SNMP NAT: fix memory corruption
Date: Sat, 20 May 2006 09:31:26 +0200
Message-ID: <446EC5CE.8070803@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020105040108050605060902"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------020105040108050605060902
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Fix memory corruption caused by the SNMP NAT helper.
The patch applies cleanly to -stable as well.


--------------020105040108050605060902
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: SNMP NAT: fix memory corruption

Fix memory corruption caused by snmp_trap_decode:

- When snmp_trap_decode fails before the id and address are allocated,
  the pointers contain random memory, but are freed by the caller
  (snmp_parse_mangle).

- When snmp_trap_decode fails after allocating just the ID, it tries
  to free both address and ID, but the address pointer still contains
  random memory. The caller frees both ID and random memory again.

- When snmp_trap_decode fails after allocating both, it frees both,
  and the callers frees both again.

The corruption can be triggered remotely when the ip_nat_snmp_basic
module is loaded and traffic on port 161 or 162 is NATed.

Found by multiple testcases of the trap-app and trap-enc groups of the
PROTOS c06-snmpv1 testsuite.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a792adfb6a4c6aadc9e676a70e58d77feff3737d
tree 9da39fb311735061f965aa0f292132ba82b4bce5
parent 2f880b65fdbc2d4915bddc59d75a176329570fdd
author Patrick McHardy <kaber@trash.net> Sat, 20 May 2006 08:44:32 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 20 May 2006 08:44:32 +0200

 net/ipv4/netfilter/ip_nat_snmp_basic.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_snmp_basic.c b/net/ipv4/netfilter/ip_nat_snmp_basic.c
index c622538..688a2f2 100644
--- a/net/ipv4/netfilter/ip_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/ip_nat_snmp_basic.c
@@ -1003,12 +1003,12 @@ static unsigned char snmp_trap_decode(st
 		
 	return 1;
 
+err_addr_free:
+	kfree((unsigned long *)trap->ip_address);
+
 err_id_free:
 	kfree(trap->id);
 
-err_addr_free:
-	kfree((unsigned long *)trap->ip_address);
-	
 	return 0;
 }
 
@@ -1126,11 +1126,10 @@ static int snmp_parse_mangle(unsigned ch
 		struct snmp_v1_trap trap;
 		unsigned char ret = snmp_trap_decode(&ctx, &trap, map, check);
 		
-		/* Discard trap allocations regardless */
-		kfree(trap.id);
-		kfree((unsigned long *)trap.ip_address);
-		
-		if (!ret)
+		if (ret) {
+			kfree(trap.id);
+			kfree((unsigned long *)trap.ip_address);
+		} else 
 			return ret;
 		
 	} else {

--------------020105040108050605060902--
