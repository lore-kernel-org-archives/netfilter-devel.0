From: Patrick McHardy <kaber@trash.net>
Subject: Re: Chain Sorting
Date: Thu, 20 Jul 2006 18:40:57 +0200
Message-ID: <44BFB219.9090503@trash.net>
References: <FFEPKIHJDEDDAAFOFDGFOELOCBAA.PCDiem@FoxValley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Paul C. Diem" <PCDiem@FoxValley.net>
In-Reply-To: <FFEPKIHJDEDDAAFOFDGFOELOCBAA.PCDiem@FoxValley.net>
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

Paul C. Diem wrote:
> Again, my apologies for not being familiar with maintaining my mods with cvs
> and the proper way to submit patches. Here's a diff of the changes I've made
> to libiptc.c including the modification to load/use the chain entry offset
> for use by the parse and the modification to insert new chains in the proper
> order and not sort chains on init:

I'm not too familiar with that code, so I'm having a hard time judging
if this will break anything. Are there any known issues? If you could
run nfsim against this patch that would help put my mind at ease :)
