From: Kevin White <kwhite@secureinteriors.com>
Subject: Re: "Proper" way to transparent proxy?
Date: Wed, 09 Oct 2002 21:15:21 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA4D4A9.8030607@secureinteriors.com>
References: <3DA48D59.7060109@secureinteriors.com> <20021009204018.GA15171@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> For the benefit of the eternal (hope hope hope) google, I am using
> the exact code below, compiled like this:
> 
> 	gcc -c preload_getsockname.c
> 	ld -o preload_getsockname.so -shared preload_getsockname.o -ldl
> 
> as an LD_PRELOAD file for a very ancient squid binary. In production
> on some handful on boxes. You probably only need the 'getsockopt' line.

Great...thanks tons.  I'll put it into action...

Thanks again!

Kevin
