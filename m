From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Sun, 19 Nov 2006 21:34:38 +0100
Message-ID: <4560BFDE.2060804@netfilter.org>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>
	<20061112173312.GA2593@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010603070607060708080408"
Cc: "Laurence J. Lane" <ljlane@debian.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20061112173312.GA2593@linuxace.com>
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
--------------010603070607060708080408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Phil Oester wrote:
> On Sat, Nov 11, 2006 at 09:35:08PM -0500, Laurence J. Lane wrote:
>> On 11/11/06, Laurence J. Lane <ljlane@debian.org> wrote:
>>
>>>  # strace -s 255 -o /tmp/bar iptables -v -A INPUT -s foonet/8 -j
>>> ACCEPT #1.3.6 [2]
>>>  iptables v1.3.6: host/network `foonet.0.0.0' not found
>>>  Try `iptables -h' or 'iptables --help' for more information.
>> This looks like something with the pad_cidr() call in
>> parse_hostnetworkmask(). ltrace shows the code calling
>> getnetbyname("foonet.0.0.0")  instead of getentbyname("foonet").
> 
> Correct.  This was added between 1.3.5 and 1.3.6 to more sanely
> handle CIDR notation.  See the commit:
> 
> https://lists.netfilter.org/pipermail/netfilter-cvslog/2006-July/005122.html
> 
> Not sure offhand how we can satisfy both cases here, but I'd posit
> that more people use x.x.x/24 than use foonet/x notation.  

I think that we have to fix this because it also breaks hostnames
defined in /etc/hosts, I have attached a patch to adress this issue.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------010603070607060708080408
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

Index: iptables.c
===================================================================
--- iptables.c	(revisión: 6678)
+++ iptables.c	(copia de trabajo)
@@ -273,8 +273,13 @@
 		   "invalid port/service `%s' specified", port);
 }
 
-struct in_addr *
-dotted_to_addr(const char *dotted)
+enum {
+	IPT_DOTTED_ADDR = 0,
+	IPT_DOTTED_MASK
+};
+
+static struct in_addr *
+__dotted_to_addr(const char *dotted, int type)
 {
 	static struct in_addr addr;
 	unsigned char *addrp;
@@ -290,9 +295,21 @@
 
 	p = buf;
 	for (i = 0; i < 3; i++) {
-		if ((q = strchr(p, '.')) == NULL)
-			return (struct in_addr *) NULL;
+		if ((q = strchr(p, '.')) == NULL) {
+			if (type == IPT_DOTTED_ADDR) {
+				/* autocomplete, this is a network address */
+				if (string_to_number(p, 0, 255, &onebyte) == -1)
+					return (struct in_addr *) NULL;
 
+				addrp[i] = (unsigned char) onebyte;
+				while (i < 3)
+					addrp[++i] = 0;
+
+				return &addr;
+			} else
+				return (struct in_addr *) NULL;
+		}
+
 		*q = '\0';
 		if (string_to_number(p, 0, 255, &onebyte) == -1)
 			return (struct in_addr *) NULL;
@@ -310,6 +327,18 @@
 	return &addr;
 }
 
+struct in_addr *
+dotted_to_addr(const char *dotted)
+{
+	return __dotted_to_addr(dotted, IPT_DOTTED_ADDR);
+}
+
+struct in_addr *
+dotted_to_mask(const char *dotted)
+{
+	return __dotted_to_addr(dotted, IPT_DOTTED_MASK);
+}
+
 static struct in_addr *
 network_to_addr(const char *name)
 {
@@ -607,34 +636,6 @@
 	return (char *) NULL;
 }
 
-static void 
-pad_cidr(char *cidr)
-{
-	char *p, *q;
-	unsigned int onebyte;
-	int i, j;
-	char buf[20];
-
-	/* copy dotted string, because we need to modify it */
-	strncpy(buf, cidr, sizeof(buf) - 1);
-	buf[sizeof(buf) - 1] = '\0';
-
-	p = buf;
-	for (i = 0; i <= 3; i++) {
-		if ((q = strchr(p, '.')) == NULL)
-			break;
-		*q = '\0';
-		if (string_to_number(p, 0, 255, &onebyte) == -1)
-			return;
-		p = q + 1;
-	}
-
-	/* pad remaining octets with zeros */
-	for (j = i; j < 3; j++) {
-		strcat(cidr, ".0");
-	}
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
@@ -674,7 +675,7 @@
 		maskaddr.s_addr = 0xFFFFFFFF;
 		return &maskaddr;
 	}
-	if ((addrp = dotted_to_addr(mask)) != NULL)
+	if ((addrp = dotted_to_mask(mask)) != NULL)
 		/* dotted_to_addr already returns a network byte order addr */
 		return addrp;
 	if (string_to_number(mask, 0, 32, &bits) == -1)
@@ -703,8 +704,6 @@
 	if ((p = strrchr(buf, '/')) != NULL) {
 		*p = '\0';
 		addrp = parse_mask(p + 1);
-		if (strrchr(p + 1, '.') == NULL)
-			pad_cidr(buf);
 	} else
 		addrp = parse_mask(NULL);
 	inaddrcpy(maskp, addrp);
Index: extensions/libipt_NETMAP.c
===================================================================
--- extensions/libipt_NETMAP.c	(revisión: 6678)
+++ extensions/libipt_NETMAP.c	(copia de trabajo)
@@ -86,7 +86,7 @@
 	range->min_ip = ip->s_addr;
 	if (slash) {
 		if (strchr(slash+1, '.')) {
-			ip = dotted_to_addr(slash+1);
+			ip = dotted_to_mask(slash+1);
 			if (!ip)
 				exit_error(PARAMETER_PROBLEM, "Bad netmask `%s'\n",
 					   slash+1);
Index: include/iptables.h
===================================================================
--- include/iptables.h	(revisión: 6678)
+++ include/iptables.h	(copia de trabajo)
@@ -154,6 +154,7 @@
 extern int service_to_port(const char *name, const char *proto);
 extern u_int16_t parse_port(const char *port, const char *proto);
 extern struct in_addr *dotted_to_addr(const char *dotted);
+extern struct in_addr *dotted_to_mask(const char *dotted);
 extern char *addr_to_dotted(const struct in_addr *addrp);
 extern char *addr_to_anyname(const struct in_addr *addr);
 extern char *mask_to_dotted(const struct in_addr *mask);

--------------010603070607060708080408--
