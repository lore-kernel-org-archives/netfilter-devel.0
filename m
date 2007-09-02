From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_conntrack: Packet/byte counters are 64 bit
Date: Sun, 02 Sep 2007 10:55:13 +0200
Message-ID: <46DA7A71.3050909@netfilter.org>
References: <46C1577A.1010308@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46C1577A.1010308@snapgear.com>
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

Philip Craig wrote:
> The counters in struct nf_conntrack are 64 bit, so the getter/setter
> have to access them as such.

Still my kernel has 32 bit counters although I know that there was a
patch on the table to recover 64 bits counters. I'm still getting in
sync with the development again, did that patch finally hit mainline?

-- 
"Será preciso viajar por los ojos de los idiotas" -- Poeta en Nueva York
-- Federico García Lorca.
