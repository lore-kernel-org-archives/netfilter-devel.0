From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [PATCH] Passive OS fingerprint matching module update. Dynamic
 fingerprint loading.
Date: Mon, 22 Sep 2003 16:51:18 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0309221647310.21735@dns.toxicfilms.tv>
References: <20030922171921.009b2133.johnpol@2ka.mipt.ru>
 <20030922173231.5bd6a7ae.johnpol@2ka.mipt.ru> <20030922135151.GM31401@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-1499177507-1064242278=:21735"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	netfilter-devel@lists.netfilter.org, quaker@ondraszek.eu.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030922135151.GM31401@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---23717851-1499177507-1064242278=:21735
Content-Type: TEXT/PLAIN; charset=US-ASCII

> can you please send patches against patch-o-matic?  (i.e. patches
> against patches) Otherwise it is very difficult for me to integrate your
> changes.
This is a patch against libipt_osf.c file in userspace/extensions, so I
guess you meant: against CVS.

Here it is. Funny thing is that, when I converted that module to
netfilter, I rewrote the code as Evgeniy now suggests to patch, but
decided not to, as I was not sure about the level of intrusion to his
code. It appears I had a good hunch.
BTW. I belive that Evgeniy patch was broken anyway.

Regards,
Maciej

Index: userspace/extensions/libipt_osf.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_osf.c,v
retrieving revision 1.1
diff -u -r1.1 libipt_osf.c
--- userspace/extensions/libipt_osf.c	13 Sep 2003 04:44:28 -0000	1.1
+++ userspace/extensions/libipt_osf.c	22 Sep 2003 14:47:00 -0000
@@ -71,15 +71,20 @@
 {
 	struct ipt_osf_info *info = (struct ipt_osf_info *)(*match)->data;

-	if (*flags)
-		exit_error(PARAMETER_PROBLEM, "Can't specify multiple strings");
-
-	check_inverse(optarg, &invert, &optind, 0);
-	parse_string(optarg, info);
-	if (invert)
-		info->invert = 1;
-	info->len=strlen((char *)info->genre);
-	*flags = 1;
+	switch(c) {
+		case '1':
+			if (*flags)
+				exit_error(PARAMETER_PROBLEM, "Can't specify multiple strings");
+			check_inverse(optarg, &invert, &optind, 0);
+			parse_string(argv[optind-1], info);
+			if (invert)
+				info->invert = 1;
+			info->len=strlen((char *)info->genre);
+			*flags = 1;
+			break;
+		default:
+			return 0;
+	}

 	return 1;
 }
---23717851-1499177507-1064242278=:21735
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="osf.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0309221651180.21735@dns.toxicfilms.tv>
Content-Description: osf.patch
Content-Disposition: attachment; filename="osf.patch"

SW5kZXg6IHVzZXJzcGFjZS9leHRlbnNpb25zL2xpYmlwdF9vc2YuYw0KPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQ0KUkNTIGZpbGU6IC9jdnNwdWJsaWMvbmV0
ZmlsdGVyL3VzZXJzcGFjZS9leHRlbnNpb25zL2xpYmlwdF9vc2YuYyx2DQpy
ZXRyaWV2aW5nIHJldmlzaW9uIDEuMQ0KZGlmZiAtdSAtcjEuMSBsaWJpcHRf
b3NmLmMNCi0tLSB1c2Vyc3BhY2UvZXh0ZW5zaW9ucy9saWJpcHRfb3NmLmMJ
MTMgU2VwIDIwMDMgMDQ6NDQ6MjggLTAwMDAJMS4xDQorKysgdXNlcnNwYWNl
L2V4dGVuc2lvbnMvbGliaXB0X29zZi5jCTIyIFNlcCAyMDAzIDE0OjQ3OjAw
IC0wMDAwDQpAQCAtNzEsMTUgKzcxLDIwIEBADQogew0KIAlzdHJ1Y3QgaXB0
X29zZl9pbmZvICppbmZvID0gKHN0cnVjdCBpcHRfb3NmX2luZm8gKikoKm1h
dGNoKS0+ZGF0YTsNCiANCi0JaWYgKCpmbGFncykNCi0JCWV4aXRfZXJyb3Io
UEFSQU1FVEVSX1BST0JMRU0sICJDYW4ndCBzcGVjaWZ5IG11bHRpcGxlIHN0
cmluZ3MiKTsNCi0NCi0JY2hlY2tfaW52ZXJzZShvcHRhcmcsICZpbnZlcnQs
ICZvcHRpbmQsIDApOw0KLQlwYXJzZV9zdHJpbmcob3B0YXJnLCBpbmZvKTsN
Ci0JaWYgKGludmVydCkNCi0JCWluZm8tPmludmVydCA9IDE7DQotCWluZm8t
Pmxlbj1zdHJsZW4oKGNoYXIgKilpbmZvLT5nZW5yZSk7DQotCSpmbGFncyA9
IDE7DQorCXN3aXRjaChjKSB7DQorCQljYXNlICcxJzoNCisJCQlpZiAoKmZs
YWdzKQ0KKwkJCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLCAiQ2Fu
J3Qgc3BlY2lmeSBtdWx0aXBsZSBzdHJpbmdzIik7DQorCQkJY2hlY2tfaW52
ZXJzZShvcHRhcmcsICZpbnZlcnQsICZvcHRpbmQsIDApOw0KKwkJCXBhcnNl
X3N0cmluZyhhcmd2W29wdGluZC0xXSwgaW5mbyk7DQorCQkJaWYgKGludmVy
dCkNCisJCQkJaW5mby0+aW52ZXJ0ID0gMTsNCisJCQlpbmZvLT5sZW49c3Ry
bGVuKChjaGFyICopaW5mby0+Z2VucmUpOw0KKwkJCSpmbGFncyA9IDE7DQor
CQkJYnJlYWs7DQorCQlkZWZhdWx0Og0KKwkJCXJldHVybiAwOw0KKwl9DQog
DQogCXJldHVybiAxOw0KIH0NCg==

---23717851-1499177507-1064242278=:21735--
