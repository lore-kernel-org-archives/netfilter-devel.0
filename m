From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Wed, 3 Jan 2018 14:53:00 +0100
Message-ID: <20180103135300.5axhczhwpriaoemm@salvia>
References: <20171228072833.9980-1-harshasharmaiitr@gmail.com>
 <20171228105236.hmii7xbk5jtctmpr@salvia>
 <20171230225110.GA10178@dimstar.local.net>
 <20171230231630.qvfkstglqwhrpsff@salvia>
 <20180102224746.GB3309@dimstar.local.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="35ibfqz3mz626pse"
To: Harsha Sharma <harshasharmaiitr@gmail.com>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48508 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbeACNxG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 08:53:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2EF4324927
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jan 2018 14:53:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B88653CCE
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jan 2018 14:53:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180102224746.GB3309@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--35ibfqz3mz626pse
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 03, 2018 at 09:47:46AM +1100, Duncan Roe wrote:
> Hi Pablo,
> 
> On Sun, Dec 31, 2017 at 12:16:30AM +0100, Pablo Neira Ayuso wrote:
> > Hi Harsha,
> >
> > On Sun, Dec 31, 2017 at 09:51:10AM +1100, Duncan Roe wrote:
> > > On Thu, Dec 28, 2017 at 11:52:36AM +0100, Pablo Neira Ayuso wrote:
> > > > Cc'ing Duncan.
> > >
> > > No need - I'm on netfilter-devel ;)
> > > >
> > > > On Thu, Dec 28, 2017 at 12:58:33PM +0530, Harsha Sharma wrote:
> > > > > Do not print timeout and burst in case default values are used.
> > > > > For e.g.
> > > > > iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
> > > > > --hashlimit-above 200/sec --hashlimit-mode srcip,dstport
> > > > > --hashlimit-name http1 -j DROP
> > > > >
> > > > > nft add rule ip filter INPUT tcp dport 80 flow table http1 { tcp dport .
> > > > > ip saddr limit rate over 200/second } counter drop
> > > >
> > > > This is what I was asking for.
> > > >
> > > > Applied, thanks Harsha.
> > > >
> > > > @Duncan: I think you can update the wiki again after this, given that
> > > > now those values should not be printed.
> > >
> > > I tested after applying the patch and now the second example is broken:
> > >
> > > > iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit --hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode srcip,dstport --hashlimit-name http2 --hashlimit-htable-expire 3000 -j DROP
> > > > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport . ip saddr timeout 3s limit rate over 200 kbytes/second burst 1 mbytes burst 6 packets} counter drop
> > >
> > > The traling "burst 6 packets" should not be there.
> >
> It gets worse. Substitute 1000 for 3000 in the above:
> 
> > $ iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit --hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode srcip,dstport --hashlimit-name http2 --hashlimit-htable-expire 1000 -j DROP
> > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport . ip saddr limit rate over 200 kbytes/second burst 1 mbytes burst 6 packets} counter drop

OK, so the problem is the extra "burst 6 packets".

This patch should fix this.

--35ibfqz3mz626pse
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 472d8e7f6cc2..3fa5719127db 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -1350,10 +1350,12 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
 
 	if (cfg->mode & XT_HASHLIMIT_BYTES)
 		print_bytes_rate_xlate(xl, cfg);
-	else
+	else {
 		print_packets_rate_xlate(xl, cfg->avg, revision);
-	if (cfg->burst != 5)
-		xt_xlate_add(xl, " burst %lu packets", cfg->burst);
+		if (cfg->burst != XT_HASHLIMIT_BURST)
+			xt_xlate_add(xl, " burst %lu packets", cfg->burst);
+
+	}
 	xt_xlate_add(xl, "}");
 
 	return ret;

--35ibfqz3mz626pse--
