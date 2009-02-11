From: Tino Keitel <tkeitel@innominate.com>
Subject: Re: [PATCH] fix source code corruption in ebtables Makefile
Date: Wed, 11 Feb 2009 17:34:49 +0100
Message-ID: <20090211163449.GA10028@tkeitel002.bln.innominate.local>
References: <20090211163142.GA28401@tkeitel002.bln.innominate.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
To: bart.de.schuymer@pandora.be, ebtables-devel@lists.sourceforge.net,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host2.bln.innominate.com ([77.245.32.75]:38845 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbZBKQfH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:35:07 -0500
Content-Disposition: inline
In-Reply-To: <20090211163142.GA28401@tkeitel002.bln.innominate.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 11, 2009 at 17:31:42 +0100, Tino Keitel wrote:
> Hi,
> 
> the attached patch fixes source code corruption in the static: target
> of the ebtables userspace Makefile. The sed magic tries to clean up the
> modified source files, but fails. It ends up with this modifications:
> 
> diff -ru ebtables-v2.0.8-2.orig/extensions/ebt_nflog.c
> ebtables-v2.0.8-2/extensions/ebt_nflog.c
> --- ebtables-v2.0.8-2.orig/extensions/ebt_nflog.c       2009-02-11
> 16:21:37.000000000 +0100
> +++ ebtables-v2.0.8-2/extensions/ebt_nflog.c    2009-02-11
> 17:22:58.000000000 +0100
> @@ -45,7 +45,7 @@
>                "in-kernel queue\n");
>  }
>  
> -static void nflog_init(struct ebt_entry_watcher *watcher)
> +static _init(struct ebt_entry_watcher *watcher)
>  {
>         struct ebt_nflog_info *info = (struct ebt_nflog_info
> *)watcher->data;
>  
> @@ -165,7 +165,7 @@
>         .name = "nflog",
>         .size = sizeof(struct ebt_nflog_info),
>         .help = nflog_help,
> -       .init = nflog_init,
> +       .init _init,
>         .parse = nflog_parse,
>         .final_check = nflog_final_check,
>         .print = nflog_print,
> 
> With the patch, the Makefile makes a backup of the original files and
> restores it after compilation.
> 
> Signed-off-by: Tino Keitel <tino.keitel@innominate.com>

And now with the patch.

-- 
Tino Keitel
Software Engineer
 
Innominate Security Technologies AG
/protecting industrial networks/
Tel: +49.30.921028-206
Fax: +49.30.921028-020
Rudower Chaussee 13
12489 Berlin / Germany
http://www.innominate.com/

Register Court: AG Charlottenburg, HRB 81603 Management Board: Dirk
Seewald, Chairman of the Supervisory Board: Volker Bibelhausen

INNOMINATE HAS MOVED. PLEASE NOTE THAT OUR BUSINESS CONTACT DATA HAS
CHANGED.

--5mCyUwZo2JvN/JJP
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="static-restore.patch"

--- ebtables-v2.0.8-2.orig/Makefile	2007-09-21 19:27:20.000000000 +0200
+++ ebtables-v2.0.8-2/Makefile	2009-02-11 17:21:22.000000000 +0100
@@ -121,15 +121,17 @@
 	printf "\nint main(int argc, char *argv[])\n{\n "  >> ebtables-standalone.c ; \
 	for arg in $(EXT_FUNC) \
 	; do \
-	sed s/_init/_$${arg}_init/ extensions/ebt_$${arg}.c > extensions/ebt_$${arg}.c_ ; \
-	mv extensions/ebt_$${arg}.c_ extensions/ebt_$${arg}.c ; \
+	cp extensions/ebt_$${arg}.c extensions/ebt_$${arg}.c_ ;\
+	sed s/_init/_$${arg}_init/ extensions/ebt_$${arg}.c > extensions/ebt_$${arg}.c__ ; \
+	mv extensions/ebt_$${arg}.c__ extensions/ebt_$${arg}.c ; \
 	printf "\t%s();\n" _$${arg}_init >> ebtables-standalone.c ; \
 	printf "extern void %s();\n" _$${arg}_init >> include/ebtables_u.h ; \
 	done ; \
 	for arg in $(EXT_TABLES) \
 	; do \
-	sed s/_init/_t_$${arg}_init/ extensions/ebtable_$${arg}.c > extensions/ebtable_$${arg}.c_ ; \
-	mv extensions/ebtable_$${arg}.c_ extensions/ebtable_$${arg}.c ; \
+	cp extensions/ebtable_$${arg}.c extensions/ebtable_$${arg}.c_ ;\
+	sed s/_init/_t_$${arg}_init/ extensions/ebtable_$${arg}.c > extensions/ebtable_$${arg}.c__ ; \
+	mv extensions/ebtable_$${arg}.c__ extensions/ebtable_$${arg}.c ; \
 	printf "\t%s();\n" _t_$${arg}_init >> ebtables-standalone.c ; \
 	printf "extern void %s();\n" _t_$${arg}_init >> include/ebtables_u.h ; \
 	done ; \
@@ -137,12 +139,10 @@
 	$(CC) $(CFLAGS) $(PROGSPECS) -o $@ $^ -I$(KERNEL_INCLUDES) -Iinclude ; \
 	for arg in $(EXT_FUNC) \
 	; do \
-	sed "s/ .*_init/ _init/" extensions/ebt_$${arg}.c > extensions/ebt_$${arg}.c_ ; \
 	mv extensions/ebt_$${arg}.c_ extensions/ebt_$${arg}.c ; \
 	done ; \
 	for arg in $(EXT_TABLES) \
 	; do \
-	sed "s/ .*_init/ _init/" extensions/ebtable_$${arg}.c > extensions/ebtable_$${arg}.c_ ; \
 	mv extensions/ebtable_$${arg}.c_ extensions/ebtable_$${arg}.c ; \
 	done ; \
 	mv ebtables-standalone.c_ ebtables-standalone.c ; \

--5mCyUwZo2JvN/JJP--
