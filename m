From: Patrick McHardy <kaber@trash.net>
Subject: Re: Time match in mangle/POSTROUTING?
Date: Wed, 03 Dec 2003 01:37:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCD305F.4040406@trash.net>
References: <3FCD2AA1.6F5E0225@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
  fabrice@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <3FCD2AA1.6F5E0225@info-link.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

POSTROUTING packets don't neccessarily have a timestamp since packets are
stamped when they are received which doesn't happen for locally generated
traffic. In the source I can see an option "kerneltime" which uses
gettimeofday, this should work fine in any chain. The patch does work in
OUTPUT, it uses kerneltime automatically then (and also unneccesarrily
in FORWARD). A correct fix would require using kerneltime in OUTPUT
and POSTROUTING and the skb stamp otherwise.

Best regards,
Patrick



Brad Fisher wrote:

>I'm curious why the time match doesn't work in POSTROUTING?  I have an
>application where it would be helpful to use it as such and was
>wondering if there was a good technical reason why it shouldn't work.
>If I modified the source to allow it to be added to the POSTROUTING
>chain, would it work as expected?  I'm assuming it won't be as simple as
>that...
>
>-Brad
>  
>
