From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] Syntax error in iptables.xslt
Date: Fri, 03 Aug 2007 12:13:41 +0100
Message-ID: <46B30DE5.2030902@ufomechanic.net>
References: <20070802154242.GB1987@tilt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Dan Nicholson <dbn.lists@gmail.com>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070802154242.GB1987@tilt>
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

* Dan Nicholson wrote, On 02/08/07 16:42:
> Patch below converts to a valid name and the one expected in the rest of
> the stylesheet when using <xsl:with-param name="node"/>.
> 
> --
> Dan
> 
> Index: iptables.xslt
> ===================================================================
> --- iptables.xslt	(revision 6982)
> +++ iptables.xslt	(working copy)
> @@ -116,7 +116,7 @@
>    </xsl:template>
>    
>    <xsl:template name="counters">
> -    <xsl:param name="$node"/>
> +    <xsl:param name="node"/>
>      <xsl:text>[</xsl:text>
>      <xsl:if test="string-length($node/@packet-count)"><xsl:value-of select="$node/@packet-count"/></xsl:if>
>      <xsl:if test="string-length($node/@packet-count)=0">0</xsl:if>
> 
> 

Thanks for spotting that. It would have had the effect of not restoring
counters.

Patrick, please accept this patch.

Signed-off by: Sam Liddicott <azez@ufomechanic.net>

Sam
