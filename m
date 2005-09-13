From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipq problem on PPC 64 bits arch
Date: Tue, 13 Sep 2005 16:37:16 +0200
Message-ID: <4326E41C.8010108@trash.net>
References: <1126620638.20081.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1126620638.20081.40.camel@localhost.localdomain>
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

Eric Leblond wrote:
> Hi,
> 
> We were not able to have libipq working on a PPC 64 (openpower from IBM)
> running RHEL4 :
> 	linux HOST 2.6.9-5.EL #1 SMP DATE ppc64 ppc64 ppc64
> iptables has been compiled from latest source (1.3.3).
> 
> Application (nufw) is able to get the message (an IPV4 queued packet)
> but when it try get the version contained in the payload if failed :
> 	((struct iphdr*) msg->payload)->version
> returns 0.
> 
> We try to set
> 	CFLAGS+=-DIPT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32
> which was not set by Makefile. But there were no result.

Known problem, the struct is layouted in a way that makes it fail in
mixed 32/64 bit environments. nfnetlink_queue doesn't have this problem.
