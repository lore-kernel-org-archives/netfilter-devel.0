From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] updated ctnetlink patches: ctnetlink-0.12.diff
Date: Fri, 05 Dec 2003 04:01:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCFF51F.1050102@trash.net>
References: <3ED4BD8D.1070500@trash.net> <20031205025503.GA11243@myinternet.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Joshua Goodall <joshua@myinternet.com.au>
In-Reply-To: <20031205025503.GA11243@myinternet.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Joshua Goodall wrote:

>>+#define nf_debug(level, format, arg...)					       \
>>+	do {								       \
>>+		if (nf_debug_level > level)				       \
>>+			printk(KERN_DEBUG "%s: " format, __FUNCTION__, ## arg);\
>>+	} while(0)
>>    
>>
>
>This triggers a bug in GCC 2.95.4 (Debian stable and others) and breaks
>the build.
>
>Please use
>printk(KERN_DEBUG "%s: " format, __FUNCTION__ , ## arg);
>- note the space after __FUNCTION__.
>
>Also occurs later in nfnetlink_conntrack.c.
>  
>

I will fix it in the next version which I plan to finish around christmas.

Thanks,
Patrick
