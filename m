From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack, nfct_catch returns ENOBUFS
Date: Mon, 18 Jun 2007 18:10:18 +0200
Message-ID: <4676AE6A.7060605@netfilter.org>
References: <OF4720118A.9A817D9F-ONC12572FE.0056ADED-C12572FE.0056CBFD@mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: fabien.marotte@mindspeed.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <OF4720118A.9A817D9F-ONC12572FE.0056ADED-C12572FE.0056CBFD@mindspeed.com>
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

fabien.marotte@mindspeed.com wrote:
> I develop an application using libnetfilter_conntrack to catch events 
> happening in the conntrack system.
> I am currently testing the robustness of my application using ab tool 
> (connection stress).
> 
> libnetfilter_conntrack version is 0.50. I use the new API.
> My callback catching the events always returns NFCT_CB_CONTINUE meaning 
> that ncft_catch should never returns.
> 
> But with 20 (and more) TCP  connections opening simultaneously, nfct_catch 
> returns. The error code in errno is 105. Seems to be ENOBUFS.
> 
> Looking at the code, I see the comment "ENOBUFS is returned in case that 
> nfnetlink is exhausted".
> 
> I am very surprised to have memory issues with so few connections.

So am I. Could you post the code?

> Could you explain me why this error occurs ? Is this a kernel error 
> propagated in user space or is this a user space error ?

Default buffer size in your system? cat /proc/sys/net/core/rmem_default

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
