From: Martin Koniczek <martin@koniczek.de>
Subject: some patch suggestions for the homepage
Date: Tue, 05 Apr 2005 02:17:49 +0000
Message-ID: <4251F54D.5090205@koniczek.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000205040403080108050604"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000205040403080108050604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

just some fixes for typos, links, etc.

attention: i also changed scripts/pom2docbook.pl to:

- take path to iptables and kernel src from environment
(will still use /usr/src/{linux, iptables} as defaults)

- added the actual name of a patch as "heading" for the
html overview, because not every patch has a title

i will try to provide a "mini-howto" within the next
days from my somewhat lengthy efforts to build the
homepage from the svn sources. for now, i need some
sleep...

--------------000205040403080108050604
Content-Type: text/plain;
 name="netfilter-homepage-versus-3822.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="netfilter-homepage-versus-3822.patch"

Index: xml/patch-o-matic/index.xml
===================================================================
--- xml/patch-o-matic/index.xml	(revision 3824)
+++ xml/patch-o-matic/index.xml	(working copy)
@@ -16,6 +16,16 @@
 </para>
 <section id="pom-whatis">
 <title>What is patch-o-matic?</title>
+<para>
+	is a system to apply netfilter-related patches
+	to the latest kernel and/or iptables sources
+
+</para>
+<para>
+	Learn more in the
+	<olink targetdoc="page-documentation" targetptr="netfilter-extensions">
+	Netfilter Extensions Howto</olink>
+</para>
 </section>
 
 </webpage>
Index: xml/downloads.xml
===================================================================
--- xml/downloads.xml	(revision 3824)
+++ xml/downloads.xml	(working copy)
@@ -657,7 +657,7 @@
 <section id="svn">
 <title> Subversion Repository</title>
 <para>
-You can access the <a href="http://subversion.tigris.org/">Subversion</a>
+You can access the <ulink url="http://subversion.tigris.org/">Subversion</ulink>
 server in two ways. For casual browsing, you can use the <ulink
 url="http://svn.netfilter.org/">ViewCVS web interface</ulink>.
 To grab the latest sources, you can do the following: </para>
@@ -667,7 +667,7 @@
 svn co https://svn.netfilter.org/netfilter/trunk/iptables
 </screen>
 </listitem>
-<listitem>Check out the other available modules (cttest, documentation, homepage, netfilter-ha, pkttables) by using
+<listitem>Check out the other available modules (cttest, documentation, homepage, netfilter-ha, pkttables, patch-o-matic-ng, ...) by using
 <screen>
 svn co https://svn.netfilter.org/netfilter/trunk/<literal>module</literal>
 </screen>
@@ -701,8 +701,10 @@
 <title>rsync Access</title>
 <para>
 The full contents of the our WWW and FTP server can be accessed via <ulink
-url="http://samba.anu.edu.au/rsync/">rsync</ulink>.  You can use this to build a 1:1 mirror of
-the netfilter site
+url="http://samba.anu.edu.au/rsync/">rsync</ulink>.
+You can use this to
+<olink targetdoc="page-documentation" targetptr="netfilter-mirror">
+build a 1:1 mirror</olink> of the netfilter site
 <itemizedlist mark="bullet">
 <listitem>To access the FTP tree, use
 <screen>
Index: xml/mailinglists.xml
===================================================================
--- xml/mailinglists.xml	(revision 3824)
+++ xml/mailinglists.xml	(working copy)
@@ -11,11 +11,13 @@
 	<titleabbrev>Mailing Lists</titleabbrev>
 </head>
 
+<section id="top">
 <para>
 Please remember, netfilter/iptables is a volunteer-based community effort,
 available for free.   Our mailinglists are a forum where fellow users can meet
 and share their experience.
 </para>
+</section>
 
 <para>
 If you are a corporate user (or vendor) interested in professional support,
Index: xml/events.xml
===================================================================
--- xml/events.xml	(revision 3824)
+++ xml/events.xml	(working copy)
@@ -22,24 +22,29 @@
 </para>
 
 <section>
+<title>currently no upcoming events listed</title>
+<para>
+</para>
+</section>
+
+<section id="events-past">
+<title>Past events</title>
+
+<section>
 <title>2004-Sep-09: ct_sync Presentation at Linux Kongress 2004</title>
 <para>
-On 2004-Sep-09 there will be a presentation by Harald about the ct_sync state replication mechanism. More interesting talks are found in the <a href="http://www.linux-kongress.org/2004/program.html">LK2004 Programme</a>.
+On 2004-Sep-09 there was a presentation by Harald about the ct_sync state replication mechanism. More interesting talks are found in the <ulink url="http://www.linux-kongress.org/2004/program.html">LK2004 Programme</ulink>.
 </para>
 </section>
 
 <section>
 <title>2004-Sep-06: 3rd Global Netfilter Developer Workshop</title>
 <para>
-On 2004-Sep-06 and 2004-Sep-07 will be the <olink targetdoc="workshop-2004">3rd Netfilter Developer Workshop</olink>, sponsored by <a href="http://www.astaro.com/">Astaro</a>.  More information can also be found at <a href="http://gnumonks.org/users/laforge/zwiki/NetfilterWorkshop2004">Harald's Workshop Wiki</a>.
+On 2004-Sep-06 and 2004-Sep-07 was the <olink targetdoc="page-documentation" targetptr="documentation-events">3rd Netfilter Developer Workshop</olink>, sponsored by <ulink url="http://www.astaro.com/">Astaro</ulink>.  More information can also be found at <ulink url="http://gnumonks.org/users/laforge/zwiki/NetfilterWorkshop2004">Harald's Workshop Wiki</ulink>.
 </para>
 </section>
 
 </section>
-
-<section id="events-past">
-<title>Past events</title>
-
 <section>
 <title>2004-Jul-24: netfilter/iptables development BOF at OLS 2004</title>
 <para>
@@ -51,7 +56,7 @@
 <title>2004-Jul-23: ct_sync presentation at OLS 2004</title>
 <para>
 At the <ulink url="http://www.linuxtag.de/">Ottawa Linux Symposium
-2004</ulink>, Harald has given a presentation on ct_sync.  The presentation and a respective papaer can be found <a href="http://svn.gnumonks.org/trunk/presentation/netfilter-failover-ols2004/">here</a>.
+	2004</ulink>, Harald has given a presentation on ct_sync.  The presentation and a respective papaer can be found <ulink url="http://svn.gnumonks.org/trunk/presentation/netfilter-failover-ols2004/">here</ulink>.
 </para>
 </section>
 
@@ -201,6 +206,12 @@
 </para>
 </section>
 
+<section id="workshop-2001-enschede">
+<title>2001-Dec-??: first netfilter/iptables developer workshop</title>
+<para>
+In Enschede, the first netfilter developer workshop took place. More information in the <ulink url="http://lists.netfilter.org/pipermail/netfilter-devel/2001-December/006201.html">Mailinglist archive</ulink>.
+</para>
+</section>
 
 </section>
 
Index: xml/mirrors.xml.template
===================================================================
--- xml/mirrors.xml.template	(revision 3824)
+++ xml/mirrors.xml.template	(working copy)
@@ -24,7 +24,8 @@
 The netfilter/iptalbes project thanks every organization that supports us by
 operating such a mirror.  If you operate a server in a country that is not yet
 listed in the list below, and you want to operate a netfilter.org mirror, feel
-free to read the <olink targetdoc="doc-howto-mirror">instructions on how to become a mirror</olink>.
+free to read the <olink targetdoc="page-documentation"
+targetptr="netfilter-mirror">instructions on how to become a mirror</olink>.
 </para>
 
 [_MIRRORTABLE_]
Index: xml/security/index.xml
===================================================================
--- xml/security/index.xml	(revision 3824)
+++ xml/security/index.xml	(working copy)
@@ -23,7 +23,7 @@
 <section>
 <title>Jun-30-2004: DoS vulnerability in 2.6.x tcp option parser</title>
 <itemizedlist mark="bullet">
-<listitem><olink targetptr="advisory-2004-06-30-2.6-tcpoption" targetdoc="2004-06-30-2.6-tcpoption">Origina Announcement</olink></listitem>
+<listitem><olink targetptr="advisory-2004-06-30-2.6-tcpoption" targetdoc="2004-06-30-2.6-tcpoption">Original Announcement</olink></listitem>
 </itemizedlist>
 <para>This bug is only present in 2.6.x kernels.  2.4.x kernels are definitely not affected.</para>
 </section>
Index: xml/about-website.xml
===================================================================
--- xml/about-website.xml	(revision 3824)
+++ xml/about-website.xml	(working copy)
@@ -40,7 +40,7 @@
 </para>
 
 <para>This website is produced from XML using the DocBook Website DTD
-v2.4 and the DocBook XSLT stylesheets.</para>
+v2.4.1/2.5.0 and the DocBook XSLT stylesheets.</para>
 
 </section>
 
Index: xml/news.xml
===================================================================
--- xml/news.xml	(revision 3824)
+++ xml/news.xml	(working copy)
@@ -221,7 +221,7 @@
 <section>
 <title>Proceedings of the second netfilter developer workshop</title>
 <para>
-It's been quite some time since the <olink targetdoc="events" localhofo="workshop-2003-budapest">second netfilter developer workshop</olink>.
+It's been quite some time since the <olink targetdoc="events" targetptr="workshop-2003-budapest">second netfilter developer workshop</olink>.
 Jozsef has now set up a <ulink url="http://people.netfilter.org/~kadlec/workshop-2003-budapest/">small page</ulink> containing some of the presentations and a summarry written by Harald.
 </para>
 </section>
@@ -375,8 +375,8 @@
 	<section>
 	<title>New iptables-1.2.7a release</title>
 	<para>The netfilter core team has released <olink
-	targetdoc="downloads" targetptr="iptables-1.2.7a">iptables-1.2.7a</olink> and <olink
-	targetdoc="downloads" targetptr="pom-20020825">patch-o-matic-20020825</olink>. Both
+	targetdoc="downloads" targetptr="iptables-1.2.7a">iptables-1.2.7a</olink> and <ulink
+	url="/files/patch-o-matic-20020825.tar.bz2">patch-o-matic-20020825</ulink>. Both
 	contain important bugfixes for new bugs introduced by the
 	iptables-1.2.7 and patch-o-matic-20020806 release.</para>
 	</section>
@@ -389,8 +389,8 @@
 	<section>
 	<title>New iptables-1.2.7 release</title>
 	<para> The netfilter core team has released <olink
-	targetdoc="downloads" targetptr="iptables-1.2.7">iptables-1.2.7</olink> and <olink
-	targetdoc="downloads" targetptr="pom-20020806">patch-o-matic-20020806</olink>.</para>
+	targetdoc="downloads" targetptr="iptables-1.2.7">iptables-1.2.7</olink> and <ulink
+	url="/files/patch-o-matic-20020806.tar.bz2">patch-o-matic-20020806</ulink>.</para>
 	</section>
 </blockquote>
 </section>
@@ -430,7 +430,9 @@
 <title>2002-May-08</title>
 <blockquote>
 	<section>
-	<title><olink targetdoc="fixme">ICMP DNAT Security Announcement</olink></title>
+	<title><ulink
+	url="https://lists.netfilter.org/pipermail/netfilter-announce/2002/000017.html">
+	ICMP DNAT Security Announcement</ulink></title>
 	<para>We have issued a security announcement about a bug in the ICMP
 	NAT code, resulting in a possible information leak</para>
 	</section>
Index: xml/support.xml
===================================================================
--- xml/support.xml	(revision 3824)
+++ xml/support.xml	(working copy)
@@ -21,7 +21,7 @@
 <para>
 The netfilter/iptables project is a volunteer-based community effort.  We can
 only exist because of the contributions of our users.  If nobody would write
-any code, answer questions on the mailinglists, wride documentation, ... the
+any code, answer questions on the mailinglists, write documentation, ... the
 project wouldn't exist.
 </para>
 
@@ -34,7 +34,7 @@
 <title>Helping other users on the mailinglists</title>
 <para>
 By answering questions asked by fellow users on the <olink
-targetdoc="mailinglists">mailinglists</olink>, you can enable the
+targetdoc="mailinglists" targetptr="top">mailinglists</olink>, you can enable the
 netfilter/iptables developers to spend more time with development, rather than
 answering to questions.  This, in turn, will make new features available
 faster.
@@ -48,7 +48,7 @@
 skip this section.  There are many other options on how you could help us
 </para>
 <para>
-If you write any extension for netfilter/iptables, plesae make it available
+If you write any extension for netfilter/iptables, please make it available
 under the GNU GPLv2 and contribute it by sending a patch.
 </para>
 <para>
Index: scripts/pom2docbook.pl
===================================================================
--- scripts/pom2docbook.pl	(revision 3824)
+++ scripts/pom2docbook.pl	(working copy)
@@ -5,7 +5,7 @@
 #
 # This code is subject to GNU GPLv2
 #
-# $Id: pom2docbook.pl,v 1.3 2004/01/09 01:04:34 laforge Exp $
+# $Id$
 #
 
 use strict;
@@ -54,9 +54,14 @@
 	my $title = $$plet{info}{title};
 	my $helptext = $$plet{info}{help};
 	$writer->startTag('section', 'id' => "pom-$repository-$name");
-	$writer->dataElement('title', $title);
+	$writer->dataElement('title', $name);
 	$writer->startTag('simplelist');
 
+	if (defined($title)) {
+		$writer->dataElement('member', sprintf("Title: %s",
+							$title));
+	}
+
 	my ($mname, $email) = $$plet{info}{author} =~ /(.*)<([^>]+)>/;
 	if (defined($email)) {
 		$writer->startTag('member');
@@ -106,10 +111,16 @@
 }
 
 my %paths;
+my $nfsrcroot;
+if ($ENV{'KERNEL_DIR'})   { $paths{linux} = $ENV{'KERNEL_DIR'}; }
+		     else { $paths{linux} = "/usr/src/linux";   }
+if ($ENV{'IPTABLES_DIR'}) { $paths{iptables} = $ENV{'IPTABLES_DIR'}; }
+		     else { $paths{iptables} = "/usr/src/iptables";  }
+#$paths{iptables} = "$nfsrcroot/iptables";
+#$nfsrcroot="/usr/ports/vpn/netfilter";
+#$nfsrcroot="/sofa/vpn/vpn2/netfilter";
 
 $paths{POM} = $opt_pomdir;
-$paths{linux} = "/usr/src/linux";
-$paths{iptables} = "/usr/src/iptables";
 my $session = Netfilter_POM->init(\%paths);
 print("Loading patchlet definitions");
 $session->parse_patchlets;
Index: scripts/Netfilter_HP.pm
===================================================================
--- scripts/Netfilter_HP.pm	(revision 3824)
+++ scripts/Netfilter_HP.pm	(working copy)
@@ -15,7 +15,7 @@
 #
 # This code is subject to GNU GPLv2
 #
-# $Id: Netfilter_HP.pm,v 1.8 2004/03/25 18:42:48 laforge Exp $
+# $Id$
 #
 
 =cut
@@ -128,7 +128,7 @@
 
 	$xml->doctype('webpage', $XML_PUBLICID, $XML_SYSTEMID);
 	$xml->startTag('webpage', 'id' => $id, lang=>'en');
-	$xml->emptyTag('config', 'param'=>'rcsdate', value=>'$Date: 2004/03/25 18:42:48 $');
+	$xml->emptyTag('config', 'param'=>'rcsdate', value=>'$Date$');
 	$xml->startTag('head');
 	$xml->dataElement('title', $title);
 	$xml->dataElement('titleabbrev', $titleabbrev);
@@ -191,7 +191,7 @@
 	}
 	
 	foreach my $ht (keys %howtos) {
-		$writer->startTag('section');
+		$writer->startTag('section', 'id'=>"$ht" );
 		$writer->dataElement('title', $howtos{$ht});
 		dbxml_tableheader($writer, \@headers);
 

--------------000205040403080108050604--
