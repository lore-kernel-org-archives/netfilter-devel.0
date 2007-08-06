From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Syntax error in iptables.xslt
Date: Mon, 06 Aug 2007 10:50:45 +0200
Message-ID: <46B6E0E5.3020808@netfilter.org>
References: <20070802154242.GB1987@tilt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
To: Dan Nicholson <dbn.lists@gmail.com>
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

Dan Nicholson wrote:
> The problem is that in <xsl:param name="$node"/>, "$node" is not a valid
> QName.
> 
> http://www.w3.org/TR/xslt#variables
> 
> Patch below converts to a valid name and the one expected in the rest of
> the stylesheet when using <xsl:with-param name="node"/>.

Applied, thanks Dan.

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.
