From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink unique id size?
Date: Sun, 20 Feb 2005 05:47:26 +0100
Message-ID: <4218165E.1060300@trash.net>
References: <4214D75D.5070005@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <4214D75D.5070005@ingate.com>
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

Marcus Sundberg wrote:
> Hi,
> 
> isn't an unsigned int a bit (or rather about 32 bits) small for
> keeping the id field of the ip_conntrack struct? It's bound to wrap
> around, and with things like long-lived ssh sessions it's even
> possible for two connections to be assigned the same id after a
> wrap-around.
> 
> Am I missing something obvious when I think ctnetlink_dump_table()
> will break down when the wrap-around occurs?
> 
> Using an uint64_t would on the other hand guarantee that each
> connection really get a unique id.

We had a long discussion about this an the result was that it has to
be 64 bit. Search the archives if you are interested, the subject
is "ctnetlink questions". I'm surprised too that it now is 32 bit.
Maybe Harald knows the reason.

Regards
Patrick
