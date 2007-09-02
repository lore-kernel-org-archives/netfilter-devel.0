From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_conntrack: Fix getters for big-endian
Date: Sun, 02 Sep 2007 10:50:26 +0200
Message-ID: <46DA7952.3090600@netfilter.org>
References: <46C1573C.7000005@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46C1573C.7000005@snapgear.com>
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
> The getters have to point to the right sized types, otherwise
> they don't work on big-endian.

Applied, thanks Philip. Sorry for the delay, I just arrived from Argentina.

-- 
"Será preciso viajar por los ojos de los idiotas" -- Poeta en Nueva York
-- Federico García Lorca.
