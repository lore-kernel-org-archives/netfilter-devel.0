From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [netfilter-core] recent in_range fix uncovered another bug?
Date: Thu, 11 Sep 2003 17:50:58 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030911081836.EF3C72C052@lists.samba.org>
References: <20030911071549.GA1045@mt.lv>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Karlis Peisenieks <karlis@mt.lv>
In-reply-to: Your message of "Thu, 11 Sep 2003 10:15:49 +0300."
             <20030911071549.GA1045@mt.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20030911071549.GA1045@mt.lv> you write:
> On Thu, Sep 11, 2003 at 10:09:56AM +0300, Karlis Peisenieks wrote:
> 
> > This patch solves "lockup" problem, but what about tons of equal 
> > conntracks?
> 
> Sorry, I overlooked how confirm works, now it is clear that two equal 
> conntracks can not be on lists. The only problem stays that potentially 
> innocent packets (e.g. in case of icmp echo request) get dropped.
> 
> Is it correct?

Yes, sometimes packets get lost.  That's actually quite a nice
solution to the race conditon 8)

Cheers,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
