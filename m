From: Patrick McHardy <kaber@trash.net>
Subject: Re: Having trouble building a new connection tracker helper module
Date: Wed, 09 Mar 2005 00:00:13 +0100
Message-ID: <422E2E7D.5040409@trash.net>
References: <8B888AAAAB0FD31189590008C79184432644807B@zbl6c002.corpeast.baynetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Chad Goss <chgoss@nortel.com>
In-Reply-To: <8B888AAAAB0FD31189590008C79184432644807B@zbl6c002.corpeast.baynetworks.com>
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

Chad Goss wrote:
> Hi folks,
> 
> I am trying to compile a new connection tracker helper module, I have
> 1) downloaded 2.6.10 kernel source 
> 
> 2) built a fresh kernel from that source
> 
> 3) created a new file "ip_conntrack_cftp.c" in
> $KERNEL_DIR/net/ipv4/netfilter/
>   (basically just copied the file ip_conntrack_tftp.c and changed all of
> "tftp" text to "cftp", "TFTP" to "CFTP"
> 
> 4) created a new file "ip_conntrack_cftp.h" in
> $KERNEL_DIR/include/linux/netfilter_ipv4, 
>   (copied ip_conntrack_tftp.h to ip_conntrack_cftp.h and made the
> adjustments to the text strings)
> 
> 5) updated the $KERNEL_DIR/net/ipv4/netfilter/Makefile adding a line
> 	# connection tracking helpers
> 	obj-$(CONFIG_IP_NF_CFTP) += ip_conntrack_cftp.o
> 	
> 
> 6) attempted to make that directory "make -C $KERNEL_DIR  M=`pwd`
> 	(executed from $KERNEL_DIR/net/ipv4/netfilter/ )
> 
> 
> But, I don't see any .ko, or .o or .mod.c files getting created... What step
> am I missing?

Kconfig. Without a config option, your Makefile addition will
always evaluate to obj-n += ...

Regards
Patrick
