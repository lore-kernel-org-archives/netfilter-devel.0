From: Zeeshan Ali <zeelists@yahoo.com>
Subject: Re: [ANNOUNCE] nfsim - netfilter simulation environment
Date: Wed, 7 Jan 2004 04:03:54 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040107120354.118.qmail@web60702.mail.yahoo.com>
References: <200401071940.21075.jeremy@redfishsoftware.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200401071940.21075.jeremy@redfishsoftware.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
  I have a fresh RH9 installation. I dont seem to have
the 2nd dir you asked me about. When i tried to find
docbook.xsl, here is what i got:

[zak@zeenix nfsim]$ locate docbook.xsl
/usr/share/apps/ksgmltools2/docbook/xsl/html/docbook.xsl
/usr/share/sgml/docbook/yelp/docbook/html/docbook.xsl

  is it either of these?

--- Jeremy Kerr <jeremy@redfishsoftware.com.au> wrote:
> Hi there,
> 
> > xsl:import : unable to load
> > doc/link-xhtml/xhtml/docbook.xsl
> 
> Looks like you don't have the doc/link-xhtml symlink
> set up correctly (which 
> is required to process the help functions for each
> file). Depending on which 
> distribution you're using, you'll need to manually
> create the links. On my 
> system, they are:
> 
> doc/link-dtd ->
> /usr/share/sgml/docbook/xml-dtd-4.2-1.0-17
> doc/link-xhtml ->
> /usr/share/sgml/docbook/xsl-stylesheets
> 
> The link-xhtml symlink is the important one, and it
> needs the 
> xhtml/docbook.xsl file within - which is provided
> (on Redhat) by the 
> docbook-style-xsl package.
> 
> If you find the proper place for the link, let me
> know and I'll add 
> autodetection to the Makefile.
> 
> 
> Jeremy


__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
