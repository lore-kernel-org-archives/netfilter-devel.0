From: Dan Nicholson <dbn.lists@gmail.com>
Subject: [PATCH] Syntax error in iptables.xslt
Date: Thu, 2 Aug 2007 08:05:33 -0700
Message-ID: <20070802150533.GA1987@tilt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Using the iptables.xslt stylesheet as shipped in iptables-1.3.8 is causing
syntax errors when run through xsltproc.

$ echo | xsltproc iptables.xslt -
compilation error: file iptables.xslt line 118 element param
The value '$node' of the attribute 'name' is not a valid QName.
$ xsltproc --version
Using libxml 20627, libxslt 10120 and libexslt 813
xsltproc was compiled against libxml 20627, libxslt 10120 and libexslt 813
libxslt 10120 was compiled against libxml 20627
libexslt 813 was compiled against libxml 20627

The problem is that in <xsl:param name="$node"/>, "$node" is not a valid
QName.

http://www.w3.org/TR/xslt#variables

Patch below converts to a valid name and the one expected in the rest of
the stylesheet when using <xsl:with-param name="node"/>.

--
Dan

Index: iptables.xslt
===================================================================
--- iptables.xslt	(revision 6982)
+++ iptables.xslt	(working copy)
@@ -116,7 +116,7 @@
   </xsl:template>
   
   <xsl:template name="counters">
-    <xsl:param name="$node"/>
+    <xsl:param name="node"/>
     <xsl:text>[</xsl:text>
     <xsl:if test="string-length($node/@packet-count)"><xsl:value-of select="$node/@packet-count"/></xsl:if>
     <xsl:if test="string-length($node/@packet-count)=0">0</xsl:if>
