From: James Morris <jmorris@intercode.com.au>
Subject: Re: [PATCH]  dead code elimination in ip6_queue.c
Date: Sun, 16 Mar 2003 11:54:45 +1100 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0303161154050.29463-100000@blackbird.intercode.com.au>
References: <3E736A61.6020907@videotron.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
In-Reply-To: <3E736A61.6020907@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 15 Mar 2003, Stephane Ouellette wrote:

> Folks,
> 
>    the following patch removes dead code in ip6_queue.c
> 

Incorrect, see NLMSG_PUT().


- James
-- 
James Morris
<jmorris@intercode.com.au>
