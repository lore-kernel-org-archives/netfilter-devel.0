From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6 0/5]: NAT fixes
Date: Sun, 28 Nov 2004 19:42:31 -0800
Message-ID: <20041128194231.0985f426.davem@davemloft.net>
References: <41AA5EFC.1080708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41AA5EFC.1080708@trash.net>
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

On Mon, 29 Nov 2004 00:27:56 +0100
Patrick McHardy <kaber@trash.net> wrote:

> the next 5 patches (against your 2.6.11 tree) fix DNAT on loopback and 
> some issues
> with locally generated ICMP errors for NATed packets.

So this means it's OK to push this into 2.6.11 instead of trying
to slip it into 2.6.10?

It looks like there are not OOPS or crash fixes in here.
If there are, those would be 2.6.10 candidates.

Please advise.
