From: Jeremy Kerr <jeremy@redfishsoftware.com.au>
Subject: Re: [ANNOUNCE] nfsim - netfilter simulation environment
Date: Wed, 7 Jan 2004 20:29:03 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401072029.03638.jeremy@redfishsoftware.com.au>
References: <20040107120354.118.qmail@web60702.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Zeeshan Ali <zeelists@yahoo.com>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20040107120354.118.qmail@web60702.mail.yahoo.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Zeeshan,

> [zak@zeenix nfsim]$ locate docbook.xsl
> /usr/share/apps/ksgmltools2/docbook/xsl/html/docbook.xsl
> /usr/share/sgml/docbook/yelp/docbook/html/docbook.xsl
>
>   is it either of these?

The symlink needs to be to a directory with a xhtml/docbook.xsl file (yours 
are to a 'html', not 'xhtml' subdir). The docbook-style-xsl package provides 
the appropriate stylesheet.



Jeremy
