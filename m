From: Eric Leblond <eric@inl.fr>
Subject: Re: ip_queue_vwmark for pom-ng
Date: Sun, 13 Jun 2004 23:00:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087160421.3320.5.camel@coati>
References: <1086903111.4794.4.camel@coati>  <1087157463.11287.20.camel@ws>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <1087157463.11287.20.camel@ws>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2004-06-13 at 22:11, Patrick McHardy wrote:
> On Thu, 2004-06-10 at 23:31, Eric Leblond wrote:
> Applied, thanks Eric. Am I right that this patch doesn't break userspace
> compatiblity ?

I add to change the definition of a structure related to libipq. So it
can break compatibility of application using the size of this structure.

But It should not impact libipq applications.

Regards
-- 
Eric Leblond <eric@inl.fr>
INL
