From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC][PATCH] NAT reservations
Date: Thu, 11 Dec 2003 14:27:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD870CA.9000803@balabit.hu>
References: <3FCF5F23.5060800@balabit.hu> <20031211131437.GD22826@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031211131437.GD22826@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

Harald Welte wrote:
> don't change existing definitions for bits in bitmasks.  this annoys
> developers who know them out of their head, didn't notice your change
> and then try to debug something.

   OK, I'll revert those changes.

> also, please try to not export that many new symbols.  range reservation
> and range removal should be enough, the __ symbols aren't even used
> outside the code, are they?

   Somehow I managed to send the patch which contained some extra exported 
functions used by TPROXY. I'll remove them next time.

-- 
   Regards,
     Krisztian KOVACS
