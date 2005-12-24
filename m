From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: How to obtain process ID that created connection or owns one
 packet
Date: Sat, 24 Dec 2005 15:20:36 +0100
Message-ID: <43AD5934.3050700@eurodev.net>
References: <1b8130000512182054y7208121dtb6b20814540bbb3b@mail.gmail.com>	<43A6EA58.9090201@eurodev.net>
	<43A6EC1F.7030600@eurodev.net>	<43ABED47.8070100@gmail.com>
	<43AC263E.7080508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: mikado4vn@gmail.com
In-Reply-To: <43AC263E.7080508@gmail.com>
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

Mikado wrote:
> Thanks all! Finally I found the answer in 'struct sk_buff':
> 
> struct sk_buff ( #include <linux/skbuff.h> )
> |_struct sock ( #include <net/sock.h> )
>   |_struct socket ( #include <linux/net.h> )
>     |_struct file ( #include <linux/fs.h> )
>       |_struct fown_struct ( #include <linux/fs.h> )
>         |_int pid

Yes, but AFAIK you can only use that in the OUTPUT hook, not in the
INPUT path. If my mind serves well, I remember that Patrick McHardy
posted some patches to add support for socket filtering some time ago. I
don't know what is the status of such work.

-- 
Pablo
