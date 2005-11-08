From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Roadmap for IPv6 stateful filtering
Date: Tue, 08 Nov 2005 14:14:11 +0100
Message-ID: <4370A4A3.20702@eurodev.net>
References: <436FBCDF.4060900@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gregor Maier <gregor@net.in.tum.de>
In-Reply-To: <436FBCDF.4060900@net.in.tum.de>
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

Gregor Maier wrote:
> I just wanted to ask if there is any roadmap or a plan when (if at all)
> stateful filtering (and maybe connection tracking) for IPv6 will be
> available in netfilter.
> I found a page that claimed that stateful IPv6 filtering will be
> available in the 2.6.15 kernel release (unfortunaly I misplaced the link
> to the page somewhere :-(  ). Is this info correct? Or is there another
> kernel version targeted?

nf_conntrack got pushed forward to 2.6.15, so you'll have that feature
in the next release candidate.

-- 
Pablo
