From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: [RFC] iptables namespaces
Date: Wed, 19 Sep 2007 17:05:47 +0200
Message-ID: <20070919150547.GA2334@suse.de>
References: <20070907180204.GA460@ekonomika.be>
	<20070907184642.GA4728@outback.rfc2324.org>
	<20070907190601.GA18714@ekonomika.be>
	<Pine.LNX.4.64.0709080924090.25942@fbirervta.pbzchgretzou.qr>
	<20070908132810.GA19766@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20070908132810.GA19766@ekonomika.be>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Steven Van Acker wrote:
> [...]
> Moreover, if there is an error in iptables-restore, none of the changes
> are committed to kernelspace. So I no longer need to use fancy checking
> while I'm loading my firewall rules.

Correct me if I'm wrong but IIRC the tables are still committed
individually. Ie you cannot commit filter, nat and mangle in one
run.

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
