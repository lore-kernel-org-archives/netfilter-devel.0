From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: How do I use ip_conntrack_destroyed?
Date: Thu, 04 Dec 2003 16:14:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCF413D.1060405@netlab.hut.fi>
References: <Pine.LNX.4.44.0312032243000.11739-100000@filer.marasystems.com> <3FCEE93C.5040104@balabit.hu>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

KOVACS Krisztian wrote:

>
>   Hi,
>
> Henrik Nordstrom wrote:
>
>>> /* Call me when a conntrack is destroyed. */
>>> extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
>>
>>
>> If you want to do this I think you should first extend
>> ip_conntrack_destroyed into a list of handlers with a suitable
>> registration functions to allow more than one module to register a 
>> "ip_conntrack_destroyed" function.
>
>
>   As I've mentioned, this is already done in the nfnetlink-ctnetlink 
> patch.
>
Thanks, it seems to be what I need.

Then, if I'm correct, I should register a function in my module as follows:

static struct ip_conntrack_notify ctnl_notify = { { NULL, NULL },
                        my_function_destroy,
                        NULL };

But where is "struct ip_conntrack_notify" defined?
I found the following code in a patch using google. It seems to be a 
modification of ip_conntrack.h, but my ip_conntrack.h file does not 
include these lines. And it's not in the nfnetlink patch neither. Is 
there any other patch that I should install?

-/* These are for NAT.  Icky. */
-/* Call me when a conntrack is destroyed. */
-extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
+/* This is for the ip_conntrack_notify facilities. */
+struct ip_conntrack_notify
+{
+        /* Internal use. */
+        struct list_head list;
+
+	void (*destroyed)(struct ip_conntrack *conntrack);
+        void (*created)(struct ip_conntrack *conntrack,
+                enum ip_conntrack_info info,
+                const struct net_device *in, 
+		const struct net_device *out);
+};
+
+extern int ip_conntrack_notify_register(struct ip_conntrack_notify *nb);
+extern int ip_conntrack_notify_unregister(struct ip_conntrack_notify *nb);


           Emmanuel
