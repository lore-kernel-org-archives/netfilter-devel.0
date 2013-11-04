From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH iptables] extensions: libxt_cluster: add note on arptables-jf
Date: Mon, 4 Nov 2013 12:39:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1311041234290.13395@ask.diku.dk>
References: <1383562439-12113-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:38159 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab3KDLjo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:39:44 -0500
In-Reply-To: <1383562439-12113-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mon, 4 Nov 2013, Pablo Neira Ayuso wrote:

> Gao feng reported problems while getting the cluster match working with
> arptables. This patch adds a note in the manpage to warn about the arptables-jf
> syntax, which is different from mainstream arptables.
>
> Reported-by: Gao feng <gaofeng@cn.fujitsu.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> extensions/libxt_cluster.man |    5 +++++
> 1 file changed, 5 insertions(+)
>
> diff --git a/extensions/libxt_cluster.man b/extensions/libxt_cluster.man
> index 62ad71c..94b4b20 100644
> --- a/extensions/libxt_cluster.man
> +++ b/extensions/libxt_cluster.man
> @@ -55,6 +55,11 @@ arptables \-A INPUT \-i eth2 \-\-h\-length 6
> \-\-destination\-mac 01:00:5e:00:01:02
> \-j mangle \-\-mangle\-mac\-d 00:zz:yy:xx:5a:27
> .PP
> +\fBNOTE\fP: the arptables commands above use mainstream syntax. If you
> +are using arptables-jf included in some RedHat, CentOS and Fedora
> +versions, you will hit syntax errors. Therefore, you'll have to adapt
> +these to the arptables-jf syntax to get them working.


While on the subject of arptables_jf.  Red Hat will be replacing 
arptables_jf with the mainstream arptables in RHEL7 and Fedora 21.

-- 
Best regards,
   Jesper Dangaard Brouer
   MSc.CS, Sr. Network Kernel Developer at Red Hat
   Author of http://www.iptv-analyzer.org
   LinkedIn: http://www.linkedin.com/in/brouer
