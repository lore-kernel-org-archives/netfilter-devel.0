From: Pablo Neira <pablo@eurodev.net>
Subject: Re: can a netfilter hook interact with userspace ?
Date: Wed, 21 Jul 2004 18:09:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40FE9548.30806@eurodev.net>
References: <2CC2CB3C95C3D311ABAC009027DCD77E01969075@flyhalf.pactolus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Horton, Dave" <dhorton@pactolus.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <2CC2CB3C95C3D311ABAC009027DCD77E01969075@flyhalf.pactolus.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Horton, Dave wrote:

>By what means can my userspace program call into my netfilter hook to
>communicate this information?
>  
>

You can use nf_register_sockopt/nf_unregister_sockopt to do so. See Sect 
4.6. Writing New modules -> Receiving Commands From Userspace in the 
netfilter hacking how to. You can find an example in ip_tables.c.

If you don't like using getsocksopt/setsocksopt to pass information to 
kernel space, you could also use netlinks sockets.

regards,
Pablo
