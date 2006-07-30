From: "Rajesh Mahajan" <rajeshmahajan09@gmail.com>
Subject: Re: IMQ AND IP_Queue
Date: Sun, 30 Jul 2006 15:52:40 +0530
Message-ID: <c9961d450607300322m2394c229x25d386c73dc3ea6f@mail.gmail.com>
References: <c9961d450607290020t2c28c065g76483acacad16fbe@mail.gmail.com>
	<44CB7A5F.7050106@trash.net>
	<c9961d450607290954s364e98c5h2a18523d944a9036@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
In-Reply-To: <c9961d450607290954s364e98c5h2a18523d944a9036@mail.gmail.com>
Content-Disposition: inline
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

Thanks

On 7/29/06, Rajesh Mahajan <rajeshmahajan09@gmail.com> wrote:

>
> On 7/29/06, Patrick McHardy <kaber@trash.net> wrote:
> > Rajesh Mahajan wrote:
> > > we r currently using kernel 2.6.12 and iptables 1.3
> >  > there is issue between imq and ip_queue
> > > we r using imq for shaping
> > > now we ip_queue module to be inserted
> > > But it is unable to insert it is giving errors
> > > FATAL: Error inserting ip_queue (/lib/modules/2.6.12-1-686
> > > /kernel/net/ipv4/netfilter/ip_queue.ko): Device or resource busy
> >
> >
> > Well known problem, you can't have two queues for the same address
> > family. The IFB device present in current kernels replaces IMQ and
> > doesn't need to bind to a netfilter queue.
> >
> >
>
>
