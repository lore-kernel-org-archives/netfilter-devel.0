From: Patrick McHardy <kaber@trash.net>
Subject: Re: REDIRECT changes DST address of the packet
Date: Tue, 26 Jul 2005 11:51:18 +0200
Message-ID: <42E60796.2060909@trash.net>
References: <20050725045409.35744.qmail@web60823.mail.yahoo.com>	
	<42E57CE5.4070202@trash.net> <42E581D4.10402@trash.net>
	<1122370295.24626.10.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1122370295.24626.10.camel@nienna.balabit>
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

KOVACS Krisztian wrote:

>   Patrick, I'm afraid this is not enough for a full-featured UDP
> solution. If you're using a single socket to receive UDP packets sent to
> multiple original addresses this approach simply fails. A better
> solution would require receiving the original destination address in a
> per-packet manner.

You're right, it doesn't work for unconnected sockets. I'm looking into
other possibilities now. I'm thinking of something similar to
SIOCGSTAMP - altough this would require increasing the size of struct
sock.

>   We're using something similar as part of the transparent proxying
> patchset, but unfortunately this requires enlarging the skb and is a
> little hackish. The patch introduces an IP_RECVORIGADDRS socket option.
> If you enable this sockopt on a UDP socket, then recvmsg() will return
> the original addresses as a control message.

Why does the skb need to be enlarged?

Regards
Patrick
