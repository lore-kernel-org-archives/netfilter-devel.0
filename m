From: Pablo Neira <pablo@eurodev.net>
Subject: Re: NF_QUEUE examples
Date: Fri, 16 Apr 2004 01:55:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407F20DA.2050704@eurodev.net>
References: <20040415162220.GA5747@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040415162220.GA5747@maluco.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Ulysses,

Ulysses Almeida wrote:

> where can i find simple examples of using it? 
>

http://cvs.netfilter.org/netfilter/testsuite/tools/intercept.c

it hasn't been modified for quite some time but it works.

>  What I understand, is: with NF_QUEUE, I can queue some packet to be
>manipulated on userspace. After this, can this packet be dequeued back
>to kernel space, and continue with it's journey?
>

exactly

> How can I write a
>userspace code, to handle with packetd queued bu NF_QUEUE? Or I didn't
>understand nothing about it?
>  
>

as Sven pointed out, if you are interested you could have a look at
ip_queue.c in kernel side.

regards,
Pablo
