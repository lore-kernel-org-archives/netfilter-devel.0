From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Question about procfs function
Date: Mon, 26 Jan 2004 17:34:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <401541A0.3030906@eurodev.net>
References: <Pine.LNX.4.44.0401251921480.2228-100000@truta.dcc.ufmg.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0401251921480.2228-100000@truta.dcc.ufmg.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi leonardo,

Leonardo Henrique Machado wrote:

>Where can I find a complete tutorial about procfs?
>  
>

This question is not netfilter related at all, better the linux kernel
maillist, anyway have a look at:

Linux Device Drivers, 2nd edition
http://www.xml.com/ldd/chapter/book/

and

Linux Kernel Modules Programming (mostly for kernel 2.2, so some things
won't work for your 2.4 and 2.6 kernel but it's a reference anyway).

http://www.faqs.org/docs/kernel/

>procfs_getinfo is a very confusing function! I would like
>to save a linked list in a buffer and after that I'll print
>it in the procfs buffer file.
>  
>

I think that there's some examples in those docs.

Pablo
