From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: remove the central spinlock
Date: Thu, 9 May 2013 07:46:52 +0000 (UTC)
Message-ID: <kmfk9c$7g6$1@ger.gmane.org>
References: <1368068665.13473.81.camel@edumazet-glaptop>
 <kmfd2s$e2m$1@ger.gmane.org> <1368079301.13473.88.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 09 May 2013 at 06:01 GMT, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2013-05-09 at 05:43 +0000, Cong Wang wrote:
>> On Thu, 09 May 2013 at 03:04 GMT, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> >  
>> > +#if 0
>> > +	for (i = 0; i < ARRAY_SIZE(nf_conntrack_locks); i++)
>> > +		arch_spin_lock_init(&nf_conntrack_locks[i]);
>> > +#endif
>> > +
>> 
>> Is this intentional?
>
> What do you think ?
>
> Apparently arch_spin_lock_init() does not exist (but for ia64)
>

Either it is not expected to use arch_spin_lock directly, or it has to
provide a nop for non-IA64.
