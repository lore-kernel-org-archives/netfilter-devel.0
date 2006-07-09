From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: handle cidr notation more sanely
Date: Sun, 9 Jul 2006 15:28:18 -0700
Message-ID: <20060709222818.GA23200@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

At present, a command such as

	iptables -A foo -s 10.10/16

will interpret 10.10/16 as 10.0.0.10/16, and after applying the mask end
up with 10.0.0.0/16, which likely isn't what the user intended.  Yet
some people do expect 10.10 (without the cidr notation) to end up as
10.0.0.10.

The below patch should satisfy all parties.  It zero pads the missing
octets only in the cidr case, leaving the IP untouched otherwise.

This resolves bug #422

Phil



--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-cidr

diff -ru ipt-orig/iptables.c ipt-new/iptables.c
--- ipt-orig/iptables.c	2006-04-21 05:04:51.000000000 -0700
+++ ipt-new/iptables.c	2006-07-09 15:15:15.000000000 -0700
@@ -583,6 +583,34 @@
 	return (char *) NULL;
 }
 
+static void 
+pad_cidr(char *cidr)
+{
+	char *p, *q;
+	unsigned int onebyte;
+	int i, j;
+	char buf[20];
+
+	/* copy dotted string, because we need to modify it */
+	strncpy(buf, cidr, sizeof(buf) - 1);
+	buf[sizeof(buf) - 1] = '\0';
+
+	p = buf;
+	for (i = 0; i <= 3; i++) {
+		if ((q = strchr(p, '.')) == NULL)
+			break;
+		*q = '\0';
+		if (string_to_number(p, 0, 255, &onebyte) == -1)
+			return;
+		p = q + 1;
+	}
+
+	/* pad remaining octets with zeros */
+	for (j = i; j < 3; j++) {
+		strcat(cidr, ".0");
+	}
+}
+
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
@@ -651,6 +679,8 @@
 	if ((p = strrchr(buf, '/')) != NULL) {
 		*p = '\0';
 		addrp = parse_mask(p + 1);
+		if (strrchr(p + 1, '.') == NULL)
+			pad_cidr(buf);
 	} else
 		addrp = parse_mask(NULL);
 	inaddrcpy(maskp, addrp);

--8t9RHnE3ZwKMSgU+--
