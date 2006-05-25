From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH 4/4] drop ftp bounce attacks
Date: Thu, 25 May 2006 12:55:59 +1000
Message-ID: <44751CBF.8040906@snapgear.com>
References: <20060524040441.111049000@snapgear.com>	<20060524040951.217594000@snapgear.com>
	<44748A4D.1070905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44748A4D.1070905@trash.net>
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

On 05/25/2006 02:31 AM, Patrick McHardy wrote:
> The best solution would be to mark the packet INVALID and let the
> user decide using the state match.

Marking the packet INVALID is definitely better than always dropping
it.

The reason I said fixing the ftp server is the best solution is
that I'm not sure whether the ftp conntrack module can match on
all possible port commands, taking into account fragmentation,
reordering, and retransmits.

This is different from attacks against the firewall, in which the
attack works only if the firewall recognizes the port command and
creates an expectation.
