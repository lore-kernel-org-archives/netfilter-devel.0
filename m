From: Jeremy Kerr <jeremy@redfishsoftware.com.au>
Subject: Re: [ANNOUNCE] nfsim - netfilter simulation environment
Date: Wed, 7 Jan 2004 20:02:03 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401072002.03196.jeremy@redfishsoftware.com.au>
References: <20040107115010.96814.qmail@web60702.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040107115010.96814.qmail@web60702.mail.yahoo.com>
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

Hi there,

> xsl:import : unable to load
> doc/link-xhtml/xhtml/docbook.xsl

Looks like you don't have the doc/link-xhtml symlink set up correctly (which 
is required to process the help functions for each file). Depending on which 
distribution you're using, you'll need to manually create the links. On my 
system, they are:

doc/link-dtd -> /usr/share/sgml/docbook/xml-dtd-4.2-1.0-17
doc/link-xhtml -> /usr/share/sgml/docbook/xsl-stylesheets

The link-xhtml symlink is the important one, and it needs the 
xhtml/docbook.xsl file within - which is provided (on Redhat) by the 
docbook-style-xsl package or (on Debian) docbook-xsl

If you find the proper place for the link, let me know and I'll add 
autodetection to the Makefile.


Jeremy
