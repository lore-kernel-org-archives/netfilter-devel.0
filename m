From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: How do I use ip_conntrack_destroyed?
Date: Thu, 04 Dec 2003 08:58:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCEE93C.5040104@balabit.hu>
References: <Pine.LNX.4.44.0312032243000.11739-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Emmanuel Guiton <emmanuel@netlab.hut.fi>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0312032243000.11739-100000@filer.marasystems.com>
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

Henrik Nordstrom wrote:
>>/* Call me when a conntrack is destroyed. */
>>extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
> 
> If you want to do this I think you should first extend
> ip_conntrack_destroyed into a list of handlers with a suitable
> registration functions to allow more than one module to register a 
> "ip_conntrack_destroyed" function.

   As I've mentioned, this is already done in the nfnetlink-ctnetlink patch.

-- 
   Regards,
     Krisztian KOVACS
