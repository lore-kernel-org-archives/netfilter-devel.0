From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: Re: [PATCH] dead code elimination in ip6_queue.c
Date: Wed, 26 Mar 2003 14:38:31 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E8201B7.8050309@videotron.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: laforge@netfilter.org, jmorris@intercode.com.au
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

Harald,

     I have been notified by James Morris that my patch is incorrect 
because of a macro named NLMSG_PUT() which uses the code I have removed 
in my patch.  There is a goto statement inside this macro.

Regards,

Stephane Ouellette
