From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH 4/5] tests/shell: add tests for handles and comments
Date: Fri, 11 Dec 2015 14:29:39 +0100
Message-ID: <CAOkSjBgTH0X2GZzd9adopiX_jijJRe4M0ysWkrfM=W04VF+w+g@mail.gmail.com>
References: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es> <144982863023.31246.1243999908078428421.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37056 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbbLKN37 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 08:29:59 -0500
Received: by wmnn186 with SMTP id n186so31513926wmn.0
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Dec 2015 05:29:58 -0800 (PST)
In-Reply-To: <144982863023.31246.1243999908078428421.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> diff --git a/tests/shell/testcases/optionals/comments_handles_monitor=
_0 b/tests/shell/testcases/optionals/comments_handles_monitor_0
> new file mode 100755
> index 0000000..f1e2004
> --- /dev/null
> +++ b/tests/shell/testcases/optionals/comments_handles_monitor_0
> @@ -0,0 +1,29 @@
> +#!/bin/bash
> +
> +# handles and comments mix well in monitor
> +
> +MKTEMP=3D$(which mktemp)
> +if [ -x $MKTEMP ] ; then
> +       tmpfile=3D$(${MKTEMP})
> +else
> +       tmpfile=3D$(/tmp/${RANDOM})
> +fi
> +
> +if [ ! -w $tmpfile ] ; then
> +       echo "Failed to create tmp file" >&2
> +       exit 0
> +fi
> +
> +trap "rm -rf $tmpfile" EXIT # cleanup if aborted
> +
> +set -e
> +
> +$NFT add table test
> +$NFT add chain test test
> +$NFT monitor -a > $tmpfile &
> +$NFT add rule test test tcp dport 22 counter accept comment test_com=
ment
> +# race :-(
> +sleep 1
> +kill $!
> +grep 'accept comment \"test_comment\" # handle '[[:digit:]]$ $tmpfil=
e >/dev/null
> +rm -rf $tmpfile

This testcase is so bad designed, we should not include it now. Or fix =
it later.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
