From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] segmentation fault in free
Date: Thu, 26 Aug 2004 18:14:19 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <412E0C5B.7090909@trash.net>
References: <412DE778.2030202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Woerner <twoerner@redhat.com>
In-Reply-To: <412DE778.2030202@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Thomas Woerner wrote:

>
> Hello,
>
>
> I have found a bad bug in iptables. saddrs and daddrs are allocated 
> with calloc in host_to_addr if a hostname resolves to more than one ip 
> address, but each array element if getting freed in do_command. The 
> first free will free the whole array and the others are returning that 
> this is not a pointer or are segfaulting.
>
> Fix for this is attached.


Thanks, already fixed in CVS.

Regards
Patrick
