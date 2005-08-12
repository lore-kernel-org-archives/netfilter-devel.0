From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Doubt in kernel packet generation
Date: Fri, 12 Aug 2005 13:43:58 +0200
Message-ID: <42FC8B7E.6090201@eurodev.net>
References: <20050809211249.GA29430@lst.de> <1123763443.14923.123.camel@varun>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilters <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: varun <varun@rocsys.com>
In-Reply-To: <1123763443.14923.123.camel@varun>
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

varun wrote:
>           I have a major doubt regarding how to generate my own icmp
> packet from the kernel space. That is iam aware of raw sockets and
> packet sockets but thats from user space. I want one of my kernel module
> to generate a packet using skb and probably add it to the transmit
> queue. Can anyone help me in this? 

have a look at ipt_REJECT.c

--
Pablo
