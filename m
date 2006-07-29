From: Patrick McHardy <kaber@trash.net>
Subject: Re: IMQ AND IP_Queue
Date: Sat, 29 Jul 2006 17:10:23 +0200
Message-ID: <44CB7A5F.7050106@trash.net>
References: <c9961d450607290020t2c28c065g76483acacad16fbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rajesh Mahajan <rajeshmahajan09@gmail.com>
In-Reply-To: <c9961d450607290020t2c28c065g76483acacad16fbe@mail.gmail.com>
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

Rajesh Mahajan wrote:
> we r currently using kernel 2.6.12 and iptables 1.3
> there is issue between imq and ip_queue
> we r using imq for shaping
> now we ip_queue module to be inserted
> But it is unable to insert it is giving errors
> FATAL: Error inserting ip_queue (/lib/modules/2.6.12-1-686
> /kernel/net/ipv4/netfilter/ip_queue.ko): Device or resource busy


Well known problem, you can't have two queues for the same address
family. The IFB device present in current kernels replaces IMQ and
doesn't need to bind to a netfilter queue.
