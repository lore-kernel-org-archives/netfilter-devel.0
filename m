From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: fixed multiple bugs in ipv6 version of ULOG
Date: Tue, 15 Mar 2005 20:16:42 +0100
Message-ID: <4237349A.5000109@trash.net>
References: <42357416.3000008@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <42357416.3000008@outerspace.dyndns.org>
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

Jonas Berlin wrote:
> Fixes in 2.4 version:
> ~  - wrong dependency in Config.in
> ~  - patch was based on some patched 2.4 version, didn't work with vanilla
> kernel
> 
> Fixes in 2.6 version:
> ~  - registered itself with wrong protocol family to nf_log
> 
> Cleanups in both versions:
> ~  - improved help
> ~  - dropped unnecessary includes
> ~  - updated author

Applied, thanks Jonas.

Regards
Patrick
