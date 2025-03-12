Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3E33232
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 12:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741782223; cv=none; b=n4qwMPKUZqvj4pr5xXhS5XLGD7gINs1mCnAO7GcpDwtzaX3F43Ld8MC4cAhdjGWa7lwJmCIFit6xCdWfh/auZy+ya3GMAQKQA4g1WCC3bNxxP3x9qQcsP0eF3060RGR0XUcgnr5aKfGNnGMYQoEQPi1vVe/zZNTnc7NPEbIdPOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741782223; c=relaxed/simple;
	bh=abIRLkJtl5pwbSIJN1hDOtsdz+2Rb0vL2rJ9DdqQKJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+fr0hut47BpfSWM+Fngz2/A+/S5zp9SZ/eFBWgUFK9XKefO5t9jUoIEDK97uPofiiYw5hGd4PxvjApS+KsX3qg4VK6s4MN44DCn7bw4HUnVpCntZD8dFTw/SOTIlVqKWt6roiUn3MtTzF6B3W6q9vPeLElhHbj6O8SrL8Bby40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QrWwUlRK; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uG6+DtpA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QrWwUlRK";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uG6+DtpA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 080286028D; Wed, 12 Mar 2025 13:23:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741782217;
	bh=aRK0io2sJg1BUEutH5YrvND9rbw2XqfuZi0qQmOVNpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QrWwUlRKN2k+KWXNatgMjEF+a0Z+UrcWliPAC7LUw6Pncd1k02vTrDd8OMCJjTZol
	 86Net1rg07ovWRZawcnPu2VSszMtYOymGWrNFZaUz4ilodejZeOvg/oll6x8NoRi4r
	 uOjMKN1pocykTwa9GD0AihOBQusMJVr0hCRXe5NFXg//TL7y5MiDHNwwYmCHl0izu/
	 6R2fKEdiFuyIEPHy9OZC0v95iR79XrE8aBKmBgXPGhZNSt/XlIh3THNFUoohxnOBWq
	 yk+DOObBAznBbGV87HfwOHugG+f32hVWHG7zpgdt7cHWF2AORTflIpgS6uJK/lsL3j
	 jc7Jh2O+kS5Qw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0F60560288;
	Wed, 12 Mar 2025 13:23:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741782215;
	bh=aRK0io2sJg1BUEutH5YrvND9rbw2XqfuZi0qQmOVNpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uG6+DtpAWugdzmz8xyquf2bs1x7ROeyOw1tqFq5zzf/Yf/hiyAqHQboOmP1jB4f/k
	 1MsuCDy6RY2DaVWC+om9jLCCVu/1rVXeIq/00SC2FjM85dspkVp5FXnL+l6SdfTK9a
	 ZICzkid26tbzeBBZMQFSEPAhWCh4uWRHYg/84O5LnCjW9AricHMGLtMEEu1lJLy/Sq
	 EOP9aTSGvsWwjXk9oBuMczRbhpsEf+2wolyxHZjBgqBKTrqOvHZJ3pqIlE9xOPB6id
	 cAr0oYer7os9pvRI/RaBPLUtrYvG6WwOzWTxln7YQ7DinvHEJJ6XQwRaMXhqwNbhxs
	 d4M0afwIeJC7w==
Date: Wed, 12 Mar 2025 13:23:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: netfilter-devel@vger.kernel.org, fw@netfilter.org
Subject: Re: [PATCH libnetfilter_log] build: doc: Install latest build_man.sh
 from libnetfilter_queue
Message-ID: <Z9F8xJF5joAN-vbf@calendula>
References: <20250312093116.11655-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250312093116.11655-1-duncan_roe@optusnet.com.au>

Hi Duncan,

On Wed, Mar 12, 2025 at 08:31:16PM +1100, Duncan Roe wrote:
> autogen.sh no longer fetches doxygen/build_man.sh from the
> libnetfilter_queue project using curl.
> Instead, just check in that file here.
> 
> Summary of updates (from git log in libnetfilter_queue tree):
> 512cd12 build: doc: Fix silly error in test
> 60aa427 build: doc: Fix `fprintf` in man pages from using single quotes
> f54dc69 build: doc: Only fix rendering of verbatim '\n"' when needed
> 809240b build: add missing backslash to build_man.sh
> 6d17e6d build: Speed up build_man.sh
> b35f537 make the HTML main page available as `man 7 libnetfilter_queue`
> 7cff95b build: doc: Update build_man.sh to find bash in PATH
> 088c883 build: doc: Update build_man.sh for doxygen 1.9.2

I think it is time to move this script out of this tree, there have
been patches from time to time to restore it for a new version of
doxygen, this is fragile.

I already mentioned that it would be good to support this natively in
doxygen, I don't remember why this has not been explored.

I suggest you set up a repository and maintain this out of the tree.

Thanks.

> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  doxygen/build_man.sh | 276 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 193 insertions(+), 83 deletions(-)
> 
> diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
> index 852c7b8..50ab884 100755
> --- a/doxygen/build_man.sh
> +++ b/doxygen/build_man.sh
> @@ -1,18 +1,25 @@
> -#!/bin/bash -p
> +#!/bin/sh
> +[ -n "$BASH" ] || exec bash -p $0 $@
>  
>  # Script to process man pages output by doxygen.
>  # We need to use bash for its associative array facility.
>  # (`bash -p` prevents import of functions from the environment).
> +# Args: none or 2 being man7 page name & relative path of source with \mainpage
>  
>  declare -A renamed_page
> +done_synopsis=false
>  
>  main(){
>    set -e
> -  cd man/man3; rm -f _*
> +  # make_man7 has no dependencies or dependants so kick it off now
> +  [ $# -ne 2 ] || make_man7 $@ &
> +  pushd man/man3 >/dev/null; rm -f _*
>    count_real_pages
>    rename_real_pages
> -  make_symlinks
> -  post_process
> +  # Nothing depends on make_symlinks so background it
> +  make_symlinks &
> +  post_process $@
> +  wait
>  }
>  
>  count_real_pages(){
> @@ -32,9 +39,16 @@ count_real_pages(){
>  
>  rename_real_pages(){
>    for i in $(ls -S | head -n$page_count)
> -  do for j in $(ls -S | tail -n+$first_link)
> -    do grep -E -q $i$ $j && break
> -    done
> +  do
> +    j=$(ed -s $i <<////
> +/Functions/+1;.#
> +/^\\.RI/;.#
> +.,.s/^.*\\\\fB//
> +.,.s/\\\\.*//
> +.,.w /dev/stdout
> +Q
> +////
> +).3
>      mv -f $i $j
>      renamed_page[$i]=$j
>    done
> @@ -47,35 +61,144 @@ make_symlinks(){
>  }
>  
>  post_process(){
> -  make_temp_files
>    #
>    # DIAGNOSTIC / DEVELOPMENT CODE
>    # set -x and restrict processing to keep_me: un-comment to activate
>    # Change keep_me as required
>    #
> -  #keep_me=nfq_icmp_get_hdr.3;\
> -  #do_diagnostics;\
> -  #
> +  #keep_me=nfq_icmp_get_hdr.3
> +  #do_diagnostics
> +
> +  # Record doxygen version
> +  i=$(doxygen --version)
> +  doxymajor=$(echo $i|cut -f1 -d.)
> +  doxyminor=$(echo $i|cut -f2 -d.)
> +
> +  # Decide if we need to fix rendering of verbatim "\n"
> +  [ $doxymajor -eq 1 -a $doxyminor -lt 9 ] &&
> +    fix_newlines=true || fix_newlines=false
> +
> +  # Decide if we need to fix double-to-single-quote conversion
> +  [ $doxymajor -eq 1 -a $doxyminor -ge 9 -a $doxyminor -lt 13 ] &&
> +    fix_quotes = true || fix_quotes=false
> +
>    # Work through the "real" man pages
>    for target in $(ls -S | head -n$page_count)
> -  do mygrep "^\\.SH \"Function Documentation" $target
> -    # Next file if this isn't a function page
> -    [ $linnum -ne 0 ] || continue
> +  do grep -Eq "^\\.SH \"Function Documentation" $target || continue
>  
> -    del_modules
> -    del_bogus_synopsis
> -    fix_name_line
> -    move_synopsis
> -    del_empty_det_desc
> -    del_def_at_lines
> -    fix_double_blanks
> +    {
> +      del_bogus_synopsis
> +      $done_synopsis || del_modules
> +      fix_name_line
> +      move_synopsis
> +      del_empty_det_desc
> +      del_def_at_lines
> +      fix_double_blanks
> +      [ $# -ne 2 ] || insert_see_also $@
>  
> -    # Fix rendering of verbatim "\n" (in code snippets)
> -    sed -i 's/\\n/\\\\n/' $target
> +      # Work around doxygen bugs (doxygen version-specific)
> +
> +      # Best effort: \" becomes \'
> +      #              Only do lines with some kind of printf,
> +      #              since other single quotes might be OK as-is.
> +      $fix_quotes && sed -i '/printf/s/'\''/"/g' $target
> +
> +      # Fix rendering of verbatim "\n" (in code snippets)
> +      $fix_newlines && sed -i 's/\\n/\\\\n/' $target
> +    }&
>  
>    done
>  
> -  remove_temp_files
> +}
> +
> +make_man7(){
> +  target=$(grep -Ew INPUT doxygen.cfg | rev | cut -f1 -d' ' | rev)/$2
> +  mypath=$(dirname $0)
> +
> +  # Build up temporary source in temp.c
> +  # (doxygen only makes man pages from .c files).
> +  ed -s $target << ////
> +1,/\\\\mainpage/d
> +0i
> +/**
> + * \\defgroup $1 $1 overview
> +.
> +/\\*\\//+1,\$d
> +a
> +
> +/**
> + * @{
> + *
> + * $1 - DELETE_ME
> + */
> +int $1(void)
> +{
> +	return 0;
> +}
> +/**
> + * @}
> + */
> +.
> +wq temp.c
> +////
> +
> +  # Create temporary doxygen config in doxytmp
> +  grep -Ew PROJECT_NUMBER doxygen.cfg >doxytmp
> +  cat >>doxytmp <<////
> +PROJECT_NAME = $1
> +ABBREVIATE_BRIEF =
> +FULL_PATH_NAMES = NO
> +TAB_SIZE = 8
> +OPTIMIZE_OUTPUT_FOR_C = YES
> +EXAMPLE_PATTERNS =
> +ALPHABETICAL_INDEX = NO
> +SEARCHENGINE = NO
> +GENERATE_LATEX = NO
> +INPUT = temp.c
> +GENERATE_HTML = NO
> +GENERATE_MAN = YES
> +MAN_EXTENSION = .7
> +////
> +
> +  doxygen doxytmp >/dev/null
> +
> +  # Remove SYNOPSIS line if there is one
> +  target=man/man7/$1.7
> +  mygrep "SH SYNOPSIS" $target
> +  [ $linnum -eq 0 ] || delete_lines $linnum $((linnum+1))
> +
> +  # doxygen 1.8.9.1 and possibly newer run the first para into NAME
> +  # (i.e. in this unusual group). There won't be a SYNOPSIS when this happens
> +  if grep -Eq "overview$1" $target; then
> +    echo "Re-running doxygen $(doxygen --version)"
> +    ed -s temp.c << ////
> +2a
> + * \\manonly
> +.PP
> +.SH "Detailed Description"
> +.PP
> +\\endmanonly
> +.
> +wq
> +////
> +    doxygen doxytmp >/dev/null
> +  fi
> +
> +  rm temp.c doxytmp
> +}
> +
> +# Insert top-level "See also" of man7 page in man3 page
> +insert_see_also(){
> +  mygrep "Detailed Description" $target
> +  [ $linnum -ne 0 ] || mygrep "Function Documentation" $target
> +  [ $linnum -ne 0 ] || { echo "NO HEADER IN $target" >&2; return; }
> +  ed -s $target <<////
> +${linnum}i
> +.SH "See also"
> +\\fB${1}\\fP(7)
> +.
> +wq
> +////
>  }
>  
>  fix_double_blanks(){
> @@ -96,7 +219,7 @@ fix_double_blanks(){
>  del_def_at_lines(){
>    linnum=1
>    while [ $linnum -ne 0 ]
> -  do mygrep "^Definition at line [[:digit:]]* of file" $target
> +  do mygrep '^Definition at line (\\fB)?[[:digit:]]*(\\fP)? of file' $target
>      [ $linnum -eq 0 ] || delete_lines $(($linnum - 1)) $linnum
>    done
>  }
> @@ -132,14 +255,13 @@ move_synopsis(){
>    mygrep "^\\.SS \"Functions" $target
>    [ $i -gt $linnum ] || return 0
>  
> -  mygrep "^\\.SH \"Function Documentation" $target
> -  j=$(($linnum - 1))
> -  head -n$(($j - 1)) $target | tail -n$(($linnum - $i - 1)) >$fileC
> -  delete_lines $i $j
> -  mygrep "^\\.SS \"Functions" $target
> -  head -n$(($linnum - 1)) $target >$fileA
> -  tail -n+$(($linnum + 1)) $target >$fileB
> -  cat $fileA $fileC $fileB >$target
> +  ed -s $target <<////
> +/^\\.SS \"Functions\"/;.d
> +.ka
> +/^\\.SH SYNOPSIS/;/^[[:space:]]*\$/-1m'a-1
> +/\"Function Documentation\"/-1;.d
> +wq
> +////
>  }
>  
>  fix_name_line(){
> @@ -147,81 +269,69 @@ fix_name_line(){
>  
>    # Search a shortened version of the page in case there are .RI lines later
>    mygrep "^\\.SH \"Function Documentation" $target
> -  head -n$linnum $target >$fileC
> +  head -n$linnum $target >../$target.tmp
>  
>    while :
> -  do mygrep ^\\.RI $fileC
> -    [ $linnum -ne 0 ] || break
> -    # Discard this entry
> -    tail -n+$(($linnum + 1)) $fileC >$fileB
> -    cp $fileB $fileC
> +  do foundline=$(grep -En "^\\.RI" ../$target.tmp 2>/dev/null | head -n1)
> +    [ "$foundline" ] || break
> +    linnum=$(echo $foundline | cut -f1 -d:)
> +    # Discard this entry (and all previous lines)
> +    ed -s ../$target.tmp <<////
> +1,${linnum}d
> +wq
> +////
>  
> -    func=$(cat $fileG | cut -f2 -d\\ | cut -c3-)
> +    func=$(echo $foundline | cut -f2 -d\\ | cut -c3-)
>      [ -z "$all_funcs" ] && all_funcs=$func ||\
>        all_funcs="$all_funcs, $func"
>    done
>    # For now, assume name is at line 5
> -  head -n4 $target >$fileA
>    desc=$(head -n5 $target | tail -n1 | cut -f3- -d" ")
> -  tail -n+6 $target >$fileB
> -  cat $fileA >$target
> -  echo "$all_funcs \\- $desc" >>$target
> -  cat $fileB >>$target
> +  ed -s $target <<////
> +5c
> +$all_funcs \\- $desc
> +.
> +wq
> +////
> +  rm ../$target.tmp
>  }
>  
> +# Prior to doxygen 1.8.20 there was a "Modules" entry which became part of the
> +# "bogus" synopsis. Doxygen 1.11.0 replaces "Modules" with "Topics" still as
> +# part of the "bogus" synopsis and so cleaned up by del_bogus_synopsis().
>  del_modules(){
> -  mygrep "^\.SS \"Modules" $target
> -  [ $linnum -ne 0  ] || return 0
> -  i=$linnum
> -  mygrep "^\\.SS \"Functions" $target
> -  delete_lines $i $(($linnum - 1))
> +  grep -Eq "^\\.SS \"Modules" $target || return 0
> +  ed -s $target <<////
> +/^\\.SS \"Modules/,/^\\.SS \"Functions/-1d
> +wq
> +////
>  }
>  
>  del_bogus_synopsis(){
> -  mygrep "SH SYNOPSIS" $target
> +  [ $(grep -E 'SH SYNOPSIS' $target | wc -l) -eq 2 ] || return 0
>    #
>    # doxygen 1.8.20 inserts its own SYNOPSIS line but there is no mention
>    # in the documentation or git log what to do with it.
>    # So get rid of it
>    #
> -  [ $linnum -ne 0  ] || return 0
> -  i=$linnum
> -  # Look for the next one
> -  tail -n+$(($i + 1)) $target >$fileC;\
> -  mygrep "SH SYNOPSIS" $fileC
> -  [ $linnum -ne 0  ] || return 0
> -
> -  mygrep "^\\.SS \"Functions" $target
> -  delete_lines $i $(($linnum - 1))
> +  ed -s $target <<////
> +/SH SYNOPSIS/,/^\\.SS \"Functions/-1d
> +wq
> +////
> +  done_synopsis=true
>  }
>  
>  # Delete lines $1 through $2 from $target
>  delete_lines(){
> -  head -n$(($1 - 1)) $target >$fileA
> -  tail -n+$(($2 +1)) $target >$fileB
> -  cat $fileA $fileB >$target
> +  ed -s $target <<////
> +$1,$2d
> +wq
> +////
>  }
>  
>  mygrep(){
> -  set +e
> -  grep -En "$1" $2 2>/dev/null >$fileH
> -  [ $? -ne 0 ] && linnum=0 ||\
> -    { head -n1 $fileH >$fileG; linnum=$(cat $fileG | cut -f1 -d:); }
> -  set -e
> -}
> -
> -make_temp_files(){
> -  temps="A B C G H"
> -  for i in $temps
> -  do declare -g file$i=$(mktemp)
> -  done
> -}
> -
> -remove_temp_files(){
> -  for i in $temps
> -  do j=file$i
> -    rm ${!j}
> -  done
> +  linnum=$(grep -En "$1" $2 2>/dev/null | head -n1 | cut -f1 -d:)
> +  [ $linnum ] || linnum=0
>  }
>  
> -main
> +main $@
> -- 
> 2.46.3
> 
