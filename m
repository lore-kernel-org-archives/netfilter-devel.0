From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Re: anyone can help me with ipqdemo?
Date: Mon, 1 Dec 2003 14:09:57 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312011408180.13057-100000@filer.marasystems.com>
References: <200312011045.hB1AjmE21299@xanadu.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fangweiwei <fangweiwei@tom.com>
In-Reply-To: <200312011045.hB1AjmE21299@xanadu.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 1 Dec 2003, Fangweiwei wrote:

> Henrik Nordstrom  ,hi

>  How should I do ? As I type "modprobe ip_queue",it doesn't
> work,says "bash:modprobe:command not found".when I enter /sbin and type
> "./modprobe ip_queue" it says: "can't locate module ip_queue".  I have
> looked for the libipq manual and found it says :
>
> #modprobe iptable_filter
> #modprobe ip_queue
> #modprobe  -A OUTPUT -p icmp -j QUEUE
> and I think if I can set these successfully ,maybe the ipqdemo can run.but the question is even modprobe I cann't run if I don't enter the /sbin. 

I think you need to get a UNIX book and read a little on the fundamentals 
on what happens when you enter a command in UNIX.

The "can't locate module ip_queue" error indicates your kernel is most
likely not compiled with ip_queue support.

Regards
Henrik
