From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: How do I use ip_conntrack_destroyed?
Date: Thu, 04 Dec 2003 16:10:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCF4E6A.8070202@balabit.hu>
References: <Pine.LNX.4.44.0312032243000.11739-100000@filer.marasystems.com> <3FCEE93C.5040104@balabit.hu> <3FCF413D.1060405@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: emmanuel@netlab.hut.fi
In-Reply-To: <3FCF413D.1060405@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

Emmanuel Guiton wrote:
> static struct ip_conntrack_notify ctnl_notify = { { NULL, NULL },
>                        my_function_destroy,
>                        NULL };
> 
> But where is "struct ip_conntrack_notify" defined?
> I found the following code in a patch using google. It seems to be a 
> modification of ip_conntrack.h, but my ip_conntrack.h file does not 
> include these lines. And it's not in the nfnetlink patch neither. Is 
> there any other patch that I should install?

   This was the case for an older version of nfnetlink. With 
nfnetlink-ctnetlink 0.13 you should use

static struct notifier_block my_notifier = {
	my_notifier_function,
	NULL,
	0
};

   For more info see that patch, it actually _uses_ notifiers to be able 
to catch conntrack entry related events. Note that this interface is much 
more universal, for example you can catch events when a conntrack entry is 
modified, etc. Good luck :)

-- 
   Regards,
     Krisztian KOVACS
