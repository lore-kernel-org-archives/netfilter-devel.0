From: John Haxby <john.haxby@oracle.com>
Subject: [PATCH] More secure SYSRQ for xtables-addons
Date: Thu, 27 Nov 2008 12:28:29 +0000
Message-ID: <492E926D.5020807@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:16692 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbYK0M2i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:28:38 -0500
Received: from acsinet13.oracle.com (acsinet13.oracle.com [141.146.126.235])
	by acsinet12.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id mARCSKk2015117
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Nov 2008 12:28:21 GMT
Received: from acsmt700.oracle.com (acsmt700.oracle.com [141.146.40.70])
	by acsinet13.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id mARCSpEL023326
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Nov 2008 12:28:52 GMT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello All,

This is a patch to the SYSRQ xtables-addon that is, I believe, secure=20
enough to use in moderately untrustworthy environments.  I'm relatively=
=20
new to posting patches so please forgive me if I've messed this up.

Rationale:

I want to be able to use SYSRQ to reboot, crash or partially diagnose=20
machines that become unresponsive for one reason or another.   These=20
machines, typically, are blades or rack mounted machines that do not=20
have a PS/2 connection for a keyboard and the old method of wheeling=20
round a "crash trolley" that has a monitor and a keyboard on it no=20
longer works:  USB keyboards rarely, if ever, work because by the time=20
the machine is responding only to a ping, udev is incapable of setting=20
up a new keyboard.

This patch extends the xt_SYSRQ module to avoid both disclosing the=20
sysrq password and preventing replay.  This is done by changing the=20
request packet from the simple "<key><password>" to a slightly more=20
complex "<key>,<seqno>,<salt>,<hash>".   The hash is the sha1 checksum=20
of "<key>,<seqno>,<salt>,<password>".   A request can be constructed in=
=20
a small shell script, for example:

    key=3D"s"
    password=3D"cookie"
    seqno=3D$(date +%s)
    salt=3D"$(dd bs=3D12 count=3D1 if=3D/dev/urandom 2>/dev/null | open=
ssl enc=20
-base64)"
    req=3D"$key,$seqno,$salt"
    req=3D"$req,$(echo -n "$req,$password" | sha1sum | cut -c 1-40)"

As before this can be sent to the victim machine using socat or netcat.

Verification of the hash in xt_SYSRQ follows much the same process.  =20
The sequence number, seqno, is initialised to the current time (in=20
seconds) when the xt_SYSRQ module is loaded and is updated each time a=20
valid request is received.   A request with a sequence number less than=
=20
the current sequence number or a wrong hash is silently ignored.  =20
(Using the time for the sequence number assumes (requires) that time=20
doesn't go backwards on a reboot and that the requester and victim have=
=20
reasonably synchronized clocks.)

The random salt is there to prevent pre-computed dictionary attacks=20
difficult: dictionary attacks are still feasible if you capture a packe=
t=20
because the hash is computed quickly -- taking perhaps several=20
milliseconds to compute a more complex hash in xt_SYSRQ when the machin=
e=20
is unresponsive is probably not the best thing you could do.  However,=20
cracking, say, a random 32 character password would take some time and=20
is probably beyond what the people in the target untrustworthy=20
environment are prepared to do or have the resources for.   It almost=20
goes without saying that no two victim machines should use the same=20
password.

Ideally the iptables rules for SYSRQ would include a minimum time=20
between requests to avoid the worst effects of sysrq-request bombing,=20
although I haven't mentioned that in the updated man page (mostly=20
because I'm not sure how to do it).

=46inally, the module allocates all the resources it need at module=20
initialisation time on the assumption that if things are going badly=20
resource allocation is going to be troublesome.

jch


diff -up xtables-addons-1.6/extensions/libxt_SYSRQ.man.sysrq xtables-ad=
dons-1.6/extensions/libxt_SYSRQ.man
--- xtables-addons-1.6/extensions/libxt_SYSRQ.man.sysrq	2008-11-18 17:1=
6:34.000000000 +0000
+++ xtables-addons-1.6/extensions/libxt_SYSRQ.man	2008-11-27 11:02:12.0=
00000000 +0000
@@ -5,13 +5,15 @@ stuck as a result -- if still possible,=20
 processes are stuck, interrupts are likely to be still processed, and =
as such,
 sysrq can be triggered through incoming network packets.
 .PP
-This xt_SYSRQ implementation does not use any encryption, so you shoul=
d change
-the SYSRQ password after use unless you have made sure it was transmit=
ted
-securely and no one sniffed the network, e.g. by use of an IPsec tunne=
l whose
-endpoint is at the machine where you want to trigger the sysrq. Also, =
you
-should limit as to who can issue commands using \fB-s\fP and/or \fB-m =
mac\fP,
-and also that the destination is correct using \fB-d\fP (to protect ag=
ainst
-potential broadcast packets), noting that it is still short of MAC/IP =
spoofing:
+The xt_SYSRQ implementation uses a salted SHA1 hash and a sequence num=
ber to
+prevent network sniffers from either guessing the password or replayin=
g earlier
+requests.  The initial sequence number comes from the time of day so y=
ou will
+have a small window of vulnerability should time go backwards at a reb=
oot.
+However, the file /sys/module/xt_SYSREQ/seqno can be used to both quer=
y and
+update the current sequence number.  Also, you should limit as to who =
can issue
+commands using \fB-s\fP and/or \fB-m mac\fP, and also that the destina=
tion is
+correct using \fB-d\fP (to protect against potential broadcast packets=
), noting
+that it is still short of MAC/IP spoofing:
 .IP
 -A INPUT -s 10.10.25.1 -m mac --mac-source aa:bb:cc:dd:ee:ff -d 10.10.=
25.7
 -p udp --dport 9 -j SYSRQ
@@ -24,10 +26,9 @@ This extension does not take any options
 required.
 .PP
 The SYSRQ password can be changed through
-/sys/module/xt_SYSRQ/parameters/password; note you need to use `echo -=
n` to
-not add a newline to the password, i.e.
+/sys/module/xt_SYSRQ/parameters/password, for example:
 .IP
-echo -n "password" >/sys/.../password
+echo "password" >/sys/module/xt_SYSRQ/parameters/password
 .PP
 Alternatively, the password may be specified at modprobe time, but thi=
s is
 insecure as people can possible see it through ps(1). You can use an o=
ption
@@ -36,12 +37,36 @@ by root.
 .IP
 options xt_SYSRQ password=3Dcookies
 .PP
-To trigger SYSRQ from a remote host, just use netcat or socat, specify=
ing the
-action (only one) as first character, followed by the password:
-.IP
-echo -n "scookies" | socat stdin udp-sendto:10.10.25.7:9
-.IP
-echo -n "scookies" | netcat -u 10.10.25.7 9
-.PP
-See the Linux docs for possible sysrq keys. Important ones are:
-re(b)oot, power(o)ff, (s)ync filesystems, (u)mount and remount readonl=
y.
+The xt_SYSRQ module is normally silent unless a successful request is =
received,
+but the \fIdebug\fP module parameter can be used to find exactly why a
+seemingly correct request is not being processed.
+.PP
+To trigger SYSRQ from a remote host, just use netcat or socat:
+.RS
+.nf
+
+sysrq_key=3D"s"  # the SysRq key
+password=3D"password"
+seqno=3D"$(date +%s)"
+salt=3D"$(dd bs=3D12 count=3D1 if=3D/dev/urandom 2>/dev/null |
+    openssl enc -base64)"
+req=3D"$sysrq_key,$seqno,$salt"
+req=3D"$req,$(echo -n "$req,$password" | sha1sum | cut -c1-40)"
+
+echo "$req" | socat stdin udp-sendto:10.10.25.7:9
+# or
+echo "$req" | netcat -uw1 10.10.25.7 9
+
+.fi
+.RE
+.PP
+See the Linux docs for possible sysrq keys. Important ones are: re(b)o=
ot,
+power(o)ff, (s)ync filesystems, (u)mount and remount readonly.  More t=
han one
+sysrq key can be used at once, but bear in mind that, for example, a s=
ync may
+not complete before a subsequent reboot or poweroff.
+.PP
+The hashing scheme should be enough to prevent mis-use of SYSRQ in man=
y
+environments, but it is not perfect: take reasonable precautions to pr=
otect
+your machines.  Most importantly ensure that each machine has a differ=
ent
+password: there is scant protection for a SYSRQ packet being applied t=
o a
+machine that happens to have the same password.
diff -up xtables-addons-1.6/extensions/xt_SYSRQ.c.sysrq xtables-addons-=
1.6/extensions/xt_SYSRQ.c
--- xtables-addons-1.6/extensions/xt_SYSRQ.c.sysrq	2008-11-18 17:16:34.=
000000000 +0000
+++ xtables-addons-1.6/extensions/xt_SYSRQ.c	2008-11-27 11:15:34.000000=
000 +0000
@@ -3,7 +3,6 @@
  *	Copyright =C2=A9 Jan Engelhardt <jengelh [at] medozas de>, 2008
  *
  *	Based upon the ipt_SYSRQ idea by Marek Zalem <marek [at] terminus s=
k>
- *	xt_SYSRQ does not use hashing or timestamps.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -19,43 +18,137 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <net/ip.h>
 #include "compat_xtables.h"
=20
 static bool sysrq_once;
 static char sysrq_password[64];
+static long seqno;
+static int debug;
 module_param_string(password, sysrq_password, sizeof(sysrq_password),
-	S_IRUSR | S_IWUSR);
+		S_IRUSR | S_IWUSR);
+module_param(seqno, long, S_IRUSR | S_IWUSR);
+module_param(debug, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(password, "password for remote sysrq");
+MODULE_PARM_DESC(seqno, "sequence number for remote sysrq");
+MODULE_PARM_DESC(debug, "debugging: 0=3Doff, 1=3Don");
=20
+
+static struct crypto_hash *tfm;
+static int digestsize;
+static unsigned char *digest_password;
+static unsigned char *sha1_digest;
+static char *sha1_hexdigest;
+
+/*
+ * The data is of the form "<requests>,<seqno>,<salt>,<hash>" where
+ * <requests> is a series of sysrq requests; <seqno> is a sequence num=
ber
+ * which must be greater than the last sequence number; <salt> is some
+ * random bytes; and <hash> is the sha1 hash of everything up to and
+ * including the preceding "/" together with the password.
+ *
+ * For example
+ *
+ *   salt=3D$RANDOM
+ *   req=3D"s,$(date +%s),$salt"
+ *   echo "$req,$(echo -n $req,secret | sha1sum | cut -c1-40)"
+ *
+ * You probably want a better salt and password than that though :-)
+ */
 static unsigned int sysrq_tg(const void *pdata, uint16_t len)
 {
 	const char *data =3D pdata;
-	char c;
+	int i, n;
+	struct scatterlist sg[2];
+	struct hash_desc desc;
+	int ret;
+	long new_seqno =3D 0;
=20
 	if (*sysrq_password =3D=3D '\0') {
 		if (!sysrq_once)
-			printk(KERN_INFO KBUILD_MODNAME "No password set\n");
+			printk(KERN_INFO KBUILD_MODNAME ": No password set\n");
 		sysrq_once =3D true;
 		return NF_DROP;
 	}
-
 	if (len =3D=3D 0)
 		return NF_DROP;
=20
-	c =3D *data;
-	if (strncmp(&data[1], sysrq_password, len - 1) !=3D 0) {
-		printk(KERN_INFO KBUILD_MODNAME "Failed attempt - "
-		       "password mismatch\n");
+	for (i =3D 0; sysrq_password[i]; i++)
+		if (sysrq_password[i] =3D=3D '\n')
+			break;
+	sysrq_password[i] =3D '\0';
+
+	i =3D 0;
+	for (n =3D 0; n < len - 1; n++) {
+		if (i =3D=3D 1 && '0' <=3D data[n] && data[n] <=3D '9')
+			new_seqno =3D 10L * new_seqno + data[n] - '0';
+		if (data[n] =3D=3D ',' && ++i =3D=3D 3)
+			break;
+	}
+	n++;
+	if (i !=3D 3) {
+		if (debug)
+			printk(KERN_WARNING KBUILD_MODNAME
+				": badly formatted request\n");
+		return NF_DROP;
+	}
+	if (seqno >=3D new_seqno) {
+		if (debug)
+			printk(KERN_WARNING KBUILD_MODNAME
+				": old sequence number ignored\n");
+		return NF_DROP;
+	}
+
+	desc.tfm =3D tfm;
+	desc.flags =3D 0;
+	ret =3D crypto_hash_init(&desc);
+	if (ret)
+		goto hash_fail;
+	sg_init_table(sg, 2);
+	sg_set_buf(&sg[0], data, n);
+	strcpy(digest_password, sysrq_password);
+	i =3D strlen(digest_password);
+	sg_set_buf(&sg[1], digest_password, i);
+	ret =3D crypto_hash_digest(&desc, sg, n + i, sha1_digest);
+	if (ret)
+		goto hash_fail;
+
+	for (i =3D 0; i < digestsize; i++) {
+		sha1_hexdigest[2 * i] =3D
+			"0123456789abcdef"[(sha1_digest[i] >> 4) & 0xf];
+		sha1_hexdigest[2 * i + 1] =3D
+			"0123456789abcdef"[sha1_digest[i] & 0xf];
+	}
+	sha1_hexdigest[2 * digestsize] =3D '\0';
+	if (len - n < digestsize) {
+		if (debug)
+			printk(KERN_INFO KBUILD_MODNAME ": Short digest,"
+				" expected %s\n", sha1_hexdigest);
+		return NF_DROP;
+	}
+	if (strncmp(data + n, sha1_hexdigest, digestsize) !=3D 0) {
+		if (debug)
+			printk(KERN_INFO KBUILD_MODNAME ": Bad digest,"
+				" expected %s\n", sha1_hexdigest);
 		return NF_DROP;
 	}
=20
+	/* Now we trust the requester */
+	seqno =3D new_seqno;
+	for (i =3D 0; i < len && data[i] !=3D ','; i++) {
+		printk(KERN_INFO KBUILD_MODNAME ": SysRq %c\n", data[i]);
 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2, 6, 19)
-	handle_sysrq(c, NULL);
+		handle_sysrq(data[i], NULL);
 #else
-	handle_sysrq(c, NULL, NULL);
+		handle_sysrq(data[i], NULL, NULL);
 #endif
+	}
 	return NF_ACCEPT;
+hash_fail:
+	printk(KERN_WARNING KBUILD_MODNAME ": digest failure\n");
+	return NF_DROP;
 }
=20
 static unsigned int
@@ -73,9 +166,11 @@ sysrq_tg4(struct sk_buff **pskb, const s
 	udph =3D (void *)iph + ip_hdrlen(skb);
 	len  =3D ntohs(udph->len) - sizeof(struct udphdr);
=20
-	printk(KERN_INFO KBUILD_MODNAME ": " NIPQUAD_FMT ":%u -> :%u len=3D%u=
\n",
-	       NIPQUAD(iph->saddr), htons(udph->source), htons(udph->dest),
-	       len);
+	if (debug)
+		printk(KERN_INFO KBUILD_MODNAME
+			": " NIPQUAD_FMT ":%u -> :%u len=3D%u\n",
+			NIPQUAD(iph->saddr), htons(udph->source),
+			htons(udph->dest), len);
 	return sysrq_tg((void *)udph + sizeof(struct udphdr), len);
 }
=20
@@ -94,9 +189,11 @@ sysrq_tg6(struct sk_buff **pskb, const s
 	udph =3D udp_hdr(skb);
 	len  =3D ntohs(udph->len) - sizeof(struct udphdr);
=20
-	printk(KERN_INFO KBUILD_MODNAME ": " NIP6_FMT ":%hu -> :%hu len=3D%u\=
n",
-	       NIP6(iph->saddr), ntohs(udph->source),
-	       ntohs(udph->dest), len);
+	if (debug)
+		printk(KERN_INFO KBUILD_MODNAME
+			": " NIP6_FMT ":%hu -> :%hu len=3D%u\n",
+			NIP6(iph->saddr), ntohs(udph->source),
+			ntohs(udph->dest), len);
 	return sysrq_tg(udph + sizeof(struct udphdr), len);
 }
=20
@@ -146,11 +243,54 @@ static struct xt_target sysrq_tg_reg[] _
=20
 static int __init sysrq_tg_init(void)
 {
+	struct timeval now;
+	tfm =3D crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm)) {
+		printk(KERN_WARNING KBUILD_MODNAME
+			": Error: Could not find or load sha1 hash\n");
+		tfm =3D NULL;
+		goto fail;
+	}
+	digestsize =3D crypto_hash_digestsize(tfm);
+	sha1_digest =3D kmalloc(digestsize, GFP_KERNEL);
+	if (!sha1_digest) {
+		printk(KERN_WARNING KBUILD_MODNAME
+			": Cannot allocate sha1_digest\n");
+		goto fail;
+	}
+	sha1_hexdigest =3D kmalloc(2 * digestsize + 1, GFP_KERNEL);
+	if (!sha1_hexdigest) {
+		printk(KERN_WARNING KBUILD_MODNAME
+			": Cannot allocate sha1_hexdigest\n");
+		goto fail;
+	}
+	digest_password =3D kmalloc(sizeof(sysrq_password), GFP_KERNEL);
+	if (!digest_password) {
+		printk(KERN_WARNING KBUILD_MODNAME
+			": Cannot allocate password digest space\n");
+		goto fail;
+	}
+	do_gettimeofday(&now);
+	seqno =3D now.tv_sec;
 	return xt_register_targets(sysrq_tg_reg, ARRAY_SIZE(sysrq_tg_reg));
+fail:
+	if (tfm)
+		crypto_free_hash(tfm);
+	if (sha1_digest)
+		kfree(sha1_digest);
+	if (sha1_hexdigest)
+		kfree(sha1_hexdigest);
+	if (digest_password)
+		kfree(digest_password);
+	return -EINVAL;
 }
=20
 static void __exit sysrq_tg_exit(void)
 {
+	crypto_free_hash(tfm);
+	kfree(sha1_digest);
+	kfree(sha1_hexdigest);
+	kfree(digest_password);
 	return xt_unregister_targets(sysrq_tg_reg, ARRAY_SIZE(sysrq_tg_reg));
 }
=20


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
