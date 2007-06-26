From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: nf_conntrack: round up hashsize to next multiple
 of PAGE_SIZE
Date: Tue, 26 Jun 2007 16:00:46 +0200
Message-ID: <46811C0E.4050308@trash.net>
References: <46811BCB.7080502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46811BCB.7080502@trash.net>
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

Patrick McHardy wrote:
> I've added these four patches to my tree to improve
> the conntrack hashing behaviour and use a hash for
> expectations instead of the global list.
>
>

+	return jhash_2words(a, b, rnd) & size;


And now fixed this obvious stupidity :)
