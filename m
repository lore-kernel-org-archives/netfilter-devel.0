From: Eric Leblond <eric@inl.fr>
Subject: Re: trying to test libnetfilter_queue on openwrt kamikaze_RC2 - failing
   with "connection refused"
Date: Sun, 01 Feb 2009 12:29:45 +0100
Message-ID: <498587A9.9040003@inl.fr>
References: <3ba156dd0901312047s3f54f6a4t3b43a36025103dfe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060302010301000409000808"
Cc: netfilter-devel@vger.kernel.org
To: Pete Whiting <pete@whitings.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:51906 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZBAL3t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Feb 2009 06:29:49 -0500
In-Reply-To: <3ba156dd0901312047s3f54f6a4t3b43a36025103dfe@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060302010301000409000808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

Pete Whiting a écrit :
> I am trying to build/test libnetfilter_queue for a user-space app
> running on openwrt. Compile failed in the utils subdirectory until I
> modified Makefile.in to include libnfnetlink.so:
> 
> 
> I verified that xt_NFQUEUE is installed:
> root@Kamikaze_RC2:~# lsmod | grep QUEUE
> xt_NFQUEUE               672  0
> x_tables                8976  16
> xt_NFQUEUE,ipt_ULOG,xt_string,xt_layer7,ipt_ipp2p,ipt_MASQUERADE,iptable_nat,xt_state,ipt_REJECT,xt_TCPMSS,ipt_LOG,xt_multiport,xt_mac,xt_limit,ip_tables,xt_tcpudp

It seems the nfnetlink_queue module is missing. It should not be on that
list because of your grep but it could be a good explanation (your
strace seems to confirm this).

If this is not the case, please apply the joined patch and let us know.

By the way, please tell us your kernel version. It seems this problem is
specific to some version.

BR,
- --
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJhYecnxA7CdMWjzIRAqX7AJsEM3sXmWRZG64PrQQog+FYuxnQQQCfVsfC
IQeVwqHXrG1GSnxkEli3o+s=
=Pk8w
-----END PGP SIGNATURE-----

--------------060302010301000409000808
Content-Type: text/x-patch;
 name="dont_exit_at_unbind.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dont_exit_at_unbind.patch"

diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index 7cf27f0..b4ace5b 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -72,8 +72,7 @@ int main(int argc, char **argv)
 
 	printf("unbinding existing nf_queue handler for AF_INET (if any)\n");
 	if (nfq_unbind_pf(h, AF_INET) < 0) {
-		fprintf(stderr, "error during nfq_unbind_pf()\n");
-		exit(1);
+		fprintf(stderr, "error during nfq_unbind_pf() but continuing\n");
 	}
 
 	printf("binding nfnetlink_queue as nf_queue handler for AF_INET\n");

--------------060302010301000409000808--
