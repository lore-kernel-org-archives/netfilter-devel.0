From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6 NETFILTER] new netfilter module ipt_program.c
Date: Sat, 11 Sep 2004 16:36:14 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41430D5E.9030207@trash.net>
References: <20040911124106.GD24787@lkcl.net> <4142F4CC.7080708@trash.net>
	<20040911132935.GF24787@lkcl.net> <20040911133443.GG24787@lkcl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
In-Reply-To: <20040911133443.GG24787@lkcl.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Luke Kenneth Casson Leighton wrote:
> On Sat, Sep 11, 2004 at 02:29:35PM +0100, Luke Kenneth Casson Leighton wrote:
> 
>  thing is, you see, i know just enough to be dangerous.
> 
>  using files->file_lock a) seems to work b) is accepted code in the
>  kernel.

It seems to work - on UP where it is a NOP. On SMP it will deadlock.
That we have some broken code doesn't mean we want more of it :)

>  if someone else has the experience and knowledge to fix ipt_owner.c
>  i'll quite happily cut/paste that instead - once it's fixed.

The "fix" is quite easy, replace all occurences of
spin_lock(&files->file_lock) in the kernel by spin_lock_bh.
But that's not going to be accepted. IIRC the SELinux guys
want to label packets with the name of the sending process,
maybe we can use this for the owner match once it's done.

Regards
Patrick
