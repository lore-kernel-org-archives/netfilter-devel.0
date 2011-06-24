From: John Haxby <john.haxby@oracle.com>
Subject: [PATCH 2/2] Improve security for xt_SYSRQ
Date: Fri, 24 Jun 2011 14:14:14 +0100
Message-ID: <d6a29877862bfd3c3e47ac592d308cbce065a918.1308920081.git.john.haxby@oracle.com>
References: <cover.1308920081.git.john.haxby@oracle.com>
Cc: prarit@redhat.com, John Haxby <john.haxby@oracle.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:42929 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab1FXNOg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:14:36 -0400
In-Reply-To: <cover.1308920081.git.john.haxby@oracle.com>
In-Reply-To: <cover.1308920081.git.john.haxby@oracle.com>
References: <cover.1308920081.git.john.haxby@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The xt_SYSRQ hash now includes the destination IPv4 or IPv6 address
which makes it harder to replay a request to many different machines
in the hope that some of them are using the same password.
---
 extensions/libxt_SYSRQ.man |   17 +++++++++++------
 extensions/xt_SYSRQ.c      |   13 +++++++++----
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_SYSRQ.man b/extensions/libxt_SYSRQ.man
index 89878e0..5470066 100644
--- a/extensions/libxt_SYSRQ.man
+++ b/extensions/libxt_SYSRQ.man
@@ -36,6 +36,8 @@ The SYSRQ password can be changed through
 .IP
 echo \-n "password" >/sys/module/xt_SYSRQ/parameters/password
 .PP
+The module will not respond to sysrq requests until a password has been set.
+.PP
 Alternatively, the password may be specified at modprobe time, but this is
 insecure as people can possible see it through ps(1). You can use an option
 line in e.g. /etc/modprobe.d/xt_sysrq if it is properly guarded, that is, only
@@ -60,12 +62,13 @@ password="password"
 seqno="$(date +%s)"
 salt="$(dd bs=12 count=1 if=/dev/urandom 2>/dev/null |
     openssl enc \-base64)"
+ipaddr=10.10.25.7
 req="$sysrq_key,$seqno,$salt"
-req="$req,$(echo \-n "$req,$password" | sha1sum | cut \-c1\-40)"
+req="$req,$(echo \-n "$req,$ipaddr,$password" | sha1sum | cut \-c1\-40)"
 
-echo "$req" | socat stdin udp\-sendto:10.10.25.7:9
+echo "$req" | socat stdin udp\-sendto:$ipaddr:9
 # or
-echo "$req" | netcat \-uw1 10.10.25.7 9
+echo "$req" | netcat \-uw1 $ipaddr 9
 .fi
 .PP
 See the Linux docs for possible sysrq keys. Important ones are: re(b)oot,
@@ -73,8 +76,10 @@ power(o)ff, (s)ync filesystems, (u)mount and remount readonly. More than one
 sysrq key can be used at once, but bear in mind that, for example, a sync may
 not complete before a subsequent reboot or poweroff.
 .PP
+An IPv4 address should have no leading zeros, an IPv6 address should
+be in the form recommended by RFC 5952.  The debug option will log the
+correct form of the address.
+.PP
 The hashing scheme should be enough to prevent mis-use of SYSRQ in many
 environments, but it is not perfect: take reasonable precautions to
-protect your machines.  Most importantly ensure that each machine has a
-different password; there is scant protection for a SYSRQ packet being
-applied to a machine that happens to have the same password.
+protect your machines.
diff --git a/extensions/xt_SYSRQ.c b/extensions/xt_SYSRQ.c
index 723e813..1befcdf 100644
--- a/extensions/xt_SYSRQ.c
+++ b/extensions/xt_SYSRQ.c
@@ -4,6 +4,8 @@
  *
  *	Based upon the ipt_SYSRQ idea by Marek Zalem <marek [at] terminus sk>
  *
+ *	Security additions John Haxby <john.haxby [at] oracle com>
+ *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
  *	version 2 or 3 as published by the Free Software Foundation.
@@ -58,13 +60,13 @@ static char *sysrq_hexdigest;
  * is a series of sysrq requests; <seqno> is a sequence number that must be
  * greater than the last sequence number; <salt> is some random bytes; and
  * <hash> is the hash of everything up to and including the preceding ","
- * together with the password.
+ * together with "<dstaddr>,<password>".
  *
  * For example
  *
  *   salt=$RANDOM
  *   req="s,$(date +%s),$salt"
- *   echo "$req,$(echo -n $req,secret | sha1sum | cut -c1-40)"
+ *   echo "$req,$(echo -n $req,10.10.25.1,secret | sha1sum | cut -c1-40)"
  *
  * You will want a better salt and password than that though :-)
  */
@@ -121,7 +123,6 @@ static unsigned int sysrq_tg(const void *pdata, uint16_t len)
 	sg_init_table(sg, 2);
 #endif
 	sg_set_buf(&sg[0], data, n);
-	strcpy(sysrq_digest_password, sysrq_password);
 	i = strlen(sysrq_digest_password);
 	sg_set_buf(&sg[1], sysrq_digest_password, i);
 	ret = crypto_hash_digest(&desc, sg, n + i, sysrq_digest);
@@ -223,6 +224,7 @@ sysrq_tg4(struct sk_buff **pskb, const struct xt_action_param *par)
 		       ": %pI4:%u -> %pI4:%u len=%u\n",
 		       &iph->saddr, htons(udph->source),
 		       &iph->daddr, htons(udph->dest), len);
+	sprintf(sysrq_digest_password, "%pI4,%s", &iph->daddr, sysrq_password);
 	return sysrq_tg((void *)udph + sizeof(struct udphdr), len);
 }
 
@@ -253,6 +255,7 @@ sysrq_tg6(struct sk_buff **pskb, const struct xt_action_param *par)
 		       ": [%pI6c]:%hu -> [%pI6c]:%hu len=%u\n",
 		       &iph->saddr, ntohs(udph->source),
 		       &iph->daddr, ntohs(udph->dest), len);
+	sprintf(sysrq_digest_password, "%pI6c,%s", &iph->daddr, sysrq_password);
 	return sysrq_tg((void *)udph + sizeof(struct udphdr), len);
 }
 #endif
@@ -340,7 +343,9 @@ static int __init sysrq_crypto_init(void)
 	sysrq_hexdigest = kmalloc(2 * sysrq_digest_size + 1, GFP_KERNEL);
 	if (sysrq_hexdigest == NULL)
 		goto fail;
-	sysrq_digest_password = kmalloc(sizeof(sysrq_password), GFP_KERNEL);
+	sysrq_digest_password =
+	    kmalloc(sizeof("xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:255.255.255.255") +
+		    sizeof(sysrq_password), GFP_KERNEL);
 	if (sysrq_digest_password == NULL)
 		goto fail;
 	do_gettimeofday(&now);
-- 
1.7.5.4

