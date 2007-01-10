From: "Alexander Sirotkin" <demiourgos@gmail.com>
Subject: netfilter performance on low-end embedded systems
Date: Wed, 10 Jan 2007 10:17:40 +0200
Message-ID: <c4357ccd0701100017p2a28d8eftb7e5387591e5bc9a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello.

I'm trying to evaluate the feasibility of using netfilter on low-end
embedded processors, such as MIPS 4K or 24K. Basicly what I'm trying
to understand is whether we can do 100Mbps with netfilter enabled
(firewall and NAT) on such a CPU or should we check hardware
acceleration solution.

If anybody did any similar benchmarks and can share results (does not
have to be on MIPS) or just has any opinion on the subject - I'd be
very grateful.

Thanks a lot.
