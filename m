From: Patrick McHardy <kaber@trash.net>
Subject: Re: --log-uid target?
Date: Thu, 04 Nov 2004 03:09:36 +0100
Message-ID: <41898F60.8080004@trash.net>
References: <1099109256.1798.411.camel@ws102.darkcore.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-develop <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: John Lange <john.lange@bighostbox.com>
In-Reply-To: <1099109256.1798.411.camel@ws102.darkcore.net>
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

John Lange wrote:

>Way back in the archives from 2002 I see a patch to add support for
>logging of the userid.
>
>Searching high and low and can't find any other reference to this
>feature and it does not appear to be in the current iptables or
>patch-o-matic downloads.
>
>Did this ever get implemented? How do you use it?
>
Just Martin's patch from 2002.

>
>I tried -j LOG --log-uid but it gives an error.
>
>I'm blocking out-bound packets to port 25 to prevent local users from
>spamming. However, I'd like to who it is that is attempting to spam and
>also be able to watch the logs to make sure legitimate processes are
>able to send mail.
>
Sounds like a useful addition. Martin, any reason why this patch was
never merged ?

Regards
Patrick
