From: Deti Fliegl <deti@fliegl.de>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Mon, 31 Oct 2005 12:10:46 +0100
Message-ID: <4365FBB6.2070904@fliegl.de>
References: <4361EAAB.1090206@fliegl.de>	<4361F6DF.3050106@eurodev.net>	<43621028.40705@fliegl.de>	<43627A8F.9060307@eurodev.net>	<436281BB.2010100@fliegl.de>	<436373E8.7040606@eurodev.net>	<436398C7.4070402@fliegl.de>
	<4365A097.1080001@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4365A097.1080001@eurodev.net>
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

Hi Pablo,

thanks for your night shift. Now it is working much more stable as no 
segfaults within conntrack happened.

Now running "while true; do conntrack -L|wc -l; done" together with my 
stresstest script the system crashed after app 20 minutes.

Hm... somehow there must be something wrong with the kernel stuff.

<4>Badness in __kfree_skb at net/core/skbuff.c:330
<4>
<4>Call Trace:<ffffffff802a2f77>{__kfree_skb+167} 
<ffffffff802bb597>{netlink_recvmsg+279}
<4>       <ffffffff8029cb2b>{sock_recvmsg+315} 
<ffffffff8019b400>{update_atime+64}
<4>



Deti
