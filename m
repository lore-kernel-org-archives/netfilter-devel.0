From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Last vestiges of NFC
Date: Sun, 02 Sep 2007 13:59:45 +0200
Message-ID: <46DAA5B1.6040307@trash.net>
References: <46D06522.2090509@hotpop.com>	<46D06FF8.5090004@hotpop.com>	<46D5A5B9.2030107@trash.net>	<46D6DEAF.9010009@hotpop.com>	<Pine.LNX.4.64.0708302040350.24730@fbirervta.pbzchgretzou.qr>	<46D824EA.1060406@hotpop.com>
	<46D83F90.5060600@trash.net> <46D9BE2A.4070901@hotpop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org
To: Peter.Riley@hotpop.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D9BE2A.4070901@hotpop.com>
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

Peter Riley wrote:
> Patrick McHardy wrote:
>>
>> The kernel doesn't use it, its *always* zero.
> 
> heh, well the whole point of this thread was about dealing with the
> fact that it isn't!  :-P  But no matter, it's all cool now..
> 
> In the end I kept that one line in dump_entry() in libip[46]tc.c,
> only for the sake of completeness. The dump_entry() function exists
> to dump out the members of an ipt_entry. As you said, nfcache must
> remain in the struct.  Please delete the line if you still really
> want it gone.


I kept it.

>> I prefer to get rid of all of them where possible, but if you want
> 
> Gotcha, patch attached.


Applied, thanks a lot Peter.

> I think there should at least be some kind of prominent changelog or
> warning notice somewhere that "prototypes in the iptables extension
> API have changed incompatibly after so many years so your custom match
> extension may now segmentation fault upon parsing if not updated".


We had lots of changes in this area very recently anyway
because of the new userspace xtables support, probably
things won't even compile anymore. But I agree, we'll add
a warning to next release announcement.
