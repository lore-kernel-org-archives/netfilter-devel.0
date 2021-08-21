Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86094C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 09:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58AED60720
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 09:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhHUJ4T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Aug 2021 05:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbhHUJ4S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Aug 2021 05:56:18 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA5EC061575
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 02:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JfxA+KicK2hBTslwyHfn8U6tabn4pGzw1xYrnea5Spc=; b=hZFlTXO+fEPSR3Gx6Z3mT9kbJH
        mY7m9qsEQuAYbZlww73RZUnbIFdaP3lcPyQguUctFvsgiFdha+OCkp+NHgHE5woYf2SDP3tCMgRp7
        gVSx8PiTI0xzrA0HNI6QLvA2BURAy//PbyFbyKOoDaXSdYEEoQckSVhn5VMKZw7fce5BWoXm9pKim
        XvgpnbhA1I2IYM3+l0SOiSVPkb0pDwiEdv/ZaYgJbd1Qf46UgJnIchISiH2GLgxJ7cm2hMNEDRpYY
        FvcmZ3mH5RpLF2yPRpyvrcTg+j9kqbbc6R1Trou4x40kK1vJ0DuYzLVbb2EV3eIt7bhRtoNt8ZWDX
        EJc2SG1Q==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHNir-0075aL-Lq; Sat, 21 Aug 2021 10:55:29 +0100
Date:   Sat, 21 Aug 2021 10:55:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v3 1/3] build: doc: Fix NAME entry in
 man pages
Message-ID: <YSDNkNFOfdyOKXh2@azazel.net>
References: <20210821053805.6371-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zfXmHbLZYZFthkKf"
Content-Disposition: inline
In-Reply-To: <20210821053805.6371-1-duncan_roe@optusnet.com.au>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--zfXmHbLZYZFthkKf
Content-Type: multipart/mixed; boundary="bArpSfK315DKcfV1"
Content-Disposition: inline


--bArpSfK315DKcfV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-21, at 15:38:03 +1000, Duncan Roe wrote:
> Add a post_process() function to the big shell script inside doxygen/Makefile.am
> to make the NAME line in a man page list the functions defined, like other man
> pages do.
> This function does a number of other things:
> - If there is a "Modules" section, delete it
> - If "Detailed Description" is empty, delete "Detailed Description" line
> - Reposition SYNOPSIS (with headers that we inserted) to start of page,
>   integrating with defined functions to look like other man pages
> - Delete all "Definition at line nnn" lines
> - Delete lines that make older versions of man o/p an unwanted blank line
> - Insert spacers and comments so Makefile.am is more readable
> - Delete lines that make older versions of man o/p an unwanted blank line
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
> v2: Delete lines that make older versions of man o/p an unwanted blank line
> v3: same as v2 but there are now 2 more patches
>  doxygen/Makefile.am | 172 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 172 insertions(+)
>
> diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
> index 29078de..5bcef61 100644
> --- a/doxygen/Makefile.am
> +++ b/doxygen/Makefile.am
> @@ -21,19 +21,32 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
>  # The command has to be a single line so the functions work
>  # and so `make` gives all lines to `bash -c`
>  # (hence ";\" at the end of every line but the last).
> +# automake (run by autogen.sh) allows comments starting ## after continuations
> +# but not blank lines
> +

Would it not make life easier to move all this shell-script into a
build_man.sh and just call that from the make-file?  Patch attached.

J.

>  	/bin/bash -p -c 'declare -A renamed_page;\
> +##
>  main(){ set -e; cd man/man3; rm -f _*;\
>    count_real_pages;\
>    rename_real_pages;\
>    make_symlinks;\
> +  post_process;\
>  };\
> +##
>  count_real_pages(){ page_count=0;\
> +  ##
> +  ## Count "real" man pages (i.e. not generated by MAN_LINKS)
> +  ## MAN_LINKS pages are 1-liners starting .so
> +  ## Method: list files in descending order of size,
> +  ## looking for the first 1-liner
> +  ##
>    for i in $$(ls -S);\
>    do head -n1 $$i | grep -E -q '^\.so' && break;\
>      page_count=$$(($$page_count + 1));\
>    done;\
>    first_link=$$(($$page_count + 1));\
>  };\
> +##
>  rename_real_pages(){ for i in $$(ls -S | head -n$$page_count);\
>    do for j in $$(ls -S | tail -n+$$first_link);\
>      do grep -E -q $$i$$ $$j && break;\
> @@ -42,10 +55,169 @@ rename_real_pages(){ for i in $$(ls -S | head -n$$page_count);\
>      renamed_page[$$i]=$$j;\
>    done;\
>  };\
> +##
>  make_symlinks(){ for j in $$(ls -S | tail -n+$$first_link);\
>    do ln -sf $${renamed_page[$$(cat $$j | cut -f2 -d/)]} $$j;\
>    done;\
>  };\
> +##
> +post_process(){ make_temp_files;\
> +  ##
> +  ## DIAGNOSTIC / DEVELOPMENT CODE
> +  ## set -x and restrict processing to keep_me: un-comment to activate
> +  ## Change keep_me as required
> +  ##
> +  ##keep_me=nfq_icmp_get_hdr.3;\
> +  ##do_diagnostics;\
> +  ##
> +  ## Work through the "real" man pages
> +  for target in $$(ls -S | head -n$$page_count);\
> +  do mygrep "^\\.SH \"Function Documentation" $$target;\
> +    ## Next file if this isn't a function page
> +    [ $$linnum -ne 0 ] || continue;\
> +    ##
> +    del_modules;\
> +    del_bogus_synopsis;\
> +    fix_name_line;\
> +    move_synopsis;\
> +    del_empty_det_desc;\
> +    del_def_at_lines;\
> +    fix_double_blanks;\
> +  done;\
> +  ##
> +  remove_temp_files;\
> +};\
> +##
> +fix_double_blanks(){ linnum=1;\
> +  ##
> +  ## Older versions of man display a blank line on encountering "\fB\fP";
> +  ## newer versions of man do not.
> +  ## doxygen emits "\fB\fP" on seeing "\par" on a line by itself.
> +  ## "\par" gives us double-spacing in the web doc, which we want, but double-
> +  ## spacing looks odd in a man page so remove "\fB\fP".
> +  ##
> +  while [ $$linnum -ne 0 ];\
> +  do mygrep \\\\fB\\\\fP $$target;\
> +    [ $$linnum -eq 0 ] || delete_lines $$linnum $$linnum;\
> +  done;\
> +};\
> +##
> +del_def_at_lines(){ linnum=1;\
> +  while [ $$linnum -ne 0 ];\
> +  do mygrep "^Definition at line [[:digit:]]* of file" $$target;\
> +    [ $$linnum -eq 0 ] || delete_lines $$(($$linnum - 1)) $$linnum;\
> +  done;\
> +};\
> +##
> +## Only invoked if you un-comment the 2 diagnostic / development lines above
> +do_diagnostics(){ mv $$keep_me xxx;\
> +  rm *.3;\
> +  mv xxx $$keep_me;\
> +  page_count=1;\
> +  set -x;\
> +};\
> +##
> +del_empty_det_desc(){ mygrep "^\\.SH \"Function Documentation" $$target;\
> +  i=$$linnum;\
> +  mygrep "^\\.SH \"Detailed Description" $$target;\
> +  [ $$linnum -ne 0  ] || return 0;\
> +  [ $$(($$i - $$linnum)) -eq 3 ] || return 0;\
> +  delete_lines $$linnum $$(($$i -1));\
> +};\
> +##
> +move_synopsis(){ mygrep "SH SYNOPSIS" $$target;\
> +  [ $$linnum -ne 0  ] || return 0;\
> +  i=$$linnum;\
> +  ## If this is a doxygen-created synopsis, leave it.
> +  ## (We haven't inserted our own one in the source yet)
> +  mygrep "^\\.SS \"Functions" $$target;\
> +  [ $$i -gt $$linnum ] || return 0;\
> +  ##
> +  mygrep "^\\.SH \"Function Documentation" $$target;\
> +  j=$$(($$linnum - 1));\
> +  head -n$$(($$j - 1)) $$target | tail -n$$(($$linnum - $$i - 1)) >$$fileC;\
> +  delete_lines $$i $$j;\
> +  mygrep "^\\.SS \"Functions" $$target;\
> +  head -n$$(($$linnum - 1)) $$target >$$fileA;\
> +  tail -n+$$(($$linnum + 1)) $$target >$$fileB;\
> +  cat $$fileA $$fileC $$fileB >$$target;\
> +};\
> +##
> +fix_name_line(){ all_funcs="";\
> +  ##
> +  ## Search a shortened version of the page in case there are .RI lines later
> +  mygrep "^\\.SH \"Function Documentation" $$target;\
> +  head -n$$linnum $$target >$$fileC;\
> +  ##
> +  while :;\
> +  do mygrep ^\\.RI $$fileC;\
> +    [ $$linnum -ne 0 ] || break;\
> +    ## Discard this entry
> +    tail -n+$$(($$linnum + 1)) $$fileC >$$fileB;\
> +    cp $$fileB $$fileC;\
> +    ##
> +    func=$$(cat $$fileG | cut -f2 -d\\ | cut -c3-);\
> +    [ -z "$$all_funcs" ] && all_funcs=$$func ||\
> +      all_funcs="$$all_funcs, $$func";\
> +  done;\
> +  ## For now, assume name is at line 5
> +  head -n4 $$target >$$fileA;\
> +  desc=$$(head -n5 $$target | tail -n1 | cut -f3- -d" ");\
> +  tail -n+6 $$target >$$fileB;\
> +  cat $$fileA >$$target;\
> +  echo "$$all_funcs \\- $$desc" >>$$target;\
> +  cat $$fileB >>$$target;\
> +};\
> +##
> +del_modules(){ mygrep "^\.SS \"Modules" $$target;\
> +  [ $$linnum -ne 0  ] || return 0;\
> +  i=$$linnum;\
> +  mygrep "^\\.SS \"Functions" $$target;\
> +  delete_lines $$i $$(($$linnum - 1));\
> +};\
> +##
> +del_bogus_synopsis(){ mygrep "SH SYNOPSIS" $$target;\
> +  ##
> +  ## doxygen 1.8.20 inserts its own SYNOPSIS line but there is no mention
> +  ## in the documentation or git log what to do with it.
> +  ## So get rid of it
> +  ##
> +  [ $$linnum -ne 0  ] || return 0;\
> +  i=$$linnum;\
> +  ## Look for the next one
> +  tail -n+$$(($$i + 1)) $$target >$$fileC;\
> +  mygrep "SH SYNOPSIS" $$fileC;\
> +  [ $$linnum -ne 0  ] || return 0;\
> +  ##
> +  mygrep "^\\.SS \"Functions" $$target;\
> +  delete_lines $$i $$(($$linnum - 1));\
> +};\
> +##
> +## Delete lines $1 through $2 from $target
> +delete_lines(){ head -n$$(($$1 - 1)) $$target >$$fileA;\
> +  tail -n+$$(($$2 +1)) $$target >$$fileB;\
> +  cat $$fileA $$fileB >$$target;\
> +};\
> +##
> +mygrep(){ set +e;\
> +  grep -En "$$1" $$2 2>/dev/null >$$fileH;\
> +  [ $$? -ne 0 ] && linnum=0 ||\
> +    { head -n1 $$fileH >$$fileG; linnum=$$(cat $$fileG | cut -f1 -d:); };\
> +  set -e;\
> +};\
> +##
> +make_temp_files(){ temps="A B C G H";\
> +  for i in $$temps;\
> +  do declare -g file$$i=$$(mktemp);\
> +  done;\
> +};\
> +##
> +remove_temp_files(){ for i in $$temps;\
> +  do j=file$$i;\
> +    rm $${!j};\
> +  done;\
> +};\
> +##
>  main'
>
>  	touch doxyfile.stamp

--bArpSfK315DKcfV1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="0001-build-use-a-separate-shell-script-to-build-man-pages.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 562e9dcfd27faa3edf3464c67e15aabf8a14f2ba Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Sat, 21 Aug 2021 10:45:36 +0100
Subject: [PATCH] build: use a separate shell-script to build man-pages.

---
 doxygen/Makefile.am  | 198 +--------------------------------------
 doxygen/build_man.sh | 215 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 218 insertions(+), 195 deletions(-)
 create mode 100755 doxygen/build_man.sh

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index e788843002de..52dca075f37d 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -25,201 +25,7 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 # but not blank lines
=20
 if BUILD_MAN
-	/bin/bash -p -c 'declare -A renamed_page;\
-##
-main(){ set -e; cd man/man3; rm -f _*;\
-  count_real_pages;\
-  rename_real_pages;\
-  make_symlinks;\
-  post_process;\
-};\
-##
-count_real_pages(){ page_count=3D0;\
-  ##
-  ## Count "real" man pages (i.e. not generated by MAN_LINKS)
-  ## MAN_LINKS pages are 1-liners starting .so
-  ## Method: list files in descending order of size,
-  ## looking for the first 1-liner
-  ##
-  for i in $$(ls -S);\
-  do head -n1 $$i | grep -E -q '^\.so' && break;\
-    page_count=3D$$(($$page_count + 1));\
-  done;\
-  first_link=3D$$(($$page_count + 1));\
-};\
-##
-rename_real_pages(){ for i in $$(ls -S | head -n$$page_count);\
-  do for j in $$(ls -S | tail -n+$$first_link);\
-    do grep -E -q $$i$$ $$j && break;\
-    done;\
-    mv -f $$i $$j;\
-    renamed_page[$$i]=3D$$j;\
-  done;\
-};\
-##
-make_symlinks(){ for j in $$(ls -S | tail -n+$$first_link);\
-  do ln -sf $${renamed_page[$$(cat $$j | cut -f2 -d/)]} $$j;\
-  done;\
-};\
-##
-post_process(){ make_temp_files;\
-  ##
-  ## DIAGNOSTIC / DEVELOPMENT CODE
-  ## set -x and restrict processing to keep_me: un-comment to activate
-  ## Change keep_me as required
-  ##
-  ##keep_me=3Dnfq_icmp_get_hdr.3;\
-  ##do_diagnostics;\
-  ##
-  ## Work through the "real" man pages
-  for target in $$(ls -S | head -n$$page_count);\
-  do mygrep "^\\.SH \"Function Documentation" $$target;\
-    ## Next file if this isn't a function page
-    [ $$linnum -ne 0 ] || continue;\
-    ##
-    del_modules;\
-    del_bogus_synopsis;\
-    fix_name_line;\
-    move_synopsis;\
-    del_empty_det_desc;\
-    del_def_at_lines;\
-    fix_double_blanks;\
-  done;\
-  ##
-  remove_temp_files;\
-};\
-##
-fix_double_blanks(){ linnum=3D1;\
-  ##
-  ## Older versions of man display a blank line on encountering "\fB\fP";
-  ## newer versions of man do not.
-  ## doxygen emits "\fB\fP" on seeing "\par" on a line by itself.
-  ## "\par" gives us double-spacing in the web doc, which we want, but dou=
ble-
-  ## spacing looks odd in a man page so remove "\fB\fP".
-  ##
-  while [ $$linnum -ne 0 ];\
-  do mygrep \\\\fB\\\\fP $$target;\
-    [ $$linnum -eq 0 ] || delete_lines $$linnum $$linnum;\
-  done;\
-};\
-##
-del_def_at_lines(){ linnum=3D1;\
-  while [ $$linnum -ne 0 ];\
-  do mygrep "^Definition at line [[:digit:]]* of file" $$target;\
-    [ $$linnum -eq 0 ] || delete_lines $$(($$linnum - 1)) $$linnum;\
-  done;\
-};\
-##
-## Only invoked if you un-comment the 2 diagnostic / development lines abo=
ve
-do_diagnostics(){ mv $$keep_me xxx;\
-  rm *.3;\
-  mv xxx $$keep_me;\
-  page_count=3D1;\
-  set -x;\
-};\
-##
-del_empty_det_desc(){ mygrep "^\\.SH \"Function Documentation" $$target;\
-  i=3D$$linnum;\
-  mygrep "^\\.SH \"Detailed Description" $$target;\
-  [ $$linnum -ne 0  ] || return 0;\
-  [ $$(($$i - $$linnum)) -eq 3 ] || return 0;\
-  delete_lines $$linnum $$(($$i -1));\
-};\
-##
-move_synopsis(){ mygrep "SH SYNOPSIS" $$target;\
-  [ $$linnum -ne 0  ] || return 0;\
-  i=3D$$linnum;\
-  ## If this is a doxygen-created synopsis, leave it.
-  ## (We haven't inserted our own one in the source yet)
-  mygrep "^\\.SS \"Functions" $$target;\
-  [ $$i -gt $$linnum ] || return 0;\
-  ##
-  mygrep "^\\.SH \"Function Documentation" $$target;\
-  j=3D$$(($$linnum - 1));\
-  head -n$$(($$j - 1)) $$target | tail -n$$(($$linnum - $$i - 1)) >$$fileC=
;\
-  delete_lines $$i $$j;\
-  mygrep "^\\.SS \"Functions" $$target;\
-  head -n$$(($$linnum - 1)) $$target >$$fileA;\
-  tail -n+$$(($$linnum + 1)) $$target >$$fileB;\
-  cat $$fileA $$fileC $$fileB >$$target;\
-};\
-##
-fix_name_line(){ all_funcs=3D"";\
-  ##
-  ## Search a shortened version of the page in case there are .RI lines la=
ter
-  mygrep "^\\.SH \"Function Documentation" $$target;\
-  head -n$$linnum $$target >$$fileC;\
-  ##
-  while :;\
-  do mygrep ^\\.RI $$fileC;\
-    [ $$linnum -ne 0 ] || break;\
-    ## Discard this entry
-    tail -n+$$(($$linnum + 1)) $$fileC >$$fileB;\
-    cp $$fileB $$fileC;\
-    ##
-    func=3D$$(cat $$fileG | cut -f2 -d\\ | cut -c3-);\
-    [ -z "$$all_funcs" ] && all_funcs=3D$$func ||\
-      all_funcs=3D"$$all_funcs, $$func";\
-  done;\
-  ## For now, assume name is at line 5
-  head -n4 $$target >$$fileA;\
-  desc=3D$$(head -n5 $$target | tail -n1 | cut -f3- -d" ");\
-  tail -n+6 $$target >$$fileB;\
-  cat $$fileA >$$target;\
-  echo "$$all_funcs \\- $$desc" >>$$target;\
-  cat $$fileB >>$$target;\
-};\
-##
-del_modules(){ mygrep "^\.SS \"Modules" $$target;\
-  [ $$linnum -ne 0  ] || return 0;\
-  i=3D$$linnum;\
-  mygrep "^\\.SS \"Functions" $$target;\
-  delete_lines $$i $$(($$linnum - 1));\
-};\
-##
-del_bogus_synopsis(){ mygrep "SH SYNOPSIS" $$target;\
-  ##
-  ## doxygen 1.8.20 inserts its own SYNOPSIS line but there is no mention
-  ## in the documentation or git log what to do with it.
-  ## So get rid of it
-  ##
-  [ $$linnum -ne 0  ] || return 0;\
-  i=3D$$linnum;\
-  ## Look for the next one
-  tail -n+$$(($$i + 1)) $$target >$$fileC;\
-  mygrep "SH SYNOPSIS" $$fileC;\
-  [ $$linnum -ne 0  ] || return 0;\
-  ##
-  mygrep "^\\.SS \"Functions" $$target;\
-  delete_lines $$i $$(($$linnum - 1));\
-};\
-##
-## Delete lines $1 through $2 from $target
-delete_lines(){ head -n$$(($$1 - 1)) $$target >$$fileA;\
-  tail -n+$$(($$2 +1)) $$target >$$fileB;\
-  cat $$fileA $$fileB >$$target;\
-};\
-##
-mygrep(){ set +e;\
-  grep -En "$$1" $$2 2>/dev/null >$$fileH;\
-  [ $$? -ne 0 ] && linnum=3D0 ||\
-    { head -n1 $$fileH >$$fileG; linnum=3D$$(cat $$fileG | cut -f1 -d:); }=
;\
-  set -e;\
-};\
-##
-make_temp_files(){ temps=3D"A B C G H";\
-  for i in $$temps;\
-  do declare -g file$$i=3D$$(mktemp);\
-  done;\
-};\
-##
-remove_temp_files(){ for i in $$temps;\
-  do j=3Dfile$$i;\
-    rm $${!j};\
-  done;\
-};\
-##
-main'
+	./build_man.sh
 endif
=20
 	touch doxyfile.stamp
@@ -245,3 +51,5 @@ endif
 uninstall-local:
 	rm -rf $(DESTDIR)$(htmldir) $(DESTDIR)$(mandir) man html doxyfile.stamp
 endif
+
+EXTRA_DIST =3D build_man.sh
diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
new file mode 100755
index 000000000000..da8c84e81c42
--- /dev/null
+++ b/doxygen/build_man.sh
@@ -0,0 +1,215 @@
+#!/bin/bash -p
+
+declare -A renamed_page
+
+main(){
+  set -e
+  cd man/man3; rm -f _*
+  count_real_pages
+  rename_real_pages
+  make_symlinks
+  post_process
+}
+
+count_real_pages(){
+  page_count=3D0
+  #
+  # Count "real" man pages (i.e. not generated by MAN_LINKS)
+  # MAN_LINKS pages are 1-liners starting .so
+  # Method: list files in descending order of size,
+  # looking for the first 1-liner
+  #
+  for i in $(ls -S)
+  do head -n1 $i | grep -E -q '^\.so' && break
+    page_count=3D$(($page_count + 1))
+  done
+  first_link=3D$(($page_count + 1))
+}
+
+rename_real_pages(){
+  for i in $(ls -S | head -n$page_count)
+  do for j in $(ls -S | tail -n+$first_link)
+    do grep -E -q $i$ $j && break
+    done
+    mv -f $i $j
+    renamed_page[$i]=3D$j
+  done
+}
+
+make_symlinks(){
+  for j in $(ls -S | tail -n+$first_link)
+  do ln -sf ${renamed_page[$(cat $j | cut -f2 -d/)]} $j
+  done
+}
+
+post_process(){
+  make_temp_files
+  #
+  # DIAGNOSTIC / DEVELOPMENT CODE
+  # set -x and restrict processing to keep_me: un-comment to activate
+  # Change keep_me as required
+  #
+  #keep_me=3Dnfq_icmp_get_hdr.3;\
+  #do_diagnostics;\
+  #
+  # Work through the "real" man pages
+  for target in $(ls -S | head -n$page_count)
+  do mygrep "^\\.SH \"Function Documentation" $target
+    # Next file if this isn't a function page
+    [ $linnum -ne 0 ] || continue
+
+    del_modules
+    del_bogus_synopsis
+    fix_name_line
+    move_synopsis
+    del_empty_det_desc
+    del_def_at_lines
+    fix_double_blanks
+  done
+
+  remove_temp_files
+}
+
+fix_double_blanks(){
+  linnum=3D1
+  #
+  # Older versions of man display a blank line on encountering "\fB\fP";
+  # newer versions of man do not.
+  # doxygen emits "\fB\fP" on seeing "\par" on a line by itself.
+  # "\par" gives us double-spacing in the web doc, which we want, but doub=
le-
+  # spacing looks odd in a man page so remove "\fB\fP".
+  #
+  while [ $linnum -ne 0 ]
+  do mygrep \\\\fB\\\\fP $target
+    [ $linnum -eq 0 ] || delete_lines $linnum $linnum
+  done
+}
+
+del_def_at_lines(){
+  linnum=3D1
+  while [ $linnum -ne 0 ]
+  do mygrep "^Definition at line [[:digit:]]* of file" $target
+    [ $linnum -eq 0 ] || delete_lines $(($linnum - 1)) $linnum
+  done
+}
+
+# Only invoked if you un-comment the 2 diagnostic / development lines above
+do_diagnostics(){
+  mv $keep_me xxx
+  rm *.3
+  mv xxx $keep_me
+  page_count=3D1
+  set -x
+}
+
+del_empty_det_desc(){
+  mygrep "^\\.SH \"Function Documentation" $target
+  i=3D$linnum
+  mygrep "^\\.SH \"Detailed Description" $target
+  [ $linnum -ne 0  ] || return 0
+  [ $(($i - $linnum)) -eq 3 ] || return 0
+  delete_lines $linnum $(($i -1))
+}
+
+move_synopsis(){
+  mygrep "SH SYNOPSIS" $target
+  [ $linnum -ne 0  ] || return 0
+  i=3D$linnum
+  # If this is a doxygen-created synopsis, leave it.
+  # (We haven't inserted our own one in the source yet)
+  mygrep "^\\.SS \"Functions" $target
+  [ $i -gt $linnum ] || return 0
+
+  mygrep "^\\.SH \"Function Documentation" $target
+  j=3D$(($linnum - 1))
+  head -n$(($j - 1)) $target | tail -n$(($linnum - $i - 1)) >$fileC
+  delete_lines $i $j
+  mygrep "^\\.SS \"Functions" $target
+  head -n$(($linnum - 1)) $target >$fileA
+  tail -n+$(($linnum + 1)) $target >$fileB
+  cat $fileA $fileC $fileB >$target
+}
+
+fix_name_line(){
+  all_funcs=3D""
+
+  # Search a shortened version of the page in case there are .RI lines lat=
er
+  mygrep "^\\.SH \"Function Documentation" $target
+  head -n$linnum $target >$fileC
+
+  while :
+  do mygrep ^\\.RI $fileC
+    [ $linnum -ne 0 ] || break
+    # Discard this entry
+    tail -n+$(($linnum + 1)) $fileC >$fileB
+    cp $fileB $fileC
+
+    func=3D$(cat $fileG | cut -f2 -d\\ | cut -c3-)
+    [ -z "$all_funcs" ] && all_funcs=3D$func ||\
+      all_funcs=3D"$all_funcs, $func"
+  done
+  # For now, assume name is at line 5
+  head -n4 $target >$fileA
+  desc=3D$(head -n5 $target | tail -n1 | cut -f3- -d" ")
+  tail -n+6 $target >$fileB
+  cat $fileA >$target
+  echo "$all_funcs \\- $desc" >>$target
+  cat $fileB >>$target
+}
+
+del_modules(){
+  mygrep "^\.SS \"Modules" $target
+  [ $linnum -ne 0  ] || return 0
+  i=3D$linnum
+  mygrep "^\\.SS \"Functions" $target
+  delete_lines $i $(($linnum - 1))
+}
+
+del_bogus_synopsis(){
+  mygrep "SH SYNOPSIS" $target
+  #
+  # doxygen 1.8.20 inserts its own SYNOPSIS line but there is no mention
+  # in the documentation or git log what to do with it.
+  # So get rid of it
+  #
+  [ $linnum -ne 0  ] || return 0
+  i=3D$linnum
+  # Look for the next one
+  tail -n+$(($i + 1)) $target >$fileC;\
+  mygrep "SH SYNOPSIS" $fileC
+  [ $linnum -ne 0  ] || return 0
+
+  mygrep "^\\.SS \"Functions" $target
+  delete_lines $i $(($linnum - 1))
+}
+
+# Delete lines $1 through $2 from $target
+delete_lines(){
+  head -n$(($1 - 1)) $target >$fileA
+  tail -n+$(($2 +1)) $target >$fileB
+  cat $fileA $fileB >$target
+}
+
+mygrep(){
+  set +e
+  grep -En "$1" $2 2>/dev/null >$fileH
+  [ $? -ne 0 ] && linnum=3D0 ||\
+    { head -n1 $fileH >$fileG; linnum=3D$(cat $fileG | cut -f1 -d:); }
+  set -e
+}
+
+make_temp_files(){
+  temps=3D"A B C G H"
+  for i in $temps
+  do declare -g file$i=3D$(mktemp)
+  done
+}
+
+remove_temp_files(){
+  for i in $temps
+  do j=3Dfile$i
+    rm ${!j}
+  done
+}
+
+main
--=20
2.32.0


--bArpSfK315DKcfV1--

--zfXmHbLZYZFthkKf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEgzYkACgkQKYasCr3x
BA39lg/+NGq7X+f3Er6Q1mufH77ASO4Ce8kzXWJ0eW6B5BejR9CIOY0QfvY+wIL6
U7qpsDOyoR4Iru1OLsfLAsdIxIErpv3VCghc0AM40aoX/TjmKeuFKXSFVkbPpOaf
HjMPgvhYUldoEmuasU0jDT03YBAKqgAyHa1oAFjSgUSOSka8F4H+KJCbSeub7T9l
VrzGresXr65KPT4WGWrtB0164DSdpJCrEP5/paSszWRpv7Ei1XtD8Jdad0AkhO8O
fAtAzE8pcTqsgK+1HZM9CO990qNadK/4pgsYPOID7Iq2c0h/a9DYiv2WKJhidHmw
9LTiIQ1Jmb/1GBHDe9jmixetYkeFWi0jZcO1c86t/TfAOADOym+p/sWYKzQZ7pGJ
UM8iIQJhvA0Xa8OEZzC6BIpGsXBpc4Y+z/nh0ep77MWnh3GyMtr39hjjqLVp5JwN
aAoBD3tcHQIT6lmrAHEyyV+VaVZxWl418GU0+BGNGY7iD1yFZxGsXY7YiMSNP7bC
bbFytWWw5TWXF3kYlQHZFbcuqFjdWkgM5RLZr7iKAaDrkf2FeaBGucw7/gf0QO9p
th8uIWYNolUxMo2HeI6z5HXgJJhKXzasTLG9TdA+T/Jc21HmLB6C0dOEyhUiLyGZ
CzMOI6K+LXKEdheS33s3JXYvMHVvNAvOVT8Iln/1/wGsKSkbheQ=
=J1Wu
-----END PGP SIGNATURE-----

--zfXmHbLZYZFthkKf--
