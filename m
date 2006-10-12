From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ulogd fix for kernel 64bits/userspace 32bits system
Date: Thu, 12 Oct 2006 14:10:22 +0200
Message-ID: <452E30AE.9030805@trash.net>
References: <1160654607.9238.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1160654607.9238.5.camel@localhost.localdomain>
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
> Hello,
> 
> This patch fixes ulogd for system with kernel space 64 bits and
> userspace 32 bits.
> 
> Auto detection of system type is taken from iptables.

We're actually going to remove that and I am very reluctant to
add this.

- its a compile-time solution and therefor unusable for distributors

- it might get accidentally enabled by a distributor should he
  be crazy enough to compile packages in a mixed environment

- it will break if we ever get compat support in the kernel
  (which is admittedly quite unlikely)

So I really need some convincing :)
