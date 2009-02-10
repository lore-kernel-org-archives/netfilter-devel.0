From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 06/16] libxtables: prefix/order - libdir
Date: Tue, 10 Feb 2009 10:04:35 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902100957230.21522@fbirervta.pbzchgretzou.qr>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de> <1234200900-5964-7-git-send-email-jengelh@medozas.de> <499120EA.3000108@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39426 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbZBJJEi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:04:38 -0500
In-Reply-To: <499120EA.3000108@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-10 07:38, Amos Jeffries wrote:
> Jan Engelhardt wrote:
>> +{
>> +	xtables_libdir = getenv("XTABLES_LIBDIR");
>> +	if (xtables_libdir != NULL)
>> +		return;
>> +	xtables_libdir = getenv("IPTABLES_LIB_DIR");
>> +	if (xtables_libdir != NULL) {
>> +		fprintf(stderr, "IPTABLES_LIB_DIR is deprecated, "
>> +		        "use XTABLES_LIBDIR.\n");
>> +		return;
>> +	}
>> +	xtables_libdir = XTABLES_LIBDIR;
>> +}
>
> You appear to be consolidating both IPTABLES_LIB_DIR and IP6TABLES_LIB_DIR into
> this function, yet it does not handle the IP6TABLES_LIB_DIR cases.

Thanks for noticing. I added a patch that adds it back
(/me still wanting to pull in jamal's stuff for the next pull).

+++ b/xtables.c
@@ -110,6 +110,19 @@ void xtables_init(void)
                        "use XTABLES_LIBDIR.\n");
                return;
        }
+       /*
+        * Well yes, IP6TABLES_LIB_DIR is of lower priority over
+        * IPTABLES_LIB_DIR since this moved to libxtables; I think that is ok
+        * for these env vars are deprecated anyhow, and in light of the
+        * (shared) libxt_*.so files, makes less sense to have
+        * IPTABLES_LIB_DIR != IP6TABLES_LIB_DIR.
+        */
+       xtables_libdir = getenv("IP6TABLES_LIB_DIR");
+       if (xtables_libdir != NULL) {
+               fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated, "
+                       "use XTABLES_LIBDIR.\n");
+               return;
+       }
        xtables_libdir = XTABLES_LIBDIR;
 }
