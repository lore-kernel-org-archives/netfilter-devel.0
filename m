From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_queue_vwmark for pom-ng
Date: Sun, 13 Jun 2004 22:11:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087157463.11287.20.camel@ws>
References: <1086903111.4794.4.camel@coati>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1086903111.4794.4.camel@coati>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-06-10 at 23:31, Eric Leblond wrote:
> Hi everyone,
> 
> I finally found the time to port my ip_queue_vwmark patch to pom-ng. I
> join a patch to this mail.
> Little reminder :
> ip_queue_vwmark adds a function to libipq (ipq_set_vwmark for
> ipq_set_verdict_with_mark) that permits to put a mark on the packet when
> reinjecting it into the kernel.

Applied, thanks Eric. Am I right that this patch doesn't break userspace
compatiblity ?

Regards
Patrick

> 
> It is used by the Nufw project (http://www.nufw.org) to mark packet with
> user identity thus enabling a per-user QOS.
> 
> BR,
