From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf-failover] Oops in ctnetlink_create_conntrack
Date: Sat, 13 Jan 2007 17:52:27 +0100
Message-ID: <45A90E4B.4000103@trash.net>
References: <200701130319.30347.simonl@parknet.dk>
	<45A90C8F.9030202@netfilter.org> <45A90D36.9060403@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-failover@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45A90D36.9060403@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
> 
>>Does the patch attached fix the problem that you're reporting? It was
>>already committed to the upcoming 2.6.20 [1]
> 
> 
> Damn, I didn't notice that Patrick already did the trick. Thanks ;)
> 
> @Patrick: Would it make sense pushing this to -stable even if ctnetlink
> is still marked as experimental?

Yes, I'll push it to -stable.
