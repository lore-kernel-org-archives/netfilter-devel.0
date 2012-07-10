From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 2/3] ipset: change 'iface' part in hash:net,iface
 set
Date: Tue, 10 Jul 2012 17:35:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207101733020.24998@blackhole.kfki.hu>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-1-git-send-email-mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:41054 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab2GJPf3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:35:29 -0400
In-Reply-To: <1341872622-5015-1-git-send-email-mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 9 Jul 2012, Mr Dash Four wrote:

> Userspace changes to ipset, allowing 'in' and 'out' values to be
> specified for the 'iface' part of hash:net,iface type sets only.
> 
> Man page updated accordingly. This patch also makes some minor
> corrections to the contents of that man page.
> 
> Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
> ---
>  include/libipset/linux_ip_set.h |    5 +++++
>  src/ipset.8                     |   11 +++--------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
> index 008da06..8f2bd95 100644
> --- a/include/libipset/linux_ip_set.h
> +++ b/include/libipset/linux_ip_set.h
> @@ -190,6 +190,10 @@ enum ip_set_dim {
>  	 * If changed, new revision of iptables match/target is required.
>  	 */
>  	IPSET_DIM_MAX = 6,
> +	/* 
> +	 * Indicates whether the new 'iface' format (in/out) has been used.
> +	 */
> +	IPSET_DIM_IFACE = 7, 
>  };

It's not a dimension, please give it some other name,
like IPSET_IFACE_INOUT_FLAG.
  
>  /* Option flags for kernel operations */
> @@ -198,6 +202,7 @@ enum ip_set_kopt {
>  	IPSET_DIM_ONE_SRC = (1 << IPSET_DIM_ONE),
>  	IPSET_DIM_TWO_SRC = (1 << IPSET_DIM_TWO),
>  	IPSET_DIM_THREE_SRC = (1 << IPSET_DIM_THREE),
> +	IPSET_DIM_IFACE_INOUT = (1 << IPSET_DIM_IFACE),
>  };

Here too, rename it.
  
>  #endif /* __IP_SET_H */
> diff --git a/src/ipset.8 b/src/ipset.8
> index bbad680..8d5f69c 100644
> --- a/src/ipset.8
> +++ b/src/ipset.8
> @@ -798,12 +798,7 @@ addresses  to the set by the \fBSET\fR netfilter target, it  will  be
>  added/deleted by the most specific prefix which can be found in  the
>  set, or by the host prefix value if the set is empty.
>  .PP 
> -The second direction parameter of the \fBset\fR match and
> -\fBSET\fR target modules corresponds to the incoming/outgoing interface:
> -\fBsrc\fR to the incoming one (similar to the \fB\-i\fR flag of iptables), while
> -\fBdst\fR to the outgoing one (similar to the \fB\-o\fR flag of iptables). When
> -the interface is flagged with \fBphysdev:\fR, the interface is interpreted
> -as the incoming/outgoing bridge port.
> +The second direction parameter of the \fBset\fR match and \fBSET\fR target modules corresponds to the incoming/outgoing interface: \fBin\fR for the incoming, \fBout\fR for the outgoing interface, consistent with their appropriate flags in netfilter/iptables. The format used in prior versions of ipset is also supported: \fBsrc\fR indicating the incoming and \fBdst\fR the outgoing interface respectively. If the interface value is preceded with \fBphysdev:\fR, the interface is then interpreted as bridge port.

Break the long lines, in all of your manpage modifications.

>  .PP 
>  The lookup time grows linearly with the number of the different prefix
>  values added to the set.
> @@ -840,7 +835,7 @@ Optional \fBcreate\fR options:
>  \fBsize\fR \fIvalue\fR
>  The size of the list, the default is 8.
>  .PP 
> -By the \fBipset\fR commad you  can add, delete and test set names in a
> +With the \fBipset\fR command you  can add, delete and test set names in a
>  \fBlist:set\fR type of set.
>  .PP 
>  By the \fBset\fR match or \fBSET\fR target of netfilter
> @@ -861,7 +856,7 @@ and add src to the first single or src,dst to the first double data storage set
>  in \fIb\fR to which the entry can be added. You can imagine a \fBlist:set\fR
>  type of set as an ordered union of the set elements. 
>  .PP 
> -Please note: by the \fBipset\fR commad you can add, delete and \fBtest\fR
> +Please note: with the \fBipset\fR command you can add, delete and \fBtest\fR
>  the setnames in a \fBlist:set\fR type of set, and \fBnot\fR the presence of
>  a set's member (such as an IP address).
>  .SH "GENERAL RESTRICTIONS"
> -- 
> 1.7.10.4

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
